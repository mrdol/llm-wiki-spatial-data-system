"""Harvest paper-linked spatial datasets by starting from target journals ("journal-first"),
instead of starting from a dataset repository and working backward to find a parent article
(the approach used by tools/harvest_datacite.R).

Rationale (session 2026-08-15): DataCite-first harvesting pulls in a lot of keyword-collision
noise (microbiome, MRI, chemistry papers that happen to use the word "spatial") because the
LLM verification step only sees a DataCite dataset title/description, never the actual paper
text. Starting from spatial-econometrics-specialized journals means every article found is
already in scope by construction, and once the article's PDF is fetched and run through GROBID,
the dataset DOI/URL can be extracted directly from the paper's own "Data Availability" text and
then verified for real files via the repo APIs already wired up in dataset_manifest_check.py
(figshare/Dataverse/Dryad/Zenodo/ScienceBase/PANGAEA/b2share, including the Dryad OAuth token
fix from this session).

Pipeline:
  1. Query OpenAlex `/works` filtered by `primary_location.source.id` for a curated list of
     spatial-econometrics/regional-science journals (see DEFAULT_SOURCES). No thematic
     "profiles" like tools/harvest_datacite.R: the journal list itself IS the scope filter.
  2. Deduplicate against everything already known locally *before* touching the network for
     PDFs: inst/kg/paper_dataset_uses.json, data/manifests/papers/paper_dataset_benchmark_
     candidates.json, and this tool's own accumulator file from previous runs
     (data/manifests/papers/journal_first_candidates.json). A paper or dataset DOI already
     seen anywhere in that state is skipped, so re-running the tool never re-fetches or
     re-downloads the same records twice.
  3. Score each new work for spatial/dataset/modeling signal from title+abstract (reuses
     lit_common.analyze_literature_candidate).
  4. For open-access works above the score threshold: download the PDF into
     corpus/papers/raw_pdf/, run GROBID (reuses tools/kg/02_run_grobid.py's process_pdf
     logic), and re-score using the full TEI text (much stronger signal than abstract alone).
  5. Extract candidate dataset repository links/DOIs from the full TEI text (reuses
     lit_common.extract_dataset_links_from_text, plus a bare-DOI-prefix scan for
     Data-Availability-style citations like "doi:10.7910/DVN/XXXXX" that have no full URL).
  6. For each extracted dataset DOI: resolve its repo type and verify real downloadable files
     exist via dataset_manifest_check.list_files()/classify_file_manifest() -- this is what
     catches "supplement PDF disguised as a dataset" cases (e.g. Shenzhen GWR, QSVCM) before
     they ever reach a human.
  7. Download: for repos with a working API (figshare/Dataverse/Dryad/Zenodo/ScienceBase/
     PANGAEA/b2share) and a verified real-data manifest, download the files automatically into
     data/raw/papers/JournalFirst_<slug>/ (same request_headers() as the existing DataCite
     download tool, so the Dryad OAuth fix applies here too). For anything else (github/osf/
     mendeley links, or a repo whose API rejected the request), the candidate is written to the
     manifest with download_status="needs_manual_retrieval" and printed at the end as a DOI/URL
     list for manual retrieval -- never guessed or scraped around.
  8. Append everything (found or not) to the persistent accumulator manifest.

Usage:
    python tools/harvest_journal_first.py --list-sources
    python tools/harvest_journal_first.py --dry-run --max-pages 1 --per-page 10
    python tools/harvest_journal_first.py --target 50 --from-year 2018 --min-citations 3 \
        --download-pdf --run-grobid --download-data
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path
from typing import Any

import requests

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "code" / "pipeline_lit"))
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "tools" / "kg"))

from lit_common import (  # noqa: E402
    analyze_literature_candidate,
    extract_dataset_links_from_text,
    normalize_openalex_work,
)
from dataset_manifest_check import (  # noqa: E402
    classify_file_manifest,
    list_files,
    load_local_env,
    repo_from_url,
    request_headers,
)

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


RAW_PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
TEI_DIR = ROOT / "corpus" / "papers" / "tei"
RAW_DATA_DIR = ROOT / "data" / "raw" / "papers"
ACCUMULATOR_PATH = ROOT / "data" / "manifests" / "papers" / "journal_first_candidates.json"
KG_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
BENCHMARK_CANDIDATES_PATH = ROOT / "data" / "manifests" / "papers" / "paper_dataset_benchmark_candidates.json"
UA = {"User-Agent": "llm-wiki-spatial-data-system/0.1 journal-first-harvest (johnny.d-oliveira@inrae.fr)"}

DEFAULT_SOURCES = {
    "S144150890": "Journal of Geographical Systems",
    "S2765037494": "Spatial Statistics",
    "S4210207419": "Journal of Spatial Econometrics",
    "S159894308": "Geographical Analysis",
    "S107631327": "Regional Science and Urban Economics",
    "S65528657": "Journal of Regional Science",
    "S7161550": "Spatial Economic Analysis",
    "S126936603": "International Regional Science Review",
}

BARE_DOI_REPO_PREFIX = {
    "10.5061": "dryad",
    "10.6084": "figshare",
    "10.7910": "dataverse",
    "10.5066": "sciencebase",
    "10.1594": "pangaea",
    "10.5281": "zenodo",
    "10.25384": "figshare",  # SAGE's figshare instance
}
BARE_DOI_RX = re.compile(
    r"\b(10\.(?:5061|6084|7910|5066|1594|5281|25384)/[A-Za-z0-9_./\-]+[A-Za-z0-9_/\-])",
    flags=re.IGNORECASE,
)
AUTO_DOWNLOAD_REPOS = {"figshare", "dataverse", "dryad", "zenodo", "sciencebase", "pangaea", "b2share"}

# Aucun de ces depots n'exige de paiement, mais quand plusieurs candidats
# existent pour le meme papier, Dryad et Zenodo sont prioritaires (depot
# academique dedie, moins de faux positifs "supplement d'article" que
# figshare ; cf. les cas Shenzhen/QSVCM de cette session), puis figshare,
# puis le reste.
REPO_PRIORITY = {
    "dryad": 0,
    "zenodo": 1,
    "figshare": 2,
    "dataverse": 3,
    "sciencebase": 3,
    "pangaea": 3,
    "b2share": 3,
    "unknown": 9,
}


# --------------------------------------------------------------------------
# Deduplication state: everything already known locally, loaded once up front
# so a paper or dataset DOI already seen is never re-fetched or re-downloaded.
# --------------------------------------------------------------------------

def normalize_doi(value: str | None) -> str:
    if not value:
        return ""
    text = str(value).strip().lower()
    text = re.sub(r"^https?://(dx\.)?doi\.org/", "", text)
    return text.strip()


def load_known_dois() -> tuple[set[str], set[str], dict[str, dict[str, Any]]]:
    """Retourne (paper_dois_connus, dataset_dois_connus, accumulateur_par_openalex_id)."""
    known_papers: set[str] = set()
    known_datasets: set[str] = set()

    if KG_PATH.exists():
        kg = json.loads(KG_PATH.read_text(encoding="utf-8"))
        for rec in kg.get("records", []):
            if rec.get("paper_doi"):
                known_papers.add(normalize_doi(rec["paper_doi"]))
            if rec.get("dataset_doi"):
                known_datasets.add(normalize_doi(rec["dataset_doi"]))

    if BENCHMARK_CANDIDATES_PATH.exists():
        d = json.loads(BENCHMARK_CANDIDATES_PATH.read_text(encoding="utf-8"))
        recs = d if isinstance(d, list) else d.get("candidates", d.get("records", []))
        for rec in recs:
            if rec.get("paper_doi"):
                known_papers.add(normalize_doi(rec["paper_doi"]))
            if rec.get("dataset_doi"):
                known_datasets.add(normalize_doi(rec["dataset_doi"]))

    accumulator: dict[str, dict[str, Any]] = {}
    if ACCUMULATOR_PATH.exists():
        d = json.loads(ACCUMULATOR_PATH.read_text(encoding="utf-8"))
        for rec in d.get("records", []):
            key = rec.get("paper_openalex_id") or rec.get("paper_doi")
            if key:
                accumulator[key] = rec
            if rec.get("paper_doi"):
                known_papers.add(normalize_doi(rec["paper_doi"]))
            for cand in rec.get("dataset_candidates", []):
                doi = normalize_doi(cand.get("doi_or_url"))
                if doi and cand.get("verified"):
                    known_datasets.add(doi)

    return known_papers, known_datasets, accumulator


def save_accumulator(accumulator: dict[str, dict[str, Any]]) -> None:
    ACCUMULATOR_PATH.parent.mkdir(parents=True, exist_ok=True)
    records = sorted(
        accumulator.values(),
        key=lambda r: (bool(r.get("dataset_candidates")), r.get("full_text_literature_score") or r.get("literature_score") or 0),
        reverse=True,
    )
    ACCUMULATOR_PATH.write_text(
        json.dumps({"records": records}, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )


# --------------------------------------------------------------------------
# OpenAlex discovery
# --------------------------------------------------------------------------

def openalex_search_source(
    source_id: str,
    *,
    from_year: int,
    max_pages: int,
    per_page: int,
    mailto: str | None,
    verbose: bool,
) -> list[dict[str, Any]]:
    session = requests.Session()
    works: list[dict[str, Any]] = []
    cursor = "*"
    for page in range(1, max_pages + 1):
        if verbose:
            print(f"  page {page}...", file=sys.stderr, flush=True)
        params = {
            "filter": f"primary_location.source.id:{source_id},from_publication_date:{from_year}-01-01",
            "sort": "cited_by_count:desc",
            "per-page": per_page,
            "cursor": cursor,
            "select": (
                "id,doi,title,publication_year,abstract_inverted_index,"
                "primary_location,locations,authorships,cited_by_count,open_access"
            ),
        }
        if mailto:
            params["mailto"] = mailto
        try:
            response = session.get("https://api.openalex.org/works", params=params, timeout=60, headers=UA)
        except requests.RequestException as exc:
            if verbose:
                print(f"  OpenAlex request failed: {exc}", file=sys.stderr)
            break
        if response.status_code != 200:
            if verbose:
                print(f"  OpenAlex returned HTTP {response.status_code}: {response.text[:200]}", file=sys.stderr)
            break
        payload = response.json()
        results = payload.get("results") or []
        if not results:
            break
        works.extend(item for item in results if isinstance(item, dict))
        next_cursor = payload.get("meta", {}).get("next_cursor")
        if not next_cursor or next_cursor == cursor:
            break
        cursor = next_cursor
    return works


# --------------------------------------------------------------------------
# PDF / GROBID / TEI text extraction
# --------------------------------------------------------------------------

def slug_filename(title: str, openalex_id: str) -> str:
    base = re.sub(r"[^A-Za-z0-9]+", "_", title or "untitled").strip("_")[:80]
    short_id = openalex_id.rsplit("/", 1)[-1]
    return f"{base}_{short_id}"


def download_pdf(url: str, dest: Path, *, timeout: int = 60) -> bool:
    try:
        resp = requests.get(url, timeout=timeout, headers=UA, allow_redirects=True)
        resp.raise_for_status()
        if resp.headers.get("content-type", "").lower().startswith("text/html"):
            return False
        dest.write_bytes(resp.content)
        return dest.stat().st_size > 1000
    except requests.RequestException:
        return False


def run_grobid_on_pdf(pdf_path: Path, *, grobid_url: str, timeout: int = 180) -> Path | None:
    tei_path = TEI_DIR / f"{pdf_path.stem}.tei.xml"
    if tei_path.exists():
        return tei_path
    try:
        alive = requests.get(f"{grobid_url.rstrip('/')}/api/isalive", timeout=10)
        if not (alive.ok and alive.text.strip().lower() == "true"):
            return None
    except requests.RequestException:
        return None
    TEI_DIR.mkdir(parents=True, exist_ok=True)
    try:
        with pdf_path.open("rb") as fh:
            response = requests.post(
                f"{grobid_url.rstrip('/')}/api/processFulltextDocument",
                files={"input": (pdf_path.name, fh, "application/pdf")},
                timeout=timeout,
            )
    except OSError:
        # Chemin trop long pour Windows (MAX_PATH ~260 caracteres) ou fichier
        # illisible -- on saute ce PDF plutot que de faire echouer tout le lot.
        return None
    if not response.ok or "<tei" not in response.text[:500].lower():
        return None
    tei_path.write_text(response.text, encoding="utf-8")
    return tei_path


def tei_full_text(tei_path: Path) -> str:
    raw = tei_path.read_text(encoding="utf-8", errors="replace")
    text = re.sub(r"<[^>]+>", " ", raw)
    text = re.sub(r"&amp;", "&", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


REFERENCES_BIB_PATH = ROOT / "corpus" / "bib" / "references.bib"


def load_bib_metadata_by_pdf_filename() -> dict[str, dict[str, str]]:
    """Associe chaque nom de fichier PDF a son titre/DOI dans corpus/bib/
    references.bib. C'est la source de verite pour tout PDF passe par le sas
    Biblio_from_pdf (tools/stage_biblio_from_pdf_datacite.py) : pdf2bib
    identifie le DOI/titre et renomme en <citekey>.pdf, puis import_to_llm_wiki
    ajoute l'entree ici avec `file = {:...:<nom>.pdf:PDF}`. Bien plus fiable
    que de re-deviner le titre/DOI depuis l'en-tete TEI de GROBID."""
    if not REFERENCES_BIB_PATH.exists():
        return {}
    text = REFERENCES_BIB_PATH.read_text(encoding="utf-8", errors="replace")
    by_filename: dict[str, dict[str, str]] = {}
    for entry_match in re.finditer(r"@\w+\{\s*([^,\s]+)\s*,(.*?)\n\}", text, flags=re.DOTALL):
        body = entry_match.group(2)
        file_match = re.search(r"file\s*=\s*\{:(.*?):PDF\}", body, flags=re.IGNORECASE | re.DOTALL)
        if not file_match:
            continue
        pdf_name = Path(file_match.group(1).replace("\\", "/")).name
        title_match = re.search(r"title\s*=\s*\{(.*?)\}\s*,?\s*\n", body, flags=re.DOTALL)
        doi_match = re.search(r"doi\s*=\s*\{([^}]+)\}", body, flags=re.IGNORECASE)
        by_filename[pdf_name] = {
            "title": re.sub(r"\s+", " ", title_match.group(1)).strip() if title_match else "",
            "doi": doi_match.group(1).strip() if doi_match else "",
        }
    return by_filename


