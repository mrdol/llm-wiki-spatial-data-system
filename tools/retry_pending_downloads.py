"""Pour les 30 candidats medium au statut candidate_dataset_download_pending
(deja verifies reels dans le KG mais jamais effectivement telecharges -- run
initial sans --download-data, ou tentative jamais faite), retelecharge les
fichiers reels via les memes fonctions que le harvest (aucun contournement,
juste completer un telechargement deja identifie comme legitime). Puis, pour
les candidats journal_first avec un PDF deja local, relance l'extraction de
formule + verification de completude maintenant que les donnees sont la.
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

from harvest_journal_first import (  # noqa: E402
    RAW_DATA_DIR,
    KG_PATH,
    BARE_DOI_REPO_PREFIX,
    verify_dataset_candidate,
    normalize_doi,
    tei_full_text,
    extract_formula_candidates,
    check_formula_completeness,
)
from dataset_manifest_check import request_headers  # noqa: E402
import requests  # noqa: E402


def repo_from_doi(doi: str) -> str | None:
    for prefix, repo in BARE_DOI_REPO_PREFIX.items():
        if doi.startswith(prefix):
            return repo
    return None


def download_files(candidate: dict, *, slug: str) -> Path | None:
    """Copie minimale de download_verified_candidate, avec un prefixe de
    dossier neutre (source mixte DataCite/journal-first/dataset-first ici,
    'JournalFirst_' serait trompeur pour les 2/3 qui ne le sont pas)."""
    files = candidate.get("files") or []
    if not files:
        return None
    target_dir = RAW_DATA_DIR / f"MediumPriorityRetry_{slug}"
    target_dir.mkdir(parents=True, exist_ok=True)
    downloaded = 0
    for f in files:
        name, url = f.get("name"), f.get("url")
        if not name or not url:
            continue
        dest = target_dir / name
        dest.parent.mkdir(parents=True, exist_ok=True)
        if dest.exists() and dest.stat().st_size > 0:
            downloaded += 1
            continue
        try:
            resp = requests.get(url, timeout=180, headers=request_headers(candidate["repo"]), allow_redirects=True)
            resp.raise_for_status()
            dest.write_bytes(resp.content)
            downloaded += 1
        except Exception:  # noqa: BLE001
            pass
    if not downloaded:
        try:
            target_dir.rmdir()
        except OSError:
            pass
        return None
    return target_dir


def main() -> None:
    curation_path = ROOT / "data/manifests/papers/paper_dataset_benchmark_candidates.json"
    curation = json.loads(curation_path.read_text(encoding="utf-8"))
    rows = curation if isinstance(curation, list) else curation.get("candidates", curation.get("records", []))
    medium = [r for r in rows if r.get("curation_priority") == "medium"]
    targets = [r for r in medium if r.get("download_status") == "candidate_dataset_download_pending"]
    print(f"{len(targets)} candidat(s) a retenter")

    kg = json.loads(KG_PATH.read_text(encoding="utf-8"))
    kg_by_doi = {normalize_doi(r.get("dataset_doi")): r for r in kg.get("records", []) if r.get("dataset_doi")}

    ok, skipped, failed = 0, [], []
    for row in targets:
        doi = normalize_doi(row.get("dataset_doi"))
        repo = repo_from_doi(doi)
        if repo is None:
            skipped.append((doi, "repo non identifiable depuis le prefixe DOI"))
            continue
        verified = verify_dataset_candidate(doi, repo, min_size_kb=0)
        if not verified.get("verified"):
            failed.append((doi, verified.get("note")))
            continue
        target_dir = download_files(verified, slug=doi.replace("/", "_").replace(".", "_"))
        if target_dir is None:
            failed.append((doi, verified.get("note")))
            continue
        ok += 1
        print(f"  OK  {doi}  ({verified.get('n_files')} fichiers)")

        kg_rec = kg_by_doi.get(doi)
        if kg_rec is not None:
            kg_rec["ingestion_status"] = "raw_data_downloaded_pending_loader"
            kg_rec["local_raw_dir"] = str(target_dir.relative_to(ROOT))
            local_pdf = kg_rec.get("local_pdf")
            if local_pdf:
                tei_path = ROOT / str(local_pdf).replace("raw_pdf", "tei").replace(".pdf", ".tei.xml")
                if tei_path.exists():
                    full_text = tei_full_text(tei_path)
                    fc = extract_formula_candidates(full_text)
                    kg_rec["formula_completeness"] = check_formula_completeness(fc, target_dir)
        time.sleep(2)

    KG_PATH.write_text(json.dumps(kg, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"\nrecuperes: {ok}, non identifiables (repo inconnu): {len(skipped)}, echecs: {len(failed)}")
    if skipped:
        print("\n-- Repo non identifiable (a inspecter manuellement) --")
        for doi, reason in skipped:
            print(f"  {doi}  [{reason}]")
    if failed:
        print("\n-- Echecs de verification/telechargement --")
        for doi, note in failed:
            print(f"  {doi}  [{note}]")


if __name__ == "__main__":
    main()
