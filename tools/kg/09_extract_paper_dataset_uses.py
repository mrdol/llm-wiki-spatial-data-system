"""Exporter les usages papier-dataset valides ou a valider vers le KG.

Entree:
- inst/kg/paper_dataset_uses.json

Sorties:
- .kg/extracted/paper_dataset_use_nodes.jsonl
- .kg/extracted/paper_dataset_use_edges.jsonl
- wiki/analyses/paper_dataset_ingestion_gaps_2026-07.md

Cette etape separe les vrais usages papier-dataset des simples mentions TEI.
Un usage valide devient PaperDatasetUse; il peut pointer vers un Dataset deja
ingere, un DatasetCatalogRecord a reconcilier, ou un DatasetCandidate a importer.
"""

from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from datetime import date
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from audit_reader import audit_candidate_kind, confidence_from_audit, read_model_evidence_audit, validation_status

MANIFEST = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
OUT_DIR = ROOT / ".kg" / "extracted"
NODE_PATH = OUT_DIR / "paper_dataset_use_nodes.jsonl"
EDGE_PATH = OUT_DIR / "paper_dataset_use_edges.jsonl"
REPORT_PATH = ROOT / "wiki" / "analyses" / "paper_dataset_ingestion_gaps_2026-07.md"
REPORT_CREATED = "2026-07-27"


def slug(value: str) -> str:
    """Transforme un libelle en fragment stable d'identifiant KG."""
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "_", value)
    return value.strip("_") or "unknown"


def node(node_id: str, node_type: str, label: str, props: dict[str, Any] | None = None) -> dict[str, Any]:
    """Construit un noeud KG."""
    return {"id": node_id, "type": node_type, "label": label, "props": props or {}}


def edge(source: str, relation: str, target: str, props: dict[str, Any] | None = None) -> dict[str, Any]:
    """Construit une relation KG."""
    return {
        "id": f"{source}|{relation}|{target}",
        "source": source,
        "relation": relation,
        "target": target,
        "props": props or {},
    }


def read_records() -> list[dict[str, Any]]:
    """Lit les usages papier-dataset curés."""
    if not MANIFEST.exists():
        return []
    payload = json.loads(MANIFEST.read_text(encoding="utf-8"))
    return payload.get("records", [])


def write_jsonl(path: Path, rows: list[dict[str, Any]]) -> None:
    """Ecrit des lignes JSONL UTF-8."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as fh:
        for row in rows:
            fh.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")


def build_graph_rows(records: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Construit les noeuds et relations PaperDatasetUse."""
    nodes: dict[str, dict[str, Any]] = {}
    edges: dict[str, dict[str, Any]] = {}

    for record in records:
        paper_id = record["paper_id"]
        dataset_name = record["dataset_name_in_paper"]
        target_id = record["canonical_dataset_id"]
        use_id = f"paper_dataset_use:{slug(paper_id)}:{slug(dataset_name)}"
        status = record.get("ingestion_status", "unknown")
        target_type = record.get("target_type", "DatasetCandidate")
        confidence = record.get("confidence", "unknown")

        nodes[paper_id] = node(
            paper_id,
            "Paper",
            record.get("paper_title") or paper_id,
            {
                "doi": record.get("paper_doi"),
                "bib_key": record.get("bib_key"),
                "source": "paper_dataset_use_manifest",
            },
        )
        nodes[target_id] = node(
            target_id,
            target_type,
            dataset_name,
            {
                "dataset_name_in_paper": dataset_name,
                "source_ref": record.get("source_ref"),
                "source_url": record.get("source_url"),
                "ingestion_status": status,
                "source": "paper_dataset_use_manifest",
            },
        )
        nodes[use_id] = node(
            use_id,
            "PaperDatasetUse",
            f"{record.get('paper_title', paper_id)} -> {dataset_name}",
            {
                key: value
                for key, value in record.items()
                if value not in (None, "", [])
            },
        )
        edges[f"{paper_id}|HAS_PAPER_DATASET_USE|{use_id}"] = edge(
            paper_id,
            "HAS_PAPER_DATASET_USE",
            use_id,
            {"source": "paper_dataset_use_manifest", "confidence": confidence},
        )
        relation = "RESOLVES_TO_DATASET" if status == "ingested" else "CANDIDATE_DATASET_USE"
        edges[f"{use_id}|{relation}|{target_id}"] = edge(
            use_id,
            relation,
            target_id,
            {"source": "paper_dataset_use_manifest", "status": status},
        )

        for estimator in record.get("estimators_used") or []:
            method_id = f"method:{slug(estimator)}"
            nodes[method_id] = node(method_id, "Method", estimator, {"source": "paper_dataset_use_manifest"})
            edges[f"{use_id}|MENTIONS_METHOD|{method_id}"] = edge(
                use_id,
                "MENTIONS_METHOD",
                method_id,
                {"source": "paper_dataset_use_manifest"},
            )

    add_audit_dataset_use_candidates(nodes, edges)
    return list(nodes.values()), list(edges.values())


