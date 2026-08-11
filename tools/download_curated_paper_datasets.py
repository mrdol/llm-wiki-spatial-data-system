"""Telecharge les jeux de donnees candidats deja curbes (Phase 10 du pipeline).

Lit `inst/kg/paper_dataset_uses.json`, traite par defaut les enregistrements
prets pour la recuperation de donnees (`tei_present_needs_curation`,
`candidate_dataset_download_pending`, `pdf_present_pending_grobid` et
`pdf_not_accessible_needs_manual_retrieval`). Chaque source est verifiee via
l'API publique du depot (figshare / Dataverse / Dryad) avant tout
telechargement reel.

Usage:
    python tools/download_curated_paper_datasets.py --list-only
    python tools/download_curated_paper_datasets.py --doi 10.1002/sim.7172 --doi 10.1017/pan.2020.23
    python tools/download_curated_paper_datasets.py --all --exclude-doi 10.5751/es-12481-260327 --max-size-mb 5000

Donnees brutes ecrites dans : data/raw/papers/<bib_key>/
Manifeste de telechargement : gg/curated_dataset_download_manifest_2026-08.tsv
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import sys
from pathlib import Path
from typing import Any

import requests

from dataset_manifest_check import UA, classify_file_manifest, list_files, repo_from_url

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


ROOT = Path(__file__).resolve().parent.parent
MANIFEST_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
RAW_DIR = ROOT / "data" / "raw" / "papers"
DOWNLOAD_MANIFEST = ROOT / "gg" / "curated_dataset_download_manifest_2026-08.tsv"
DEFAULT_DOWNLOAD_STATUSES = {
    "tei_present_needs_curation",
    "candidate_dataset_download_pending",
    "pdf_present_pending_grobid",
    "pdf_not_accessible_needs_manual_retrieval",
}


def load_records() -> list[dict[str, Any]]:
    data = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    return data["records"]


def save_records(records: list[dict[str, Any]]) -> None:
    data = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    by_key = {(r.get("paper_doi"), r.get("canonical_dataset_id")): r for r in records}
    for row in data["records"]:
        key = (row.get("paper_doi"), row.get("canonical_dataset_id"))
        if key in by_key:
            row.update(by_key[key])
    MANIFEST_PATH.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")


def slug(record: dict[str, Any]) -> str:
    return record.get("bib_key") or record.get("paper_id", "unknown").replace(":", "_").replace("/", "_")


def download_record(
    record: dict[str, Any],
    max_size_mb: float,
    dry_run: bool,
    file_pattern: str | None = None,
) -> dict[str, Any]:
    dataset_doi = record.get("dataset_doi") or ""
    url = record.get("data_access_url") or ""
    repo = repo_from_url(url)
    base = {
        "paper_doi": record.get("paper_doi"),
        "dataset_doi": dataset_doi,
        "repo": repo,
        "target_dir": "",
        "status": "",
        "total_size_mb": "",
        "n_files": "",
        "note": "",
    }

    if repo not in {"figshare", "dataverse", "dryad", "zenodo"}:
        return {**base, "status": "skipped_unsupported_repo", "note": f"Pas d'API de telechargement automatique geree pour '{repo}'."}

    try:
        files = list_files(repo, dataset_doi)
    except Exception as exc:
        return {**base, "status": "error_listing_files", "note": str(exc)}

    if not files:
        return {**base, "status": "no_files_found", "note": ""}

    probably_real, reason = classify_file_manifest(files)
    if not probably_real:
        return {**base, "status": "rejected_supplement_mirror", "note": reason}

    if file_pattern:
        pattern = re.compile(file_pattern, re.IGNORECASE)
        matched = [f for f in files if f.get("name") and pattern.search(f["name"])]
        if not matched:
            return {**base, "status": "no_files_match_pattern", "note": f"pattern={file_pattern!r} sur {len(files)} fichiers"}
        files = matched

    total_size = sum(f.get("size") or 0 for f in files)
    total_mb = total_size / (1024 * 1024)
    base["total_size_mb"] = f"{total_mb:.2f}"
    base["n_files"] = str(len(files))

    if total_mb > max_size_mb:
        return {**base, "status": "skipped_too_large", "note": f"{total_mb:.0f} Mo > seuil {max_size_mb:.0f} Mo"}

    target_dir = RAW_DIR / slug(record)
    base["target_dir"] = str(target_dir.relative_to(ROOT)) if target_dir.is_relative_to(ROOT) else str(target_dir)

    if dry_run:
        return {**base, "status": "dry_run", "note": ""}

    target_dir.mkdir(parents=True, exist_ok=True)
    downloaded = 0
    errors = []
    for f in files:
        if not f.get("url") or not f.get("name"):
            errors.append(f"fichier sans URL/nom: {f}")
            continue
        dest = target_dir / f["name"]
        if dest.exists() and dest.stat().st_size > 0:
            downloaded += 1
            continue
        try:
            resp = requests.get(f["url"], timeout=180, headers=UA, allow_redirects=True)
            resp.raise_for_status()
            dest.write_bytes(resp.content)
            downloaded += 1
        except Exception as exc:
            errors.append(f"{f['name']}: {exc}")

    if errors and downloaded == 0:
        return {**base, "status": "failed", "note": " ; ".join(errors)[:400]}
    if errors:
        return {**base, "status": "partial", "note": " ; ".join(errors)[:400]}
    return {**base, "status": "downloaded", "note": ""}


def main() -> None:
    parser = argparse.ArgumentParser(description="Telecharge les datasets candidats curbes (Phase 10).")
    parser.add_argument("--doi", action="append", dest="dois", help="Ne traiter que ce(s) DOI papier (repetable).")
    parser.add_argument("--exclude-doi", action="append", dest="exclude_dois", default=[], help="Exclure ce(s) DOI papier.")
    parser.add_argument("--all", action="store_true", help="Traiter tous les enregistrements aux statuts telechargeables.")
    parser.add_argument(
        "--status",
        action="append",
        dest="statuses",
        default=None,
        help="Statut ingestion_status a traiter (repetable). Par defaut: statuts telechargeables DataCite/KG.",
    )
    parser.add_argument("--max-size-mb", type=float, default=5000, help="Ignorer les datasets au-dela de cette taille totale.")
    parser.add_argument("--list-only", action="store_true", help="Lister taille/fichiers sans rien telecharger.")
    parser.add_argument(
        "--file-pattern",
        default=None,
        help="Regex : ne telecharger que les fichiers dont le nom matche (utile pour un sous-ensemble d'un dataset volumineux, ex. '^annual-dat').",
    )
    args = parser.parse_args()

    records = load_records()
    statuses = set(args.statuses or DEFAULT_DOWNLOAD_STATUSES)
    candidates = [r for r in records if r.get("ingestion_status") in statuses]
    if args.dois:
        candidates = [r for r in candidates if r.get("paper_doi") in args.dois]
    candidates = [r for r in candidates if r.get("paper_doi") not in (args.exclude_dois or [])]

    if not args.all and not args.dois:
        print("Precise --all ou --doi <doi> (repetable). Utilise --list-only pour un aperçu sans rien ecrire.")
        return

    rows = []
    for index, record in enumerate(candidates, start=1):
        print(f"[{index}/{len(candidates)}] {record.get('paper_doi')} -> {record.get('dataset_doi')}", flush=True)
        row = download_record(record, args.max_size_mb, dry_run=args.list_only, file_pattern=args.file_pattern)
        print(f"    {row['status']}  {row.get('total_size_mb','?')} Mo  {row.get('n_files','?')} fichiers  {row.get('note','')}")
        rows.append(row)
        record["dataset_download_status"] = row.get("status", "")
        record["dataset_download_note"] = row.get("note", "")
        if row.get("target_dir"):
            record["local_raw_dir"] = row.get("target_dir", "")
        if row["status"] == "downloaded":
            record["ingestion_status"] = "raw_data_downloaded"
        elif row["status"] == "rejected_supplement_mirror":
            record["ingestion_status"] = "rejected_supplement_mirror_no_raw_data"
            record["rejection_reason"] = row.get("note", "")

    if rows:
        DOWNLOAD_MANIFEST.parent.mkdir(parents=True, exist_ok=True)
        with DOWNLOAD_MANIFEST.open("w", encoding="utf-8", newline="") as fh:
            writer = csv.DictWriter(fh, fieldnames=list(rows[0].keys()), delimiter="\t")
            writer.writeheader()
            writer.writerows(rows)
        print(f"manifest: {DOWNLOAD_MANIFEST}")

    if not args.list_only:
        save_records(candidates)
        print(f"statuts mis a jour dans: {MANIFEST_PATH}")


if __name__ == "__main__":
    main()