def tei_header_metadata(tei_path: Path) -> dict[str, Any]:
    """Titre/DOI extraits de l'en-tete TEI (GROBID les detecte deja depuis le
    PDF lui-meme) -- utilise pour les PDF ajoutes a la main, qui n'ont pas de
    metadonnees OpenAlex prealables."""
    raw = tei_path.read_text(encoding="utf-8", errors="replace")
    header_match = re.search(r"<teiHeader.*?</teiHeader>", raw, flags=re.S)
    header = header_match.group(0) if header_match else raw
    title_match = re.search(r'<title[^>]*level="a"[^>]*>(.*?)</title>', header, flags=re.S) or re.search(
        r"<title[^>]*>(.*?)</title>", header, flags=re.S
    )
    doi_match = re.search(r'<idno type="DOI">(.*?)</idno>', header, flags=re.S | re.I)
    title = re.sub(r"<[^>]+>", " ", title_match.group(1)).strip() if title_match else None
    doi = re.sub(r"<[^>]+>", " ", doi_match.group(1)).strip() if doi_match else None
    return {"title": title or None, "doi": doi or None}


def extract_candidate_dataset_dois(text: str) -> list[dict[str, str]]:
    candidates: dict[str, str] = {}
    for match in BARE_DOI_RX.finditer(text):
        doi = match.group(1).rstrip(".,;)")
        prefix = doi.split("/", 1)[0]
        repo = BARE_DOI_REPO_PREFIX.get(prefix, "unknown")
        candidates[doi.lower()] = repo
    for link in extract_dataset_links_from_text(text):
        url = link["url"]
        repo = repo_from_url(url)
        if repo != "unknown":
            candidates.setdefault(url.lower(), repo)
    ordered = [{"doi_or_url": k, "repo": v} for k, v in candidates.items()]
    ordered.sort(key=lambda c: REPO_PRIORITY.get(c["repo"], 9))
    return ordered


