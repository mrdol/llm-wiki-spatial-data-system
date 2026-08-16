"""Construit le manifeste central de curation des datasets issus de papiers.

Le but est de disposer d'une ligne par candidat dataset avant toute promotion
vers les fiches definitives ou le package spatialtidymodels. Le script consolide
les preuves deja produites par les fiches Markdown, DataCite, le KG et l'audit
TEI, sans inventer de formule ni de source.
"""

from __future__ import annotations

import argparse
import csv
import html
import json
import re
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


DEFAULT_OUTPUT_CSV = Path("data/manifests/papers/paper_dataset_benchmark_candidates.csv")
DEFAULT_OUTPUT_JSON = Path("data/manifests/papers/paper_dataset_benchmark_candidates.json")
DEFAULT_OUTPUT_MD = Path("wiki/analyses/paper_dataset_benchmark_candidates_2026-08.md")
DEFAULT_OUTPUT_HTML = Path("wiki/analyses/paper_dataset_benchmark_candidates_2026-08.html")
DEFAULT_MEDIUM_REVIEW_MD = Path("wiki/analyses/paper_dataset_medium_review_2026-08.md")
DEFAULT_LOW_REVIEW_MD = Path("wiki/analyses/paper_dataset_low_archive_2026-08.md")

COLUMNS = [
    "candidate_id",
    "source_layers",
    "curation_priority",
    "candidate_status",
    "benchmark_status",
    "package_include",
    "paper_title",
    "paper_doi",
    "dataset_name",
    "dataset_id",
    "dataset_doi",
    "dataset_url",
    "local_pdf",
    "local_artifact",
    "local_raw_dir",
    "download_status",
    "preprocessing_status",
    "response_variable",
    "candidate_y_status",
    "predictors_or_covariates",
    "candidate_x_status",
    "formula_or_model_specification",
    "formula_status",
    "spatial_support",
    "w_or_neighbor_status",
    "estimators_evidence",
    "audit_candidate_count",
    "audit_data_source_count",
    "audit_model_evidence_count",
    "audit_top_sections",
    "main_gap",
    "required_next_step",
    "evidence_sources",
    "wiki_path",
    "verification_notes",
]


def read_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8-sig"))


def repair_mojibake(value: str) -> str:
    """Corrige les mojibakes les plus courants sans toucher aux sources."""
    markers = ("Ã", "â", "ð", "�")
    if not any(marker in value for marker in markers):
        return value
    best = value
    best_score = sum(best.count(marker) for marker in markers)
    for encoding in ("cp1252", "latin1"):
        try:
            candidate = value.encode(encoding).decode("utf-8")
        except UnicodeError:
            continue
        score = sum(candidate.count(marker) for marker in markers)
        if score < best_score:
            best = candidate
            best_score = score
    return best


def clean(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, (list, tuple, set)):
        return "; ".join(clean(v) for v in value if clean(v))
    if isinstance(value, bool):
        return "yes" if value else "no"
    return repair_mojibake(str(value).replace("\r", " ").replace("\n", " ").strip())


def slug(value: str) -> str:
    value = value.lower().strip()
    value = re.sub(r"https?://", "", value)
    value = re.sub(r"[^a-z0-9]+", "_", value)
    return value.strip("_")[:120] or "unknown"


NON_DOI_SENTINELS = {"none", "not_applicable", "n/a", "na", "unknown", "null"}


def doi_key(value: str) -> str:
    value = clean(value).lower()
    value = re.sub(r"^https?://(dx\.)?doi\.org/", "", value)
    value = value.strip()
    if value in NON_DOI_SENTINELS:
        return ""
    return value


def normalize_paper_dataset_id(value: str) -> str:
    """Aligne les canonical_dataset_id KG au format "paper_<id>" (underscore)
    utilise par les fiches wiki et les .rds, pour que candidate_key() fusionne
    correctement les deux couches au lieu de creer deux lignes pour le meme
    dataset. Les autres namespaces colon-separated (ex. dataset_candidate:
    datacite:...) ne sont pas des identifiants de fiche/rds et ne doivent pas
    etre touches ici.
    """
    value = clean(value)
    if value.startswith("paper:"):
        return "paper_" + value[len("paper:") :]
    return value


def candidate_key(row: dict[str, Any]) -> str:
    source_layers = clean(row.get("source_layers")).lower()
    dataset_id = clean(row.get("dataset_id"))
    if ("package_metadata" in source_layers or "wiki_fiche" in source_layers) and dataset_id:
        return f"dataset_id:{dataset_id.lower()}"
    dataset_doi = doi_key(row.get("dataset_doi", ""))
    if dataset_doi:
        return f"dataset_doi:{dataset_doi}"
    if dataset_id:
        return f"dataset_id:{dataset_id.lower()}"
    paper_doi = doi_key(row.get("paper_doi", ""))
    dataset_name = clean(row.get("dataset_name"))
    if paper_doi and dataset_name:
        return f"paper_dataset:{paper_doi}:{slug(dataset_name)}"
    return f"candidate:{slug(clean(row.get('candidate_id')) or clean(row.get('paper_title')))}"


def empty_row(candidate_id: str) -> dict[str, Any]:
    return {column: "" for column in COLUMNS} | {"candidate_id": candidate_id}


