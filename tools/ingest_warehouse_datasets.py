#!/usr/bin/env python
"""Telecharge et enregistre les candidats Bloc 3 (entrepots, sans papier).

Contrairement au Bloc 2, pas de PDF/GROBID/formule a extraire : une fois le
controle structurel passe (tools/check_warehouse_dataset_availability.py),
le dataset est directement telecharge et enregistre dans le KG, pret pour la
conversion sf commune a tous les blocs.

Usage:
    python tools/ingest_warehouse_datasets.py --list-only
    python tools/ingest_warehouse_datasets.py --all
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import unicodedata
from pathlib import Path
from typing import Any

from dataset_manifest_check import list_files, repo_from_url

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


ROOT = Path(__file__).resolve().parent.parent
CANDIDATES_PATH = ROOT / "data" / "manifests" / "papers" / "warehouse_dataset_candidates.json"
RAW_DIR = ROOT / "data" / "raw" / "warehouse"
KG_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"


def normalize_doi(value: Any) -> str:
    text = str(value or "").strip().lower()
    text = re.sub(r"^https?://(dx\.)?doi\.org/", "", text)
    return text.rstrip(".")


def slug(value: str) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    return re.sub(r"[^A-Za-z0-9]+", "_", value.lower()).strip("_") or "unknown"


def bib_key(row: dict[str, Any]) -> str:
    year = str(row.get("year") or "nd")
    title = str(row.get("title") or "warehouse candidate")
    words = [w for w in re.split(r"[^A-Za-z0-9]+", title) if w]
    title_part = "".join(w[:18].capitalize() for w in words[:4]) or "WarehouseCandidate"
    doi_part = slug(normalize_doi(row.get("dataset_doi")))[:16]
    return f"Warehouse_{year}_{title_part}_{doi_part}"


def load_kg() -> dict[str, Any]:
    if not KG_PATH.exists():
        return {"records": []}
    return json.loads(KG_PATH.read_text(encoding="utf-8-sig"))


def save_kg(payload: dict[str, Any]) -> None:
    KG_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")


def download_dataset(row: dict[str, Any], max_size_mb: float, dry_run: bool) -> dict[str, Any]:
    dataset_doi = str(row.get("dataset_doi") or "")
    url = str(row.get("data_access_url") or "")
    repo = repo_from_url(url)
    bk = bib_key(row)
    base = {"bib_key": bk, "dataset_doi": dataset_doi, "repo": repo, "status": "", "note": ""}

    if repo not in {"figshare", "dataverse", "dryad", "zenodo", "sciencebase", "pangaea", "b2share"}:
        return {**base, "status": "skipped_unsupported_repo", "note": f"'{repo}' non gere automatiquement."}

    try:
        files = list_files(repo, dataset_doi, url)
    except Exception as exc:  # noqa: BLE001
        return {**base, "status": "error_listing_files", "note": str(exc)}
    if not files:
        return {**base, "status": "no_files_found"}

    total_mb = sum(f.get("size") or 0 for f in files) / (1024 * 1024)
    if total_mb > max_size_mb:
        return {**base, "status": "skipped_too_large", "note": f"{total_mb:.0f} Mo > seuil {max_size_mb:.0f} Mo"}

    if dry_run:
        return {**base, "status": "dry_run", "note": f"{len(files)} fichier(s), {total_mb:.1f} Mo"}

    import requests

    target_dir = RAW_DIR / bk
    target_dir.mkdir(parents=True, exist_ok=True)
    downloaded, errors = 0, []
    for f in files:
        if not f.get("url") or not f.get("name"):
            continue
        dest = target_dir / f["name"]
        if dest.exists() and dest.stat().st_size > 0:
            downloaded += 1
            continue
        try:
            resp = requests.get(f["url"], timeout=180, headers={"User-Agent": "llm-wiki-spatial-data-system/0.1"}, allow_redirects=True)
            resp.raise_for_status()
            dest.write_bytes(resp.content)
            downloaded += 1
        except Exception as exc:  # noqa: BLE001
            errors.append(f"{f['name']}: {exc}")

    if errors and downloaded == 0:
        return {**base, "status": "failed", "note": " ; ".join(errors)[:400]}
    if errors:
        return {**base, "status": "partial", "note": " ; ".join(errors)[:400]}
    return {**base, "status": "downloaded", "note": f"{downloaded} fichier(s) -> {target_dir}"}


def kg_record(row: dict[str, Any], download_status: str, conversion: dict[str, Any] | None) -> dict[str, Any]:
    dataset_doi = normalize_doi(row.get("dataset_doi"))
    bk = bib_key(row)
    if download_status != "downloaded":
        ingestion_status = f"warehouse_download_{download_status}"
    elif conversion and conversion.get("status") == "converted":
        ingestion_status = "converted_to_sf"
    else:
        ingestion_status = "raw_data_downloaded_needs_manual_conversion"

    record = {
        "paper_id": f"dataset:warehouse:{slug(dataset_doi)}",
        "bib_key": bk,
        "paper_title": None,
        "paper_doi": None,
        "dataset_name_in_paper": row.get("title"),
        "canonical_dataset_id": f"dataset_candidate:warehouse:{slug(dataset_doi)}",
        "target_type": "WarehouseDatasetCandidate",
        "ingestion_status": ingestion_status,
        "theme": "",
        "n_observations": conversion.get("n_obs") if conversion else None,
        "n_covariates": None,
        "source_type": "warehouse_verified_candidate",
        "source_ref": f"DataCite dataset DOI {row.get('dataset_doi')} (no associated publication - Bloc 3)",
        "source_url": row.get("data_access_url"),
        "evidence": row.get("dataset_check_reason") or "",
        "evidence_page": None,
        "estimators_used": [],
        "cv_scheme": None,
        "formula": None,
        "spatial_characterization": row.get("dataset_check_reason") or "",
        "confidence": "low",
        "dataset_doi": row.get("dataset_doi"),
        "data_access_url": row.get("data_access_url"),
        "license_name": row.get("license_name"),
        "publisher": row.get("publisher"),
        "local_raw_dir": str((RAW_DIR / bk).relative_to(ROOT)) if download_status == "downloaded" else None,
    }
    if conversion and conversion.get("status") == "converted":
        record["local_sf_path"] = conversion.get("sf_path")
        record["local_typology_path"] = conversion.get("typology_path")
    elif conversion:
        record["conversion_failure_reason"] = conversion.get("reason")
    return record


def main() -> int:
    parser = argparse.ArgumentParser(description="Download and register Bloc 3 warehouse dataset candidates.")
    parser.add_argument("--max-size-mb", type=float, default=200)
    parser.add_argument("--list-only", action="store_true")
    parser.add_argument("--all", action="store_true")
    args = parser.parse_args()

    if not args.all and not args.list_only:
        print("Precise --all ou --list-only.")
        return 0

    rows = json.loads(CANDIDATES_PATH.read_text(encoding="utf-8-sig"))
    payload = load_kg()
    known_dataset_dois = {normalize_doi(r.get("dataset_doi")) for r in payload.get("records", [])} - {""}

    results = []
    new_records = []
    for index, row in enumerate(rows, start=1):
        doi = normalize_doi(row.get("dataset_doi"))
        if doi in known_dataset_dois:
            print(f"[{index}/{len(rows)}] {doi} -> deja dans le KG, ignore")
            continue
        print(f"[{index}/{len(rows)}] {doi} -> {row.get('title', '')[:60]}", flush=True)
        result = download_dataset(row, args.max_size_mb, dry_run=args.list_only)
        print(f"    {result['status']}  {result.get('note', '')}")
        results.append(result)

        conversion = None
        if not args.list_only and result["status"] == "downloaded":
            from warehouse_sf_conversion import convert_warehouse_folder

            bk = bib_key(row)
            conversion = convert_warehouse_folder(bk, RAW_DIR / bk)
            if conversion["status"] == "converted":
                print(f"    converted_to_sf: N={conversion['n_obs']} T={conversion['t_periods']} ({conversion['method']}) -> {conversion['sf_path']}")
            else:
                print(f"    conversion_failed: {conversion['reason']}")

        if not args.list_only:
            new_records.append(kg_record(row, result["status"], conversion))

    if new_records:
        payload.setdefault("records", []).extend(new_records)
        save_kg(payload)
        print(f"\n{len(new_records)} enregistrement(s) ajoute(s) au KG.")

    counts: dict[str, int] = {}
    for r in results:
        counts[r["status"]] = counts.get(r["status"], 0) + 1
    print("summary:", counts)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
