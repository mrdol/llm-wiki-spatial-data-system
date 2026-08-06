#!/usr/bin/env python
"""Appliquer la decision manuelle apres verification des PDF DataCite.

Decision du 2026-08-06:
- 24 articles conservent un PDF local et poursuivent le pipeline GROBID/KG;
- 5 articles sont rejetes car payants ou sans jeu de donnees exploitable.

Le script met a jour les manifestes DataCite et les usages papier-dataset du KG
sans supprimer les traces historiques. Les candidats rejetes gardent leur ligne,
mais leur statut les exclut de la suite automatique.
"""

from __future__ import annotations

import csv
import html
import json
import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
PAPER_USE_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
CANDIDATES_JSON = ROOT / "data" / "manifests" / "papers" / "datacite_spatial_dataset_candidates.json"
CANDIDATES_CSV = ROOT / "data" / "manifests" / "papers" / "datacite_spatial_dataset_candidates_excel.csv"
INGEST_JSON = ROOT / "data" / "manifests" / "papers" / "datacite_verified_ingestion_manifest.json"
INGEST_CSV = ROOT / "data" / "manifests" / "papers" / "datacite_verified_ingestion_manifest_excel.csv"
PDF_MANIFEST = ROOT / "data" / "manifests" / "papers" / "datacite_verified_pdf_download_manifest.csv"
MANUAL_CATALOG = ROOT / "data" / "manifests" / "papers" / "datacite_verified_manual_download_catalog.csv"
REPORT = ROOT / "wiki" / "analyses" / "datacite_verified_ingestion_2026-08.md"


REJECTION_REASON = (
    "Rejected after manual PDF/source screening on 2026-08-06: "
    "article is paywalled or does not provide an exploitable benchmark dataset."
)

REJECTED_DOIS = {
    "10.1002/eap.2893",
    "10.1016/j.ufug.2020.126778",
    "10.1080/13658816.2019.1707834",
    "10.1080/24694452.2018.1462691",
    "10.1093/ajae/aaz047",
}

LOCAL_PDFS = {
    "10.1002/sim.7172": "Cluster detection of spatial regression coefficients.pdf",
    "10.1007/s10640-021-00536-2": "Systematic Variation in Waste Site Effects on Residential Property Values - A Meta-Regression Analysis and Benefit Transfer.pdf",
    "10.1016/j.eneco.2015.08.003": "Regional distribution of photovoltaic deployment in the UK and its determinants A spatial econometric approach.pdf",
    "10.1016/j.envint.2019.104909": "An ensemble-based model of PM2.5 concentration across the contiguous united states with high spatiotemporal resolution.pdf",
    "10.1017/pan.2020.23": "Juhl_2021_WaldTestCommonFactorsSpatialModelSpecification.pdf",
    "10.1021/acs.est.0c01791": "AnEnsembleLearningApproachforEstimatingHighSpatiotemporalResolution.pdf",
    "10.1021/acs.est.9b03358": "Assessing NO2 Concentration and Model Uncertainty with High spatiotemporal resolution accross the contiguous united states.pdf",
    "10.1038/sdata.2018.246": "A global dataset of air temperature derived from satellite remote sensing and weather stations.pdf",
    "10.1080/07474938.2022.2047507": "Model selection and model averaging for matrix exponential spatial models_nodatafound.pdf",
    "10.1080/17583004.2021.1962979": "Above ground carbon stock mapping over coimbatore and Nilgiris biosphere.pdf",
    "10.1093/isq/sqz068": "Regulatory Convergence in the Financial Periphery.pdf",
    "10.1111/1365-2435.13092": "Primary productivity explains size variation across the Pallid bat western geographic range.pdf",
    "10.1111/2041-210x.13762": "Sydenham_2022_MetaComNet_RandomForestSpatialPollinatorPredictions.pdf",
    "10.1111/2041-210x.13957": "Laxton_2023_StructuralComplexityEcologicalInsightSpatioTemporalSDM.pdf",
    "10.1111/ecog.06085": "Niche conservatism limits the distribution of Medicago in the tropics.pdf",
    "10.1111/geb.12999": "Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals.pdf",
    "10.1111/geb.13792": "Global Ecology and Biogeography - 2023 - Mäkinen - Integrated species distribution models to account for sampling biases.pdf",
    "10.1186/s41043-022-00309-7": "Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019 a geographically weighted regression analysis.pdf",
    "10.1371/journal.pone.0138456": "Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome.pdf",
    "10.1590/0001-3765201920180666": "Spatial distribution of wood volume in Brazilian savannas.pdf",
    "10.1590/0034-7612163114": "Building a sustainable development index and spacial assessment of municipalities inequalities in the state of Ceara.pdf",
    "10.1590/0103-6351/4456": "Determinants and spatial dependence of innovation in Brazilian regions - evidence from a Spatial Tobit Model.pdf",
    "10.1590/1806-9479.2019.187145": "O impacto das cooperativas na producao agropecuaria brasileira - uma analise econometrica espacial.pdf",
    "10.5751/es-12481-260327": "How do Indigenous and local knowledge systems respond to climate change.pdf",
}