# --------------------------------------------------------------------------
# Dataset verification + download (auto for API-backed repos, manual otherwise)
# --------------------------------------------------------------------------

def looks_like_url(value: str) -> bool:
    return value.startswith("http://") or value.startswith("https://")


def verify_dataset_candidate(doi_or_url: str, repo: str, *, min_size_kb: int) -> dict[str, Any]:
    result: dict[str, Any] = {"doi_or_url": doi_or_url, "repo": repo, "verified": False, "n_files": 0, "note": ""}
    if repo not in AUTO_DOWNLOAD_REPOS:
        result["note"] = f"depot '{repo}' non supporte par l'API de verification -- retrieval manuel requis"
        result["download_status"] = "needs_manual_retrieval"
        return result
    try:
        if repo in {"sciencebase", "b2share"} and looks_like_url(doi_or_url):
            files = list_files(repo, "", data_access_url=doi_or_url)
        else:
            files = list_files(repo, doi_or_url)
    except Exception as exc:  # noqa: BLE001 - un depot en echec ne doit pas arreter le run
        result["note"] = f"erreur API {repo}: {exc}"
        result["download_status"] = "needs_manual_retrieval"
        return result
    if not files:
        result["note"] = "aucun fichier trouve via l'API du depot"
        result["download_status"] = "needs_manual_retrieval"
        return result

    total_kb = sum((f.get("size") or 0) for f in files) / 1024
    if min_size_kb and total_kb < min_size_kb:
        result["note"] = f"depot trouve mais taille totale {total_kb:.0f}Ko < seuil {min_size_kb}Ko"
        result["n_files"] = len(files)
        result["download_status"] = "skipped_too_small"
        return result

    probably_real, reason = classify_file_manifest(files)
    result["n_files"] = len(files)
    result["verified"] = bool(probably_real)
    result["note"] = reason
    result["files"] = files
    result["download_status"] = "verified_pending_download" if probably_real else "needs_manual_retrieval"
    return result


