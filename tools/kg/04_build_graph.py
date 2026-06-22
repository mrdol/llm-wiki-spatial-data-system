"""Construire le knowledge graph local en SQLite.

Entrees:
- .kg/extracted/*_nodes.jsonl
- .kg/extracted/*_edges.jsonl

Sortie:
- .kg/graph.sqlite

SQLite est utilise comme premier support robuste: il ne demande pas de
dependance externe et permet deja les requetes de controle.
"""

from __future__ import annotations

import json
import sqlite3
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
KG_DIR = ROOT / ".kg"
EXTRACTED_DIR = KG_DIR / "extracted"
GRAPH_DB = KG_DIR / "graph.sqlite"


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    """Lit un fichier JSONL s'il existe."""
    if not path.exists():
        return []
    rows: list[dict[str, Any]] = []
    with path.open(encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    return rows


def collect_rows(pattern: str) -> list[dict[str, Any]]:
    """Collecte les lignes extraites par les passerelles amont."""
    rows: list[dict[str, Any]] = []
    for path in sorted(EXTRACTED_DIR.glob(pattern)):
        rows.extend(read_jsonl(path))
    return rows


def merge_nodes(rows: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    """Fusionne les noeuds qui partagent le meme identifiant."""
    nodes: dict[str, dict[str, Any]] = {}
    for row in rows:
        node_id = row["id"]
        current = nodes.setdefault(
            node_id,
            {"id": node_id, "type": row.get("type", ""), "label": row.get("label", ""), "props": {}},
        )
        current["type"] = current["type"] or row.get("type", "")
        current["label"] = current["label"] or row.get("label", "")
        current["props"].update(row.get("props") or {})
    return nodes


def merge_edges(rows: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    """Fusionne les relations identiques source-relation-cible."""
    edges: dict[str, dict[str, Any]] = {}
    for row in rows:
        edge_id = row.get("id") or f"{row['source']}|{row['relation']}|{row['target']}"
        current = edges.setdefault(
            edge_id,
            {
                "id": edge_id,
                "source": row["source"],
                "relation": row["relation"],
                "target": row["target"],
                "props": {},
            },
        )
        current["props"].update(row.get("props") or {})
    return edges


def write_sqlite(nodes: dict[str, dict[str, Any]], edges: dict[str, dict[str, Any]]) -> None:
    """Ecrit les noeuds et relations dans graph.sqlite."""
    KG_DIR.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(GRAPH_DB) as con:
        con.execute("PRAGMA foreign_keys = OFF")
        con.execute("DROP TABLE IF EXISTS nodes")
        con.execute("DROP TABLE IF EXISTS edges")
        con.execute(
            """
            CREATE TABLE nodes (
                id TEXT PRIMARY KEY,
                type TEXT NOT NULL,
                label TEXT NOT NULL,
                props_json TEXT NOT NULL
            )
            """
        )
        con.execute(
            """
            CREATE TABLE edges (
                id TEXT PRIMARY KEY,
                source TEXT NOT NULL,
                relation TEXT NOT NULL,
                target TEXT NOT NULL,
                props_json TEXT NOT NULL
            )
            """
        )
        con.executemany(
            "INSERT INTO nodes (id, type, label, props_json) VALUES (?, ?, ?, ?)",
            [
                (row["id"], row["type"], row["label"], json.dumps(row.get("props") or {}, ensure_ascii=False))
                for row in sorted(nodes.values(), key=lambda item: item["id"])
            ],
        )
        con.executemany(
            "INSERT INTO edges (id, source, relation, target, props_json) VALUES (?, ?, ?, ?, ?)",
            [
                (
                    row["id"],
                    row["source"],
                    row["relation"],
                    row["target"],
                    json.dumps(row.get("props") or {}, ensure_ascii=False),
                )
                for row in sorted(edges.values(), key=lambda item: item["id"])
            ],
        )
        con.execute("CREATE INDEX idx_nodes_type ON nodes(type)")
        con.execute("CREATE INDEX idx_edges_source ON edges(source)")
        con.execute("CREATE INDEX idx_edges_target ON edges(target)")
        con.execute("CREATE INDEX idx_edges_relation ON edges(relation)")


def main() -> None:
    KG_DIR.mkdir(parents=True, exist_ok=True)
    node_rows = collect_rows("*_nodes.jsonl")
    edge_rows = collect_rows("*_edges.jsonl")
    nodes = merge_nodes(node_rows)
    edges = merge_edges(edge_rows)
    write_sqlite(nodes, edges)

    print(f"nodes={len(nodes)}")
    print(f"edges={len(edges)}")
    print(f"graph={GRAPH_DB}")


if __name__ == "__main__":
    main()
