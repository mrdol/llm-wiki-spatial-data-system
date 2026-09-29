#!/usr/bin/env python3
"""Build the article-first recovery manifest for the data-paper corpus.

The input coding table records empirical dataset uses by article.  This tool
splits those uses, merges known aliases, attaches existing KG records and
extracts repository clues from the corresponding TEI.  It does not download
anything and never treats a bibliographic DOI as a dataset DOI.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import unicodedata
from collections import defaultdict
from pathlib import Path
from urllib.parse import urlparse


REPOSITORY_HOSTS = {
    "datadryad.org", "doi.org", "figshare.com", "github.com", "kaggle.com",
    "dataverse.harvard.edu", "zenodo.org", "spatial-panels.com",
    "ncei.noaa.gov", "ncdc.noaa.gov", "usgs.gov", "waterdata.usgs.gov",
    "prism.oregonstate.edu", "data.gov", "data.gouv.fr", "rdrr.io",
    "cran.r-project.org", "pysal.org",
}
DATA_DOI_PREFIXES = ("10.5061/", "10.5281/", "10.6084/", "10.7910/", "10.6071/")

# Only aliases needed to merge repeated sources.  Distinct paper-specific
# extracts remain separate unless the coding table explicitly identifies them
# as the same empirical source.
ALIASES = {norm_key: canonical for norm_key, canonical in {
    "boston housing": "boston_housing",
    "dublin voter turnout data": "dublin_voter_2002",
    "dublin voter turnout": "dublin_voter_2002",
    "dublin voter 2002": "dublin_voter_2002",
    "ncdc us precipitation anomalies": "ncdc_precip_anomalies",
    "usda forest inventory and analysis biomass": "fia_biomass",
    "us state hecm mortgage originations": "hecm_originations",
    "us state cigarette demand": "us_cigarette_panel",
    "meuse": "meuse",
    "meuse river topsoil zinc": "meuse",
}.items()}

KNOWN_LOCAL = {
    "boston_housing": ["data/final_datasets/sf/Python_geodatasets_spdata.boston.rds"],
    "meuse": ["data/final_datasets/sf/R_sp_meuse_meuse.rds"],
    "georgia": ["data/final_datasets/sf/Python_libpysal_georgia.rds"],
    "clearwater": ["data/final_datasets/sf/Python_libpysal_clearwater.rds"],
    "tokyo": ["data/final_datasets/sf/Python_libpysal_tokyo.rds"],
}

RESTRICTED_KEYS = {"massachusetts_birth_registry_and_pm2_5_exposure_study"}


def norm(value: str) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode()
    value = re.sub(r"(?<=[a-z])(?=[A-Z])", " ", value)
    return re.sub(r"[^a-z0-9]+", " ", value.lower()).strip()


def slug(value: str) -> str:
    return norm(value).replace(" ", "_")


def clean_url(value: str) -> str:
    return value.rstrip(".,;:)'\"]}")


def useful_url(value: str) -> bool:
    try:
        host = urlparse(value).netloc.lower().removeprefix("www.")
    except ValueError:
        return False
    return any(host == h or host.endswith("." + h) for h in REPOSITORY_HOSTS)


def tei_clues(path: Path) -> tuple[list[str], list[str], str]:
    if not path.exists():
        return [], [], ""
    text = path.read_text(encoding="utf-8", errors="ignore")
    urls = sorted({clean_url(u) for u in re.findall(r"https?://[^\s<>&quot;]+", text) if useful_url(clean_url(u))})
    dois = sorted({d.lower().rstrip(".,;:)") for d in re.findall(r"10\.\d{4,9}/[-._;()/:A-Za-z0-9]+", text)
                   if d.lower().startswith(DATA_DOI_PREFIXES)})
    plain = re.sub(r"<[^>]+>", " ", text)
    plain = re.sub(r"\s+", " ", plain)
    return urls, dois, plain


def score_name(dataset_name: str, kg_name: str) -> float:
    special = {
        "king county houses": "kinghouseprices",
        "nyc airbnb": "nycairbnb",
    }
    if special.get(norm(dataset_name)) == norm(kg_name).replace(" ", ""):
        return 1.0
    a, b = set(norm(dataset_name).split()), set(norm(kg_name).split())
    if not a or not b:
        return 0.0
    return len(a & b) / len(a | b)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--coding", required=True, type=Path)
    ap.add_argument("--kg", default=Path("inst/kg/paper_dataset_uses.json"), type=Path)
    ap.add_argument("--seed", default=Path("extensions_projet_2026-09/redaction_datapaper/meta_analyse_datasets_a_recuperer_2026-09-17.tsv"), type=Path)
    ap.add_argument("--output", required=True, type=Path)
    args = ap.parse_args()

    with args.coding.open(encoding="utf-8-sig", newline="") as fh:
        articles = list(csv.DictReader(fh, delimiter="\t"))
    kg = json.loads(args.kg.read_text(encoding="utf-8"))["records"]
    seeds = []
    if args.seed.exists():
        with args.seed.open(encoding="utf-8-sig", newline="") as fh:
            seeds = list(csv.DictReader(fh, delimiter="\t"))
    raw_dirs = [p for p in Path("data/raw/papers").glob("*") if p.is_dir()]
    kg_by_doi: dict[str, list[dict]] = defaultdict(list)
    for rec in kg:
        if rec.get("paper_doi"):
            kg_by_doi[rec["paper_doi"].lower()].append(rec)

    uses: dict[str, dict] = {}
    tei_cache: dict[str, tuple[list[str], list[str]]] = {}
    for article in articles:
        if int(article.get("n_real_datasets") or 0) == 0:
            continue
        names = [x.strip() for x in article["real_dataset_names"].split(";") if x.strip()]
        tei = Path(article["tei_path"])
        if str(tei) not in tei_cache:
            tei_cache[str(tei)] = tei_clues(tei)
        urls, data_dois, plain_tei = tei_cache[str(tei)]
        for name in names:
            key = ALIASES.get(norm(name), slug(name))
            item = uses.setdefault(key, {
                "dataset_key": key, "dataset_name": name, "article_ids": [],
                "paper_dois": [], "tei_paths": [], "tei_repository_urls": set(),
                "tei_dataset_dois": set(), "kg_records": [],
                "tei_evidence": [],
            })
            item["article_ids"].append(article["id"])
            if article.get("doi"):
                item["paper_dois"].append(article["doi"])
            item["tei_paths"].append(article["tei_path"])
            item["tei_repository_urls"].update(urls)
            item["tei_dataset_dois"].update(data_dois)
            tokens = [t for t in norm(name).split() if len(t) >= 5]
            if tokens:
                match = re.search(re.escape(tokens[0]), plain_tei, flags=re.IGNORECASE)
                if match:
                    lo, hi = max(0, match.start() - 220), min(len(plain_tei), match.end() + 420)
                    item["tei_evidence"].append(plain_tei[lo:hi].strip())
            candidates = kg_by_doi.get((article.get("doi") or "").lower(), [])
            ranked = sorted(candidates, key=lambda r: score_name(name, r.get("dataset_name_in_paper", "")), reverse=True)
            if ranked and score_name(name, ranked[0].get("dataset_name_in_paper", "")) >= 0.25:
                item["kg_records"].append(ranked[0])
            elif 0 < len(candidates) <= 2:
                # Repository records often repeat the article title instead of
                # the empirical dataset name.  An exact paper DOI remains
                # strong provenance when there are at most two linked records.
                item["kg_records"].extend(candidates)

    rows = []
    for key, item in sorted(uses.items()):
        records = item.pop("kg_records")
        source_urls = {r.get("source_url") for r in records if r.get("source_url")}
        source_urls |= {r.get("data_access_url") for r in records if r.get("data_access_url")}
        dataset_dois = {r.get("dataset_doi") for r in records if r.get("dataset_doi")}
        dataset_dois |= item.pop("tei_dataset_dois")
        local_paths = set()
        for rec in records:
            for field in ("local_raw_dir", "local_rds", "local_sf_path"):
                if rec.get(field):
                    local_paths.add(rec[field])
        local_paths.update(KNOWN_LOCAL.get(key, []))
        for data_doi in dataset_dois:
            doi_token = re.sub(r"[^a-z0-9]+", "_", data_doi.lower()).strip("_")
            local_paths.update(str(p) for p in raw_dirs if doi_token in p.name.lower())
        existing = [p for p in local_paths if Path(p).exists()]
        final_existing = [p for p in existing if "data/final_datasets" in p.replace("\\", "/")]
        article_ids = set(item["article_ids"])
        seed_candidates = [s for s in seeds if article_ids & set(s.get("article_ids", "").split(";"))]
        seed_candidates.sort(key=lambda s: score_name(item["dataset_name"], s.get("dataset_name", "")), reverse=True)
        seed = seed_candidates[0] if seed_candidates else {}
        ingestion = sorted({r.get("ingestion_status", "") for r in records if r.get("ingestion_status")})
        if final_existing:
            status = "already_in_repo"
        elif existing:
            status = "local_repository_artifact_needs_content_check"
        elif records and any(s in {"ingested", "converted_to_sf"} for s in ingestion):
            status = "already_catalogued_check_artifact"
        elif key in RESTRICTED_KEYS or "birth registry" in norm(item["dataset_name"]):
            status = "source_identified_restricted_or_manual"
        elif source_urls or dataset_dois or item["tei_repository_urls"]:
            status = "source_clues_to_verify"
        else:
            status = "source_needs_identification"
        rows.append({
            "dataset_key": key,
            "article_ids": ";".join(sorted(set(item["article_ids"]))),
            "paper_dois": ";".join(sorted(set(item["paper_dois"]))),
            "dataset_name": item["dataset_name"],
            "recovery_status": status,
            "kg_ingestion_status": ";".join(ingestion),
            "dataset_dois": ";".join(sorted(dataset_dois)),
            "verified_or_kg_source_urls": ";".join(sorted(source_urls)),
            "tei_repository_clues": ";".join(sorted(item.pop("tei_repository_urls"))),
            "existing_local_paths": ";".join(sorted(existing)),
            "tei_paths": ";".join(sorted(set(item["tei_paths"]))),
            "source_owner_seed": seed.get("primary_source_or_owner", ""),
            "retrieval_lead_seed": seed.get("retrieval_lead", ""),
            "curation_notes_seed": seed.get("notes", ""),
            "tei_evidence_excerpt": " | ".join(item["tei_evidence"][:2]),
            "next_action": {
                "already_in_repo": "verify exact paper extract, variables and licence",
                "local_repository_artifact_needs_content_check": "inspect local files: the repository artifact may contain code or simulations rather than the empirical data",
                "already_catalogued_check_artifact": "locate or rebuild the catalogued local artifact",
                "source_identified_restricted_or_manual": "document access conditions; do not automate restricted data",
                "source_clues_to_verify": "verify repository relation, file list, licence and exact analytical extract",
                "source_needs_identification": "read TEI data/source passages, references and supplementary-material statement",
            }[status],
        })

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="utf-8", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=list(rows[0]), delimiter="\t")
        writer.writeheader()
        writer.writerows(rows)
    print(json.dumps({"articles": len({a for r in rows for a in r['article_ids'].split(';')}),
                      "empirical_uses": sum(len(r["article_ids"].split(";")) for r in rows),
                      "canonical_sources": len(rows),
                      "status_counts": {s: sum(r["recovery_status"] == s for r in rows)
                                        for s in sorted({r["recovery_status"] for r in rows})}}, indent=2))


if __name__ == "__main__":
    main()
