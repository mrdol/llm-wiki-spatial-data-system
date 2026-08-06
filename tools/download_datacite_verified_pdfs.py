#!/usr/bin/env python
"""Telecharger les PDF open access des candidats DataCite valides.

Le script part du manifeste d'ingestion DataCite et ne conserve un fichier que
si la reponse HTTP ressemble vraiment a un PDF. Les DOI, pages HTML et pages
editeur non telechargeables sont traces dans un manifeste, mais pas sauvegardes
comme PDF.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import time
import unicodedata
from pathlib import Path
from typing import Any

import requests


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_INPUT = ROOT / "data" / "manifests" / "papers" / "datacite_verified_ingestion_manifest.json"
DEFAULT_PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
DEFAULT_MANIFEST = ROOT / "data" / "manifests" / "papers" / "datacite_verified_pdf_download_manifest.csv"
USER_AGENT = "llm-wiki-spatial-data-system/0.1 (johnny.d-oliveira@inrae.fr)"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Download OA PDFs for verified DataCite candidates.")
    parser.add_argument("--input", default=str(DEFAULT_INPUT), help="Manifeste JSON d'ingestion.")
    parser.add_argument("--pdf-dir", default=str(DEFAULT_PDF_DIR), help="Dossier cible des PDF.")
    parser.add_argument("--manifest", default=str(DEFAULT_MANIFEST), help="Manifeste CSV des telechargements.")
    parser.add_argument("--sleep", type=float, default=0.5, help="Pause en secondes entre deux requetes.")
    parser.add_argument("--timeout", type=int, default=90, help="Timeout HTTP par requete.")
    parser.add_argument("--dry-run", action="store_true", help="N'ecrit aucun PDF.")
    return parser.parse_args()


def read_rows(path: Path) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8-sig") as handle:
        data = json.load(handle)
    if not isinstance(data, list):
        raise ValueError(f"Le manifeste doit etre une liste JSON: {path}")
    return [dict(row) for row in data]


def normalize_doi(value: Any) -> str:
    text = str(value or "").strip().lower()
    text = re.sub(r"^https?://(dx\.)?doi\.org/", "", text)
    return text.strip().rstrip(".")


def safe_name(value: str, limit: int = 120) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = re.sub(r"[^A-Za-z0-9_. -]+", " ", value)
    value = re.sub(r"\s+", " ", value).strip(" .")
    if len(value) > limit:
        value = value[:limit].rsplit(" ", 1)[0].strip(" .")
    return value or "unknown"


def output_name(row: dict[str, Any]) -> str:
    title = str(row.get("publication_title") or row.get("dataset_title") or "paper")
    title = re.sub(r"\s*:\s*", " - ", title)
    title_part = safe_name(title, limit=170)
    return f"{title_part}.pdf"


def pdf_url_candidates(row: dict[str, Any]) -> list[str]:
    # Plusieurs metadonnees DataCite pointent vers une page article et non vers
    # un PDF direct. On garde toutes les candidates et on verifiera le contenu.
    values = [
        row.get("open_access_pdf_url"),
        row.get("publication_url"),
    ]
    urls: list[str] = []
    for value in values:
        url = str(value or "").strip()
        if url and url not in urls:
            urls.append(url)
            pmc = re.search(r"pmc\.ncbi\.nlm\.nih\.gov/articles/(PMC\d+)", url, re.IGNORECASE)
            if pmc:
                derived = f"https://pmc.ncbi.nlm.nih.gov/articles/{pmc.group(1)}/pdf/"
                if derived not in urls:
                    urls.append(derived)
    return urls


def looks_like_pdf(content: bytes, content_type: str) -> bool:
    head = content[:20].lstrip()
    return head.startswith(b"%PDF") or "application/pdf" in content_type.lower()


def build_session() -> requests.Session:
    session = requests.Session()
    session.headers.update(
        {
            "User-Agent": USER_AGENT,
            "Accept": "application/pdf,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.5",
        }
    )
    return session


def download_one(
    session: requests.Session,
    row: dict[str, Any],
    pdf_dir: Path,
    timeout: int,
    dry_run: bool,
) -> dict[str, str]:
    destination = pdf_dir / output_name(row)
    urls = pdf_url_candidates(row)
    base = {
        "dataset_doi": normalize_doi(row.get("dataset_doi")),
        "publication_doi": normalize_doi(row.get("publication_doi")),
        "publication_title": str(row.get("publication_title") or ""),
        "local_pdf": str(destination.relative_to(ROOT)) if destination.is_relative_to(ROOT) else str(destination),
    }
    if destination.exists() and destination.stat().st_size > 1024:
        return {**base, "status": "already_present", "source_url": "", "http_status": "", "content_type": "", "note": ""}
    if not urls:
        return {**base, "status": "no_url", "source_url": "", "http_status": "", "content_type": "", "note": "Aucune URL PDF/article."}
    if dry_run:
        return {**base, "status": "dry_run", "source_url": " | ".join(urls), "http_status": "", "content_type": "", "note": ""}

    attempts = []
    for url in urls:
        try:
            response = session.get(url, timeout=timeout, allow_redirects=True)
            content_type = response.headers.get("content-type", "")
            attempts.append(f"{response.status_code} {content_type} {url}")
            if response.status_code == 200 and looks_like_pdf(response.content, content_type):
                pdf_dir.mkdir(parents=True, exist_ok=True)
                destination.write_bytes(response.content)
                return {
                    **base,
                    "status": "downloaded",
                    "source_url": response.url,
                    "http_status": str(response.status_code),
                    "content_type": content_type,
                    "note": "",
                }
        except requests.RequestException as exc:
            attempts.append(f"ERROR {type(exc).__name__} {url}")

    return {
        **base,
        "status": "not_downloaded",
        "source_url": " | ".join(urls),
        "http_status": "",
        "content_type": "",
        "note": "Aucune URL candidate n'a renvoye un PDF. Tentatives: " + " ; ".join(attempts),
    }


def write_manifest(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = list(rows[0].keys()) if rows else []
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, delimiter=";")
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    args = parse_args()
    input_path = Path(args.input).resolve()
    pdf_dir = Path(args.pdf_dir).resolve()
    manifest_path = Path(args.manifest).resolve()

    rows = read_rows(input_path)
    session = build_session()
    outputs = []
    for index, row in enumerate(rows, start=1):
        print(f"[{index}/{len(rows)}] {row.get('publication_doi') or row.get('dataset_doi')}", flush=True)
        outputs.append(download_one(session, row, pdf_dir, args.timeout, args.dry_run))
        if args.sleep > 0:
            time.sleep(args.sleep)
    write_manifest(manifest_path, outputs)
    counts: dict[str, int] = {}
    for row in outputs:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
    print("summary:", counts)
    print(f"manifest: {manifest_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
