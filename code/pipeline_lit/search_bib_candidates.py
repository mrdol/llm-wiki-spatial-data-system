"""Recherche OpenAlex pour enrichir le corpus de regression spatiale.

Cette passe sert de criblage bibliographique: elle ne pretend pas valider
definitivement les formules ou les donnees, mais elle evite les doublons avec
les BibTeX locaux et produit une table de candidats a curer.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import time
from pathlib import Path
from typing import Any
from urllib.parse import quote

import requests


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_OUTPUT_CSV = ROOT / "gg" / "regression_article_search_openalex_candidates_2026-08.csv"
DEFAULT_OUTPUT_MD = ROOT / "gg" / "regression_article_search_openalex_candidates_2026-08.md"
BIB_FILES = [
    ROOT / "corpus" / "bib" / "references.bib",
    ROOT / "gg" / "regression_article.bib",
]

SEARCH_QUERIES = [
    'spatial econometrics SAR SEM SDM dataset regression',
    'spatial regression dataset SAR SEM SDM spatial lag spatial error',
    'geographically weighted regression dataset GWR MGWR bandwidth',
    'multiscale geographically weighted regression dataset MGWR',
    'spatially varying coefficient model dataset regression',
    'Moran eigenvector maps ESF spatial regression dataset',
    'spatial random forest geospatial machine learning dataset regression',
    'geographically weighted random forest dataset',
    'spatial boosting GWRBoost gamboost spboost dataset',
    'Airbnb spatial regression GWR SAR SEM dataset',
    'housing price spatial econometrics GWR SAR dataset',
    'crime spatial regression GWR SAR dataset',
    'education inequality spatial regression dataset',
    'health mortality spatial regression GWR dataset',
    'crop yield spatial regression GWR random forest dataset',
    'soil geochemistry pollution spatial regression dataset',
    'precipitation temperature spatial interpolation regression random forest',
    'transport mobility spatial regression dataset',
    'land use biodiversity spatial regression random forest dataset',
    'spatial cross validation near prediction spatial prediction dataset',
]

ESTIMATOR_PATTERNS = {
    "SAR": r"\bSAR\b|spatial lag|spatial autoregressive",
    "SEM": r"\bSEM\b|spatial error",
    "SDM": r"spatial durbin",
    "SLX": r"\bSLX\b|spatial lag of x",
    "GWR": r"\bGWR\b|geographically weighted regression",
    "MGWR": r"\bMGWR\b|multiscale geographically weighted",
    "SVC": r"spatially varying coefficient|varying coefficient",
    "ESF": r"eigenvector spatial filtering|Moran eigenvector|Moran's eigenvector|\bESF\b",
    "spatial_random_forest": r"spatial random forest|geographical random forest|geographically weighted random forest|\bGRF\b",
    "boosting": r"boosting|GWRBoost|gamboost|spboost",
    "spatial_CV": r"spatial cross.validation|near prediction|spatial prediction",
}

RELEVANCE_PATTERN = re.compile(
    r"spatial econometric|spatial regression|spatial lag|spatial error|spatial durbin|"
    r"geographically weighted|multiscale geographically|spatially varying coefficient|"
    r"eigenvector spatial filtering|Moran eigenvector|spatial autocorrelation|"
    r"spatial random forest|geographically weighted random forest|GWRBoost|spboost|"
    r"spatial cross.validation|near prediction",
    flags=re.IGNORECASE,
)

EXCLUSION_PATTERN = re.compile(
    r"species distribution model|synthetic aperture radar|search and rescue|tutorial|review|state.of.the.art",
    flags=re.IGNORECASE,
)

STRONG_ESTIMATORS = {"SAR", "SEM", "SDM", "SLX", "GWR", "MGWR", "SVC", "ESF", "spatial_random_forest"}

DOMAIN_PATTERNS = {
    "Airbnb / tourism": r"airbnb|short.term rental|tourism|hotel",
    "housing / real estate": r"housing|house price|real estate|property",
    "crime / policing": r"crime|policing|violent|burglary|arrest",
    "education / inequality": r"education|school|income|inequality|poverty",
    "health / epidemiology": r"health|mortality|disease|covid|cancer|malaria|epidemi",
    "agriculture / crop yield": r"crop|yield|agricultur|precision agriculture",
    "soil / geochemistry / pollution": r"soil|geochem|pollution|heavy metal|zinc|lead|cadmium",
    "climate / weather": r"climate|precipitation|rainfall|temperature|weather",
    "transport / mobility": r"transport|mobility|traffic|accessibility",
    "land use / biodiversity": r"land use|deforestation|biodiversity|species|habitat",
}

COLUMNS = [
    "paper_title",
    "authors",
    "year",
    "DOI",
    "citation_count",
    "already_in_corpus",
    "domain",
    "estimator_keywords",
    "dataset_name",
    "dataset_topic",
    "dataset_size_if_available",
    "response_variable",
    "predictors_or_covariates",
    "coordinates_or_geometry",
    "W_or_neighbor_structure_if_available",
    "regression_formula_or_model_specification",
    "formula_status",
    "data_access_url",
    "code_url",
    "open_access_pdf_url",
    "reason_for_selection",
    "ingestion_priority",
    "verification_notes",
    "source_url",
    "matched_query",
]


def normalize_doi(value: str | None) -> str:
    doi = (value or "").strip().lower()
    doi = doi.replace("https://doi.org/", "").replace("http://dx.doi.org/", "")
    doi = doi.replace("doi:", "").rstrip(".")
    return doi


def normalize_title(value: str | None) -> str:
    text = (value or "").lower()
    text = re.sub(r"[^a-z0-9]+", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def read_local_bib_index() -> tuple[set[str], set[str]]:
    dois: set[str] = set()
    titles: set[str] = set()
    for path in BIB_FILES:
        if not path.exists():
            continue
        text = path.read_text(encoding="utf-8", errors="ignore")
        for match in re.finditer(r"\bdoi\s*=\s*[{\"]([^}\"]+)[}\"]", text, flags=re.IGNORECASE):
            doi = normalize_doi(match.group(1))
            if doi:
                dois.add(doi)
        for match in re.finditer(r"\btitle\s*=\s*[{\"]([^}\"]+)[}\"]", text, flags=re.IGNORECASE):
            title = normalize_title(match.group(1))
            if title:
                titles.add(title)
    return dois, titles


def decode_abstract(index: dict[str, list[int]] | None) -> str:
    if not index:
        return ""
    words: list[tuple[int, str]] = []
    for word, positions in index.items():
        for position in positions:
            words.append((position, word))
    return " ".join(word for _, word in sorted(words))


def compact_authors(work: dict[str, Any], limit: int = 6) -> str:
    names = []
    for authorship in work.get("authorships") or []:
        author = authorship.get("author") or {}
        name = author.get("display_name")
        if name:
            names.append(name)
    if len(names) > limit:
        return "; ".join(names[:limit]) + "; et al."
    return "; ".join(names)


def detect_many(text: str, patterns: dict[str, str]) -> list[str]:
    found = []
    for label, pattern in patterns.items():
        if re.search(pattern, text, flags=re.IGNORECASE):
            found.append(label)
    return found


def is_relevant_candidate(text: str, estimators: list[str]) -> bool:
    """Ecarte les homonymes et les papiers generaux sans benchmark spatial."""
    if not estimators:
        return False
    if EXCLUSION_PATTERN.search(text):
        return False
    if any(estimator in STRONG_ESTIMATORS for estimator in estimators):
        return bool(RELEVANCE_PATTERN.search(text))
    if "boosting" in estimators:
        return bool(
            re.search(r"spatial|geograph|geospatial|spatio.temporal|spatiotemporal", text, flags=re.IGNORECASE)
            and re.search(r"regression|prediction|dataset|case study|application", text, flags=re.IGNORECASE)
        )
    return bool(RELEVANCE_PATTERN.search(text))


def ranking_score(row: dict[str, str]) -> int:
    """Favorise les estimateurs econometriques spatiaux avant les papiers ML generiques."""
    estimators = set(row["estimator_keywords"].split("; "))
    score = 0
    score += 80 * len(estimators & {"GWR", "MGWR", "SAR", "SEM", "SDM", "SLX", "SVC", "ESF"})
    score += 50 if "spatial_random_forest" in estimators else 0
    score += 20 if "boosting" in estimators else 0
    score += 20 if row["open_access_pdf_url"] != "non trouvé" else 0
    score += 20 if row["domain"] != "non vérifié" else 0
    return score


def oa_pdf_url(work: dict[str, Any]) -> str:
    locations = []
    if isinstance(work.get("best_oa_location"), dict):
        locations.append(work["best_oa_location"])
    locations.extend(loc for loc in work.get("locations") or [] if isinstance(loc, dict))
    for loc in locations:
        pdf = loc.get("pdf_url")
        if pdf:
            return pdf
    return ""


def source_url(work: dict[str, Any]) -> str:
    doi = normalize_doi(work.get("doi"))
    if doi:
        return f"https://doi.org/{doi}"
    return work.get("id") or ""


def infer_priority(citations: int, estimators: list[str], text: str, pdf: str) -> str:
    has_dataset_signal = bool(re.search(r"dataset|data set|case study|empirical|application", text, re.IGNORECASE))
    if citations >= 100 and estimators and (pdf or has_dataset_signal):
        return "high"
    if citations >= 50 and estimators:
        return "high"
    if citations >= 20 and estimators:
        return "medium"
    return "low"


def work_to_row(work: dict[str, Any], query: str, local_dois: set[str], local_titles: set[str]) -> dict[str, str]:
    title = work.get("title") or ""
    doi = normalize_doi(work.get("doi"))
    abstract = decode_abstract(work.get("abstract_inverted_index"))
    text = f"{title} {abstract}"
    estimators = detect_many(text, ESTIMATOR_PATTERNS)
    domains = detect_many(text, DOMAIN_PATTERNS)
    citations = int(work.get("cited_by_count") or 0)
    title_key = normalize_title(title)
    pdf = oa_pdf_url(work)
    already = "yes" if (doi and doi in local_dois) or (title_key and title_key in local_titles) else "no"
    priority = infer_priority(citations, estimators, text, pdf)
    dataset_signal = "spatial dataset likely, manual verification required"
    if re.search(r"case study|application|empirical", text, flags=re.IGNORECASE):
        dataset_signal = "empirical/case-study dataset likely, manual verification required"
    if re.search(r"data set|dataset", text, flags=re.IGNORECASE):
        dataset_signal = "dataset mentioned in title/abstract, manual verification required"

    return {
        "paper_title": title,
        "authors": compact_authors(work),
        "year": str(work.get("publication_year") or ""),
        "DOI": doi,
        "citation_count": str(citations),
        "already_in_corpus": already,
        "domain": "; ".join(domains) if domains else "non vérifié",
        "estimator_keywords": "; ".join(estimators) if estimators else "non vérifié",
        "dataset_name": "non vérifié",
        "dataset_topic": "; ".join(domains) if domains else "non vérifié",
        "dataset_size_if_available": "non trouvé",
        "response_variable": "non vérifié",
        "predictors_or_covariates": "non vérifié",
        "coordinates_or_geometry": "spatial units/coordinates implied; à vérifier",
        "W_or_neighbor_structure_if_available": "non vérifié",
        "regression_formula_or_model_specification": "non vérifié",
        "formula_status": "not_found",
        "data_access_url": "non trouvé",
        "code_url": "non trouvé",
        "open_access_pdf_url": pdf or "non trouvé",
        "reason_for_selection": f"{dataset_signal}; citations={citations}; query={query}",
        "ingestion_priority": priority,
        "verification_notes": "OpenAlex screening only; vérifier texte complet, données, formule et code avant ingestion.",
        "source_url": source_url(work),
        "matched_query": query,
    }


def fetch_query(session: requests.Session, query: str, per_page: int, max_pages: int, mailto: str | None) -> list[dict[str, Any]]:
    works: list[dict[str, Any]] = []
    cursor = "*"
    for _ in range(max_pages):
        params = {
            "search": query,
            "filter": "from_publication_date:2000-01-01,cited_by_count:>19,type:article",
            "per-page": per_page,
            "cursor": cursor,
            "sort": "cited_by_count:desc",
            "select": (
                "id,doi,title,publication_year,cited_by_count,abstract_inverted_index,"
                "authorships,open_access,best_oa_location,locations"
            ),
        }
        if mailto:
            params["mailto"] = mailto
        response = session.get("https://api.openalex.org/works", params=params, timeout=60)
        if response.status_code == 429:
            # OpenAlex limite parfois les rafales: on attend puis on retente
            # la meme page avant d'abandonner cette requete.
            retry_after = int(response.headers.get("Retry-After") or 12)
            time.sleep(retry_after)
            response = session.get("https://api.openalex.org/works", params=params, timeout=60)
            if response.status_code == 429:
                break
        response.raise_for_status()
        payload = response.json()
        works.extend(item for item in payload.get("results") or [] if isinstance(item, dict))
        next_cursor = payload.get("meta", {}).get("next_cursor")
        if not next_cursor or next_cursor == cursor:
            break
        cursor = next_cursor
        time.sleep(0.4)
    return works


def write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=COLUMNS)
        writer.writeheader()
        writer.writerows(rows)


def md_table(rows: list[dict[str, str]], limit: int) -> str:
    columns = [
        "paper_title",
        "authors",
        "year",
        "DOI",
        "citation_count",
        "domain",
        "estimator_keywords",
        "open_access_pdf_url",
        "ingestion_priority",
        "verification_notes",
    ]
    out = ["| " + " | ".join(columns) + " |", "|" + "|".join("---" for _ in columns) + "|"]
    for row in rows[:limit]:
        values = []
        for column in columns:
            value = str(row.get(column, "")).replace("\n", " ").replace("|", "\\|")
            if len(value) > 130:
                value = value[:127] + "..."
            values.append(value)
        out.append("| " + " | ".join(values) + " |")
    return "\n".join(out)


def write_markdown(path: Path, rows: list[dict[str, str]], *, top_limit: int) -> None:
    high = [row for row in rows if row["ingestion_priority"] == "high"]
    medium = [row for row in rows if row["ingestion_priority"] == "medium"]
    content = [
        "# OpenAlex spatial-regression candidate papers",
        "",
        "Source prompt: `tools/search_bib.md`.",
        "",
        "This is an automated screening table. Dataset names, formulas, covariates, code URLs and data URLs remain `non vérifié` unless OpenAlex directly exposed enough evidence. Manual curation is required before adding papers to the corpus.",
        "",
        f"- candidates after local BibTeX DOI/title exclusion: {len(rows)}",
        f"- high priority: {len(high)}",
        f"- medium priority: {len(medium)}",
        "",
        "## Top candidates",
        "",
        md_table(rows, top_limit),
        "",
        "## Next 10 for ingestion",
        "",
        md_table(rows[:10], 10),
        "",
    ]
    path.write_text("\n".join(content), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Search OpenAlex for spatial-regression benchmark candidate papers.")
    parser.add_argument("--limit", type=int, default=200)
    parser.add_argument("--per-page", type=int, default=50)
    parser.add_argument("--max-pages", type=int, default=2)
    parser.add_argument("--mailto")
    parser.add_argument("--csv", default=str(DEFAULT_OUTPUT_CSV))
    parser.add_argument("--md", default=str(DEFAULT_OUTPUT_MD))
    parser.add_argument("--top-md-limit", type=int, default=60)
    parser.add_argument("--from-csv", help="Reclasse un CSV existant sans relancer OpenAlex.")
    args = parser.parse_args()

    if args.from_csv:
        with Path(args.from_csv).open(encoding="utf-8", newline="") as handle:
            rows = list(csv.DictReader(handle))
        cleaned = []
        for row in rows:
            estimators = row.get("estimator_keywords", "").split("; ")
            text = " ".join(
                [
                    row.get("paper_title", ""),
                    row.get("reason_for_selection", ""),
                    row.get("verification_notes", ""),
                ]
            )
            if row.get("already_in_corpus") == "yes":
                continue
            if not is_relevant_candidate(text, estimators):
                continue
            cleaned.append(row)
        priority_rank = {"high": 0, "medium": 1, "low": 2}
        cleaned = sorted(
            cleaned,
            key=lambda row: (priority_rank.get(row["ingestion_priority"], 9), -ranking_score(row), -int(row["citation_count"])),
        )[: args.limit]
        write_csv(Path(args.csv), cleaned)
        write_markdown(Path(args.md), cleaned, top_limit=args.top_md_limit)
        print(json.dumps({
            "mode": "postprocess_csv",
            "input": args.from_csv,
            "candidate_count": len(cleaned),
            "csv": args.csv,
            "md": args.md,
        }, ensure_ascii=False, indent=2))
        return

    local_dois, local_titles = read_local_bib_index()
    session = requests.Session()
    session.headers.update({"User-Agent": "llm-wiki-spatial-data-system/0.1 literature screening"})

    rows_by_doi_or_title: dict[str, dict[str, str]] = {}
    for query in SEARCH_QUERIES:
        for work in fetch_query(session, query, args.per_page, args.max_pages, args.mailto):
            row = work_to_row(work, query, local_dois, local_titles)
            if row["already_in_corpus"] == "yes":
                continue
            if row["estimator_keywords"] == "non vérifié":
                continue
            text = f"{row['paper_title']} {row['reason_for_selection']}"
            if not is_relevant_candidate(text, row["estimator_keywords"].split("; ")):
                abstract = decode_abstract(work.get("abstract_inverted_index"))
                if not is_relevant_candidate(f"{row['paper_title']} {abstract}", row["estimator_keywords"].split("; ")):
                    continue
            key = row["DOI"] or normalize_title(row["paper_title"])
            current = rows_by_doi_or_title.get(key)
            if current is None or int(row["citation_count"]) > int(current["citation_count"]):
                rows_by_doi_or_title[key] = row

    priority_rank = {"high": 0, "medium": 1, "low": 2}
    rows = sorted(
        rows_by_doi_or_title.values(),
        key=lambda row: (priority_rank.get(row["ingestion_priority"], 9), -ranking_score(row), -int(row["citation_count"])),
    )[: args.limit]

    write_csv(Path(args.csv), rows)
    write_markdown(Path(args.md), rows, top_limit=args.top_md_limit)
    print(json.dumps({
        "local_dois": len(local_dois),
        "local_titles": len(local_titles),
        "candidate_count": len(rows),
        "csv": args.csv,
        "md": args.md,
        "top_10": [
            {
                "title": row["paper_title"],
                "doi": row["DOI"],
                "citations": row["citation_count"],
                "estimators": row["estimator_keywords"],
                "priority": row["ingestion_priority"],
            }
            for row in rows[:10]
        ],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
