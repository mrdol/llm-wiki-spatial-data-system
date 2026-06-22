from __future__ import annotations

import json
import time
from pathlib import Path
from urllib.parse import quote
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "data" / "manifests" / "software_dataset_literature_links.jsonl"
NOTE = ROOT / "wiki" / "analyses" / "discovery" / "software_dataset_literature_links_2026_04_29.md"


DATASETS = [
    {
        "dataset": "Columbus crime",
        "queries": [
            '"Columbus" "crime" "spatial econometrics"',
            '"Columbus crime" spatial lag model',
            '"Anselin" "Columbus" "crime"',
        ],
    },
    {
        "dataset": "North Carolina SIDS",
        "queries": [
            '"North Carolina" SIDS spatial analysis',
            '"nc.sids" spatial',
            '"sudden infant death syndrome" "North Carolina" spatial',
        ],
    },
    {
        "dataset": "Boston housing",
        "queries": [
            '"Boston housing" "Harrison" "Rubinfeld"',
            '"Boston housing data" "Journal of Environmental Economics"',
            '"hedonic prices" "demand for clean air"',
        ],
    },
    {
        "dataset": "Guerry moral statistics",
        "queries": [
            '"Guerry" "Moral Statistics" spatial',
            '"Guerry" "crime" "literacy" spatial',
            '"Guerry dataset" spatial regression',
        ],
    },
    {
        "dataset": "Georgia education",
        "queries": [
            '"Georgia" "PctBach" "geographically weighted regression"',
            '"Georgia" "GWmodel" "GWR"',
            '"Georgia education" "geographically weighted regression"',
        ],
    },
    {
        "dataset": "Baltimore housing",
        "queries": [
            '"Baltimore" housing price spatial econometrics',
            '"Baltimore" "housing" "spatial regression"',
            '"baltim" "PySAL" housing',
        ],
    },
    {
        "dataset": "US state income",
        "queries": [
            '"US states" per capita income spatial Markov',
            '"spatial Markov" "US income"',
            '"Rey" "spatial Markov" "income"',
        ],
    },
    {
        "dataset": "Mexico state income",
        "queries": [
            '"Mexican states" income "spatial Markov"',
            '"Mexico" "regional income" "spatial Markov"',
            '"Mexicojoin" "PySAL"',
        ],
    },
    {
        "dataset": "St Louis homicide",
        "queries": [
            '"St Louis" homicide spatial analysis counties',
            '"STL" homicide "PySAL"',
            '"St. Louis" homicide spatial econometrics',
        ],
    },
    {
        "dataset": "Colombia malaria",
        "queries": [
            '"Colombia" malaria spatial analysis municipality',
            '"malaria" "Colombia" "spatial" "municipalities"',
            '"GeoDa" "malaria" "Colombia"',
        ],
    },
    {
        "dataset": "Chicago Airbnb",
        "queries": [
            '"Chicago" Airbnb spatial regression',
            '"Airbnb" "Chicago" "spatial" "neighborhood"',
            '"Airbnb" "Chicago" "spatial analysis"',
        ],
    },
    {
        "dataset": "Chicago health",
        "queries": [
            '"Chicago" health "community areas" spatial analysis',
            '"Chicago health" "spatial regression"',
            '"Chicago" "community areas" "health indicators"',
        ],
    },
    {
        "dataset": "NCOVR county homicide",
        "queries": [
            '"NCOVR" homicide spatial',
            '"county homicide" "spatial" "NCOVR"',
            '"National Consortium on Violence Research" spatial homicide',
        ],
    },
    {
        "dataset": "Las Rosas corn yield",
        "queries": [
            '"Las Rosas" corn yield spatial',
            '"rosas1999" yield spatial',
            '"corn yield" "spatial regression" "Las Rosas"',
        ],
    },
    {
        "dataset": "Chile labor",
        "queries": [
            '"Chile" labor market areas spatial',
            '"Chile" labor "functional labor market areas"',
            '"FLMA" Chile spatial labor',
        ],
    },
    {
        "dataset": "NYC earnings",
        "queries": [
            '"New York City" earnings "LEHD" spatial',
            '"NYC" earnings "LEHD" blocks',
            '"LEHD" "New York City" spatial analysis',
        ],
    },
    {
        "dataset": "King County home sales",
        "queries": [
            '"King County" house sales spatial regression',
            '"King County" housing price spatial',
            '"kc_house" spatial regression',
        ],
    },
    {
        "dataset": "Cincinnati crime",
        "queries": [
            '"Cincinnati" crime spatial regression',
            '"Walnut Hills" Cincinnati crime spatial',
            '"Cincinnati" crime "spatial analysis"',
        ],
    },
    {
        "dataset": "US SDOH 2014",
        "queries": [
            '"social determinants of health" "spatial" "tract" "2014"',
            '"CDC SVI" "spatial" "health" "tract"',
            '"US SDOH" spatial analysis census tract',
        ],
    },
    {
        "dataset": "xarray air temperature",
        "queries": [
            '"xarray" "air_temperature" dataset',
            '"air_temperature.nc" xarray climate',
            '"NCEP" air temperature xarray',
        ],
    },
    {
        "dataset": "GeoLife trajectory",
        "queries": [
            '"GeoLife" GPS trajectory dataset',
            '"GeoLife" "trajectory" "Microsoft Research"',
            '"GeoLife" "user mobility" "GPS trajectory"',
        ],
    },
    {
        "dataset": "Foursquare NYC mobility",
        "queries": [
            '"Foursquare" "NYC" "check-in" dataset',
            '"TSMC2014" "Foursquare" "New York"',
            '"Foursquare" "check-in" "New York" "mobility"',
        ],
    },
]