def merge_row(rows: dict[str, dict[str, Any]], incoming: dict[str, Any]) -> None:
    key = candidate_key(incoming)
    row = rows.setdefault(key, empty_row(clean(incoming.get("candidate_id")) or slug(key)))
    incoming_layers = clean(incoming.get("source_layers")).lower()
    canonical_package_row = "package_metadata" in incoming_layers or "wiki_fiche" in incoming_layers

    # On conserve toutes les couches de preuve qui pointent vers le meme candidat.
    layers = set(filter(None, clean(row.get("source_layers")).split("; ")))
    layers.update(filter(None, clean(incoming.get("source_layers")).split("; ")))
    row["source_layers"] = "; ".join(sorted(layers))

    sources = set(filter(None, clean(row.get("evidence_sources")).split("; ")))
    sources.update(filter(None, clean(incoming.get("evidence_sources")).split("; ")))
    row["evidence_sources"] = "; ".join(sorted(sources))

    for column in COLUMNS:
        if column in {"candidate_id", "source_layers", "evidence_sources"}:
            continue
        value = clean(incoming.get(column))
        if (
            canonical_package_row
            and value
            and column in {
                "benchmark_status",
                "package_include",
                "response_variable",
                "candidate_y_status",
                "predictors_or_covariates",
                "candidate_x_status",
                "formula_or_model_specification",
                "formula_status",
                "main_gap",
                "required_next_step",
                "wiki_path",
                "verification_notes",
            }
        ):
            row[column] = value
        elif value and not clean(row.get(column)):
            row[column] = value

    # Les compteurs d'audit doivent s'additionner si plusieurs sources convergent.
    for column in ["audit_candidate_count", "audit_data_source_count", "audit_model_evidence_count"]:
        old = int(clean(row.get(column)) or 0)
        new = int(clean(incoming.get(column)) or 0)
        if new:
            row[column] = str(max(old, new))

    row["curation_priority"] = choose_priority(row)


def choose_priority(row: dict[str, Any]) -> str:
    status = clean(row.get("benchmark_status")).lower()
    package_include = clean(row.get("package_include")).lower()
    candidate_status = clean(row.get("candidate_status")).lower()
    source_layers = clean(row.get("source_layers")).lower()
    local_artifact = clean(row.get("local_artifact"))
    formula = clean(row.get("formula_or_model_specification"))
    y_status = clean(row.get("candidate_y_status")).lower()
    x_status = clean(row.get("candidate_x_status")).lower()

    if (
        candidate_status in {"rejected", "excluded", "dropped"}
        or status in {"excluded", "excluded_simulation"}
        or status.startswith("not_ready")
    ):
        return "low"
    if source_layers == "tei_audit":
        return "low"
    if package_include == "yes" and status == "ready":
        return "high"
    if status == "ready" and local_artifact and formula and y_status == "present" and x_status == "present":
        return "high"
    if status.startswith("almost_ready") or status.startswith("needs_"):
        return "medium"
    if candidate_status == "verified_candidate":
        return "medium"
    # Un signal TEI seul ne suffit pas a devenir priorite moyenne : il faut
    # encore identifier un dataset concret et une source de telechargement.
    return "low"


def y_status(response: str, benchmark_status: str) -> str:
    response = clean(response).lower()
    if response and response not in {"pending", "null", "none", "na"}:
        return "present"
    if benchmark_status.startswith("not_ready"):
        return "not_usable_or_missing"
    return "missing"


def x_status(predictors: Any, benchmark_status: str) -> str:
    text = clean(predictors).lower()
    if text and text not in {"pending", "null", "none", "na"}:
        return "present"
    if benchmark_status.startswith("not_ready"):
        return "not_usable_or_missing"
    return "missing"


def load_readiness_audit(repo_root: Path) -> dict[str, dict[str, str]]:
    path = repo_root / "data/manifests/papers/paper_dataset_readiness_audit.csv"
    if not path.exists():
        return {}
    with path.open(encoding="utf-8-sig", newline="") as f:
        return {row["dataset"]: row for row in csv.DictReader(f, delimiter=";")}


def load_audit_summary(repo_root: Path) -> dict[str, dict[str, Any]]:
    path = repo_root / "data/manifests/papers/model_evidence_audit.csv"
    summary: dict[str, dict[str, Any]] = defaultdict(lambda: {
        "audit_candidate_count": 0,
        "audit_data_source_count": 0,
        "audit_model_evidence_count": 0,
        "audit_top_sections": [],
        "paper_title": "",
        "paper_doi": "",
    })
    if not path.exists():
        return {}

    with path.open(encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f, delimiter=";")
        for row in reader:
            doi = doi_key(row.get("doi", ""))
            paper_id = clean(row.get("paper_id"))
            key = doi or paper_id
            if not key:
                continue
            item = summary[key]
            item["paper_title"] = item["paper_title"] or clean(row.get("paper_title"))
            item["paper_doi"] = item["paper_doi"] or clean(row.get("doi"))
            item["audit_candidate_count"] += 1
            evidence_type = clean(row.get("evidence_type")).lower()
            formula_type = clean(row.get("formula_type")).lower()
            if "data_source" in evidence_type:
                item["audit_data_source_count"] += 1
            if "model" in evidence_type or "formula" in evidence_type or "empirical" in formula_type:
                item["audit_model_evidence_count"] += 1
            section = clean(row.get("section_title"))
            if section and section not in item["audit_top_sections"] and len(item["audit_top_sections"]) < 5:
                item["audit_top_sections"].append(section)
            title = clean(row.get("paper_title"))
            if title:
                summary[f"title:{slug(title)}"] = item
    return dict(summary)


def load_package_dataset_dois(repo_root: Path) -> set[str]:
    metadata_path = repo_root / "packages/spatialtidymodels/inst/metadata/datasets.json"
    data = read_json(metadata_path, {"records": []})
    out: set[str] = set()
    for record in data.get("records", []):
        dataset = clean(record.get("dataset") or record.get("dataset_id"))
        if not dataset.startswith("paper_"):
            continue
        dataset_doi = doi_key(record.get("dataset_doi", ""))
        if dataset_doi:
            out.add(dataset_doi)
    return out


