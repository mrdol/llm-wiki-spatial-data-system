#!/usr/bin/env python
"""Build/download a dataset-first batch from an explicit DOI list.

This is the targeted counterpart of ``tools/harvest_dataset_first.py``: it
does not search Dryad/Zenodo again. It starts from known dataset DOIs, verifies
their repository file manifests, optionally downloads files, and writes records
compatible with ``tools/ingest_dataset_first_candidates.py``.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import sys
import time
from pathlib import Path
from typing import Any

import requests

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

from dataset_manifest_check import (  # noqa: E402
    classify_file_manifest,
    list_files,
    load_local_env,
    request_headers,
)
from harvest_dataset_first import (  # noqa: E402
    analyze_dataset_first_candidate,
    clean_doi,
    openalex_work_by_doi,
    slug,
)
from lit_common import normalize_openalex_work  # noqa: E402

RAW_DATA_DIR = ROOT / "data" / "raw" / "papers"
DEFAULT_INPUT = ROOT / "tmp" / "dataset_first_explicit_download_batch_2026-09-03.csv"
DEFAULT_OUTPUT = ROOT / "data" / "manifests" / "papers" / "dataset_first_candidates_explicit_batch_2026-09-03.json"
DEFAULT_REPORT = ROOT / "data" / "manifests" / "papers" / "dataset_first_explicit_download_batch_2026-09-03.csv"
UA = {"User-Agent": "llm-wiki-spatial-data-system/0.1 explicit-dataset-first-download"}

ZENODO_PUBLICATION_RELATIONS = {
    "issupplementto",
    "iscitedby",
    "cites",
    "isdocumentedby",
    "isreferencedby",
    "isdescribedby",
}


def repo_from_doi(doi: str) -> str:
    doi = clean_doi(doi).lower()
    if doi.startswith("10.5061/dryad.") or doi.startswith("10.25338/"):
        return "dryad"
    if doi.startswith("10.5281/zenodo."):
        return "zenodo"
    if doi.startswith("10.6084/m9.figshare.") or doi.startswith("10.25384/"):
        return "figshare"
    if doi.startswith("10.7910/dvn/"):
        return "dataverse"
    return "unknown"


def dryad_metadata(dataset_doi: str) -> dict[str, Any]:
    import urllib.parse

    enc = urllib.parse.quote(f"doi:{dataset_doi}", safe="")
    resp = requests.get(
        f"https://datadryad.org/api/v2/datasets/{enc}",
        timeout=30,
        headers=request_headers("dryad"),
    )
    resp.raise_for_status()
    payload = resp.json()
    related = payload.get("relatedWorks") or []
    pub_doi, pub_rel = None, None
    for item in related:
        if (item.get("identifierType") or "").upper() == "DOI":
            cand = clean_doi(item.get("identifier") or "")
            if cand and cand != dataset_doi:
                pub_doi, pub_rel = cand, item.get("relationship")
                break
    return {
        "dataset_title": payload.get("title"),
        "dataset_abstract": payload.get("abstract"),
        "dataset_keywords": payload.get("keywords") or [],
        "linked_publication_doi": pub_doi,
        "linked_publication_relationship": pub_rel,
    }


def zenodo_metadata(dataset_doi: str) -> dict[str, Any]:
    match = re.search(r"zenodo\.(\d+)", dataset_doi, re.IGNORECASE)
    if not match:
        return {}
    resp = requests.get(f"https://zenodo.org/api/records/{match.group(1)}", timeout=30, headers=UA)
    resp.raise_for_status()
    payload = resp.json()
    meta = payload.get("metadata") or {}
    pub_doi, pub_rel = None, None
    for item in meta.get("related_identifiers") or []:
        relation = (item.get("relation") or "").lower()
        if (item.get("scheme") or "").lower() == "doi" and relation in ZENODO_PUBLICATION_RELATIONS:
            cand = clean_doi(item.get("identifier") or "")
            if cand and cand != dataset_doi:
                pub_doi, pub_rel = cand, item.get("relation")
                break
    return {
        "dataset_title": meta.get("title"),
        "dataset_abstract": meta.get("description"),
        "dataset_keywords": meta.get("keywords") or [],
        "linked_publication_doi": pub_doi,
        "linked_publication_relationship": pub_rel,
    }


def metadata_for(repo: str, dataset_doi: str) -> dict[str, Any]:
    try:
        if repo == "dryad":
            return dryad_metadata(dataset_doi)
        if repo == "zenodo":
            return zenodo_metadata(dataset_doi)
    except Exception as exc:  # noqa: BLE001
        return {"metadata_error": f"{type(exc).__name__}: {exc}"}
    return {}


def download_files(repo: str, dataset_doi: str, files: list[dict[str, Any]]) -> tuple[str, str | None, str]:
    target_dir = RAW_DATA_DIR / f"DatasetFirst_{slug(dataset_doi)}"
    target_dir.mkdir(parents=True, exist_ok=True)
    downloaded = 0
    errors = []
    for item in files:
        name = item.get("name")
        url = item.get("url")
        if not name or not url:
            errors.append(f"missing name/url: {item}")
            continue
        dest = target_dir / name
        dest.parent.mkdir(parents=True, exist_ok=True)
        if dest.exists() and dest.stat().st_size > 0:
            downloaded += 1
            continue
        last_error = None
        for attempt in range(3):
            try:
                with requests.get(url, timeout=180, headers=request_headers(repo), allow_redirects=True, stream=True) as resp:
                    if resp.status_code == 429 and attempt < 2:
                        time.sleep(10 * (attempt + 1))
                        continue
                    resp.raise_for_status()
                    tmp = dest.with_suffix(dest.suffix + ".part")
                    with tmp.open("wb") as fh:
                        for chunk in resp.iter_content(chunk_size=1024 * 1024):
                            if chunk:
                                fh.write(chunk)
                    tmp.replace(dest)
                downloaded += 1
                last_error = None
                break
            except Exception as exc:  # noqa: BLE001
                last_error = exc
                time.sleep(5 * (attempt + 1))
        if last_error is not None:
            errors.append(f"{name}: {last_error}")
    if downloaded and not errors:
        return "downloaded", str(target_dir.relative_to(ROOT)), ""
    if downloaded:
        return "partial", str(target_dir.relative_to(ROOT)), " ; ".join(errors)[:500]
    try:
        target_dir.rmdir()
    except OSError:
        pass
    return "failed", None, " ; ".join(errors)[:500]


def read_input(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as fh:
        rows = list(csv.DictReader(fh))
    out = []
    seen = set()
    for row in rows:
        doi = clean_doi(row.get("dataset_doi") or row.get("doi") or "")
        if not doi or doi in seen:
            continue
        seen.add(doi)
        row["dataset_doi"] = doi
        row["repo"] = (row.get("repo") or repo_from_doi(doi)).lower()
        out.append(row)
    return out


def main() -> int:
    parser = argparse.ArgumentParser(description="Download/verify an explicit dataset-first DOI batch.")
    parser.add_argument("--input", default=str(DEFAULT_INPUT))
    parser.add_argument("--output", default=str(DEFAULT_OUTPUT))
    parser.add_argument("--report", default=str(DEFAULT_REPORT))
    parser.add_argument("--download-data", action="store_true")
    parser.add_argument(
        "--accept-existing-local",
        action="store_true",
        help="If data/raw/papers/DatasetFirst_<doi> already contains files, mark the record downloaded without fetching missing files.",
    )
    parser.add_argument("--min-dataset-size-kb", type=int, default=0)
    parser.add_argument("--max-dataset-size-kb", type=int, default=500_000)
    parser.add_argument("--file-pattern", default=None, help="Regex limiting downloaded files by name.")
    parser.add_argument("--mailto", default=None)
    parser.add_argument("--sleep-sec", type=float, default=0.5)
    args = parser.parse_args()

    load_local_env()
    rows_in = read_input(Path(args.input).resolve())
    pattern = re.compile(args.file_pattern, re.IGNORECASE) if args.file_pattern else None
    records = []
    report_rows = []

    for index, row in enumerate(rows_in, start=1):
        dataset_doi = row["dataset_doi"]
        repo = row["repo"]
        print(f"[{index}/{len(rows_in)}] {repo} {dataset_doi}", flush=True)
        meta = metadata_for(repo, dataset_doi)
        title = meta.get("dataset_title") or row.get("title") or row.get("title_log")
        abstract = meta.get("dataset_abstract") or ""
        keywords = meta.get("dataset_keywords") or []
        text = " ".join([str(title or ""), str(abstract or ""), " ".join(map(str, keywords))])
        analysis = analyze_dataset_first_candidate(
            text,
            strict_spatial_only=False,
            include_low_priority_domains=True,
        )

        record: dict[str, Any] = {
            "record_type": "dataset_first_candidate",
            "repo": repo,
            "query": row.get("query") or "explicit_doi_batch",
            "dataset_doi": dataset_doi,
            "dataset_title": title,
            "dataset_abstract": abstract,
            "dataset_keywords": keywords,
            "dataset_literature_score": analysis.get("literature_score"),
            "dataset_first_score": analysis.get("dataset_first_score"),
            "dataset_candidate_decision": analysis.get("candidate_decision"),
            "dataset_first_decision": analysis.get("dataset_first_decision"),
            "strict_spatial_model_terms": analysis.get("strict_spatial_model_terms"),
            "regression_terms": analysis.get("regression_terms"),
            "pure_spatial_terms": analysis.get("pure_spatial_terms"),
            "spatiotemporal_penalty_terms": analysis.get("spatiotemporal_penalty_terms"),
            "low_priority_domain_terms": analysis.get("low_priority_domain_terms"),
            "dataset_first_blockers": analysis.get("dataset_first_blockers"),
            "linked_publication_doi": meta.get("linked_publication_doi") or row.get("linked_publication_doi"),
            "linked_publication_relationship": meta.get("linked_publication_relationship"),
            "paper_resolved": False,
        }
        if meta.get("metadata_error"):
            record["metadata_error"] = meta["metadata_error"]

        try:
            files = list_files(repo, dataset_doi)
            probably_real, reason = classify_file_manifest(files)
        except Exception as exc:  # noqa: BLE001
            files = []
            probably_real = False
            reason = f"{type(exc).__name__}: {exc}"

        if pattern:
            files = [f for f in files if f.get("name") and pattern.search(str(f["name"]))]
            if not files:
                probably_real = False
                reason = f"aucun fichier ne matche --file-pattern {args.file_pattern!r}"

        total_kb = int(sum(f.get("size") or 0 for f in files) / 1024)
        record["verified"] = bool(probably_real)
        record["n_files"] = len(files)
        record["note"] = reason
        record["local_raw_dir"] = None

        local_dir = RAW_DATA_DIR / f"DatasetFirst_{slug(dataset_doi)}"
        local_files = list(local_dir.rglob("*")) if local_dir.exists() else []
        local_file_count = sum(1 for p in local_files if p.is_file())

        if args.accept_existing_local and local_file_count > 0:
            record["verified"] = True
            record["download_status"] = "downloaded"
            record["local_raw_dir"] = str(local_dir.relative_to(ROOT))
            record["note"] = f"{reason} | fichiers deja presents localement: {local_file_count}"
        elif not probably_real:
            record["download_status"] = "failed"
        elif args.min_dataset_size_kb and total_kb < args.min_dataset_size_kb:
            record["download_status"] = "verified_pending_download"
            record["note"] = f"{reason} | sous seuil minimal {total_kb}Ko < {args.min_dataset_size_kb}Ko, non telecharge automatiquement"
        elif args.max_dataset_size_kb and total_kb > args.max_dataset_size_kb:
            record["download_status"] = "verified_pending_download"
            record["note"] = f"{reason} | depot {total_kb}Ko > seuil max {args.max_dataset_size_kb}Ko, telechargement saute"
        elif args.download_data:
            status, local_raw_dir, note = download_files(repo, dataset_doi, files)
            record["download_status"] = status
            record["local_raw_dir"] = local_raw_dir
            if note:
                record["note"] = f"{record['note']} | erreurs telechargement: {note}"
        else:
            record["download_status"] = "verified_pending_download"

        pub_doi = clean_doi(record.get("linked_publication_doi") or "")
        if pub_doi:
            record["paper_doi"] = pub_doi
            work = openalex_work_by_doi(pub_doi, mailto=args.mailto)
            if work:
                paper = normalize_openalex_work(work, query="explicit_doi_batch")
                record["paper_resolved"] = True
                for key in ("paper_openalex_id", "paper_title", "paper_year", "paper_venue", "paper_abstract"):
                    record[key] = paper.get(key)
                oa = work.get("open_access") or {}
                record["is_oa"] = oa.get("is_oa")
                record["oa_url"] = oa.get("oa_url")

        records.append(record)
        report_rows.append(
            {
                "dataset_doi": dataset_doi,
                "repo": repo,
                "verified": record.get("verified"),
                "download_status": record.get("download_status"),
                "n_files": record.get("n_files"),
                "total_mb": f"{total_kb / 1024:.2f}",
                "local_raw_dir": record.get("local_raw_dir") or "",
                "linked_publication_doi": record.get("linked_publication_doi") or "",
                "paper_resolved": record.get("paper_resolved"),
                "title": title or "",
                "note": record.get("note") or "",
            }
        )
        print(
            "    {status}  files={files}  size={size:.2f} MB  raw={raw}".format(
                status=record.get("download_status"),
                files=record.get("n_files"),
                size=total_kb / 1024,
                raw=record.get("local_raw_dir") or "-",
            ),
            flush=True,
        )
        time.sleep(args.sleep_sec)

    output = Path(args.output).resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps({"records": records}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    report = Path(args.report).resolve()
    report.parent.mkdir(parents=True, exist_ok=True)
    with report.open("w", encoding="utf-8-sig", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=list(report_rows[0].keys()))
        writer.writeheader()
        writer.writerows(report_rows)

    print(f"records: {len(records)}")
    print(f"output: {output}")
    print(f"report: {report}")
    return 0


if __name__ == "__main__":
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    raise SystemExit(main())