def openalex_search(query: str) -> list[dict]:
    url = (
        "https://api.openalex.org/works"
        f"?search={quote(query)}"
        "&filter=type:article"
        "&select=id,doi,title,publication_year,primary_location,authorships,cited_by_count,open_access"
        "&per-page=5"
    )
    req = Request(url, headers={"User-Agent": "llm-wiki-karpathy dataset-literature-search"})
    with urlopen(req, timeout=45) as response:
        payload = json.loads(response.read().decode("utf-8"))
    return payload.get("results", [])


def source_name(work: dict) -> str | None:
    loc = work.get("primary_location") or {}
    source = loc.get("source") or {}
    return source.get("display_name")


def authors(work: dict, limit: int = 4) -> list[str]:
    out = []
    for authorship in work.get("authorships") or []:
        author = authorship.get("author") or {}
        if author.get("display_name"):
            out.append(author["display_name"])
    return out[:limit]


def normalize(work: dict, dataset: str, query: str) -> dict:
    return {
        "dataset": dataset,
        "query": query,
        "paper_title": work.get("title"),
        "paper_doi": work.get("doi"),
        "paper_year": work.get("publication_year"),
        "venue": source_name(work),
        "authors": authors(work),
        "openalex_id": work.get("id"),
        "cited_by_count": work.get("cited_by_count"),
        "is_oa": (work.get("open_access") or {}).get("is_oa"),
        "oa_url": (work.get("open_access") or {}).get("oa_url"),
    }


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)
    NOTE.parent.mkdir(parents=True, exist_ok=True)

    records = []
    seen = set()
    for ds in DATASETS:
        kept = 0
        for query in ds["queries"]:
            try:
                works = openalex_search(query)
            except Exception as exc:
                records.append({"dataset": ds["dataset"], "query": query, "error": str(exc)})
                continue
            time.sleep(0.2)
            for work in works:
                key = work.get("doi") or work.get("id") or work.get("title")
                if not key or (ds["dataset"], key) in seen:
                    continue
                seen.add((ds["dataset"], key))
                records.append(normalize(work, ds["dataset"], query))
                kept += 1
                if kept >= 3:
                    break
            if kept >= 3:
                break

    with OUT.open("w", encoding="utf-8") as handle:
        for record in records:
            handle.write(json.dumps(record, ensure_ascii=True) + "\n")

    lines = [
        "# Software Dataset Literature Links",
        "",
        "This discovery note links documented software datasets to journal articles found through OpenAlex queries. These links are candidates: they should be manually checked before being treated as canonical evidence of dataset use.",
        "",
        f"Machine manifest: `{OUT.relative_to(ROOT)}`.",
        "",
    ]
    current = None
    for record in records:
        if record.get("dataset") != current:
            current = record.get("dataset")
            lines.extend(["", f"## {current}", ""])
        if record.get("error"):
            lines.append(f"- Search error for `{record.get('query')}`: {record.get('error')}")
            continue
        title = record.get("paper_title") or "Untitled"
        venue = record.get("venue") or "venue unknown"
        year = record.get("paper_year") or "year unknown"
        doi = record.get("paper_doi") or record.get("openalex_id") or "no DOI"
        authors_text = ", ".join(record.get("authors") or [])
        lines.append(f"- {title} ({year}), {venue}. DOI/OpenAlex: {doi}. Authors: {authors_text}.")

    NOTE.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