def add_package_metadata_rows(repo_root: Path, rows: dict[str, dict[str, Any]], audit_by_doi: dict[str, dict[str, Any]]) -> None:
    metadata_path = repo_root / "packages/spatialtidymodels/inst/metadata/datasets.json"
    data = read_json(metadata_path, {"records": []})
    readiness = load_readiness_audit(repo_root)

    for record in data.get("records", []):
        dataset = clean(record.get("dataset"))
        if not dataset.startswith("paper_"):
            continue
        status = clean(record.get("benchmark_status")) or "not_assessed"
        audit = readiness.get(dataset, {})
        audit_status = clean(audit.get("benchmark_status"))
        audit_package_include = clean(audit.get("package_include"))
        record_package_include = clean(record.get("package_include"))
        # `paper_dataset_readiness_audit.csv` is a review queue snapshot. For
        # datasets that already have a generated fiche and package metadata, the
        # fiche is the canonical, newer source of readiness. The audit can fill
        # blanks, but it must not downgrade or stale-overwrite curated metadata.
        merged_status = status or audit_status
        merged_package_include = record_package_include or audit_package_include
        merged_gap = clean(record.get("benchmark_missing_items")) or clean(audit.get("main_gap"))
        merged_next_step = clean(record.get("benchmark_readiness_reason")) or clean(audit.get("next_step"))
        doi = doi_key(record.get("publication_doi", ""))
        audit_summary = audit_by_doi.get(doi, {}) or audit_by_doi.get(f"title:{slug(record.get('publication_title', ''))}", {})
        incoming = {
            "candidate_id": dataset,
            "source_layers": "wiki_fiche; package_metadata",
            "candidate_status": "fiche_documented",
            "benchmark_status": merged_status,
            "package_include": merged_package_include,
            "paper_title": record.get("source_ref") or record.get("title"),
            "paper_doi": record.get("publication_doi"),
            "dataset_name": record.get("title") or record.get("dataset_id"),
            "dataset_id": dataset,
            "dataset_doi": record.get("dataset_doi"),
            "dataset_url": record.get("source_url"),
            "local_artifact": record.get("local_artifact") or record.get("rds"),
            "download_status": "final_artifact_present" if clean(record.get("local_artifact") or record.get("rds")) else "missing_final_artifact",
            "preprocessing_status": audit.get("raw_status") or "unknown",
            "response_variable": record.get("response"),
            "candidate_y_status": y_status(record.get("response", ""), status),
            "predictors_or_covariates": record.get("predictors"),
            "candidate_x_status": x_status(record.get("predictors", ""), status),
            "formula_or_model_specification": record.get("formula") or record.get("formula_used") or record.get("formula_pub"),
            "formula_status": record.get("formula_status"),
            "spatial_support": record.get("data_type") or record.get("structure") or clean(record.get("coords")),
            "w_or_neighbor_status": "needs_review",
            "estimators_evidence": record.get("eligible_estimators"),
            "audit_candidate_count": audit_summary.get("audit_candidate_count", 0),
            "audit_data_source_count": audit_summary.get("audit_data_source_count", 0),
            "audit_model_evidence_count": audit_summary.get("audit_model_evidence_count", 0),
            "audit_top_sections": audit_summary.get("audit_top_sections", []),
            "main_gap": merged_gap,
            "required_next_step": merged_next_step,
            "evidence_sources": "packages/spatialtidymodels/inst/metadata/datasets.json; data/manifests/papers/paper_dataset_readiness_audit.csv",
            "wiki_path": record.get("wiki_path"),
            "verification_notes": record.get("notes") or record.get("description_confidence"),
        }
        merge_row(rows, incoming)


