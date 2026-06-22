"""Extraire les concepts declares dans inst/kg/concepts.yml vers le KG.

Entree:
- inst/kg/concepts.yml

Sorties:
- .kg/extracted/concept_nodes.jsonl
- .kg/extracted/concept_edges.jsonl

Le parseur reste volontairement simple pour eviter une dependance YAML: il lit
les champs utilises par le projet (`label`, `aliases`, `wiki_page`).
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
CONCEPTS_PATH = ROOT / "inst" / "kg" / "concepts.yml"
OUT_DIR = ROOT / ".kg" / "extracted"
NODE_PATH = OUT_DIR / "concept_nodes.jsonl"
EDGE_PATH = OUT_DIR / "concept_edges.jsonl"


def norm_space(value: Any) -> str:
    """Nettoie une valeur textuelle."""
    return re.sub(r"\s+", " ", str(value or "")).strip()


def slug(value: Any) -> str:
    """Construit un fragment d'identifiant stable."""
    text = norm_space(value).lower()
    text = re.sub(r"[^a-z0-9]+", "_", text)
    return text.strip("_") or "unknown"


def parse_concepts() -> list[dict[str, Any]]:
    """Lit les concepts depuis concepts.yml sans dependance externe."""
    if not CONCEPTS_PATH.exists():
        return []

    concepts: list[dict[str, Any]] = []
    current: dict[str, Any] | None = None
    in_aliases = False

    for raw_line in CONCEPTS_PATH.read_text(encoding="utf-8").splitlines():
        line = raw_line.rstrip()
        concept_match = re.match(r"\s{2}([A-Za-z0-9_]+):\s*$", line)
        if concept_match:
            if current:
                concepts.append(current)
            key = concept_match.group(1)
            current = {"key": key, "label": key, "aliases": [], "wiki_page": ""}
            in_aliases = False
            continue

        if current is None:
            continue

        label_match = re.match(r"\s+label:\s*(.+?)\s*$", line)
        if label_match:
            current["label"] = norm_space(label_match.group(1))
            in_aliases = False
            continue

        wiki_match = re.match(r"\s+wiki_page:\s*(.+?)\s*$", line)
        if wiki_match:
            current["wiki_page"] = norm_space(wiki_match.group(1))
            in_aliases = False
            continue

        if re.match(r"\s+aliases:\s*$", line):
            in_aliases = True
            continue

        alias_match = re.match(r"\s+-\s*(.+?)\s*$", line)
        if in_aliases and alias_match:
            current["aliases"].append(norm_space(alias_match.group(1)))

    if current:
        concepts.append(current)
    return concepts


def write_jsonl(path: Path, rows: list[dict[str, Any]]) -> None:
    """Ecrit des lignes JSONL."""
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as fh:
        for row in rows:
            fh.write(json.dumps(row, ensure_ascii=False) + "\n")


def main() -> None:
    nodes: list[dict[str, Any]] = []
    edges: list[dict[str, Any]] = []

    for concept in parse_concepts():
        concept_id = f"concept:{slug(concept['key'])}"
        nodes.append(
            {
                "id": concept_id,
                "type": "Concept",
                "label": concept["label"],
                "props": {
                    "key": concept["key"],
                    "aliases": concept["aliases"],
                    "source": str(CONCEPTS_PATH.relative_to(ROOT)),
                },
            }
        )

        wiki_page = concept.get("wiki_page") or ""
        if wiki_page:
            page_id = f"wikipage:{slug(wiki_page)}"
            nodes.append(
                {
                    "id": page_id,
                    "type": "WikiPage",
                    "label": wiki_page,
                    "props": {"path": wiki_page, "source": "concepts.yml"},
                }
            )
            edges.append(
                {
                    "source": concept_id,
                    "relation": "DOCUMENTED_BY",
                    "target": page_id,
                    "props": {"source": "concepts.yml"},
                }
            )

    write_jsonl(NODE_PATH, nodes)
    write_jsonl(EDGE_PATH, edges)
    print(f"concept nodes={len(nodes)}")
    print(f"concept edges={len(edges)}")
    print(f"nodes={NODE_PATH}")
    print(f"edges={EDGE_PATH}")


if __name__ == "__main__":
    main()
