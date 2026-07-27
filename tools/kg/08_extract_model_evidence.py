"""Exporter les preuves dataset-estimateur vers le KG.

Entree:
- packages/spatialtidymodels/inst/metadata/datasets.json

Sorties:
- .kg/extracted/model_evidence_nodes.jsonl
- .kg/extracted/model_evidence_edges.jsonl

Cette passerelle rend interrogeables les liens fins du type:
dataset Columbus -> estimateur SAR lag -> source Anselin 1988 -> pages/tables.
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
DATASETS_JSON = ROOT / "packages" / "spatialtidymodels" / "inst" / "metadata" / "datasets.json"
OUT_DIR = ROOT / ".kg" / "extracted"
NODE_PATH = OUT_DIR / "model_evidence_nodes.jsonl"
EDGE_PATH = OUT_DIR / "model_evidence_edges.jsonl"


def slug(value: str) -> str:
    """Transforme un libelle en fragment stable d'identifiant KG."""
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "_", value)
    return value.strip("_") or "unknown"


def node(node_id: str, node_type: str, label: str, props: dict[str, Any] | None = None) -> dict[str, Any]:
    """Construit un noeud KG JSONL."""
    return {"id": node_id, "type": node_type, "label": label, "props": props or {}}


def edge(source: str, relation: str, target: str, props: dict[str, Any] | None = None) -> dict[str, Any]:
    """Construit une relation KG JSONL."""
    return {
        "id": f"{source}|{relation}|{target}",
        "source": source,
        "relation": relation,
        "target": target,
        "props": props or {},
    }


def read_dataset_records() -> list[dict[str, Any]]:
    """Lit les records dataset exportes pour le package."""
    payload = json.loads(DATASETS_JSON.read_text(encoding="utf-8"))
    return payload.get("records", [])


def write_jsonl(path: Path, rows: list[dict[str, Any]]) -> None:
    """Ecrit une liste de dictionnaires en JSONL UTF-8."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as fh:
        for row in rows:
            fh.write(json.dumps(row, ensure_ascii=False) + "\n")


def build_model_evidence() -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Construit les noeuds et relations de preuves modele-dataset."""
    nodes: dict[str, dict[str, Any]] = {}
    edges: dict[str, dict[str, Any]] = {}

    for dataset in read_dataset_records():
        dataset_name = dataset.get("dataset")
        if not dataset_name:
            continue
        dataset_id = f"dataset:spatialtidymodels:{slug(dataset_name)}"
        nodes[dataset_id] = node(
            dataset_id,
            "Dataset",
            dataset_name,
            {
                "dataset_id": dataset.get("dataset_id"),
                "formula": dataset.get("formula"),
                "source_ref": dataset.get("source_ref"),
                "wiki_path": dataset.get("wiki_path"),
            },
        )

        for item in dataset.get("estimator_evidence") or []:
            estimator = item.get("estimator")
            if not estimator:
                continue
            estimator_id = f"estimator:spatialtidymodels:{slug(estimator)}"
            evidence_id = f"model_evidence:{slug(dataset_name)}:{slug(estimator)}"
            source_ref = item.get("source_ref")
            paper_id = f"paper_ref:{slug(source_ref)}" if source_ref else None

            nodes[estimator_id] = node(estimator_id, "Estimator", estimator)
            nodes[evidence_id] = node(
                evidence_id,
                "ModelEvidence",
                f"{dataset_name} -> {estimator}",
                {
                    "dataset": dataset_name,
                    "estimator": estimator,
                    "basis": item.get("basis"),
                    "source_ref": source_ref,
                    "pages": item.get("pages"),
                    "pdf_pages": item.get("pdf_pages"),
                    "tables": item.get("tables") or [],
                    "notes": item.get("notes"),
                    "formula": dataset.get("formula"),
                },
            )

            edges[f"{dataset_id}|HAS_MODEL_EVIDENCE|{evidence_id}"] = edge(
                dataset_id, "HAS_MODEL_EVIDENCE", evidence_id
            )
            edges[f"{evidence_id}|EVALUATES_ESTIMATOR|{estimator_id}"] = edge(
                evidence_id, "EVALUATES_ESTIMATOR", estimator_id
            )
            if paper_id:
                nodes[paper_id] = node(paper_id, "PaperReference", source_ref)
                edges[f"{evidence_id}|SUPPORTED_BY_SOURCE|{paper_id}"] = edge(
                    evidence_id, "SUPPORTED_BY_SOURCE", paper_id
                )

    return list(nodes.values()), list(edges.values())


def main() -> None:
    nodes, edges = build_model_evidence()
    write_jsonl(NODE_PATH, nodes)
    write_jsonl(EDGE_PATH, edges)
    print(f"nodes={len(nodes)}")
    print(f"edges={len(edges)}")
    print(f"wrote={NODE_PATH}")
    print(f"wrote={EDGE_PATH}")


if __name__ == "__main__":
    main()
