"""Harvest paper-linked spatial datasets by starting from Dryad + Zenodo dataset search
("dataset-first"), instead of starting from a journal (tools/harvest_journal_first.py) or
from DataCite's global aggregation (tools/harvest_datacite.R).

Rationale (session 2026-08-15): journal-first yielded ~4% (3/68 papers with any extractable
dataset link) on spatial-econometrics/regional-science journals -- those fields often use
restricted/proprietary microdata not deposited in a DOI-linked repo, so scanning article full
text for a repo URL rarely pays off. DataCite-first pulls in a lot of keyword-collision noise
because it aggregates every repository in the world (MRI/EEG/chemistry papers that happen to
use the word "spatial"). Dryad and Zenodo both expose their own search API with keyword/subject
filters *and* a structured related-publication link on every dataset record
(`relatedWorks`/`related_identifiers`) -- so instead of guessing the dataset from the paper's
text, we search the dataset directly and read its own metadata for the paper DOI, no GROBID
scan required to make that link (GROBID is now only needed to check formula completeness once
a linked publication exists and its PDF has been fetched).

Pipeline:
  1. Query the Dryad and Zenodo search APIs with a curated list of spatial-modeling keywords
     (see DEFAULT_QUERIES). This is the dataset-first equivalent of the journal list in
     harvest_journal_first.py: the query vocabulary IS the scope filter.
  2. Deduplicate against everything already known: inst/kg/paper_dataset_uses.json,
     data/manifests/papers/paper_dataset_benchmark_candidates.json, the journal-first
     accumulator's own verified datasets, and this tool's own accumulator
     (data/manifests/papers/dataset_first_candidates.json).
  3. Score each new dataset from its own title/abstract/keywords (reuses
     lit_common.analyze_literature_candidate) -- this is a dataset-relevance score, not a
     paper-relevance score.
  4. Verify real downloadable files exist via dataset_manifest_check.list_files()/
     classify_file_manifest() (reuses harvest_journal_first.verify_dataset_candidate) and
     download them for verified candidates (Dryad OAuth token fix applies here too).
  5. Read the linked publication DOI directly from the dataset's own metadata
     (relatedWorks/related_identifiers), no guessing. Resolve it via OpenAlex
     (works/https://doi.org/<doi>) to get title/venue/year/OA PDF url.
  6. If the paper is open access and the dataset score clears --min-score: download the PDF,
     run GROBID, and check formula completeness against the already-downloaded dataset files
     (reuses harvest_journal_first.extract_formula_candidates/check_formula_completeness).
  7. Append everything (found or not) to the persistent accumulator manifest. A dedicated
     ingestion script (tools/ingest_dataset_first_candidates.py) then bridges verified
     candidates into inst/kg/paper_dataset_uses.json, same as the journal-first pipeline.

Usage:
    python tools/harvest_dataset_first.py --list-queries
    python tools/harvest_dataset_first.py --dry-run --max-pages 1 --per-page 10
    python tools/harvest_dataset_first.py --target 200 --download-pdf --run-grobid --download-data
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import time
import unicodedata
from concurrent.futures import ThreadPoolExecutor, TimeoutError as FutureTimeoutError, as_completed
from pathlib import Path
from typing import Any

import requests

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "code" / "pipeline_lit"))
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "tools" / "kg"))

from lit_common import analyze_literature_candidate, normalize_openalex_work  # noqa: E402
from dataset_manifest_check import load_local_env, request_headers  # noqa: E402
from harvest_journal_first import (  # noqa: E402
    RAW_PDF_DIR,
    RAW_DATA_DIR,
    TEI_DIR,
    KG_PATH,
    BENCHMARK_CANDIDATES_PATH,
    ACCUMULATOR_PATH as JOURNAL_FIRST_ACCUMULATOR_PATH,
    BARE_DOI_REPO_PREFIX,
    normalize_doi,
    slug_filename,
    download_pdf,
    run_grobid_on_pdf,
    tei_full_text,
    extract_formula_candidates,
    check_formula_completeness,
    verify_dataset_candidate,
)

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


ACCUMULATOR_PATH = ROOT / "data" / "manifests" / "papers" / "dataset_first_candidates.json"
UA = {"User-Agent": "llm-wiki-spatial-data-system/0.1 dataset-first-harvest (johnny.d-oliveira@inrae.fr)"}

DEFAULT_QUERIES = [
    "spatial autoregressive model",
    "geographically weighted regression",
    "spatial lag model",
    "spatial error model",
    "spatial durbin model",
    "spatial panel data model",
    "conditional autoregressive model",
    "spatial weight matrix regression",
    "kriging regression covariates",
    "spatial econometrics",
]

DRYAD_SEARCH_URL = "https://datadryad.org/api/v2/search"
ZENODO_SEARCH_URL = "https://zenodo.org/api/records"
OPENALEX_WORKS_URL = "https://api.openalex.org/works"

# Types de relation Zenodo qui indiquent une publication associee au dataset
# (jamais une reference bibliographique quelconque citee dans le dataset).
ZENODO_PUBLICATION_RELATIONS = {
    "issupplementto",
    "iscitedby",
    "cites",
    "isdocumentedby",
    "isreferencedby",
    "isdescribedby",
}


# --------------------------------------------------------------------------
# Helpers
# --------------------------------------------------------------------------

def slug(value: str) -> str:
    value = unicodedata.normalize("NFKD", value or "").encode("ascii", "ignore").decode("ascii")
    value = re.sub(r"[^A-Za-z0-9]+", "_", value.lower())
    return value.strip("_") or "unknown"


def clean_doi(value: str) -> str:
    """harvest_journal_first.normalize_doi() only strips the https://doi.org/
    URL form (OpenAlex DOIs never carry a bare 'doi:' prefix, so it never had
    to). Dryad's search API always returns identifiers as 'doi:10.xxxx/...',
    which dataset_manifest_check.dryad_files() re-prepends itself -- passing
    it through unstripped would silently break dedup and every downstream
    API call keyed on this DOI."""
    text = normalize_doi(value)
    if text.startswith("doi:"):
        text = text[len("doi:"):]
    return text.strip()


# --------------------------------------------------------------------------
# Dryad / Zenodo search
# --------------------------------------------------------------------------

def _get_with_backoff(url: str, *, params: dict[str, Any], headers: dict[str, str], timeout: int = 30, retries: int = 2) -> requests.Response:
    """Zenodo's anonymous search quota is easy to trip when querying dozens of
    paper titles back to back (no ZENODO_ACCESS_TOKEN configured); a single
    429 used to bubble up as a lost query. Retry with a short backoff instead
    of just dropping the query."""
    last_exc: Exception | None = None
    for attempt in range(retries + 1):
        resp = requests.get(url, params=params, headers=headers, timeout=timeout)
        if resp.status_code != 429:
            resp.raise_for_status()
            return resp
        last_exc = requests.HTTPError(f"429 Client Error: TOO MANY REQUESTS for url: {resp.url}")
        if attempt < retries:
            time.sleep(2 * (attempt + 1))
    raise last_exc  # type: ignore[misc]


def search_dryad(query: str, *, page: int, per_page: int) -> list[dict[str, Any]]:
    resp = _get_with_backoff(
        DRYAD_SEARCH_URL,
        params={"q": query, "page": page, "per_page": per_page},
        headers=request_headers("dryad"),
    )
    return resp.json().get("_embedded", {}).get("stash:datasets", [])


def search_zenodo(query: str, *, page: int, per_page: int) -> list[dict[str, Any]]:
    # Pas de "sort": laisser le classement par pertinence par defaut de Zenodo
    # ("bestmatch" quand une requete q= est fournie). "sort=mostrecent" avait
    # ete mis par erreur -- pour une recherche ciblee sur un titre de papier
    # precis, ca renvoyait les depots les plus RECENTS partageant un mot
    # quelconque (physique, politique, vitamines...) au lieu du vrai match.
    resp = _get_with_backoff(
        ZENODO_SEARCH_URL,
        params={"q": query, "type": "dataset", "page": page, "size": per_page},
        headers=UA,
    )
    time.sleep(0.4)  # politesse -- espacer les requetes anonymes evite de retrigger le 429
    return resp.json().get("hits", {}).get("hits", [])


def normalize_dryad_hit(hit: dict[str, Any], query: str) -> dict[str, Any]:
    doi = clean_doi(hit.get("identifier", ""))
    related = hit.get("relatedWorks") or []
    pub_doi, pub_relationship = None, None
    for rw in related:
        if (rw.get("identifierType") or "").upper() == "DOI":
            cand = clean_doi(rw.get("identifier", ""))
            if cand and cand != doi:
                pub_doi, pub_relationship = cand, rw.get("relationship")
                break
    return {
        "repo": "dryad",
        "query": query,
        "dataset_doi": doi,
        "dataset_title": hit.get("title"),
        "dataset_abstract": hit.get("abstract"),
        "dataset_keywords": hit.get("keywords") or [],
        "linked_publication_doi": pub_doi,
        "linked_publication_relationship": pub_relationship,
    }


def normalize_zenodo_hit(hit: dict[str, Any], query: str) -> dict[str, Any]:
    meta = hit.get("metadata", {}) or {}
    doi = clean_doi(hit.get("doi") or meta.get("doi", ""))
    related = meta.get("related_identifiers") or []
    pub_doi, pub_relationship = None, None
    for ri in related:
        if (ri.get("scheme") or "").lower() == "doi" and (ri.get("relation") or "").lower() in ZENODO_PUBLICATION_RELATIONS:
            cand = clean_doi(ri.get("identifier", ""))
            if cand and cand != doi:
                pub_doi, pub_relationship = cand, ri.get("relation")
                break
    # Zenodo miroite parfois des depots Dryad/figshare/... en gardant leur DOI
    # d'origine (ex. "10.5061/dryad.xxx") au lieu d'un "10.5281/zenodo.NNNN" --
    # dataset_manifest_check.zenodo_files() ne sait resoudre que ce dernier
    # format (il extrait l'id numerique du DOI). Sans ce correctif, ces hits
    # echouaient silencieusement la verification (files=[]) tout en
    # "consommant" le DOI dans known_datasets, empechant la vraie verification
    # via le bon depot de tourner plus tard dans le meme run.
    repo = "zenodo"
    if doi and not re.search(r"zenodo\.\d+", doi, re.IGNORECASE):
        for prefix, real_repo in BARE_DOI_REPO_PREFIX.items():
            if doi.startswith(prefix.lower()):
                repo = real_repo
                break
    return {
        "repo": repo,
        "query": query,
        "dataset_doi": doi,
        "dataset_title": meta.get("title"),
        "dataset_abstract": meta.get("description"),
        "dataset_keywords": meta.get("keywords") or [],
        "linked_publication_doi": pub_doi,
        "linked_publication_relationship": pub_relationship,
    }


def openalex_work_by_doi(doi: str, *, mailto: str | None) -> dict[str, Any] | None:
    params = {"mailto": mailto} if mailto else {}
    try:
        resp = requests.get(f"{OPENALEX_WORKS_URL}/https://doi.org/{doi}", params=params, timeout=30, headers=UA)
        if resp.status_code == 404:
            return None
        resp.raise_for_status()
        return resp.json()
    except requests.RequestException:
        return None


# --------------------------------------------------------------------------
# Known-state loading / accumulator (own file, distinct from journal_first's)
# --------------------------------------------------------------------------

def load_known_state() -> tuple[set[str], dict[str, dict[str, str]], dict[str, dict[str, Any]]]:
    """Retourne (known_dataset_dois, known_paper_files_by_doi, accumulator_by_dataset_doi).

    known_paper_files permet de reutiliser un PDF/TEI deja telecharge par une autre
    branche du pipeline (journal-first, DataCite) pour la meme publication au lieu de
    le re-televerser."""
    known_datasets: set[str] = set()
    known_paper_files: dict[str, dict[str, str]] = {}

    if KG_PATH.exists():
        kg = json.loads(KG_PATH.read_text(encoding="utf-8"))
        for rec in kg.get("records", []):
            if rec.get("dataset_doi"):
                known_datasets.add(normalize_doi(rec["dataset_doi"]))
            pd = normalize_doi(rec.get("paper_doi") or "")
            if pd and (rec.get("local_pdf") or rec.get("local_tei")):
                entry = known_paper_files.setdefault(pd, {})
                if rec.get("local_pdf"):
                    entry["local_pdf"] = rec["local_pdf"]
                if rec.get("local_tei"):
                    entry["local_tei"] = rec["local_tei"]

    if BENCHMARK_CANDIDATES_PATH.exists():
        d = json.loads(BENCHMARK_CANDIDATES_PATH.read_text(encoding="utf-8"))
        recs = d if isinstance(d, list) else d.get("candidates", d.get("records", []))
        for rec in recs:
            if rec.get("dataset_doi"):
                known_datasets.add(normalize_doi(rec["dataset_doi"]))

    if JOURNAL_FIRST_ACCUMULATOR_PATH.exists():
        d = json.loads(JOURNAL_FIRST_ACCUMULATOR_PATH.read_text(encoding="utf-8"))
        for rec in d.get("records", []):
            for cand in rec.get("dataset_candidates") or []:
                if cand.get("verified") and cand.get("doi_or_url"):
                    known_datasets.add(normalize_doi(cand["doi_or_url"]))

    accumulator: dict[str, dict[str, Any]] = {}
    if ACCUMULATOR_PATH.exists():
        d = json.loads(ACCUMULATOR_PATH.read_text(encoding="utf-8"))
        for rec in d.get("records", []):
            doi = rec.get("dataset_doi")
            if doi:
                accumulator[doi] = rec
                known_datasets.add(normalize_doi(doi))

    return known_datasets, known_paper_files, accumulator


def save_accumulator(accumulator: dict[str, dict[str, Any]]) -> None:
    ACCUMULATOR_PATH.parent.mkdir(parents=True, exist_ok=True)
    records = sorted(
        accumulator.values(),
        key=lambda r: (bool(r.get("verified")), r.get("dataset_literature_score") or 0),
        reverse=True,
    )
    ACCUMULATOR_PATH.write_text(json.dumps({"records": records}, indent=2, ensure_ascii=False), encoding="utf-8")


# --------------------------------------------------------------------------
# Download (own directory prefix, distinct from journal_first's JournalFirst_<slug>)
# --------------------------------------------------------------------------

def download_dataset_files(candidate: dict[str, Any], *, dataset_slug: str) -> Path | None:
    repo = candidate["repo"]
    files = candidate.get("files") or []
    if not files:
        return None
    target_dir = RAW_DATA_DIR / f"DatasetFirst_{dataset_slug}"
    target_dir.mkdir(parents=True, exist_ok=True)
    downloaded = 0
    errors: list[str] = []
    for f in files:
        name, url = f.get("name"), f.get("url")
        if not name or not url:
            continue
        # Certains noms de fichier Zenodo (archives GitHub) contiennent un
        # "/" (ex. "bbroyle/evo3D_supplementary-v1.zip") -- creer les
        # sous-dossiers avant d'ecrire, sinon FileNotFoundError.
        dest = target_dir / name
        dest.parent.mkdir(parents=True, exist_ok=True)
        if dest.exists() and dest.stat().st_size > 0:
            downloaded += 1
            continue
        last_exc: Exception | None = None
        for attempt in range(3):
            try:
                resp = requests.get(url, timeout=180, headers=request_headers(repo), allow_redirects=True)
                if resp.status_code == 429 and attempt < 2:
                    time.sleep(5 * (attempt + 1))
                    continue
                resp.raise_for_status()
                dest.write_bytes(resp.content)
                downloaded += 1
                last_exc = None
                break
            except Exception as exc:  # noqa: BLE001
                last_exc = exc
                if attempt < 2:
                    time.sleep(5 * (attempt + 1))
        if last_exc is not None:
            errors.append(f"{name}: {last_exc}")
    candidate["download_status"] = "downloaded" if downloaded and not errors else ("partial" if downloaded else "failed")
    candidate["local_raw_dir"] = str(target_dir.relative_to(ROOT)) if downloaded else None
    if errors:
        candidate["note"] = (candidate.get("note", "") + " | erreurs telechargement: " + "; ".join(errors[:3]))[:500]
    if not downloaded:
        # Ne jamais laisser un dossier vide sur disque quand tous les
        # telechargements ont echoue (429 Dryad observes en rafale sur cette
        # session) -- source de confusion pour l'utilisateur (dossier present
        # mais sans donnees) et pour un futur run (croirait le dataset deja
        # traite via local_raw_dir).
        try:
            target_dir.rmdir()
        except OSError:
            pass
    return target_dir if downloaded else None


# --------------------------------------------------------------------------
# Per-candidate processing
# --------------------------------------------------------------------------

def process_dataset_hit(
    cand: dict[str, Any],
    *,
    min_score: int,
    min_size_kb: int,
    max_size_kb: int,
    download_pdf_flag: bool,
    run_grobid_flag: bool,
    download_data_flag: bool,
    grobid_url: str,
    mailto: str | None,
    known_paper_files: dict[str, dict[str, str]],
    verbose: bool,
) -> dict[str, Any]:
    dataset_doi = cand["dataset_doi"]
    text = " ".join(
        filter(None, [cand.get("dataset_title"), cand.get("dataset_abstract"), " ".join(cand.get("dataset_keywords") or [])])
    )
    analysis = analyze_literature_candidate(text)
    dataset_slug = slug(dataset_doi)

    record: dict[str, Any] = {
        "record_type": "dataset_first_candidate",
        "repo": cand["repo"],
        "query": cand["query"],
        "dataset_doi": dataset_doi,
        "dataset_title": cand.get("dataset_title"),
        "dataset_keywords": cand.get("dataset_keywords") or [],
        "dataset_literature_score": analysis["literature_score"],
        "dataset_candidate_decision": analysis["candidate_decision"],
        "linked_publication_doi": cand.get("linked_publication_doi"),
        "linked_publication_relationship": cand.get("linked_publication_relationship"),
        "paper_resolved": False,
    }

    verified = verify_dataset_candidate(dataset_doi, cand["repo"], min_size_kb=min_size_kb)
    target_dir = None
    if verified["verified"] and download_data_flag:
        total_kb = sum((f.get("size") or 0) for f in verified.get("files") or []) / 1024
        if max_size_kb and total_kb > max_size_kb:
            verified["download_status"] = "skipped_too_large"
            verified["note"] = f"{verified.get('note', '')} | depot {total_kb:.0f}Ko > seuil max {max_size_kb}Ko, telechargement saute (recuperation manuelle)".strip(" |")
        else:
            target_dir = download_dataset_files(verified, dataset_slug=dataset_slug)
    verified.pop("files", None)
    record.update(
        {
            "verified": verified["verified"],
            "n_files": verified.get("n_files", 0),
            "download_status": verified.get("download_status"),
            "note": verified.get("note"),
            "local_raw_dir": verified.get("local_raw_dir"),
        }
    )

    pub_doi = clean_doi(cand.get("linked_publication_doi") or "")
    if pub_doi and analysis["literature_score"] >= min_score:
        record["paper_doi"] = pub_doi
        known_files = known_paper_files.get(pub_doi)
        if known_files and known_files.get("local_pdf"):
            record["paper_resolved"] = True
            record["local_pdf"] = known_files.get("local_pdf")
            record["local_tei"] = known_files.get("local_tei")
            record["pdf_download_status"] = "reused_existing"
            if known_files.get("local_tei") and target_dir is not None:
                tei_path = ROOT / known_files["local_tei"]
                if tei_path.exists():
                    full_text = tei_full_text(tei_path)
                    fc_candidates = extract_formula_candidates(full_text)
                    record["formula_completeness"] = check_formula_completeness(fc_candidates, target_dir)
        else:
            work = openalex_work_by_doi(pub_doi, mailto=mailto)
            if work is None:
                record["paper_resolution_note"] = "DOI introuvable via OpenAlex"
            else:
                paper_record = normalize_openalex_work(work, query=f"dataset_first:{cand['repo']}")
                record["paper_resolved"] = True
                for key in ("paper_openalex_id", "paper_title", "paper_year", "paper_venue", "paper_abstract"):
                    record[key] = paper_record.get(key)
                oa = work.get("open_access") or {}
                record["is_oa"] = oa.get("is_oa")
                record["oa_url"] = oa.get("oa_url")
                if download_pdf_flag and record["is_oa"] and record["oa_url"]:
                    RAW_PDF_DIR.mkdir(parents=True, exist_ok=True)
                    fname = slug_filename(record.get("paper_title") or "untitled", record.get("paper_openalex_id") or dataset_slug)
                    pdf_path = RAW_PDF_DIR / f"{fname}.pdf"
                    if pdf_path.exists() or download_pdf(record["oa_url"], pdf_path):
                        record["pdf_download_status"] = "downloaded"
                        record["local_pdf"] = str(pdf_path.relative_to(ROOT))
                        if run_grobid_flag:
                            tei_path = run_grobid_on_pdf(pdf_path, grobid_url=grobid_url)
                            if tei_path is None:
                                record["grobid_status"] = "failed_or_unavailable"
                            else:
                                record["grobid_status"] = "ok"
                                record["local_tei"] = str(tei_path.relative_to(ROOT))
                                full_text = tei_full_text(tei_path)
                                fa = analyze_literature_candidate(full_text)
                                record["full_text_literature_score"] = fa["literature_score"]
                                if target_dir is not None:
                                    fc_candidates = extract_formula_candidates(full_text)
                                    record["formula_completeness"] = check_formula_completeness(fc_candidates, target_dir)
                    else:
                        record["pdf_download_status"] = "failed"

    if verbose:
        flag = "OK" if record["verified"] else "??"
        if record["paper_resolved"]:
            pub_note = "paper_linked"
        elif record.get("linked_publication_doi"):
            pub_note = "paper_unresolved"
        else:
            pub_note = "no_linked_paper"
        print(
            f"  [{flag}] {cand['repo']:8s} score={analysis['literature_score']:2d} {pub_note:14s} {dataset_doi} {(cand.get('dataset_title') or '')[:55]}",
            file=sys.stderr,
        )
    return record


# --------------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------------

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Dataset-first harvest of paper-linked spatial datasets via Dryad + Zenodo search.")
    parser.add_argument("--queries", help="Comma-separated search queries. Defaults to the curated spatial-modeling vocabulary.")
    parser.add_argument(
        "--queries-file",
        help="Path to a newline-separated queries file (e.g. paper titles already retained but without a "
        "verified dataset yet -- Dryad/Zenodo datasets are conventionally titled 'Data from: <paper title>', "
        "so searching by the paper's own title is a strong targeted signal). Overrides --queries/defaults.",
    )
    parser.add_argument("--list-queries", action="store_true", help="Print the default query list and exit.")
    parser.add_argument("--max-pages", type=int, default=2)
    parser.add_argument("--per-page", type=int, default=25)
    parser.add_argument("--min-score", type=int, default=4, help="lit_common literature_score threshold (on dataset title/abstract/keywords) to bother resolving/fetching the linked paper.")
    parser.add_argument("--min-dataset-size-kb", type=int, default=200, help="Skip a verified repo whose total file size is below this (0 disables).")
    parser.add_argument("--max-dataset-size-kb", type=int, default=500_000, help="Do not auto-download a verified repo whose total file size exceeds this (~500MB default, 0 disables) -- avoids one huge file blocking a run for a long time; flagged for manual retrieval instead.")
    parser.add_argument("--target", type=int, default=300, help="Max total NEW (not-already-known) dataset candidates processed this run, across queries/repos.")
    parser.add_argument("--mailto")
    parser.add_argument("--download-pdf", action="store_true", help="Download the OA PDF of the linked publication when found.")
    parser.add_argument("--run-grobid", action="store_true", help="Run GROBID on the downloaded PDF and check formula completeness (implies --download-pdf).")
    parser.add_argument("--download-data", action="store_true", help="Download verified dataset files (implies --run-grobid --download-pdf).")
    parser.add_argument("--grobid-url", default="http://localhost:8070")
    parser.add_argument("--dry-run", action="store_true", help="Only search+score, skip verification/PDF/GROBID/download entirely.")
    parser.add_argument(
        "--workers",
        type=int,
        default=4,
        help="Process this many dataset candidates concurrently (threaded -- each candidate is a sequence of "
        "independent network round-trips: verify/download files, resolve paper via OpenAlex, download PDF, "
        "GROBID. GROBID itself has no CPU limit configured and sits idle between single-candidate calls, so "
        "this is what actually uses the spare capacity. 1 disables concurrency. Keep modest (4-8) to stay "
        "polite to Dryad/Zenodo/OpenAlex/GROBID.",
    )
    parser.add_argument(
        "--max-runtime-minutes",
        type=int,
        default=15,
        help="Hard wall-clock budget for the candidate-processing phase (0 disables). Observed hangs this "
        "session (a worker thread blocked on a network call that never raised despite an explicit "
        "requests timeout) motivated this: past the budget, whatever has completed is saved and the "
        "process force-exits (os._exit) rather than waiting forever on threads Python cannot forcibly kill.",
    )
    parser.add_argument("--quiet", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    load_local_env()

    if args.list_queries:
        for q in DEFAULT_QUERIES:
            print(q)
        return 0

    if args.queries_file:
        lines = Path(args.queries_file).read_text(encoding="utf-8").splitlines()
        queries = [q.strip() for q in lines if q.strip() and not q.strip().startswith("#")]
    else:
        queries = [q.strip() for q in (args.queries.split(",") if args.queries else DEFAULT_QUERIES) if q.strip()]
    verbose = not args.quiet
    download_pdf_flag = args.download_pdf or args.run_grobid or args.download_data
    run_grobid_flag = args.run_grobid or args.download_data
    download_data_flag = args.download_data

    known_datasets, known_paper_files, accumulator = load_known_state()

    # Phase 1: recherche + dedup, sequentiel (bon marche, et le dedup sur
    # known_datasets doit rester sequentiel pour eviter deux threads qui
    # traiteraient le meme DOI en double).
    to_process: list[dict[str, Any]] = []
    skipped_known = 0
    search_fns = (("dryad", search_dryad), ("zenodo", search_zenodo))

    for query in queries:
        if len(to_process) >= args.target:
            break
        for repo, search_fn in search_fns:
            if len(to_process) >= args.target:
                break
            for page in range(1, args.max_pages + 1):
                if len(to_process) >= args.target:
                    break
                try:
                    hits = search_fn(query, page=page, per_page=args.per_page)
                except Exception as exc:  # noqa: BLE001 - un depot en echec ne doit pas arreter le run
                    if verbose:
                        print(f"  [erreur recherche {repo}] {exc}", file=sys.stderr)
                    break
                if not hits:
                    break
                for hit in hits:
                    cand = normalize_dryad_hit(hit, query) if repo == "dryad" else normalize_zenodo_hit(hit, query)
                    doi = cand.get("dataset_doi")
                    if not doi or doi in known_datasets:
                        skipped_known += 1
                        continue
                    known_datasets.add(doi)

                    if args.dry_run:
                        text = " ".join(filter(None, [cand.get("dataset_title"), cand.get("dataset_abstract")]))
                        score = analyze_literature_candidate(text)["literature_score"]
                        if verbose:
                            print(f"  [{repo}] score={score} {doi} {(cand.get('dataset_title') or '')[:60]}", file=sys.stderr)
                        continue

                    to_process.append(cand)
                    if len(to_process) >= args.target:
                        break

    if args.dry_run:
        print(json.dumps({"mode": "dataset_first_harvest_dry_run", "already_known_skipped": skipped_known}, indent=2))
        return 0

    # Phase 2: verification/telechargement/GROBID par candidat -- ce sont des
    # aller-retours reseau independants (API repo, OpenAlex, GROBID, qui n'a
    # aucune limite CPU configuree et reste inactif entre deux appels uniques),
    # donc paralleliser ici est ce qui utilise reellement la capacite dispo.
    new_records: list[dict[str, Any]] = []
    timed_out = False
    if args.workers <= 1 or len(to_process) <= 1:
        for cand in to_process:
            record = process_dataset_hit(
                cand,
                min_score=args.min_score,
                min_size_kb=args.min_dataset_size_kb,
                max_size_kb=args.max_dataset_size_kb,
                download_pdf_flag=download_pdf_flag,
                run_grobid_flag=run_grobid_flag,
                download_data_flag=download_data_flag,
                grobid_url=args.grobid_url,
                mailto=args.mailto,
                known_paper_files=known_paper_files,
                verbose=verbose,
            )
            accumulator[record["dataset_doi"]] = record
            new_records.append(record)
    else:
        pool = ThreadPoolExecutor(max_workers=args.workers)
        futures = [
            pool.submit(
                process_dataset_hit,
                cand,
                min_score=args.min_score,
                min_size_kb=args.min_dataset_size_kb,
                max_size_kb=args.max_dataset_size_kb,
                download_pdf_flag=download_pdf_flag,
                run_grobid_flag=run_grobid_flag,
                download_data_flag=download_data_flag,
                grobid_url=args.grobid_url,
                mailto=args.mailto,
                known_paper_files=known_paper_files,
                verbose=verbose,
            )
            for cand in to_process
        ]
        budget_seconds = args.max_runtime_minutes * 60 if args.max_runtime_minutes else None
        try:
            for future in as_completed(futures, timeout=budget_seconds):
                record = future.result()
                accumulator[record["dataset_doi"]] = record
                new_records.append(record)
        except FutureTimeoutError:
            timed_out = True
            print(
                f"\n[budget] {args.max_runtime_minutes} min ecoulees -- {len(new_records)}/{len(to_process)} "
                "candidats traites, arret force (un ou plusieurs threads restent bloques sur un appel reseau "
                "malgre les timeout= explicites -- cause non identifiee, observee a plusieurs reprises cette "
                "session)",
                file=sys.stderr,
            )
        # shutdown(wait=True) implicite d'un `with` bloquerait indefiniment sur
        # les threads bloques (Python ne peut pas tuer un thread de force) --
        # wait=False + cancel_futures evite au moins d'attendre les taches pas
        # encore demarrees. Les threads deja bloques resteront des zombies
        # jusqu'a la sortie du process, forcee plus bas si timed_out.
        pool.shutdown(wait=False, cancel_futures=True)

    save_accumulator(accumulator)

    verified_new = [r for r in new_records if r.get("verified")]
    paper_linked = [r for r in new_records if r.get("paper_resolved")]
    manual_needed = [r for r in new_records if r.get("verified") and r.get("download_status") == "needs_manual_retrieval"]
    no_linked_paper = [r for r in new_records if r.get("verified") and not r.get("linked_publication_doi")]
    paper_unresolved = [r for r in new_records if r.get("linked_publication_doi") and not r.get("paper_resolved")]
    pdf_failed = [r for r in new_records if r.get("pdf_download_status") == "failed"]
    formula_incomplete = [r for r in new_records if (r.get("formula_completeness") or {}).get("status") == "incomplete"]

    summary = {
        "mode": "dataset_first_harvest",
        "queries": queries,
        "already_known_skipped": skipped_known,
        "new_candidates_processed": len(new_records),
        "new_verified_datasets": len(verified_new),
        "new_verified_with_paper_linked": len(paper_linked),
        "verified_but_no_linked_publication": len(no_linked_paper),
        "linked_publication_doi_not_resolved": len(paper_unresolved),
        "candidates_needing_manual_retrieval": len(manual_needed),
        "pdf_download_failed": len(pdf_failed),
        "datasets_with_incomplete_formula": len(formula_incomplete),
        "accumulator_path": str(ACCUMULATOR_PATH.relative_to(ROOT)),
        "accumulator_total_records": len(accumulator),
    }
    if timed_out:
        summary["runtime_budget_exceeded_minutes"] = args.max_runtime_minutes
        summary["candidates_not_processed"] = len(to_process) - len(new_records)
    print(json.dumps(summary, indent=2, ensure_ascii=False))

    if manual_needed:
        print("\n-- Datasets verifies mais depot sans API de verification/telechargement fiable, ou API en echec --", file=sys.stderr)
        for r in manual_needed:
            print(f"  {r['repo']:8s} {r['dataset_doi']:45s} {r.get('note','')}", file=sys.stderr)

    if no_linked_paper:
        print("\n-- Datasets verifies mais aucune publication liee dans les metadonnees du depot (manual_review) --", file=sys.stderr)
        for r in no_linked_paper:
            print(f"  {r['repo']:8s} {r['dataset_doi']:45s} {(r.get('dataset_title') or '')[:70]}", file=sys.stderr)

    if paper_unresolved:
        print("\n-- Publication liee trouvee dans le depot mais DOI introuvable via OpenAlex --", file=sys.stderr)
        for r in paper_unresolved:
            print(f"  {r['dataset_doi']:45s} -> {r.get('linked_publication_doi')}", file=sys.stderr)

    if pdf_failed:
        print("\n-- PDF de la publication liee non recuperable automatiquement --", file=sys.stderr)
        for r in pdf_failed:
            print(f"  {r.get('oa_url') or '(pas d url OA)':60s} (dataset: {r['dataset_doi']} / papier: {r.get('paper_title')})", file=sys.stderr)

    if formula_incomplete:
        print("\n-- Depots telecharges mais formule du papier incomplete (variable(s) absente(s), a chercher via source externe, jamais a fabriquer) --", file=sys.stderr)
        for r in formula_incomplete:
            fc = r["formula_completeness"]
            print(f"  {r['dataset_doi']:45s} (papier: {r.get('paper_title')})", file=sys.stderr)
            print(f"    {fc['note']}", file=sys.stderr)

    if timed_out:
        # sys.exit()/return normal attendraient les threads bloques a la
        # fermeture de l'interpreteur (atexit du module concurrent.futures) --
        # os._exit() court-circuite ce nettoyage, sans consequence ici puisque
        # save_accumulator() a deja ecrit tout ce qui a ete produit.
        sys.stdout.flush()
        sys.stderr.flush()
        os._exit(0)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