def add_datacite_rows(
    repo_root: Path,
    rows: dict[str, dict[str, Any]],
    audit_by_doi: dict[str, dict[str, Any]],
    package_dataset_dois: set[str],
) -> None:
    path = repo_root / "data/manifests/papers/datacite_verified_ingestion_manifest.json"
    for record in read_json(path, []):
        doi = doi_key(record.get("publication_doi", ""))
        dataset_doi = doi_key(record.get("dataset_doi", ""))
        ingestion_status = clean(record.get("ingestion_status"))
        candidate_status = clean(record.get("candidate_status")).lower()
        if dataset_doi and dataset_doi in package_dataset_dois:
            # A generated paper_* fiche/package row is the canonical state for
            # this dataset DOI. Keeping the raw DataCite row would reintroduce
            # stale `needs_grobid_kg_review` noise in the curation dashboard.
            continue
        audit_summary = audit_by_doi.get(doi, {}) or audit_by_doi.get(f"title:{slug(record.get('publication_title', ''))}", {})
        if ingestion_status.startswith("rejected") or candidate_status in {"rejected", "excluded", "dropped"}:
            benchmark_status = "excluded"
            package_include = "no"
            main_gap = "candidate rejected by user or verification; no GROBID/KG work required"
            required_next_step = "none - keep in low archive unless the decision is explicitly reopened"
        elif ingestion_status.startswith("blocked"):
            benchmark_status = ingestion_status.replace("blocked", "not_ready", 1)
            package_include = "no"
            main_gap = clean(record.get("blocking_reason")) or "raw data or paper evidence blocks a defensible benchmark artifact"
            required_next_step = clean(record.get("blocking_next_step")) or "keep archived until missing source data or reconciliation evidence is found"
        elif audit_summary.get("audit_candidate_count", 0):
            benchmark_status = "needs_preprocessing"
            package_include = "manual_review"
            main_gap = "TEI/KG evidence already exists; dataset still needs raw-data inspection, loader and fiche reconciliation"
            required_next_step = "inspect/download raw data, write or update loader, then generate/reconcile paper_* fiche"
        elif not clean(record.get("local_pdf")):
            benchmark_status = "needs_pdf_before_grobid"
            package_include = "manual_review"
            main_gap = "no local legal PDF is linked yet; GROBID cannot be run for this candidate"
            required_next_step = "retrieve a legal PDF or exclude the candidate, then run GROBID/KG"
        else:
            benchmark_status = "needs_grobid_kg_review"
            package_include = "manual_review"
            main_gap = "dataset not yet inspected/preprocessed as final sf artifact"
            required_next_step = record.get("ingestion_next_step")
        incoming = {
            "candidate_id": f"datacite_{slug(record.get('dataset_doi') or record.get('publication_doi') or record.get('dataset_title', ''))}",
            "source_layers": "datacite_verified",
            "candidate_status": record.get("candidate_status"),
            "benchmark_status": benchmark_status,
            "package_include": package_include,
            "paper_title": record.get("publication_title"),
            "paper_doi": record.get("publication_doi"),
            "dataset_name": record.get("dataset_title"),
            "dataset_doi": record.get("dataset_doi"),
            "dataset_url": record.get("data_access_url"),
            "local_pdf": record.get("local_pdf"),
            "download_status": record.get("ingestion_status"),
            "formula_or_model_specification": record.get("formula_pub"),
            "formula_status": record.get("formula_status"),
            "spatial_support": record.get("spatial_evidence"),
            "estimators_evidence": record.get("estimators_from_metadata"),
            "audit_candidate_count": audit_summary.get("audit_candidate_count", 0),
            "audit_data_source_count": audit_summary.get("audit_data_source_count", 0),
            "audit_model_evidence_count": audit_summary.get("audit_model_evidence_count", 0),
            "audit_top_sections": audit_summary.get("audit_top_sections", []),
            "main_gap": main_gap,
            "required_next_step": required_next_step,
            "evidence_sources": "data/manifests/papers/datacite_verified_ingestion_manifest.json",
            "verification_notes": record.get("verification_notes"),
        }
        merge_row(rows, incoming)


def add_kg_dataset_use_rows(
    repo_root: Path,
    rows: dict[str, dict[str, Any]],
    audit_by_doi: dict[str, dict[str, Any]],
    package_dataset_dois: set[str],
) -> None:
    data = read_json(repo_root / "inst/kg/paper_dataset_uses.json", {"records": []})
    for record in data.get("records", []):
        canonical_id = clean(record.get("canonical_dataset_id"))
        if canonical_id.startswith("dataset_candidate:warehouse"):
            continue
        dataset_doi = doi_key(record.get("dataset_doi", ""))
        if dataset_doi and dataset_doi in package_dataset_dois:
            continue
        doi = doi_key(record.get("paper_doi", ""))
        audit_summary = audit_by_doi.get(doi, {})
        ingestion_status = clean(record.get("ingestion_status"))
        if ingestion_status.startswith("rejected"):
            candidate_status = "rejected"
            benchmark_status = "excluded"
        elif ingestion_status.startswith("blocked"):
            candidate_status = ingestion_status
            benchmark_status = ingestion_status.replace("blocked", "not_ready", 1)
        elif ingestion_status == "ingested":
            candidate_status = ingestion_status
            benchmark_status = "ready"
        else:
            candidate_status = ingestion_status
            benchmark_status = "needs_reconciliation"
        incoming = {
            "candidate_id": slug(record.get("canonical_dataset_id") or f"{record.get('bib_key')}_{record.get('dataset_name_in_paper')}") ,
            "source_layers": "kg_paper_dataset_use",
            "candidate_status": candidate_status,
            "benchmark_status": benchmark_status,
            "package_include": "manual_review" if not ingestion_status.startswith("rejected") else "no",
            "paper_title": record.get("paper_title"),
            "paper_doi": record.get("paper_doi"),
            "dataset_name": record.get("dataset_name_in_paper"),
            "dataset_id": normalize_paper_dataset_id(record.get("canonical_dataset_id")),
            "dataset_doi": record.get("dataset_doi"),
            "dataset_url": record.get("source_url"),
            "download_status": record.get("ingestion_status"),
            "local_pdf": record.get("local_pdf"),
            "local_raw_dir": record.get("local_raw_dir"),
            "response_variable": "",
            "formula_or_model_specification": record.get("formula"),
            "formula_status": "explicit" if clean(record.get("formula")) else "not_found",
            "spatial_support": record.get("spatial_characterization"),
            "estimators_evidence": record.get("estimators_used"),
            "audit_candidate_count": audit_summary.get("audit_candidate_count", 0),
            "audit_data_source_count": audit_summary.get("audit_data_source_count", 0),
            "audit_model_evidence_count": audit_summary.get("audit_model_evidence_count", 0),
            "audit_top_sections": audit_summary.get("audit_top_sections", []),
            "main_gap": "reconcile catalog/final artifact/formula before package use" if record.get("ingestion_status") != "ingested" else "verify formula and package readiness",
            "required_next_step": "inspect source dataset and create or update fiche if benchmarkable",
            "evidence_sources": "inst/kg/paper_dataset_uses.json",
            "verification_notes": record.get("evidence"),
        }
        merge_row(rows, incoming)