def add_audit_dataset_use_candidates(
    nodes: dict[str, dict[str, Any]],
    edges: dict[str, dict[str, Any]],
) -> None:
    """Expose les signaux audit qui peuvent devenir des usages papier-dataset.

    L'audit ne nomme pas toujours un dataset canonique. On cree donc des
    PaperDatasetUseCandidate a relire, sans les relier a un Dataset confirme.
    """
    accepted_kinds = {"DataSourceCandidate", "VariableTableCandidate"}
    for index, row in enumerate(read_model_evidence_audit(), start=1):
        kind = audit_candidate_kind(row)
        priority_score = int(row.get("priority_score_int") or 0)
        if kind not in accepted_kinds or priority_score < 45:
            continue

        paper_id = row.get("paper_id") or f"paper:audit:{index}"
        status = validation_status(row)
        candidate_id = f"paper_dataset_use_candidate:audit:{slug(paper_id)}:{slug(row.get('section_id') or 'section')}:{index}"
        dataset_candidate_id = f"dataset_candidate:audit:{slug(paper_id)}:{slug(row.get('section_id') or 'section')}:{index}"

        nodes[paper_id] = node(
            paper_id,
            "Paper",
            row.get("paper_title") or paper_id,
            {
                "doi": row.get("doi"),
                "source": "model_evidence_audit",
            },
        )
        nodes[dataset_candidate_id] = node(
            dataset_candidate_id,
            "DatasetCandidate",
            row.get("table_caption") or row.get("section_title") or "Dataset candidate from TEI audit",
            {
                "candidate_status": status,
                "candidate_source": "model_evidence_audit",
                "section_role": row.get("section_role"),
                "section_title": row.get("section_title"),
                "candidate_text": row.get("candidate_text"),
                "tei_file": row.get("tei_file"),
            },
        )
        nodes[candidate_id] = node(
            candidate_id,
            "PaperDatasetUseCandidate",
            f"{row.get('paper_title') or paper_id} -> dataset candidate",
            {
                "status": status,
                "confidence": confidence_from_audit(row),
                "section_id": row.get("section_id"),
                "section_title": row.get("section_title"),
                "section_role": row.get("section_role"),
                "priority_score": row.get("priority_score"),
                "evidence_type": row.get("evidence_type"),
                "candidate_text": row.get("candidate_text"),
                "table_caption": row.get("table_caption"),
                "needs_manual_review": row.get("needs_manual_review"),
                "audit_reason": row.get("audit_reason"),
                "tei_file": row.get("tei_file"),
                "source": "model_evidence_audit",
            },
        )
        edges[f"{paper_id}|HAS_PAPER_DATASET_USE_CANDIDATE|{candidate_id}"] = edge(
            paper_id,
            "HAS_PAPER_DATASET_USE_CANDIDATE",
            candidate_id,
            {"source": "model_evidence_audit", "status": status},
        )
        edges[f"{candidate_id}|CANDIDATE_DATASET_USE|{dataset_candidate_id}"] = edge(
            candidate_id,
            "CANDIDATE_DATASET_USE",
            dataset_candidate_id,
            {"source": "model_evidence_audit", "status": status},
        )


def write_gap_report(records: list[dict[str, Any]]) -> None:
    """Ecrit la liste des jeux spatiaux mentionnes par papier et non ingeres."""
    by_paper: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for record in records:
        if record.get("ingestion_status") != "ingested":
            by_paper[record.get("paper_title") or record["paper_id"]].append(record)

    lines = [
        "---",
        "title: Papiers du corpus avec datasets spatiaux non encore ingérés",
        "type: metadata",
        f"created: {REPORT_CREATED}",
        f"updated: {date.today().isoformat()}",
        "sources: [inst/kg/paper_dataset_uses.json]",
        "tags: [metadata, kg, papers, datasets, ingestion, gaps]",
        "---",
        "",
        "# Papiers du corpus avec datasets spatiaux non encore ingérés",
        "",
        f"Date : {REPORT_CREATED}",
        "",
        "Cette liste est issue des usages papier-dataset curés dans `inst/kg/paper_dataset_uses.json`.",
        "Elle ne reprend pas les simples cooccurrences TEI non validées.",
        "",
    ]
    if not by_paper:
        lines.append("Aucun dataset non ingéré dans le manifeste curé actuel.")
    for paper_title, paper_records in sorted(by_paper.items()):
        first = paper_records[0]
        lines.extend(
            [
                f"## {paper_title}",
                "",
                f"- DOI papier : `{first.get('paper_doi') or 'non renseigné'}`",
                f"- BibTeX key : `{first.get('bib_key') or 'non renseigné'}`",
                "",
                "| Dataset | Statut | Thème | n | Covariables | Source | Pourquoi il reste à faire |",
                "|---|---|---|---:|---:|---|---|",
            ]
        )
        for record in paper_records:
            lines.append(
                "| {dataset} | `{status}` | {theme} | {n} | {k} | {source} | {reason} |".format(
                    dataset=record.get("dataset_name_in_paper", ""),
                    status=record.get("ingestion_status", ""),
                    theme=record.get("theme", ""),
                    n=record.get("n_observations", ""),
                    k=record.get("n_covariates", ""),
                    source=record.get("source_ref", ""),
                    reason=record.get("evidence", "").replace("|", "/"),
                )
            )
        lines.append("")

    lines.extend(
        [
            "## Related Pages",
            "",
            "- [[paper_dataset_ingestion_pipeline_2026-08]]",
            "- [[model_evidence_candidates_review_2026-08]]",
        ]
    )

    REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
    REPORT_PATH.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8", newline="\n")


def main() -> None:
    records = read_records()
    nodes, edges = build_graph_rows(records)
    write_jsonl(NODE_PATH, nodes)
    write_jsonl(EDGE_PATH, edges)
    write_gap_report(records)
    print(f"records={len(records)}")
    print(f"nodes={NODE_PATH}")
    print(f"edges={EDGE_PATH}")
    print(f"report={REPORT_PATH}")


if __name__ == "__main__":
    main()
