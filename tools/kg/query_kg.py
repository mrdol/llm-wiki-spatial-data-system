"""Interroger le KG local.

Exemples:
  python tools/kg/query_kg.py --list-papers
  python tools/kg/query_kg.py --paper-doi 10.1080/13658816.2013.865739
  python tools/kg/query_kg.py --node-type Formula
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


def main() -> None:
    parser = argparse.ArgumentParser(description="Query local KG SQLite database.")
    parser.add_argument("--list-papers", action="store_true")
    parser.add_argument("--node-type")
    parser.add_argument("--paper-doi")
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
        else:
            print(f"KG database path: {GRAPH_DB}")


if __name__ == "__main__":
    main()