def download_verified_candidate(candidate: dict[str, Any], *, paper_slug: str) -> Path | None:
    """Telecharge les fichiers reels d'un candidat verifie (repos a API connue
    uniquement -- meme pattern que tools/download_curated_paper_datasets.py,
    request_headers() applique donc aussi le token OAuth Dryad corrige cette
    session). Les depots sans API (github/osf/mendeley) restent en attente
    manuelle, jamais devines ni contournes. Retourne le dossier telecharge
    (ou None si rien n'a ete telecharge) pour la verification de completude."""
    repo = candidate["repo"]
    files = candidate.get("files") or []
    if not files:
        return None
    target_dir = RAW_DATA_DIR / f"JournalFirst_{paper_slug}"
    target_dir.mkdir(parents=True, exist_ok=True)
    downloaded = 0
    errors: list[str] = []
    for f in files:
        name, url = f.get("name"), f.get("url")
        if not name or not url:
            continue
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
        try:
            target_dir.rmdir()
        except OSError:
            pass
    return target_dir if downloaded else None


# --------------------------------------------------------------------------
# Formula-completeness check: does the downloaded deposit actually contain
# every variable the paper's formula uses? (session 2026-08-15 process --
# never fabricate a missing variable, always document the gap explicitly so
# the later manual/LLM loader-writing step knows exactly what to search for
# via a legitimate external source, or accept as formula_used vs formula_pub.)
# --------------------------------------------------------------------------

FORMULA_CANDIDATE_RX = re.compile(r"\b([A-Za-z_][A-Za-z0-9_.]{1,40})\s*~\s*([^.;\n]{3,300}?)(?:[.;\n]|$)")


def extract_formula_candidates(text: str) -> list[dict[str, Any]]:
    """Extraction volontairement simple (le parsing complet, avec nettoyage
    de code happe par GROBID et rejet des formules de graphe, vit dans
    tools/kg/03_parse_tei.py::explicit_formula_candidates -- pas reimporte
    ici pour garder cet outil de decouverte independant de la mecanique KG).
    Retient juste les motifs "reponse ~ x1 + x2 + ..." plausibles."""
    candidates = []
    for match in FORMULA_CANDIDATE_RX.finditer(text):
        response = match.group(1).strip()
        rhs = match.group(2).strip()
        if response.lower() in {"log", "logit", "y", "f", "g"}:
            continue
        terms = [t.strip().strip("()") for t in re.split(r"\s*\+\s*", rhs) if t.strip()]
        terms = [re.sub(r"^I\((.*)\)$", r"\1", t) for t in terms]
        if len(terms) < 2:
            continue
        candidates.append({"response": response, "covariates": terms, "raw": match.group(0)[:250]})
    candidates.sort(key=lambda c: len(c["covariates"]), reverse=True)
    return candidates[:5]


def read_columns_from_file(path: Path) -> list[str] | None:
    """Lit uniquement l'en-tete d'un fichier tabulaire/geospatial telecharge,
    sans charger toutes les donnees. Retourne None si le format n'est pas
    reconnu (raster, archive .zip non extraite, PDF de supplement, etc.) --
    dans ce cas la verification de completude est marquee "non verifiable
    automatiquement", jamais devinee."""
    suffix = path.suffix.lower()
    try:
        if suffix in {".csv", ".tsv", ".txt"}:
            sep = "\t" if suffix == ".tsv" else ","
            with path.open("r", encoding="utf-8", errors="replace") as fh:
                header = fh.readline()
            if "\t" in header and sep == ",":
                sep = "\t"
            return [c.strip().strip('"') for c in header.strip().split(sep) if c.strip()]
        if suffix == ".xlsx":
            import openpyxl

            wb = openpyxl.load_workbook(path, read_only=True)
            ws = wb.worksheets[0]
            row = next(ws.iter_rows(min_row=1, max_row=1, values_only=True))
            wb.close()
            return [str(c).strip() for c in row if c is not None]
        if suffix == ".shp":
            import fiona

            with fiona.open(path) as src:
                return list(src.schema.get("properties", {}).keys())
    except Exception:  # noqa: BLE001 - lecture d'en-tete best-effort seulement
        return None
    return None