def normalize_doi(value: Any) -> str:
    text = str(value or "").strip().lower()
    text = text.replace("https://doi.org/", "").replace("http://dx.doi.org/", "")
    return text.replace("doi:", "").strip().rstrip(".")


def mojibake_score(value: str) -> int:
    """Repere les sequences typiques d'un texte UTF-8 mal decode."""
    return sum(value.count(marker) for marker in ("Ã", "Â", "â€", "�"))


def clean_text(value: Any) -> str:
    """Nettoie les champs texte avant d'ecrire les rapports lisibles."""
    text = html.unescape(str(value or ""))
    if mojibake_score(text) > 0:
        for encoding in ("cp1252", "latin1"):
            try:
                candidate = text.encode(encoding).decode("utf-8")
            except UnicodeError:
                continue
            if mojibake_score(candidate) < mojibake_score(text):
                text = candidate
                break
    text = text.translate(
        str.maketrans(
            {
                "‐": "-",
                "‑": "-",
                "–": "-",
                "—": "-",
                "’": "'",
                "‘": "'",
                "“": '"',
                "”": '"',
                "…": "...",
            }
        )
    )
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def read_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8-sig") as handle:
        return json.load(handle)


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle, delimiter=";"))


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    if not rows:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = list(rows[0].keys())
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, delimiter=";")
        writer.writeheader()
        writer.writerows(rows)


def local_pdf_path(publication_doi: str) -> str:
    filename = LOCAL_PDFS[publication_doi]
    path = PDF_DIR / filename
    if path.exists():
        return str(path.relative_to(ROOT))
    # Certains noms longs sont mieux resolus via enumeration du dossier sous Windows.
    for candidate in PDF_DIR.glob("*.pdf"):
        if candidate.name == filename:
            return str(candidate.relative_to(ROOT))
    raise FileNotFoundError(f"PDF local introuvable pour {publication_doi}: {path}")


def update_candidate_row(row: dict[str, Any]) -> dict[str, Any]:
    doi = normalize_doi(row.get("publication_doi"))
    if doi in REJECTED_DOIS:
        row["candidate_status"] = "rejected_after_manual_screening"
        row["verification_action"] = "reject"
        row["verification_issues"] = REJECTION_REASON
        row["ingestion_next_step"] = "excluded from GROBID/KG/wiki dataset ingestion"
    elif doi in LOCAL_PDFS:
        row["candidate_status"] = "verified_candidate"
        row["local_pdf"] = local_pdf_path(doi)
        row["ingestion_next_step"] = "run GROBID -> KG -> formula/model evidence -> dataset fiche"
    return row


