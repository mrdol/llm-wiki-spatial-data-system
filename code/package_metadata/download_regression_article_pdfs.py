#!/usr/bin/env python
"""Telecharge les PDF open access references dans gg/regression_article.bib.

Le script part du .bib de travail, detecte les entrees sans PDF local, puis
tente les telechargements legaux accessibles publiquement. Les PDF payants ou
les pages editeur qui ne renvoient pas un vrai PDF sont traces dans un manifeste
au lieu d'etre contournes.
"""

from __future__ import annotations

import argparse
import csv
import re
import time
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import requests


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_BIB = ROOT / "gg" / "regression_article.bib"
DEFAULT_PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
DEFAULT_MANIFEST = ROOT / "gg" / "regression_article_pdf_download_manifest_2026-08.tsv"
DEFAULT_EMAIL = "johnny.d-oliveira@inrae.fr"


@dataclass
class BibEntry:
    key: str
    title: str = ""
    doi: str = ""
    urls: list[str] = field(default_factory=list)
    file_value: str = ""
    has_local_pdf: bool = False


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Download OA PDFs listed in regression_article.bib.")
    parser.add_argument("--bib", default=str(DEFAULT_BIB), help="Fichier BibTeX source.")
    parser.add_argument("--pdf-dir", default=str(DEFAULT_PDF_DIR), help="Dossier cible des PDF.")
    parser.add_argument("--manifest", default=str(DEFAULT_MANIFEST), help="Manifeste TSV de sortie.")
    parser.add_argument("--email", default=DEFAULT_EMAIL, help="Email envoye a l'API Unpaywall.")
    parser.add_argument("--timeout", type=int, default=90, help="Timeout HTTP par requete.")
    parser.add_argument("--sleep", type=float, default=0.5, help="Pause entre deux entrees.")
    parser.add_argument("--limit", type=int, default=0, help="Limite optionnelle du nombre d'entrees a traiter.")
    parser.add_argument("--dry-run", action="store_true", help="N'ecrit aucun PDF.")
    return parser.parse_args()