def check_formula_completeness(formula_candidates: list[dict[str, Any]], target_dir: Path) -> dict[str, Any] | None:
    """Compare la formule la plus riche extraite du texte du papier aux
    colonnes reellement presentes dans les fichiers telecharges. Ne conclut
    JAMAIS qu'une variable manque sans avoir liste les colonnes reelles --
    si aucun fichier n'est lisible, retourne un statut explicite
    'non_verifiable', jamais un faux 'complet' ou 'incomplet'."""
    if not formula_candidates:
        return None
    all_columns: set[str] = set()
    files_read = 0
    for f in sorted(target_dir.rglob("*")):
        if not f.is_file():
            continue
        cols = read_columns_from_file(f)
        if cols:
            files_read += 1
            all_columns.update(c.strip().lower() for c in cols if c and c.strip())
    if not files_read:
        return {
            "status": "non_verifiable",
            "note": "aucun fichier tabulaire/shapefile lisible dans le depot telecharge (raster, archive non extraite, ou format non reconnu) -- verification manuelle requise",
        }

    best = formula_candidates[0]
    response_present = best["response"].lower() in all_columns
    present, missing = [], []
    for term in best["covariates"]:
        term_clean = re.sub(r"[*:^0-9() ]", "", term).lower()
        if term_clean and any(
            term_clean == c or (len(term_clean) >= 3 and (term_clean in c or c in term_clean))
            for c in all_columns
        ):
            present.append(term)
        else:
            missing.append(term)
    return {
        "status": "complete" if not missing and response_present else "incomplete",
        "formula_raw": best["raw"],
        "response": best["response"],
        "response_present": response_present,
        "covariates_present": present,
        "covariates_missing": missing,
        "n_files_checked": files_read,
        "note": (
            "toutes les variables de la formule sont presentes dans le depot"
            if not missing and response_present
            else f"{len(missing)} covariable(s) de la formule absente(s) du depot telecharge (a chercher via source externe citee par le papier, jamais a fabriquer) : {', '.join(missing[:10])}"
            + ("" if response_present else " | reponse elle-meme absente")
        ),
    }


# --------------------------------------------------------------------------
# Per-work processing
# --------------------------------------------------------------------------

def process_work(
    work: dict[str, Any],
    *,
    query_label: str,
    min_score: int,
    min_size_kb: int,
    download_pdf_flag: bool,
    run_grobid_flag: bool,
    download_data_flag: bool,
    grobid_url: str,
    known_datasets: set[str],
    verbose: bool,
) -> dict[str, Any]:
    record = normalize_openalex_work(work, query=query_label)
    record["cited_by_count"] = work.get("cited_by_count")
    oa = work.get("open_access") or {}
    record["is_oa"] = oa.get("is_oa")
    record["oa_url"] = oa.get("oa_url")
    record["full_text_analyzed"] = False
    record["dataset_candidates"] = []

    if record["literature_score"] < min_score:
        return record
    if not (download_pdf_flag and record["is_oa"] and record["oa_url"]):
        return record

    RAW_PDF_DIR.mkdir(parents=True, exist_ok=True)
    fname = slug_filename(record.get("paper_title") or "untitled", record.get("paper_openalex_id") or "unknown")
    pdf_path = RAW_PDF_DIR / f"{fname}.pdf"
    if not pdf_path.exists():
        if verbose:
            print(f"    downloading PDF -> {pdf_path.name}", file=sys.stderr)
        if not download_pdf(record["oa_url"], pdf_path):
            record["pdf_download_status"] = "failed"
            return record
    record["pdf_download_status"] = "downloaded"
    record["local_pdf"] = str(pdf_path.relative_to(ROOT))

    if not run_grobid_flag:
        return record

    tei_path = run_grobid_on_pdf(pdf_path, grobid_url=grobid_url)
    if tei_path is None:
        record["grobid_status"] = "failed_or_unavailable"
        return record
    record["grobid_status"] = "ok"
    record["local_tei"] = str(tei_path.relative_to(ROOT))

    full_text = tei_full_text(tei_path)
    full_text_analysis = analyze_literature_candidate(full_text)
    record["full_text_analyzed"] = True
    record["full_text_literature_score"] = full_text_analysis["literature_score"]
    record["full_text_candidate_decision"] = full_text_analysis["candidate_decision"]
    record["full_text_modeling_signals"] = full_text_analysis["modeling_signals"]

    formula_candidates = extract_formula_candidates(full_text)
    raw_candidates = extract_candidate_dataset_dois(full_text)
    verified_candidates = []
    for cand in raw_candidates:
        if normalize_doi(cand["doi_or_url"]) in known_datasets:
            if verbose:
                print(f"    [skip] dataset deja connu : {cand['doi_or_url'][:70]}", file=sys.stderr)
            continue
        verified = verify_dataset_candidate(cand["doi_or_url"], cand["repo"], min_size_kb=min_size_kb)
        if verified["verified"] and download_data_flag:
            target_dir = download_verified_candidate(verified, paper_slug=fname)
            if target_dir is not None:
                verified["formula_completeness"] = check_formula_completeness(formula_candidates, target_dir)
        verified.pop("files", None)  # ne pas dupliquer le detail complet dans le manifest accumulateur
        verified_candidates.append(verified)
        if verbose:
            flag = "OK" if verified["verified"] else "??"
            status = verified.get("download_status", "")
            fc = verified.get("formula_completeness") or {}
            fc_note = f" [formule: {fc['status']}]" if fc.get("status") else ""
            print(f"    [{flag}] {cand['repo']:10s} {status:26s} {cand['doi_or_url'][:60]}{fc_note}", file=sys.stderr)
    record["dataset_candidates"] = verified_candidates
    return record


