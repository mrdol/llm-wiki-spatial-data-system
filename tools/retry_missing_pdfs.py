#!/usr/bin/env python
"""Pour les candidats dataset-first ayant deja un dataset reel telecharge et
un paper_doi connu (resolu via OpenAlex) mais dont le PDF n'a jamais ete
recupere (echec initial ou --download-pdf non tente), retente le
telechargement PDF + GROBID + verification de completude de formule.
Strictement legal : re-essaie la meme URL OA deja identifiee par OpenAlex,
ne contourne aucune protection. Les echecs restants (page d'atterrissage
editeur, pas payant a priori mais bloque) sont listes pour recuperation
manuelle par l'utilisateur.
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

from harvest_dataset_first import ACCUMULATOR_PATH, slug  # noqa: E402
from harvest_journal_first import (  # noqa: E402
    RAW_PDF_DIR,
    download_pdf,
    run_grobid_on_pdf,
    slug_filename,
    tei_full_text,
    extract_formula_candidates,
    check_formula_completeness,
    normalize_doi,
)
from lit_common import analyze_literature_candidate, normalize_openalex_work  # noqa: E402
from harvest_dataset_first import openalex_work_by_doi  # noqa: E402


def main() -> None:
    payload = json.loads(ACCUMULATOR_PATH.read_text(encoding="utf-8"))
    records = payload["records"]
    targets = [
        r for r in records
        if r.get("verified") and r.get("download_status") == "downloaded"
        and not r.get("local_pdf") and r.get("paper_doi")
    ]
    print(f"{len(targets)} candidat(s) avec dataset present + paper_doi connu mais sans PDF local")

    recovered, still_failed = 0, []
    for rec in targets:
        pub_doi = normalize_doi(rec["paper_doi"])
        work = openalex_work_by_doi(pub_doi, mailto="doliveirajohnny9@gmail.com")
        if work is None:
            still_failed.append((rec["dataset_doi"], pub_doi, rec.get("paper_title"), "DOI introuvable via OpenAlex"))
            continue
        paper_record = normalize_openalex_work(work, query="retry_missing_pdf")
        oa = work.get("open_access") or {}
        is_oa, oa_url = oa.get("is_oa"), oa.get("oa_url")
        if not (is_oa and oa_url):
            still_failed.append((rec["dataset_doi"], pub_doi, rec.get("paper_title"), "pas en open access (paywall)"))
            continue

        RAW_PDF_DIR.mkdir(parents=True, exist_ok=True)
        fname = slug_filename(paper_record.get("paper_title") or "untitled", paper_record.get("paper_openalex_id") or slug(pub_doi))
        pdf_path = RAW_PDF_DIR / f"{fname}.pdf"
        if pdf_path.exists() or download_pdf(oa_url, pdf_path):
            rec["pdf_download_status"] = "downloaded"
            rec["local_pdf"] = str(pdf_path.relative_to(ROOT))
            rec["paper_resolved"] = True
            for k in ("paper_title", "paper_year", "paper_venue"):
                rec[k] = paper_record.get(k)
            tei_path = run_grobid_on_pdf(pdf_path, grobid_url="http://localhost:8070")
            if tei_path is not None:
                rec["grobid_status"] = "ok"
                rec["local_tei"] = str(tei_path.relative_to(ROOT))
                full_text = tei_full_text(tei_path)
                fa = analyze_literature_candidate(full_text)
                rec["full_text_literature_score"] = fa["literature_score"]
                raw_dir = ROOT / rec["local_raw_dir"] if rec.get("local_raw_dir") else None
                if raw_dir and raw_dir.exists():
                    fc_candidates = extract_formula_candidates(full_text)
                    rec["formula_completeness"] = check_formula_completeness(fc_candidates, raw_dir)
            recovered += 1
            print(f"  OK  {rec['dataset_doi']}  ({paper_record.get('paper_title')})")
        else:
            still_failed.append((rec["dataset_doi"], pub_doi, rec.get("paper_title"), "telechargement PDF echoue (page d'atterrissage editeur probable)"))
            print(f"  ECHEC PDF  {rec['dataset_doi']}  {oa_url}")
        time.sleep(2)

    ACCUMULATOR_PATH.write_text(json.dumps({"records": records}, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"\nrecuperes: {recovered}, toujours sans PDF: {len(still_failed)}")
    if still_failed:
        print("\n-- A recuperer manuellement --")
        for dataset_doi, pub_doi, title, reason in still_failed:
            print(f"  dataset={dataset_doi}  papier_doi={pub_doi}  ({title})  [{reason}]")


if __name__ == "__main__":
    main()
