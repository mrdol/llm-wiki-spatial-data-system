"""Interroger le KG local.

Exemples:
  python tools/kg/query_kg.py --list-papers
  python tools/kg/query_kg.py --paper-doi 10.1080/13658816.2013.865739
  python tools/kg/query_kg.py --node-type Formula
  python tools/kg/query_kg.py --dataset-evidence columbus_crime
  python tools/kg/query_kg.py --paper-dataset-uses 10.1007/s10109-025-00481-4
  python tools/kg/query_kg.py --paper-dataset-gaps
"""

from __future__ import annotations

import argparse
import json
import sqlite3
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
GRAPH_DB = ROOT / ".kg" / "graph.sqlite"


def props(text: str) -> dict:
    """Decode les proprietes JSON stockees en SQLite."""
    return json.loads(text or "{}")


def list_papers(con: sqlite3.Connection) -> None:
    """Affiche les papiers presents dans le KG."""
    for row in con.execute("SELECT id, label, props_json FROM nodes WHERE type = 'Paper' ORDER BY label"):
        data = props(row[2])
        print(f"{row[0]}\t{data.get('doi', '')}\t{row[1]}")


def list_node_type(con: sqlite3.Connection, node_type: str) -> None:
    """Affiche les noeuds d'un type donne."""
    for row in con.execute("SELECT id, label FROM nodes WHERE type = ? ORDER BY label", (node_type,)):
        print(f"{row[0]}\t{row[1]}")


def describe_paper(con: sqlite3.Connection, doi: str) -> None:
    """Affiche les relations principales d'un papier par DOI."""
    paper_id = f"paper:doi:{doi.lower().replace('https://doi.org/', '').strip()}"
    row = con.execute("SELECT label, props_json FROM nodes WHERE id = ?", (paper_id,)).fetchone()
    if not row:
        raise SystemExit(f"Paper not found: {paper_id}")
    print(f"Paper: {row[0]}")
    data = props(row[1])
    for key in ("doi", "published", "journal", "file", "pdf_file", "tei_file"):
        if data.get(key):
            print(f"{key}: {data[key]}")
    print("")
    for edge in con.execute(
        """
        SELECT e.relation, n.type, n.label, e.props_json
        FROM edges e
        JOIN nodes n ON n.id = e.target
        WHERE e.source = ?
        ORDER BY e.relation, n.label
        """,
        (paper_id,),
    ):
        edge_props = props(edge[3])
        detail = f" confidence={edge_props.get('confidence')}" if edge_props.get("confidence") else ""
        print(f"{edge[0]}\t{edge[1]}\t{edge[2]}{detail}")


def dataset_model_evidence(con: sqlite3.Connection, dataset: str) -> None:
    """Affiche les preuves dataset-estimateur disponibles dans le KG."""
    dataset_id = f"dataset:spatialtidymodels:{dataset.lower().replace('-', '_')}"
    row = con.execute("SELECT label, props_json FROM nodes WHERE id = ?", (dataset_id,)).fetchone()
    if not row:
        raise SystemExit(f"Dataset evidence node not found: {dataset_id}")

    data = props(row[1])
    print(f"Dataset: {row[0]}")
    if data.get("formula"):
        print(f"formula: {data['formula']}")
    if data.get("wiki_path"):
        print(f"wiki_path: {data['wiki_path']}")
    print("")

    rows = con.execute(
        """
        SELECT n.label, n.props_json
        FROM edges e
        JOIN nodes n ON n.id = e.target
        WHERE e.source = ? AND e.relation = 'HAS_MODEL_EVIDENCE'
        ORDER BY json_extract(n.props_json, '$.basis'), json_extract(n.props_json, '$.estimator')
        """,
        (dataset_id,),
    ).fetchall()

    for label, props_json in rows:
        item = props(props_json)
        print(f"- {item.get('estimator')}: {item.get('basis')}")
        if item.get("source_ref"):
            print(f"  source: {item['source_ref']}")
        if item.get("pages") or item.get("pdf_pages"):
            print(f"  pages: {item.get('pages', '')} ; pdf_pages: {item.get('pdf_pages', '')}")
        if item.get("tables"):
            print(f"  tables: {', '.join(item['tables'])}")
        if item.get("notes"):
            print(f"  notes: {item['notes']}")