def normalize_spaces(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip()


def field_value(block: str, name: str) -> str:
    pattern = re.compile(rf"\b{name}\s*=\s*([{{\"])(.*?)(?(1)[}}\"])", re.IGNORECASE | re.DOTALL)
    match = pattern.search(block)
    if not match:
        return ""
    return normalize_spaces(match.group(2).replace("\n", " "))


def all_field_values(block: str, name: str) -> list[str]:
    pattern = re.compile(rf"\b{name}\s*=\s*([{{\"])(.*?)(?(1)[}}\"])", re.IGNORECASE | re.DOTALL)
    values = []
    for match in pattern.finditer(block):
        value = normalize_spaces(match.group(2).replace("\n", " "))
        if value and value not in values:
            values.append(value)
    return values


def normalize_doi(value: str) -> str:
    value = normalize_spaces(value).lower()
    value = re.sub(r"^https?://(dx\.)?doi\.org/", "", value)
    return value.rstrip(".")


def safe_filename(value: str, limit: int = 140) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = re.sub(r"[^A-Za-z0-9_.-]+", "_", value)
    value = re.sub(r"_+", "_", value).strip("_.")
    return (value[:limit].strip("_.") or "paper") + ".pdf"


def looks_like_pdf(content: bytes, content_type: str) -> bool:
    head = content[:20].lstrip()
    return head.startswith(b"%PDF") or "application/pdf" in content_type.lower()


def local_paths_from_file_field(file_value: str) -> list[Path]:
    """Extrait les chemins PDF possibles depuis le champ JabRef file."""
    paths: list[Path] = []
    if not file_value:
        return paths

    # Format frequent: :C\:/path/to/file.pdf:PDF
    for match in re.finditer(r":([A-Za-z])\\?:([^:]+?\.pdf)(?::|$)", file_value):
        paths.append(Path(f"{match.group(1)}:{match.group(2)}".replace("\\", "/")))

    # Format chemin Windows direct.
    for match in re.finditer(r"([A-Za-z]:[^:]+?\.pdf)(?::|$)", file_value):
        paths.append(Path(match.group(1).replace("\\", "/")))

    # Format relatif eventuel.
    for match in re.finditer(r"([^:]+?\.pdf)(?::|$)", file_value):
        candidate = Path(match.group(1).replace("\\", "/"))
        if not candidate.is_absolute():
            candidate = ROOT / candidate
        paths.append(candidate)
    return paths


def pdf_exists(entry: BibEntry, pdf_dir: Path) -> bool:
    candidates = local_paths_from_file_field(entry.file_value)
    candidates.append(pdf_dir / f"{entry.key}.pdf")
    for path in candidates:
        try:
            if path.exists() and path.stat().st_size > 1024:
                return True
        except OSError:
            continue
    return False


def parse_bib(path: Path, pdf_dir: Path) -> list[BibEntry]:
    text = path.read_text(encoding="utf-8-sig")
    starts = list(re.finditer(r"@\w+\s*\{\s*([^,]+),", text))
    entries: list[BibEntry] = []
    for index, match in enumerate(starts):
        start = match.start()
        end = starts[index + 1].start() if index + 1 < len(starts) else len(text)
        block = text[start:end]
        entry = BibEntry(
            key=match.group(1).strip(),
            title=field_value(block, "title"),
            doi=normalize_doi(field_value(block, "doi")),
            urls=all_field_values(block, "url"),
            file_value=field_value(block, "file"),
        )
        entry.has_local_pdf = pdf_exists(entry, pdf_dir)
        entries.append(entry)
    return entries


def build_session() -> requests.Session:
    session = requests.Session()
    session.headers.update(
        {
            "User-Agent": (
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36"
            ),
            "Accept": "application/pdf,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        }
    )
    return session


def derived_pdf_urls(url: str) -> list[str]:
    urls = [url]
    pmc = re.search(r"pmc\.ncbi\.nlm\.nih\.gov/articles/(PMC\d+)", url, re.IGNORECASE)
    if pmc:
        urls.insert(0, f"https://pmc.ncbi.nlm.nih.gov/articles/{pmc.group(1)}/pdf/")
        urls.insert(0, f"https://europepmc.org/backend/ptpmcrender.fcgi?accid={pmc.group(1)}&blobtype=pdf")
    doi = re.search(r"doi\.org/(10\.[^?#]+)", url, re.IGNORECASE)
    if doi:
        urls.append(f"https://doi.org/{doi.group(1)}")
    return urls


def unpaywall_urls(session: requests.Session, doi: str, email: str, timeout: int) -> tuple[list[str], str]:
    if not doi:
        return [], "DOI absent."
    api_url = f"https://api.unpaywall.org/v2/{doi}?email={email}"
    try:
        response = session.get(api_url, timeout=timeout)
    except requests.RequestException as exc:
        return [], f"Unpaywall inaccessible: {type(exc).__name__}"
    if response.status_code != 200:
        return [], f"Unpaywall HTTP {response.status_code}"
    try:
        data: dict[str, Any] = response.json()
    except ValueError:
        return [], "Unpaywall a renvoye une reponse non JSON."
    if not data.get("is_oa"):
        return [], "Unpaywall: aucune version open access connue."

    urls: list[str] = []
    locations = []
    if data.get("best_oa_location"):
        locations.append(data["best_oa_location"])
    locations.extend(data.get("oa_locations") or [])
    for location in locations:
        for key in ("url_for_pdf", "url"):
            value = str(location.get(key) or "").strip()
            if not value:
                continue
            for candidate in derived_pdf_urls(value):
                if candidate not in urls:
                    urls.append(candidate)
    return urls, "" if urls else "Unpaywall OA mais sans URL exploitable."


def candidate_urls(session: requests.Session, entry: BibEntry, email: str, timeout: int) -> tuple[list[str], str]:
    urls: list[str] = []
    notes: list[str] = []
    for url in entry.urls:
        for candidate in derived_pdf_urls(url):
            if candidate not in urls:
                urls.append(candidate)
    unpaywall, note = unpaywall_urls(session, entry.doi, email, timeout)
    if note:
        notes.append(note)
    for url in unpaywall:
        if url not in urls:
            urls.append(url)
    return urls, " ".join(notes)


def download_entry(
    session: requests.Session,
    entry: BibEntry,
    pdf_dir: Path,
    email: str,
    timeout: int,
    dry_run: bool,
) -> dict[str, str]:
    destination = pdf_dir / safe_filename(entry.key)
    base = {
        "key": entry.key,
        "title": entry.title,
        "doi": entry.doi,
        "status": "",
        "local_path": str(destination.relative_to(ROOT)) if destination.is_relative_to(ROOT) else str(destination),
        "source_url": "",
        "http_status": "",
        "content_type": "",
        "note": "",
    }
    if entry.has_local_pdf:
        return {**base, "status": "already_present", "note": "PDF deja reference localement."}

    urls, note = candidate_urls(session, entry, email, timeout)
    if not urls:
        return {**base, "status": "no_oa_url", "local_path": "", "note": note or "Aucune URL candidate."}
    if dry_run:
        return {**base, "status": "dry_run", "source_url": " | ".join(urls), "note": note}

    attempts: list[str] = []
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
                    "note": note,
                }
        except requests.RequestException as exc:
            attempts.append(f"ERROR {type(exc).__name__}: {url}")

    return {
        **base,
        "status": "not_downloaded",
        "local_path": "",
        "source_url": " | ".join(urls),
        "note": (note + " " if note else "") + "Tentatives: " + " ; ".join(attempts),
    }


def write_manifest(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = list(rows[0].keys()) if rows else []
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, delimiter="\t")
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    args = parse_args()
    bib = Path(args.bib).resolve()
    pdf_dir = Path(args.pdf_dir).resolve()
    manifest = Path(args.manifest).resolve()
    session = build_session()

    entries = parse_bib(bib, pdf_dir)
    targets = [entry for entry in entries if not entry.has_local_pdf]
    if args.limit > 0:
        targets = targets[: args.limit]

    print(f"entries={len(entries)}")
    print(f"already_local={len(entries) - len([entry for entry in entries if not entry.has_local_pdf])}")
    print(f"targets={len(targets)}")

    rows = []
    for index, entry in enumerate(targets, start=1):
        print(f"[{index}/{len(targets)}] {entry.key} {entry.doi}", flush=True)
        rows.append(download_entry(session, entry, pdf_dir, args.email, args.timeout, args.dry_run))
        if args.sleep > 0:
            time.sleep(args.sleep)

    if not rows:
        rows = [
            {
                "key": "",
                "title": "",
                "doi": "",
                "status": "nothing_to_do",
                "local_path": "",
                "source_url": "",
                "http_status": "",
                "content_type": "",
                "note": "",
            }
        ]
    write_manifest(manifest, rows)
    counts: dict[str, int] = {}
    for row in rows:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
        print(f"{row['status']:>15}  {row['key']}  {row['local_path']}")
    print(f"summary={counts}")
    print(f"manifest={manifest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