# --------------------------------------------------------------------------
# Manual additions: pick up PDFs dropped into corpus/papers/raw_pdf/ and raw
# dataset folders dropped into data/raw/papers/ by hand, and run the same
# GROBID -> extraction -> verification -> download pipeline on them.
# --------------------------------------------------------------------------

def known_local_pdfs(accumulator: dict[str, dict[str, Any]]) -> set[str]:
    return {Path(r["local_pdf"]).name for r in accumulator.values() if r.get("local_pdf")}


def known_local_raw_dirs() -> set[str]:
    """Dossiers data/raw/papers/<x> deja references quelque part (KG ou
    accumulateur journal-first), pour ne signaler que les vraiment nouveaux."""
    known: set[str] = set()
    if KG_PATH.exists():
        kg = json.loads(KG_PATH.read_text(encoding="utf-8"))
        for rec in kg.get("records", []):
            d = rec.get("local_raw_dir")
            if d:
                known.add(Path(str(d).replace("\\", "/")).name)
    if ACCUMULATOR_PATH.exists():
        d = json.loads(ACCUMULATOR_PATH.read_text(encoding="utf-8"))
        for rec in d.get("records", []):
            for cand in rec.get("dataset_candidates", []):
                if cand.get("local_raw_dir"):
                    known.add(Path(cand["local_raw_dir"]).name)
    return known


def scan_manual_pdfs(
    accumulator: dict[str, dict[str, Any]],
    *,
    known_datasets: set[str],
    min_size_kb: int,
    download_data_flag: bool,
    grobid_url: str,
    verbose: bool,
) -> list[dict[str, Any]]:
    """Traite les PDF presents dans corpus/papers/raw_pdf/ mais absents de
    l'accumulateur (ajoutes a la main, pas decouverts par une requete
    OpenAlex) : GROBID, extraction de candidats dataset, verification,
    telechargement optionnel -- meme traitement que les PDF automatiques.

    Le titre/DOI vient prioritairement de corpus/bib/references.bib (source
    de verite pour tout PDF passe par le sas Biblio_from_pdf avant d'atterrir
    ici -- voir tools/stage_biblio_from_pdf_datacite.py), avec l'en-tete TEI
    de GROBID comme repli pour un PDF depose brut sans passer par ce sas."""
    if not RAW_PDF_DIR.exists():
        return []
    already = known_local_pdfs(accumulator)
    bib_metadata = load_bib_metadata_by_pdf_filename()
    if verbose and bib_metadata:
        print(f"  {len(bib_metadata)} entree(s) chargee(s) depuis {REFERENCES_BIB_PATH.name} (Biblio_from_pdf).", file=sys.stderr)
    new_records: list[dict[str, Any]] = []
    for pdf_path in sorted(RAW_PDF_DIR.glob("*.pdf")):
        if pdf_path.name in already:
            continue
        if verbose:
            print(f"  [manuel] PDF non suivi trouve : {pdf_path.name}", file=sys.stderr)
        try:
            new_records_batch = _process_manual_pdf(
                pdf_path,
                known_datasets=known_datasets,
                min_size_kb=min_size_kb,
                download_data_flag=download_data_flag,
                grobid_url=grobid_url,
                bib_metadata=bib_metadata,
                verbose=verbose,
            )
        except Exception as exc:  # noqa: BLE001 - un fichier problematique ne doit pas arreter tout le lot
            if verbose:
                print(f"    [erreur] {pdf_path.name} : {exc}", file=sys.stderr)
            new_records_batch = {
                "record_type": "literature_dataset_candidate",
                "source": "manual_pdf",
                "discovery_source": "manual_pdf",
                "paper_openalex_id": None,
                "local_pdf": str(pdf_path.relative_to(ROOT)),
                "pdf_download_status": "manually_provided",
                "grobid_status": f"error: {exc}",
                "dataset_candidates": [],
                "full_text_analyzed": False,
            }
        new_records.append(new_records_batch)
        accumulator[f"manual_pdf:{pdf_path.name}"] = new_records_batch
    return new_records


