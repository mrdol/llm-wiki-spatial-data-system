#!/usr/bin/env python
"""Retente le telechargement des candidats Bloc 3 rejetes comme 'depot non
supporte', apres ajout d'un nouveau connecteur (ScienceBase, PANGAEA,
B2SHARE, Dataverse generique...) dans dataset_manifest_check.py.

Ne retouche pas les DOI/URL/dataset_doi existants : relit juste le repo avec
la version a jour de repo_from_url() et retente le telechargement si le
depot est desormais reconnu.

Usage:
    python tools/retry_warehouse_download.py --list-only
    python tools/retry_warehouse_download.py --all
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from dataset_manifest_check import list_files, repo_from_url

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent.parent
KG_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
RAW_DIR = ROOT / "data" / "raw" / "warehouse"

TARGET_STATUS = "warehouse_download_skipped_unsupported_repo"
SUPPORTED_REPOS = {"figshare", "dataverse", "dryad", "zenodo", "sciencebase", "pangaea", "b2share"}


def download_one(record: dict, max_size_mb: float, dry_run: bool) -> dict:
    url = record.get("data_access_url") or record.get("source_url") or ""
    dataset_doi = record.get("dataset_doi") or ""
    repo = repo_from_url(url)
    if repo not in SUPPORTED_REPOS:
        return {"status": "still_unsupported", "repo": repo}

    try:
        files = list_files(repo, dataset_doi, url)
    except Exception as exc:  # noqa: BLE001
        return {"status": "error_listing_files", "note": str(exc)}
    if not files:
        return {"status": "no_files_found", "repo": repo}

    total_mb = sum(f.get("size") or 0 for f in files) / (1024 * 1024)
    if total_mb > max_size_mb:
        return {"status": "skipped_too_large", "note": f"{total_mb:.0f} Mo > seuil {max_size_mb:.0f} Mo", "repo": repo}

    if dry_run:
        return {"status": "dry_run", "note": f"{len(files)} fichier(s), {total_mb:.1f} Mo", "repo": repo}

    import requests

    bib_key = record["bib_key"]
    target_dir = RAW_DIR / bib_key
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
        return {"status": "failed", "note": " ; ".join(errors)[:400], "repo": repo}
    if errors:
        return {"status": "partial", "note": " ; ".join(errors)[:400], "repo": repo}
    return {"status": "downloaded", "note": f"{downloaded} fichier(s) -> {target_dir}", "repo": repo}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-size-mb", type=float, default=200)
    parser.add_argument("--list-only", action="store_true")
    parser.add_argument("--all", action="store_true")
    args = parser.parse_args()
    if not args.all and not args.list_only:
        print("Precise --all ou --list-only.")
        return 0

    payload = json.loads(KG_PATH.read_text(encoding="utf-8-sig"))
    pending = [r for r in payload["records"] if r.get("ingestion_status") == TARGET_STATUS]
    print(f"Candidats a retenter : {len(pending)}")

    converted = 0
    for index, record in enumerate(pending, start=1):
        bib_key = record["bib_key"]
        result = download_one(record, args.max_size_mb, dry_run=args.list_only)
        print(f"[{index}/{len(pending)}] {bib_key} -> {result['status']} {result.get('note', '')}")

        if args.list_only or result["status"] != "downloaded":
            if not args.list_only and result["status"] != "still_unsupported":
                record["ingestion_status"] = f"warehouse_download_{result['status']}"
            continue

        from warehouse_sf_conversion import convert_warehouse_folder

        conversion = convert_warehouse_folder(bib_key, RAW_DIR / bib_key)
        record["local_raw_dir"] = str((RAW_DIR / bib_key).relative_to(ROOT))
        if conversion["status"] == "converted":
            record["ingestion_status"] = "converted_to_sf"
            record["local_sf_path"] = conversion["sf_path"]
            record["local_typology_path"] = conversion["typology_path"]
            record["n_observations"] = conversion["n_obs"]
            record.pop("conversion_failure_reason", None)
            converted += 1
            print(f"    converted_to_sf: N={conversion['n_obs']} T={conversion['t_periods']} ({conversion['method']})")
        else:
            record["ingestion_status"] = "raw_data_downloaded_needs_manual_conversion"
            record["conversion_failure_reason"] = conversion["reason"]
            print(f"    conversion_failed: {conversion['reason']}")

    if not args.list_only:
        KG_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
        print(f"\nKG mis a jour. Nouvellement convertis : {converted}/{len(pending)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
