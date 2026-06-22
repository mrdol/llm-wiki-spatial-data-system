"""Generer des resumes compacts du KG pour l'agent.

Entree:
- .kg/graph.sqlite

Sorties:
- .kg/summaries/corpus.md
- .kg/summaries/papers.md
- .kg/summaries/datasets.md
- .kg/summaries/packages.md
- .kg/summaries/methods.md
- .kg/summaries/formulas.md
- .kg/summaries/source_families.md
"""

from __future__ import annotations

import json
import sqlite3
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
KG_DIR = ROOT / ".kg"
DB = KG_DIR / "graph.sqlite"
SUMMARY_DIR = KG_DIR / "summaries"


def props(text: str) -> dict[str, Any]:
    """Decode les proprietes JSON."""
    try:
        return json.loads(text or "{}")
    except json.JSONDecodeError:
        return {}


def rows(con: sqlite3.Connection, sql: str, params: tuple[Any, ...] = ()) -> list[sqlite3.Row]:
    """Retourne des lignes SQLite en mode dict."""
    return list(con.execute(sql, params))


def write_summary(name: str, lines: list[str]) -> None:
    """Ecrit un resume Markdown."""
    SUMMARY_DIR.mkdir(parents=True, exist_ok=True)
    (SUMMARY_DIR / name).write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def count_by(con: sqlite3.Connection, table: str, field: str) -> list[str]:
    """Produit des lignes de comptage par type/relation."""
    return [
        f"- {name}: {count}"
        for name, count in con.execute(
            f"SELECT {field}, COUNT(*) FROM {table} GROUP BY {field} ORDER BY COUNT(*) DESC"
        )
    ]


def label_lines(con: sqlite3.Connection, node_type: str, limit: int = 40) -> list[str]:
    """Liste compacte de noeuds."""
    out: list[str] = []
    for node_id, label, props_json in con.execute(
        "SELECT id, label, props_json FROM nodes WHERE type = ? ORDER BY label LIMIT ?",
        (node_type, limit),
    ):
        p = props(props_json)
        suffix = ""
        if p.get("doi"):
            suffix = f" doi:{p['doi']}"
        elif p.get("package"):
            suffix = f" package:{p['package']}"
        out.append(f"- `{node_id}` {label}{suffix}")
    return out or ["- none"]


def make_corpus(con: sqlite3.Connection) -> None:
    """Resume global du corpus KG."""
    n_nodes = con.execute("SELECT COUNT(*) FROM nodes").fetchone()[0]
    n_edges = con.execute("SELECT COUNT(*) FROM edges").fetchone()[0]
    write_summary(
        "corpus.md",
        [
            "# KG Corpus Summary",
            "",
            f"- nodes: {n_nodes}",
            f"- edges: {n_edges}",
            "",
            "## Node Types",
            *count_by(con, "nodes", "type"),
            "",
            "## Edge Relations",
            *count_by(con, "edges", "relation"),
            "",
            "## Recommended Order",
            "1. Use `07_export_agent_index.py search <topic>`.",
            "2. Use `07_export_agent_index.py explain <node>`.",
            "3. Use `07_export_agent_index.py neighbors <node> 2`.",
            "4. Open corpus/wiki files only after graph inspection.",
        ],
    )


def make_type_summary(con: sqlite3.Connection, filename: str, title: str, node_types: list[str]) -> None:
    """Resume par types de noeuds."""
    lines = [f"# {title}", ""]
    for node_type in node_types:
        count = con.execute("SELECT COUNT(*) FROM nodes WHERE type = ?", (node_type,)).fetchone()[0]
        lines.extend([f"## {node_type}", "", f"- count: {count}", "", *label_lines(con, node_type), ""])
    write_summary(filename, lines)


def main() -> None:
    if not DB.exists():
        raise FileNotFoundError(DB)
    con = sqlite3.connect(DB)
    con.row_factory = sqlite3.Row
    make_corpus(con)
    make_type_summary(con, "papers.md", "Papers", ["Paper"])
    make_type_summary(con, "datasets.md", "Datasets And Variables", ["Dataset", "ResponseVariable", "Covariate", "CoordinateVariable", "GeometryColumn", "AuxiliaryFile"])
    make_type_summary(con, "packages.md", "Packages", ["RPackage", "PythonPackage"])
    make_type_summary(con, "methods.md", "Methods", ["Method", "Concept"])
    make_type_summary(con, "formulas.md", "Formulas", ["Formula"])
    make_type_summary(con, "source_families.md", "Sources", ["SourceFamily", "WebSource", "DocumentationPage"])
    print(f"summaries={SUMMARY_DIR}")


if __name__ == "__main__":
    main()