def add_audit_only_rows(rows: dict[str, dict[str, Any]], audit_by_doi: dict[str, dict[str, Any]]) -> None:
    existing_paper_dois = {doi_key(row.get("paper_doi", "")) for row in rows.values() if row.get("paper_doi")}
    for key, item in audit_by_doi.items():
        if key.startswith("title:"):
            continue
        if key in existing_paper_dois:
            continue
        if item["audit_data_source_count"] == 0 or item["audit_model_evidence_count"] == 0:
            continue
        incoming = {
            "candidate_id": f"tei_audit_{slug(key)}",
            "source_layers": "tei_audit",
            "candidate_status": "needs_manual_curation",
            "benchmark_status": "needs_dataset_identification",
            "package_include": "manual_review",
            "paper_title": item.get("paper_title"),
            "paper_doi": item.get("paper_doi"),
            "dataset_name": "pending_from_tei_audit",
            "download_status": "unknown",
            "formula_status": "candidate_evidence_in_tei",
            "audit_candidate_count": item.get("audit_candidate_count", 0),
            "audit_data_source_count": item.get("audit_data_source_count", 0),
            "audit_model_evidence_count": item.get("audit_model_evidence_count", 0),
            "audit_top_sections": item.get("audit_top_sections", []),
            "main_gap": "audit suggests data/model evidence but dataset identity is not curated",
            "required_next_step": "review TEI/PDF sections and add a concrete dataset candidate if evidence is valid",
            "evidence_sources": "data/manifests/papers/model_evidence_audit.csv",
        }
        merge_row(rows, incoming)


def write_csv(path: Path, records: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=COLUMNS, delimiter=";")
        writer.writeheader()
        for record in records:
            writer.writerow({column: clean(record.get(column)) for column in COLUMNS})


