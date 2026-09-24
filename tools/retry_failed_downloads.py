#!/usr/bin/env python
"""One-off retry pass for dataset_first/journal_first candidates whose files
were verified real but the actual download failed (Dryad 429 rate-limit
storm observed session 2026-08-16, triggered by --workers concurrency hitting
the file-download endpoint too fast). Runs strictly serially with a delay
between candidates -- the opposite of the concurrent harvest, on purpose, to
avoid re-triggering the same rate limit. Updates the accumulator files and
the KG in place; anything still failing after this pass is left as-is for
the harvest scripts' own manual-retrieval reporting.
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

from harvest_dataset_first import (  # noqa: E402
    ACCUMULATOR_PATH as DATASET_FIRST_PATH,
    download_dataset_files,
    slug,
)
from harvest_journal_first import (  # noqa: E402
    ACCUMULATOR_PATH as JOURNAL_FIRST_PATH,
    download_verified_candidate,
    verify_dataset_candidate,
)


def retry_dataset_first() -> None:
    payload = json.loads(DATASET_FIRST_PATH.read_text(encoding="utf-8"))
    records = payload.get("records", [])
    targets = [r for r in records if r.get("verified") and r.get("download_status") in {"failed", "partial"}]
    print(f"dataset_first: {len(targets)} candidat(s) a retenter")
    ok, still_failed = 0, []
    for rec in targets:
        doi, repo = rec["dataset_doi"], rec["repo"]
        verified = verify_dataset_candidate(doi, repo, min_size_kb=0)
        if not verified.get("verified"):
            still_failed.append((doi, rec.get("paper_title") or rec.get("dataset_title")))
            continue
        target_dir = download_dataset_files(verified, dataset_slug=slug(doi))
        rec["download_status"] = verified.get("download_status")
        rec["note"] = verified.get("note")
        rec["local_raw_dir"] = verified.get("local_raw_dir")
        if target_dir is not None:
            ok += 1
            print(f"  OK  {doi}")
        else:
            still_failed.append((doi, rec.get("paper_title") or rec.get("dataset_title")))
            print(f"  ECHEC  {doi}  {rec.get('note')}")
        time.sleep(12)
    DATASET_FIRST_PATH.write_text(json.dumps({"records": records}, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"dataset_first: {ok} recuperes, {len(still_failed)} toujours en echec")
    return still_failed


def retry_journal_first() -> None:
    payload = json.loads(JOURNAL_FIRST_PATH.read_text(encoding="utf-8"))
    records = payload.get("records", [])
    still_failed = []
    ok = 0
    for rec in records:
        fname = Path(rec.get("local_pdf", "")).stem or slug(rec.get("paper_title") or "unknown")
        for cand in rec.get("dataset_candidates") or []:
            if cand.get("verified") and cand.get("download_status") in {"failed", "partial"}:
                doi, repo = cand["doi_or_url"], cand["repo"]
                verified = verify_dataset_candidate(doi, repo, min_size_kb=0)
                if not verified.get("verified"):
                    still_failed.append((doi, rec.get("paper_title")))
                    continue
                target_dir = download_verified_candidate(verified, paper_slug=fname)
                cand["download_status"] = verified.get("download_status")
                cand["note"] = verified.get("note")
                cand["local_raw_dir"] = verified.get("local_raw_dir")
                if target_dir is not None:
                    ok += 1
                    print(f"  OK  {doi}")
                else:
                    still_failed.append((doi, rec.get("paper_title")))
                    print(f"  ECHEC  {doi}  {cand.get('note')}")
                time.sleep(12)
    JOURNAL_FIRST_PATH.write_text(json.dumps({"records": records}, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"journal_first: {ok} recuperes, {len(still_failed)} toujours en echec")
    return still_failed


if __name__ == "__main__":
    f1 = retry_dataset_first()
    f2 = retry_journal_first()
    still_failed = f1 + f2
    if still_failed:
        print("\n-- Toujours en echec apres nouvelle tentative (a telecharger manuellement) --")
        for doi, title in still_failed:
            print(f"  {doi}  ({title})")