def _process_manual_pdf(
    pdf_path: Path,
    *,
    known_datasets: set[str],
    min_size_kb: int,
    download_data_flag: bool,
    grobid_url: str,
    bib_metadata: dict[str, dict[str, str]],
    verbose: bool,
) -> dict[str, Any]:
    record: dict[str, Any] = {
        "record_type": "literature_dataset_candidate",
        "source": "manual_pdf",
        "discovery_source": "manual_pdf",
        "paper_openalex_id": None,
        "local_pdf": str(pdf_path.relative_to(ROOT)),
        "pdf_download_status": "manually_provided",
        "dataset_candidates": [],
        "full_text_analyzed": False,
    }
    bib_entry = bib_metadata.get(pdf_path.name)
    if bib_entry:
        record["paper_title"] = bib_entry["title"] or pdf_path.stem
        record["paper_doi"] = bib_entry["doi"] or None
        record["metadata_source"] = "references_bib"
    tei_path = run_grobid_on_pdf(pdf_path, grobid_url=grobid_url)
    if tei_path is None:
        record["grobid_status"] = "failed_or_unavailable"
        return record
    record["grobid_status"] = "ok"
    record["local_tei"] = str(tei_path.relative_to(ROOT))
    if not bib_entry:
        header = tei_header_metadata(tei_path)
        record["paper_title"] = header["title"] or pdf_path.stem
        record["paper_doi"] = header["doi"]
        record["metadata_source"] = "tei_header"

    full_text = tei_full_text(tei_path)
    analysis = analyze_literature_candidate(full_text)
    record["full_text_analyzed"] = True
    record["full_text_literature_score"] = analysis["literature_score"]
    record["full_text_candidate_decision"] = analysis["candidate_decision"]
    record["full_text_modeling_signals"] = analysis["modeling_signals"]

    formula_candidates = extract_formula_candidates(full_text)
    raw_candidates = extract_candidate_dataset_dois(full_text)
    verified_candidates = []
    fname_slug = pdf_path.stem
    for cand in raw_candidates:
        if normalize_doi(cand["doi_or_url"]) in known_datasets:
            continue
        verified = verify_dataset_candidate(cand["doi_or_url"], cand["repo"], min_size_kb=min_size_kb)
        if verified["verified"] and download_data_flag:
            target_dir = download_verified_candidate(verified, paper_slug=fname_slug)
            if target_dir is not None:
                verified["formula_completeness"] = check_formula_completeness(formula_candidates, target_dir)
        verified.pop("files", None)
        verified_candidates.append(verified)
        if verbose:
            flag = "OK" if verified["verified"] else "??"
            fc = verified.get("formula_completeness") or {}
            fc_note = f" [formule: {fc['status']}]" if fc.get("status") else ""
            print(f"    [{flag}] {cand['repo']:10s} {verified.get('download_status', ''):26s} {cand['doi_or_url'][:60]}{fc_note}", file=sys.stderr)
    record["dataset_candidates"] = verified_candidates
    return record


def scan_manual_raw_data(*, verbose: bool) -> list[dict[str, Any]]:
    """Signale les dossiers data/raw/papers/<x> ajoutes a la main et pas
    encore rattaches a un papier dans le KG ou l'accumulateur. Ne devine
    jamais le papier associe -- affiche juste la liste pour rattachement
    manuel (ou par une session Claude qui inspecte le contenu, comme fait
    tout au long de cette session pour chaque nouveau depot)."""
    if not RAW_DATA_DIR.exists():
        return []
    known = known_local_raw_dirs()
    unlinked = []
    for d in sorted(RAW_DATA_DIR.iterdir()):
        if not d.is_dir() or d.name in known:
            continue
        try:
            files = sorted(p.name for p in d.rglob("*") if p.is_file())
        except OSError as exc:
            # Chemin trop long pour Windows (MAX_PATH) quelque part sous ce
            # dossier -- on le signale quand meme, juste sans le detail des
            # fichiers, plutot que de faire echouer tout le scan.
            files = []
            if verbose:
                print(f"    [erreur] listing {d.name} : {exc}", file=sys.stderr)
        unlinked.append({"dir": str(d.relative_to(ROOT)), "n_files": len(files), "files_sample": files[:8]})
        if verbose:
            print(f"  [manuel] dossier data/raw/papers non rattache : {d.name} ({len(files)} fichier(s))", file=sys.stderr)
    return unlinked


# --------------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------------

