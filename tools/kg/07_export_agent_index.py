"""Interface agent pour interroger le KG local.

Commandes:
  python tools/kg/07_export_agent_index.py stats
  python tools/kg/07_export_agent_index.py search "GWR"
  python tools/kg/07_export_agent_index.py explain "dataset:r:spdep:columbus"
  python tools/kg/07_export_agent_index.py neighbors "paper:doi:10.1080/13658816.2013.865739" 2
  python tools/kg/07_export_agent_index.py papers-for-dataset "LondonHP"
  python tools/kg/07_export_agent_index.py formulas-for "GWR"
"""

from __future__ import annotations

import argparse
import json
import sqlite3
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
DB = ROOT / ".kg" / "graph.sqlite"
SUMMARIES = ROOT / ".kg" / "summaries"


def props(text: str) -> dict[str, Any]:
    """Decode les proprietes JSON."""
    try:
        return json.loads(text or "{}")
    except json.JSONDecodeError:
        return {}


def connect() -> sqlite3.Connection:
    """Ouvre la base KG."""
    if not DB.exists():
        raise SystemExit("KG database not found. Run python tools/kg/run_all.py first.")
    con = sqlite3.connect(DB)
    con.row_factory = sqlite3.Row
    return con


def resolve_node(con: sqlite3.Connection, query: str) -> str | None:
    """Resout un identifiant exact ou une recherche par label."""
    row = con.execute("SELECT id FROM nodes WHERE id = ?", (query,)).fetchone()
    if row:
        return row["id"]
    q = f"%{query}%"
    row = con.execute(
        "SELECT id FROM nodes WHERE label LIKE ? OR id LIKE ? ORDER BY label LIMIT 1",
        (q, q),
    ).fetchone()
    return row["id"] if row else None


def print_node(row: sqlite3.Row | None) -> None:
    """Affiche un noeud."""
    if not row:
        print("Node not found.")
        return
    p = props(row["props_json"])
    print(f"# {row['label']}")
    print(f"- id: `{row['id']}`")
    print(f"- type: `{row['type']}`")
    for key in ("doi", "year", "package", "dataset", "source", "file", "tei_file", "pdf_file", "url"):
        if p.get(key):
            print(f"- {key}: {p[key]}")
    summary = p.get("abstract") or p.get("description") or p.get("text_preview") or p.get("formula_text")
    if summary:
        print("\n## Summary")
        print(str(summary)[:1600])


def cmd_stats(args: argparse.Namespace) -> None:
    """Affiche les stats du graphe."""
    con = connect()
    print("# KG Stats")
    for table in ("nodes", "edges"):
        print(f"- {table}: {con.execute(f'SELECT COUNT(*) FROM {table}').fetchone()[0]}")
    print("\n## Node types")
    for row in con.execute("SELECT type, COUNT(*) AS n FROM nodes GROUP BY type ORDER BY n DESC"):
        print(f"- {row['type']}: {row['n']}")
    print("\n## Relations")
    for row in con.execute("SELECT relation, COUNT(*) AS n FROM edges GROUP BY relation ORDER BY n DESC"):
        print(f"- {row['relation']}: {row['n']}")


def cmd_search(args: argparse.Namespace) -> None:
    """Recherche dans id, label et props JSON."""
    con = connect()
    q = f"%{args.query}%"
    rows = con.execute(
        """
        SELECT id, type, label, props_json
        FROM nodes
        WHERE id LIKE ? OR label LIKE ? OR props_json LIKE ?
        ORDER BY
          CASE type
            WHEN 'Dataset' THEN 1
            WHEN 'Paper' THEN 2
            WHEN 'Method' THEN 3
            WHEN 'Formula' THEN 4
            ELSE 5
          END,
          label
        LIMIT ?
        """,
        (q, q, q, args.limit),
    ).fetchall()
    print(f"# Search: {args.query}")
    if not rows:
        print("- no result")
        return
    for row in rows:
        p = props(row["props_json"])
        detail = p.get("doi") or p.get("package") or p.get("source") or ""
        print(f"- `{row['id']}` ({row['type']}) {row['label']} {detail}")