def update_ingestion_rows(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    kept = []
    for row in rows:
        doi = normalize_doi(row.get("publication_doi"))
        if doi in REJECTED_DOIS:
            continue
        if doi in LOCAL_PDFS:
            row["local_pdf"] = local_pdf_path(doi)
            row["ingestion_status"] = "pdf_present_pending_grobid"
            row["ingestion_next_step"] = "run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted"
        kept.append(row)
    return kept


def update_download_manifest(rows: list[dict[str, Any]], candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
    by_doi = {normalize_doi(row.get("publication_doi")): row for row in rows}
    candidate_by_doi = {normalize_doi(row.get("publication_doi")): row for row in candidates}
    output = []
    for doi, candidate in candidate_by_doi.items():
        row = by_doi.get(
            doi,
            {
                "dataset_doi": candidate.get("dataset_doi", ""),
                "publication_doi": candidate.get("publication_doi", ""),
                "publication_title": candidate.get("publication_title") or candidate.get("article_title") or "",
                "local_pdf": "",
                "status": "",
                "source_url": candidate.get("open_access_pdf_url") or candidate.get("article_oa_url") or candidate.get("publication_url") or "",
                "http_status": "",
                "content_type": "",
                "note": "",
            },
        )
        if doi in REJECTED_DOIS:
            row["status"] = "rejected_after_manual_screening"
            row["local_pdf"] = ""
            row["note"] = REJECTION_REASON
        elif doi in LOCAL_PDFS:
            row["status"] = "pdf_present_pending_grobid"
            row["local_pdf"] = local_pdf_path(doi)
            row["note"] = "PDF present locally; ready for GROBID."
        else:
            row["status"] = candidate.get("candidate_status", "not_in_verified_pdf_batch")
            row["note"] = "Not part of the 24 PDFs selected for the next GROBID batch."
        output.append(row)
    return sorted(output, key=lambda row: normalize_doi(row.get("publication_doi")))


def update_paper_dataset_uses(payload: dict[str, Any]) -> dict[str, Any]:
    for row in payload.get("records", []):
        if row.get("source_type") != "datacite_verified_candidate":
            continue
        doi = normalize_doi(row.get("paper_doi"))
        if doi in REJECTED_DOIS:
            row["ingestion_status"] = "rejected_after_manual_screening"
            row["confidence"] = "low"
            row["evidence"] = REJECTION_REASON
            row["excluded_from_package_pipeline"] = True
        elif doi in LOCAL_PDFS:
            row["ingestion_status"] = "pdf_present_pending_grobid"
            row["local_pdf"] = local_pdf_path(doi)
            row["excluded_from_package_pipeline"] = False
    payload.setdefault("metadata", {})
    payload["metadata"]["datacite_pdf_screening_date"] = "2026-08-06"
    payload["metadata"]["datacite_pdf_screening_kept"] = len(LOCAL_PDFS)
    payload["metadata"]["datacite_pdf_screening_rejected"] = len(REJECTED_DOIS)
    return payload


def write_report(rows: list[dict[str, Any]], rejected_rows: list[dict[str, Any]]) -> None:
    lines = [
        "# Ingestion des candidats DataCite valides",
        "",
        "Date : 2026-08-06",
        "",
        f"- Candidats initiaux : **{len(rows) + len(rejected_rows)}**",
        f"- PDF locaux conserves pour la suite : **{len(rows)}**",
        f"- Rejets apres verification manuelle : **{len(rejected_rows)}**",
        "",
        "Les 24 lignes conservees poursuivent le pipeline: PDF -> GROBID -> TEI -> KG -> fiche dataset.",
        "Les 5 rejets restent traces dans les manifestes, mais sont exclus de la suite automatique.",
        "",
        "## Conserves",
        "",
        "| DOI article | Article | PDF local |",
        "|---|---|---|",
    ]
    for row in rows:
        lines.append(
            "| {doi} | {title} | `{pdf}` |".format(
                doi=row.get("publication_doi", ""),
                title=clean_text(row.get("publication_title", "")).replace("|", "/"),
                pdf=row.get("local_pdf", ""),
            )
        )
    lines.extend(
        [
            "",
            "## Rejetes",
            "",
            "| DOI article | Article | Raison |",
            "|---|---|---|",
        ]
    )
    for row in rejected_rows:
        lines.append(
            "| {doi} | {title} | {reason} |".format(
                doi=row.get("publication_doi", ""),
                title=clean_text(row.get("publication_title", "") or row.get("article_title", "")).replace("|", "/"),
                reason=REJECTION_REASON,
            )
        )
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8", newline="\n")


def main() -> int:
    candidates = [update_candidate_row(row) for row in read_json(CANDIDATES_JSON)]
    write_json(CANDIDATES_JSON, candidates)
    write_csv(CANDIDATES_CSV, candidates)

    original_ingestion = read_json(INGEST_JSON)
    rejected_rows = [row for row in candidates if normalize_doi(row.get("publication_doi")) in REJECTED_DOIS]
    kept_ingestion = update_ingestion_rows(original_ingestion)
    write_json(INGEST_JSON, kept_ingestion)
    write_csv(INGEST_CSV, kept_ingestion)

    pdf_rows = update_download_manifest(read_csv(PDF_MANIFEST), candidates)
    write_csv(PDF_MANIFEST, pdf_rows)
    manual_rows = [
        {
            "dataset_doi": row.get("dataset_doi", ""),
            "publication_doi": row.get("publication_doi", ""),
            "publication_title": row.get("publication_title") or row.get("article_title") or "",
            "local_pdf": local_pdf_path(normalize_doi(row.get("publication_doi"))) if normalize_doi(row.get("publication_doi")) in LOCAL_PDFS else "",
            "candidate_status": row.get("candidate_status", ""),
            "data_access_url": row.get("data_access_url", ""),
        }
        for row in candidates
    ]
    write_csv(MANUAL_CATALOG, sorted(manual_rows, key=lambda row: normalize_doi(row.get("publication_doi"))))

    write_json(PAPER_USE_PATH, update_paper_dataset_uses(read_json(PAPER_USE_PATH)))
    write_report(kept_ingestion, rejected_rows)

    print(f"kept={len(kept_ingestion)}")
    print(f"rejected={len(rejected_rows)}")
    print(f"pdf_manifest={PDF_MANIFEST}")
    print(f"report={REPORT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