def main() -> int:
    parser = argparse.ArgumentParser(description="Journal-first harvest of paper-linked spatial datasets.")
    parser.add_argument("--sources", help="Comma-separated OpenAlex source IDs. Defaults to the curated journal list.")
    parser.add_argument("--list-sources", action="store_true", help="Print the default journal list and exit.")
    parser.add_argument("--from-year", type=int, default=2015)
    parser.add_argument("--max-pages", type=int, default=2)
    parser.add_argument("--per-page", type=int, default=25)
    parser.add_argument("--min-citations", type=int, default=0)
    parser.add_argument("--min-score", type=int, default=4, help="lit_common literature_score threshold to bother fetching a PDF.")
    parser.add_argument("--min-dataset-size-kb", type=int, default=200, help="Skip a verified repo whose total file size is below this (0 disables).")
    parser.add_argument("--target", type=int, default=300, help="Max total NEW (not-already-known) works processed this run, across all sources.")
    parser.add_argument("--mailto")
    parser.add_argument("--download-pdf", action="store_true", help="Download OA PDFs for candidates above --min-score.")
    parser.add_argument("--run-grobid", action="store_true", help="Run GROBID on downloaded PDFs and extract dataset links (implies --download-pdf).")
    parser.add_argument("--download-data", action="store_true", help="Download verified dataset files for API-backed repos (implies --run-grobid --download-pdf).")
    parser.add_argument("--grobid-url", default="http://localhost:8070")
    parser.add_argument("--dry-run", action="store_true", help="Only discover+score from OpenAlex, skip PDF/GROBID/download entirely.")
    parser.add_argument(
        "--scan-manual",
        action="store_true",
        help=(
            "Process PDFs manually dropped into corpus/papers/raw_pdf/ (GROBID + dataset "
            "extraction + verification) and list data/raw/papers/ folders manually dropped "
            "there that aren't linked to any paper yet. Runs instead of the OpenAlex "
            "discovery loop unless --sources/other discovery flags are also given."
        ),
    )
    parser.add_argument("--skip-discovery", action="store_true", help="With --scan-manual, skip the OpenAlex discovery loop entirely.")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    if args.list_sources:
        for sid, name in DEFAULT_SOURCES.items():
            print(f"{sid}\t{name}")
        return 0

    load_local_env()
    verbose = not args.quiet
    sources = (
        {sid: DEFAULT_SOURCES.get(sid, sid) for sid in args.sources.split(",")}
        if args.sources
        else DEFAULT_SOURCES
    )
    run_grobid_flag = (args.run_grobid or args.download_data) and not args.dry_run
    download_pdf_flag = (args.download_pdf or run_grobid_flag) and not args.dry_run
    download_data_flag = args.download_data and not args.dry_run

    known_papers, known_datasets, accumulator = load_known_dois()
    if verbose:
        print(
            f"Etat local charge : {len(known_papers)} paper_doi connus, {len(known_datasets)} dataset_doi connus, "
            f"{len(accumulator)} enregistrements dans l'accumulateur ({ACCUMULATOR_PATH.name}).",
            file=sys.stderr,
        )

    new_records: list[dict[str, Any]] = []
    unlinked_raw_dirs: list[dict[str, Any]] = []
    if args.scan_manual:
        if verbose:
            print("== Scan des ajouts manuels (corpus/papers/raw_pdf/, data/raw/papers/)", file=sys.stderr)
        new_records.extend(
            scan_manual_pdfs(
                accumulator,
                known_datasets=known_datasets,
                min_size_kb=args.min_dataset_size_kb,
                download_data_flag=download_data_flag,
                grobid_url=args.grobid_url,
                verbose=verbose,
            )
        )
        unlinked_raw_dirs = scan_manual_raw_data(verbose=verbose)

    skipped_known = 0
    if args.scan_manual and args.skip_discovery:
        sources = {}
    for source_id, source_name in sources.items():
        if verbose:
            print(f"== {source_name} ({source_id})", file=sys.stderr, flush=True)
        works = openalex_search_source(
            source_id,
            from_year=args.from_year,
            max_pages=args.max_pages,
            per_page=args.per_page,
            mailto=args.mailto,
            verbose=verbose,
        )
        if args.min_citations:
            works = [w for w in works if (w.get("cited_by_count") or 0) >= args.min_citations]

        for work in works:
            paper_doi = normalize_doi(work.get("doi"))
            openalex_id = work.get("id")
            if openalex_id in accumulator or (paper_doi and paper_doi in known_papers):
                skipped_known += 1
                continue
            if len(new_records) >= args.target:
                break
            record = process_work(
                work,
                query_label=f"journal_first:{source_name}",
                min_score=args.min_score,
                min_size_kb=args.min_dataset_size_kb,
                download_pdf_flag=download_pdf_flag,
                run_grobid_flag=run_grobid_flag,
                download_data_flag=download_data_flag,
                grobid_url=args.grobid_url,
                known_datasets=known_datasets,
                verbose=verbose,
            )
            new_records.append(record)
            if openalex_id:
                accumulator[openalex_id] = record
            if paper_doi:
                known_papers.add(paper_doi)
        if len(new_records) >= args.target:
            break

    save_accumulator(accumulator)

    verified_new = [r for r in new_records if any(c.get("verified") for c in r.get("dataset_candidates", []))]
    manual_needed = [
        (r.get("paper_title"), r.get("paper_doi"), c)
        for r in new_records
        for c in r.get("dataset_candidates", [])
        if c.get("download_status") == "needs_manual_retrieval"
    ]
    pdf_failed = [
        (r.get("paper_title"), r.get("paper_doi"), r.get("oa_url"))
        for r in new_records
        if r.get("pdf_download_status") == "failed"
    ]
    formula_incomplete = [
        (r.get("paper_title"), r.get("paper_doi"), c)
        for r in new_records
        for c in r.get("dataset_candidates", [])
        if (c.get("formula_completeness") or {}).get("status") == "incomplete"
    ]

    summary = {
        "mode": "journal_first_harvest",
        "sources_queried": sources,
        "from_year": args.from_year,
        "already_known_skipped": skipped_known,
        "new_works_processed": len(new_records),
        "new_works_with_verified_dataset": len(verified_new),
        "candidates_needing_manual_retrieval": len(manual_needed),
        "pdf_download_failed": len(pdf_failed),
        "manual_raw_data_dirs_unlinked": len(unlinked_raw_dirs),
        "datasets_with_incomplete_formula": len(formula_incomplete),
        "accumulator_path": str(ACCUMULATOR_PATH.relative_to(ROOT)),
        "accumulator_total_records": len(accumulator),
    }
    print(json.dumps(summary, indent=2, ensure_ascii=False))

    if unlinked_raw_dirs:
        print("\n-- data/raw/papers/ : dossiers ajoutes a la main, pas encore rattaches a un papier --", file=sys.stderr)
        for entry in unlinked_raw_dirs:
            print(f"  {entry['dir']} ({entry['n_files']} fichier(s) : {', '.join(entry['files_sample'])})", file=sys.stderr)

    if manual_needed:
        print("\n-- Datasets a recuperer manuellement (depot sans API de verification, ou API en echec) --", file=sys.stderr)
        for title, paper_doi, cand in manual_needed:
            print(f"  {cand['repo']:10s} {cand['doi_or_url']:60s} (papier: {title} / {paper_doi})", file=sys.stderr)

    if pdf_failed:
        print("\n-- PDF non recuperables automatiquement (page d'atterrissage editeur, pas un lien PDF direct) --", file=sys.stderr)
        for title, paper_doi, oa_url in pdf_failed:
            print(f"  {oa_url or '(pas d url OA)':60s} (papier: {title} / {paper_doi})", file=sys.stderr)

    if formula_incomplete:
        print("\n-- Depots telecharges mais formule du papier incomplete (variable(s) absente(s), a chercher via source externe, jamais a fabriquer) --", file=sys.stderr)
        for title, paper_doi, cand in formula_incomplete:
            fc = cand["formula_completeness"]
            print(f"  {cand['doi_or_url']:50s} (papier: {title} / {paper_doi})", file=sys.stderr)
            print(f"    {fc['note']}", file=sys.stderr)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