def cmd_explain(args: argparse.Namespace) -> None:
    """Explique un noeud et ses relations."""
    con = connect()
    node_id = resolve_node(con, args.node)
    if not node_id:
        print("Node not found.")
        return
    row = con.execute("SELECT * FROM nodes WHERE id = ?", (node_id,)).fetchone()
    print_node(row)

    print("\n## Outgoing")
    rows = con.execute(
        """
        SELECT e.relation, e.target, n.type, n.label
        FROM edges e LEFT JOIN nodes n ON n.id = e.target
        WHERE e.source = ?
        ORDER BY e.relation, n.label
        LIMIT ?
        """,
        (node_id, args.limit),
    ).fetchall()
    for r in rows:
        print(f"- {r['relation']}: `{r['target']}` ({r['type']}) {r['label']}")
    if not rows:
        print("- none")

    print("\n## Incoming")
    rows = con.execute(
        """
        SELECT e.relation, e.source, n.type, n.label
        FROM edges e LEFT JOIN nodes n ON n.id = e.source
        WHERE e.target = ?
        ORDER BY e.relation, n.label
        LIMIT ?
        """,
        (node_id, args.limit),
    ).fetchall()
    for r in rows:
        print(f"- {r['relation']}: `{r['source']}` ({r['type']}) {r['label']}")
    if not rows:
        print("- none")


def cmd_neighbors(args: argparse.Namespace) -> None:
    """Liste le voisinage non oriente d'un noeud."""
    con = connect()
    node_id = resolve_node(con, args.node)
    if not node_id:
        print("Node not found.")
        return
    seen = {node_id}
    frontier = {node_id}
    for _ in range(args.depth):
        new: set[str] = set()
        for nid in frontier:
            for row in con.execute("SELECT target AS id FROM edges WHERE source = ? UNION SELECT source AS id FROM edges WHERE target = ?", (nid, nid)):
                new.add(row["id"])
        frontier = new - seen
        seen |= new

    print(f"# Neighbors: {node_id} depth={args.depth}")
    for nid in sorted(seen):
        row = con.execute("SELECT id, type, label FROM nodes WHERE id = ?", (nid,)).fetchone()
        if row:
            print(f"- `{row['id']}` ({row['type']}) {row['label']}")
        else:
            print(f"- `{nid}`")


def cmd_papers_for_dataset(args: argparse.Namespace) -> None:
    """Trouve les papiers lies a un dataset."""
    con = connect()
    q = f"%{args.dataset}%"
    datasets = con.execute("SELECT id, label FROM nodes WHERE type = 'Dataset' AND (id LIKE ? OR label LIKE ?)", (q, q)).fetchall()
    print(f"# Papers for dataset: {args.dataset}")
    if not datasets:
        print("- no dataset match")
        return
    for ds in datasets[: args.limit]:
        print(f"\n## {ds['label']} (`{ds['id']}`)")
        rows = con.execute(
            """
            SELECT e.source, n.label, n.props_json
            FROM edges e JOIN nodes n ON n.id = e.source
            WHERE e.target = ? AND e.relation = 'USES_DATASET' AND n.type = 'Paper'
            ORDER BY n.label
            LIMIT ?
            """,
            (ds["id"], args.limit),
        ).fetchall()
        for r in rows:
            p = props(r["props_json"])
            doi = f" doi:{p.get('doi')}" if p.get("doi") else ""
            print(f"- `{r['source']}` {r['label']}{doi}")
        if not rows:
            print("- no paper relation")


def cmd_formulas_for(args: argparse.Namespace) -> None:
    """Cherche des formules liees a un terme."""
    con = connect()
    q = f"%{args.query}%"
    rows = con.execute(
        """
        SELECT id, label, props_json
        FROM nodes
        WHERE type = 'Formula' AND (label LIKE ? OR props_json LIKE ?)
        LIMIT ?
        """,
        (q, q, args.limit),
    ).fetchall()
    print(f"# Formulas for: {args.query}")
    if not rows:
        print("- no formula found")
        return
    for r in rows:
        p = props(r["props_json"])
        print(f"\n## `{r['id']}`")
        print(p.get("formula_text") or r["label"])


def main() -> None:
    parser = argparse.ArgumentParser(description="Query llm-wiki KG.")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("stats")
    p.set_defaults(func=cmd_stats)

    p = sub.add_parser("search")
    p.add_argument("query")
    p.add_argument("--limit", type=int, default=30)
    p.set_defaults(func=cmd_search)

    p = sub.add_parser("explain")
    p.add_argument("node")
    p.add_argument("--limit", type=int, default=40)
    p.set_defaults(func=cmd_explain)

    p = sub.add_parser("neighbors")
    p.add_argument("node")
    p.add_argument("depth", nargs="?", type=int, default=2)
    p.set_defaults(func=cmd_neighbors)

    p = sub.add_parser("papers-for-dataset")
    p.add_argument("dataset")
    p.add_argument("--limit", type=int, default=20)
    p.set_defaults(func=cmd_papers_for_dataset)

    p = sub.add_parser("formulas-for")
    p.add_argument("query")
    p.add_argument("--limit", type=int, default=20)
    p.set_defaults(func=cmd_formulas_for)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
