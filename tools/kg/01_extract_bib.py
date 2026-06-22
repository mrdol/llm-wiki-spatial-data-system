"""Extraire les references JabRef/BibTeX pour le KG.

Entree:
- corpus/bib/references.bib

Sorties:
- .kg/extracted/bib_nodes.jsonl
- .kg/extracted/bib_edges.jsonl

Le but est de transformer les notices JabRef en noeuds Paper stables.
Les champs kg_dataset et kg_method, s'ils existent, creent deja des
relations controlees vers Dataset et Method.
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
BIB_PATH = ROOT / "corpus" / "bib" / "references.bib"
OUT_DIR = ROOT / ".kg" / "extracted"
NODE_PATH = OUT_DIR / "bib_nodes.jsonl"
EDGE_PATH = OUT_DIR / "bib_edges.jsonl"


def norm_space(value: str) -> str:
    """Nettoie les espaces sans modifier le sens du texte."""
    return re.sub(r"\s+", " ", value or "").strip()


def slug(value: str) -> str:
    """Produit un identifiant lisible et stable pour les noeuds non DOI."""
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "_", value)
    return value.strip("_") or "unknown"


def clean_bib_value(value: str) -> str:
    """Retire les delimitateurs BibTeX simples autour d'une valeur."""
    value = norm_space(value)
    if len(value) >= 2 and value[0] in "{\"" and value[-1] in "}\"":
        value = value[1:-1]
    return norm_space(value)


def split_entries(text: str) -> list[tuple[str, str, str]]:
    """Separe grossierement les entrees BibTeX sans dependance externe."""
    entries: list[tuple[str, str, str]] = []
    index = 0
    while True:
        match = re.search(r"@(\w+)\s*\{\s*([^,\s]+)\s*,", text[index:], flags=re.IGNORECASE)
        if not match:
            break
        start = index + match.start()
        body_start = index + match.end()
        depth = 1
        pos = body_start
        while pos < len(text) and depth:
            char = text[pos]
            if char == "{":
                depth += 1
            elif char == "}":
                depth -= 1
            pos += 1
        entry_type = match.group(1)
        key = match.group(2)
        body = text[body_start : pos - 1]
        entries.append((entry_type, key, body))
        index = pos
    return entries


def parse_fields(body: str) -> dict[str, str]:
    """Lit les champs cle = valeur d'une entree BibTeX simple."""
    fields: dict[str, str] = {}
    pattern = re.compile(r"(\w+)\s*=\s*([{\"])", flags=re.IGNORECASE)
    pos = 0
    while True:
        match = pattern.search(body, pos)
        if not match:
            break
        key = match.group(1).lower()
        opener = match.group(2)
        value_start = match.end()
        if opener == "{":
            depth = 1
            cursor = value_start
            while cursor < len(body) and depth:
                if body[cursor] == "{":
                    depth += 1
                elif body[cursor] == "}":
                    depth -= 1
                cursor += 1
            value = body[value_start : cursor - 1]
        else:
            cursor = value_start
            while cursor < len(body) and body[cursor] != "\"":
                cursor += 1
            value = body[value_start:cursor]
            cursor += 1
        fields[key] = clean_bib_value(value)
        comma = body.find(",", cursor)
        pos = comma + 1 if comma != -1 else cursor
    return fields


def paper_id(fields: dict[str, str], key: str) -> str:
    """Utilise le DOI comme identifiant principal quand il existe."""
    doi = fields.get("doi", "").lower().replace("https://doi.org/", "").strip()
    if doi:
        return f"paper:doi:{doi}"
    return f"paper:bib:{slug(key)}"


def add_node(nodes: dict[str, dict[str, Any]], node_id: str, node_type: str, label: str, **props: Any) -> None:
    """Ajoute ou complete un noeud sans dupliquer son identifiant."""
    current = nodes.setdefault(node_id, {"id": node_id, "type": node_type, "label": label, "props": {}})
    current["label"] = current["label"] or label
    current["props"].update({key: value for key, value in props.items() if value not in ("", None, [])})


def add_edge(edges: dict[str, dict[str, Any]], source: str, relation: str, target: str, **props: Any) -> None:
    """Ajoute une relation orientee entre deux noeuds."""
    edge_id = f"{source}|{relation}|{target}"
    edges[edge_id] = {
        "id": edge_id,
        "source": source,
        "relation": relation,
        "target": target,
        "props": {key: value for key, value in props.items() if value not in ("", None, [])},
    }


def write_jsonl(path: Path, rows: list[dict[str, Any]]) -> None:
    """Ecrit une collection de dictionnaires en JSONL."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        for row in rows:
            fh.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")


def main() -> None:
    if not BIB_PATH.exists():
        raise FileNotFoundError(BIB_PATH)

    nodes: dict[str, dict[str, Any]] = {}
    edges: dict[str, dict[str, Any]] = {}
    text = BIB_PATH.read_text(encoding="utf-8")

    for entry_type, key, body in split_entries(text):
        fields = parse_fields(body)
        pid = paper_id(fields, key)
        title = fields.get("title") or key
        add_node(
            nodes,
            pid,
            "Paper",
            title,
            bib_key=key,
            entry_type=entry_type,
            doi=fields.get("doi"),
            year=fields.get("year"),
            journal=fields.get("journal"),
            authors=fields.get("author"),
            file=fields.get("file"),
            source="jabref",
        )

        for dataset in re.split(r"[;|]", fields.get("kg_dataset", "")):
            dataset = norm_space(dataset)
            if dataset:
                did = f"dataset:{slug(dataset)}"
                add_node(nodes, did, "Dataset", dataset, source="jabref")
                add_edge(edges, pid, "USES_DATASET", did, extraction_source="jabref", confidence=1.0)

        for method in re.split(r"[;|]", fields.get("kg_method", "")):
            method = norm_space(method)
            if method:
                mid = f"method:{slug(method)}"
                add_node(nodes, mid, "Method", method, source="jabref")
                add_edge(edges, pid, "MENTIONS_METHOD", mid, extraction_source="jabref", confidence=1.0)

    write_jsonl(NODE_PATH, sorted(nodes.values(), key=lambda row: row["id"]))
    write_jsonl(EDGE_PATH, sorted(edges.values(), key=lambda row: row["id"]))

    print(f"BibTeX entries: {len([row for row in nodes.values() if row['type'] == 'Paper'])}")
    print(f"nodes={NODE_PATH}")
    print(f"edges={EDGE_PATH}")


if __name__ == "__main__":
    main()