def paper_dataset_uses(con: sqlite3.Connection, doi: str) -> None:
    """Affiche les usages dataset verifies ou a valider pour un papier."""
    paper_id = f"paper:doi:{doi.lower().replace('https://doi.org/', '').strip()}"
    row = con.execute("SELECT label FROM nodes WHERE id = ?", (paper_id,)).fetchone()
    if not row:
        raise SystemExit(f"Paper not found: {paper_id}")
    print(f"Paper: {row[0]}")
    print("")
    rows = con.execute(
        """
        SELECT n.id, n.label, n.props_json
        FROM edges e
        JOIN nodes n ON n.id = e.target
        WHERE e.source = ? AND e.relation = 'HAS_PAPER_DATASET_USE'
        ORDER BY json_extract(n.props_json, '$.dataset_name_in_paper')
        """,
        (paper_id,),
    ).fetchall()
    if not rows:
        print("No PaperDatasetUse nodes found.")
        return
    for _, _, props_json in rows:
        item = props(props_json)
        dataset_name = item.get("dataset_name_in_paper") or item.get("dataset") or ""
        status = item.get("ingestion_status") or item.get("status") or ""
        print(f"- {dataset_name}: {status}")
        print(f"  theme: {item.get('theme', '')}; n={item.get('n_observations', '')}; covariates={item.get('n_covariates', '')}")
        print(f"  source: {item.get('source_ref', '')}")
        print(f"  target: {item.get('canonical_dataset_id') or item.get('dataset_target', '')}")


def paper_dataset_gaps(con: sqlite3.Connection) -> None:
    """Liste les usages de datasets spatiaux non encore ingeres."""
    rows = con.execute(
        """
        SELECT p.label, u.props_json
        FROM nodes u
        JOIN edges e ON e.target = u.id AND e.relation = 'HAS_PAPER_DATASET_USE'
        JOIN nodes p ON p.id = e.source
        WHERE u.type = 'PaperDatasetUse'
          AND coalesce(json_extract(u.props_json, '$.ingestion_status'), '') <> 'ingested'
          AND coalesce(json_extract(u.props_json, '$.source_ref'), '') <> ''
        ORDER BY p.label, json_extract(u.props_json, '$.dataset_name_in_paper')
        """
    ).fetchall()
    if not rows:
        print("No non-ingested PaperDatasetUse nodes found.")
        return
    current_paper = None
    for paper_label, props_json in rows:
        item = props(props_json)
        if paper_label != current_paper:
            current_paper = paper_label
            print("")
            print(f"Paper: {paper_label}")
            if item.get("paper_doi"):
                print(f"DOI: {item['paper_doi']}")
        print(
            "- {dataset} | {status} | n={n} | covariates={k} | source={source}".format(
                dataset=item.get("dataset_name_in_paper", ""),
                status=item.get("ingestion_status", ""),
                n=item.get("n_observations", ""),
                k=item.get("n_covariates", ""),
                source=item.get("source_ref", ""),
            )
        )


def main() -> None:
    parser = argparse.ArgumentParser(description="Query local KG SQLite database.")
    parser.add_argument("--list-papers", action="store_true")
    parser.add_argument("--node-type")
    parser.add_argument("--paper-doi")
    parser.add_argument("--dataset-evidence")
    parser.add_argument("--paper-dataset-uses")
    parser.add_argument("--paper-dataset-gaps", action="store_true")
    args = parser.parse_args()

    if not GRAPH_DB.exists():
        raise FileNotFoundError(GRAPH_DB)

    with sqlite3.connect(GRAPH_DB) as con:
        if args.list_papers:
            list_papers(con)
        elif args.node_type:
            list_node_type(con, args.node_type)
        elif args.paper_doi:
            describe_paper(con, args.paper_doi)
        elif args.dataset_evidence:
            dataset_model_evidence(con, args.dataset_evidence)
        elif args.paper_dataset_uses:
            paper_dataset_uses(con, args.paper_dataset_uses)
        elif args.paper_dataset_gaps:
            paper_dataset_gaps(con)
        else:
            print(f"KG database path: {GRAPH_DB}")


if __name__ == "__main__":
    main()