def write_json(path: Path, records: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "metadata_schema": "paper_dataset_benchmark_curation_v1",
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "description": "Central manifest for paper-derived spatial benchmark dataset candidates before wiki/package promotion.",
        "records": records,
    }
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def write_report(path: Path, records: list[dict[str, Any]], csv_path: Path, json_path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    priority_counts = Counter(clean(row.get("curation_priority")) for row in records)
    status_counts = Counter(clean(row.get("benchmark_status")) for row in records)
    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    lines = [
        "---",
        'title: "Paper Dataset Benchmark Candidates"',
        "type: analysis",
        "created: 2026-08-09",
        f"updated: {today}",
        "sources:",
        "  - tools/build_paper_dataset_curation_manifest.py",
        "  - inst/kg/paper_dataset_uses.json",
        "tags: [papers, datasets, benchmark, curation]",
        "---",
        "",
        "# Paper Dataset Benchmark Candidates",
        "",
        "Ce rapport resume le manifeste central de curation des datasets issus de papiers.",
        "Il ne promeut aucun dataset vers le package : il sert a decider quoi verifier, telecharger, pretraiter ou rejeter.",
        "",
        "## Sorties",
        "",
        f"- CSV Excel (`;`) : `{csv_path.as_posix()}`",
        f"- JSON : `{json_path.as_posix()}`",
        "- HTML interactif : `wiki/analyses/paper_dataset_benchmark_candidates_2026-08.html`",
        "",
        "## Bilan",
        "",
        f"- Candidats consolides : {len(records)}",
    ]
    for key, value in sorted(priority_counts.items()):
        lines.append(f"- Priorite `{key}` : {value}")
    lines.extend(["", "## Statuts benchmark", ""])
    for key, value in sorted(status_counts.items()):
        lines.append(f"- `{key}` : {value}")
    lines.extend(["", "## Candidats prioritaires", "", "| priority | dataset | paper | status | next step |", "|---|---|---|---|---|"])
    for row in records:
        if clean(row.get("curation_priority")) not in {"high", "medium"}:
            continue
        lines.append(
            "| {priority} | {dataset} | {paper} | {status} | {next_step} |".format(
                priority=clean(row.get("curation_priority")),
                dataset=clean(row.get("dataset_name"))[:80],
                paper=clean(row.get("paper_title"))[:80],
                status=clean(row.get("benchmark_status")),
                next_step=clean(row.get("required_next_step"))[:120],
            )
        )
    lines.extend(["", "## Related Pages", "", "- [[paper_dataset_ingestion_pipeline_2026-08]]"])
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def html_link(value: str, *, kind: str = "auto") -> str:
    text = clean(value)
    if not text:
        return ""
    if kind == "doi":
        doi = doi_key(text)
        if doi:
            return f'<a href="https://doi.org/{html.escape(doi)}" target="_blank" rel="noopener">{html.escape(text)}</a>'
    if text.startswith(("http://", "https://")):
        return f'<a href="{html.escape(text)}" target="_blank" rel="noopener">{html.escape(text)}</a>'
    if re.search(r"\.(md|pdf|csv|json|rds|gpkg|zip)$", text, flags=re.I) or "/" in text or "\\" in text:
        href = "../../" + text.replace("\\", "/")
        return f'<a href="{html.escape(href)}" target="_blank" rel="noopener">{html.escape(text)}</a>'
    return html.escape(text)


def write_interactive_html(path: Path, records: list[dict[str, Any]], csv_path: Path, json_path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    priority_counts = Counter(clean(row.get("curation_priority")) for row in records)
    status_counts = Counter(clean(row.get("benchmark_status")) for row in records)
    display_columns = [
        "curation_priority",
        "benchmark_status",
        "package_include",
        "dataset_name",
        "paper_title",
        "paper_doi",
        "dataset_doi",
        "download_status",
        "response_variable",
        "candidate_y_status",
        "candidate_x_status",
        "formula_status",
        "main_gap",
        "required_next_step",
        "wiki_path",
        "local_artifact",
        "local_pdf",
    ]
    records_json = json.dumps(
        [{column: clean(row.get(column)) for column in COLUMNS} for row in records],
        ensure_ascii=False,
    )
    columns_json = json.dumps(display_columns, ensure_ascii=False)
    html_text = f"""<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Paper Dataset Benchmark Candidates</title>
  <style>
    :root {{
      color-scheme: light;
      --bg: #f7f8fa;
      --panel: #ffffff;
      --text: #1f2933;
      --muted: #5f6b7a;
      --line: #d9dee7;
      --accent: #1f6feb;
      --high: #d9480f;
      --medium: #b7791f;
      --low: #4a5568;
      --ready: #137333;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background: var(--bg);
      color: var(--text);
      font-size: 14px;
    }}
    header {{
      padding: 18px 22px 12px;
      background: var(--panel);
      border-bottom: 1px solid var(--line);
      position: sticky;
      top: 0;
      z-index: 3;
    }}
    h1 {{ margin: 0 0 8px; font-size: 22px; letter-spacing: 0; }}
    .meta {{ color: var(--muted); display: flex; flex-wrap: wrap; gap: 12px; }}
    .toolbar {{
      display: grid;
      grid-template-columns: minmax(220px, 1fr) repeat(4, minmax(150px, 190px)) auto auto;
      gap: 10px;
      align-items: end;
      margin-top: 14px;
    }}
    label {{ display: grid; gap: 4px; color: var(--muted); font-size: 12px; }}
    input, select, button {{
      min-height: 34px;
      border: 1px solid var(--line);
      border-radius: 6px;
      padding: 6px 9px;
      background: #fff;
      color: var(--text);
      font: inherit;
    }}
    button {{ cursor: pointer; white-space: nowrap; }}
    button.primary {{ background: var(--accent); border-color: var(--accent); color: #fff; }}
    main {{ padding: 16px 22px 30px; }}
    .cards {{ display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 14px; }}
    .card {{
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 10px 12px;
      min-width: 145px;
    }}
    .card b {{ display: block; font-size: 20px; }}
    .card span {{ color: var(--muted); font-size: 12px; }}
    .table-wrap {{
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
      overflow: auto;
      max-height: calc(100vh - 210px);
    }}
    table {{ border-collapse: collapse; min-width: 1900px; width: 100%; }}
    th, td {{ border-bottom: 1px solid var(--line); padding: 7px 8px; vertical-align: top; }}
    th {{
      position: sticky;
      top: 0;
      background: #eef2f7;
      text-align: left;
      z-index: 2;
      cursor: pointer;
      user-select: none;
      font-size: 12px;
    }}
    td {{ max-width: 260px; overflow-wrap: anywhere; }}
    td.small {{ max-width: 130px; }}
    a {{ color: var(--accent); text-decoration: none; }}
    a:hover {{ text-decoration: underline; }}
    .pill {{
      display: inline-block;
      border-radius: 999px;
      padding: 2px 8px;
      font-size: 12px;
      background: #edf2f7;
      color: #2d3748;
    }}
    .pill.high {{ color: #fff; background: var(--high); }}
    .pill.medium {{ color: #fff; background: var(--medium); }}
    .pill.low {{ color: #fff; background: var(--low); }}
    .pill.ready {{ color: #fff; background: var(--ready); }}
    .muted {{ color: var(--muted); }}
    @media (max-width: 1100px) {{
      .toolbar {{ grid-template-columns: 1fr 1fr; }}
      .table-wrap {{ max-height: none; }}
    }}
  </style>
</head>
<body>
  <header>
    <h1>Paper Dataset Benchmark Candidates</h1>
    <div class="meta">
      <span>{len(records)} candidats consolides</span>
      <span>CSV: {html.escape(csv_path.as_posix())}</span>
      <span>JSON: {html.escape(json_path.as_posix())}</span>
    </div>
    <div class="toolbar">
      <label>Recherche
        <input id="search" type="search" placeholder="dataset, papier, DOI, gap...">
      </label>
      <label>Priorite
        <select id="priority"><option value="">Toutes</option></select>
      </label>
      <label>Statut benchmark
        <select id="status"><option value="">Tous</option></select>
      </label>
      <label>Package
        <select id="package"><option value="">Tous</option></select>
      </label>
      <label>Formule
        <select id="formula"><option value="">Toutes</option></select>
      </label>
      <button id="clear">Reset</button>
      <button id="export" class="primary">Exporter selection</button>
    </div>
  </header>
  <main>
    <section class="cards">
      <div class="card"><b id="visibleCount">0</b><span>lignes visibles</span></div>
      <div class="card"><b id="selectedCount">0</b><span>cases cochees</span></div>
      <div class="card"><b>{priority_counts.get("high", 0)}</b><span>priorite high</span></div>
      <div class="card"><b>{priority_counts.get("medium", 0)}</b><span>priorite medium</span></div>
      <div class="card"><b>{status_counts.get("ready", 0)}</b><span>ready</span></div>
    </section>
    <div class="table-wrap">
      <table id="table">
        <thead></thead>
        <tbody></tbody>
      </table>
    </div>
  </main>
  <script>
    const records = {records_json};
    const columns = {columns_json};
    const stateKey = "paper_dataset_benchmark_candidates_checked_v1";
    let checked = new Set(JSON.parse(localStorage.getItem(stateKey) || "[]"));
    let sortColumn = "curation_priority";
    let sortDirection = 1;

    const filters = {{
      search: document.getElementById("search"),
      priority: document.getElementById("priority"),
      status: document.getElementById("status"),
      package: document.getElementById("package"),
      formula: document.getElementById("formula"),
    }};

    function uniqueValues(column) {{
      return [...new Set(records.map(row => row[column]).filter(Boolean))].sort((a, b) => a.localeCompare(b));
    }}

    function fillSelect(id, column) {{
      const select = filters[id];
      uniqueValues(column).forEach(value => {{
        const option = document.createElement("option");
        option.value = value;
        option.textContent = value;
        select.appendChild(option);
      }});
    }}

    function candidateId(row) {{
      return row.candidate_id || row.dataset_doi || row.dataset_id || row.dataset_name;
    }}

    function linkify(value, column) {{
      if (!value) return "";
      const escaped = value
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;");
      if (column.endsWith("_doi") && value) {{
        const doi = value.replace(/^https?:\\/\\/(dx\\.)?doi\\.org\\//i, "");
        return `<a href="https://doi.org/${{encodeURI(doi)}}" target="_blank" rel="noopener">${{escaped}}</a>`;
      }}
      if (/^https?:\\/\\//i.test(value)) {{
        return `<a href="${{escaped}}" target="_blank" rel="noopener">${{escaped}}</a>`;
      }}
      if ((/\\.(md|pdf|csv|json|rds|gpkg|zip)$/i.test(value) || /[\\\\/]/.test(value)) && !value.includes(";")) {{
        const href = "../../" + value.replaceAll("\\\\", "/");
        return `<a href="${{href}}" target="_blank" rel="noopener">${{escaped}}</a>`;
      }}
      return escaped;
    }}

    function pill(value) {{
      const cls = String(value || "").toLowerCase().replace(/[^a-z0-9]+/g, "_");
      const priority = ["high", "medium", "low"].includes(cls) ? cls : "";
      const ready = cls === "ready" ? "ready" : "";
      return `<span class="pill ${{priority || ready}}">${{value || ""}}</span>`;
    }}

    function filteredRows() {{
      const query = filters.search.value.trim().toLowerCase();
      return records.filter(row => {{
        if (filters.priority.value && row.curation_priority !== filters.priority.value) return false;
        if (filters.status.value && row.benchmark_status !== filters.status.value) return false;
        if (filters.package.value && row.package_include !== filters.package.value) return false;
        if (filters.formula.value && row.formula_status !== filters.formula.value) return false;
        if (!query) return true;
        return columns.some(column => String(row[column] || "").toLowerCase().includes(query));
      }}).sort((a, b) => {{
        const av = String(a[sortColumn] || "");
        const bv = String(b[sortColumn] || "");
        return sortDirection * av.localeCompare(bv, undefined, {{numeric: true, sensitivity: "base"}});
      }});
    }}

    function render() {{
      const rows = filteredRows();
      const thead = document.querySelector("#table thead");
      const tbody = document.querySelector("#table tbody");
      thead.innerHTML = "<tr><th>select</th>" + columns.map(column => `<th data-column="${{column}}">${{column}}</th>`).join("") + "</tr>";
      tbody.innerHTML = rows.map(row => {{
        const id = candidateId(row);
        const cells = columns.map(column => {{
          const cls = ["curation_priority", "benchmark_status", "package_include", "formula_status", "candidate_y_status", "candidate_x_status"].includes(column) ? "small" : "";
          const value = ["curation_priority", "benchmark_status"].includes(column) ? pill(row[column]) : linkify(row[column], column);
          return `<td class="${{cls}}" title="${{String(row[column] || "").replaceAll('"', "&quot;")}}">${{value}}</td>`;
        }}).join("");
        return `<tr><td class="small"><input type="checkbox" data-id="${{id.replaceAll('"', "&quot;")}}" ${{checked.has(id) ? "checked" : ""}}></td>${{cells}}</tr>`;
      }}).join("");
      document.getElementById("visibleCount").textContent = rows.length;
      document.getElementById("selectedCount").textContent = checked.size;
      document.querySelectorAll("th[data-column]").forEach(th => {{
        th.addEventListener("click", () => {{
          const column = th.dataset.column;
          if (sortColumn === column) sortDirection *= -1;
          else {{
            sortColumn = column;
            sortDirection = 1;
          }}
          render();
        }});
      }});
      document.querySelectorAll("input[type=checkbox][data-id]").forEach(input => {{
        input.addEventListener("change", event => {{
          const id = event.target.dataset.id;
          if (event.target.checked) checked.add(id);
          else checked.delete(id);
          localStorage.setItem(stateKey, JSON.stringify([...checked]));
          document.getElementById("selectedCount").textContent = checked.size;
        }});
      }});
    }}

    function exportRows() {{
      const visible = filteredRows();
      const selectedVisible = visible.filter(row => checked.has(candidateId(row)));
      const rows = selectedVisible.length ? selectedVisible : visible;
      const outColumns = ["selected"].concat(columns);
      const escapeCsv = value => `"${{String(value || "").replaceAll('"', '""')}}"`;
      const csv = [
        outColumns.join(";"),
        ...rows.map(row => outColumns.map(column => column === "selected" ? (checked.has(candidateId(row)) ? "yes" : "no") : escapeCsv(row[column])).join(";"))
      ].join("\\n");
      const blob = new Blob([csv], {{type: "text/csv;charset=utf-8"}});
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = "paper_dataset_benchmark_candidates_selection.csv";
      a.click();
      URL.revokeObjectURL(url);
    }}

    fillSelect("priority", "curation_priority");
    fillSelect("status", "benchmark_status");
    fillSelect("package", "package_include");
    fillSelect("formula", "formula_status");
    Object.values(filters).forEach(input => input.addEventListener("input", render));
    document.getElementById("clear").addEventListener("click", () => {{
      Object.values(filters).forEach(input => input.value = "");
      render();
    }});
    document.getElementById("export").addEventListener("click", exportRows);
    render();
  </script>
</body>
</html>
"""
    path.write_text(html_text, encoding="utf-8")


def write_priority_review(
    path: Path,
    records: list[dict[str, Any]],
    priority: str,
    title: str,
    instructions: list[str],
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    selected = [row for row in records if clean(row.get("curation_priority")) == priority]
    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    lines = [
        "---",
        f'title: "{title}"',
        "type: analysis",
        "created: 2026-08-10",
        f"updated: {today}",
        "sources:",
        "  - tools/build_paper_dataset_curation_manifest.py",
        "tags: [papers, datasets, benchmark, curation]",
        "---",
        "",
        f"# {title}",
        "",
        f"Candidats `{priority}` : {len(selected)}",
        "",
        "## Regles de traitement",
        "",
    ]
    lines.extend(f"- {item}" for item in instructions)
    lines.extend([
        "",
        "## File de revue",
        "",
        "| dataset | paper | status | main gap | next step | evidence |",
        "|---|---|---|---|---|---|",
    ])
    for row in selected:
        lines.append(
            "| {dataset} | {paper} | {status} | {gap} | {next_step} | {evidence} |".format(
                dataset=clean(row.get("dataset_name"))[:90],
                paper=clean(row.get("paper_title"))[:90],
                status=clean(row.get("benchmark_status"))[:60],
                gap=clean(row.get("main_gap"))[:100],
                next_step=clean(row.get("required_next_step"))[:120],
                evidence=clean(row.get("evidence_sources"))[:100],
            )
        )
    lines.extend(["", "## Related Pages", "", "- [[paper_dataset_ingestion_pipeline_2026-08]]"])
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")

def build_manifest(repo_root: Path) -> list[dict[str, Any]]:
    rows: dict[str, dict[str, Any]] = {}
    audit_by_doi = load_audit_summary(repo_root)
    package_dataset_dois = load_package_dataset_dois(repo_root)
    add_package_metadata_rows(repo_root, rows, audit_by_doi)
    add_datacite_rows(repo_root, rows, audit_by_doi, package_dataset_dois)
    add_kg_dataset_use_rows(repo_root, rows, audit_by_doi, package_dataset_dois)
    add_audit_only_rows(rows, audit_by_doi)

    records = list(rows.values())
    priority_order = {"high": 0, "medium": 1, "low": 2}
    records.sort(key=lambda row: (priority_order.get(clean(row.get("curation_priority")), 9), clean(row.get("paper_title")), clean(row.get("dataset_name"))))
    return records


def load_records_from_json(path: Path) -> list[dict[str, Any]]:
    payload = read_json(path, {"records": []})
    records = payload.get("records", []) if isinstance(payload, dict) else []
    return [{column: clean(row.get(column)) for column in COLUMNS} for row in records]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path.cwd())
    parser.add_argument("--csv", type=Path, default=DEFAULT_OUTPUT_CSV)
    parser.add_argument("--json", type=Path, default=DEFAULT_OUTPUT_JSON)
    parser.add_argument("--report", type=Path, default=DEFAULT_OUTPUT_MD)
    parser.add_argument("--html", type=Path, default=DEFAULT_OUTPUT_HTML)
    parser.add_argument("--html-only", action="store_true", help="Generate only the interactive HTML from the existing JSON manifest.")
    parser.add_argument("--medium-review", type=Path, default=DEFAULT_MEDIUM_REVIEW_MD)
    parser.add_argument("--low-review", type=Path, default=DEFAULT_LOW_REVIEW_MD)
    args = parser.parse_args()

    repo_root = args.repo_root.resolve()
    if args.html_only:
        records = load_records_from_json(repo_root / args.json)
        write_interactive_html(repo_root / args.html, records, args.csv, args.json)
        print(f"HTML: {repo_root / args.html}")
        return

    records = build_manifest(repo_root)
    write_csv(repo_root / args.csv, records)
    write_json(repo_root / args.json, records)
    write_report(repo_root / args.report, records, args.csv, args.json)
    write_interactive_html(repo_root / args.html, records, args.csv, args.json)
    write_priority_review(
        repo_root / args.medium_review,
        records,
        "medium",
        "Medium Paper Dataset Candidates - Manual Review Queue",
        [
            "Verifier le DOI du dataset et le DOI de l article parent.",
            "Ouvrir le PDF/TEI et confirmer qu il existe une application empirique exploitable.",
            "Controler Y, X, coordonnees/geometrie et eventuelle matrice W.",
            "Telecharger et pretraiter seulement apres validation de ces preuves.",
            "Promouvoir en `high` uniquement si le dataset peut devenir benchmarkable.",
        ],
    )
    write_priority_review(
        repo_root / args.low_review,
        records,
        "low",
        "Low Paper Dataset Candidates - Deferred Archive",
        [
            "Ne pas ingerer automatiquement ces candidats.",
            "Les garder comme archive de recherche ou comme source secondaire.",
            "Les reconsiderer seulement si un domaine, un estimateur ou une source externe justifie une nouvelle passe.",
        ],
    )

    counts = Counter(clean(row.get("curation_priority")) for row in records)
    print(f"Candidats consolides: {len(records)}")
    for key in ["high", "medium", "low"]:
        print(f"  {key}: {counts.get(key, 0)}")
    print(f"CSV: {repo_root / args.csv}")
    print(f"JSON: {repo_root / args.json}")
    print(f"Report: {repo_root / args.report}")
    print(f"HTML: {repo_root / args.html}")
    print(f"Medium review: {repo_root / args.medium_review}")
    print(f"Low archive: {repo_root / args.low_review}")


if __name__ == "__main__":
    main()




