"""Extraire les fiches Markdown de corpus/web_md vers le KG.

Entree:
- corpus/web_md/*.md
- corpus/web_md/*.Rmd

Sorties:
- .kg/extracted/web_nodes.jsonl
- .kg/extracted/web_edges.jsonl
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[2]
WEB_DIR = ROOT / "corpus" / "web_md"
CONCEPTS_PATH = ROOT / "inst" / "kg" / "concepts.yml"
OUT_DIR = ROOT / ".kg" / "extracted"
NODE_PATH = OUT_DIR / "web_nodes.jsonl"
EDGE_PATH = OUT_DIR / "web_edges.jsonl"

PACKAGE_NAMES = {
    "sf": "RPackage",
    "terra": "RPackage",
    "stars": "RPackage",
    "spdep": "RPackage",
    "spatialreg": "RPackage",
    "GWmodel": "RPackage",
    "GWmodel3": "RPackage",
    "spData": "RPackage",
    "spDataLarge": "RPackage",
    "mgcv": "RPackage",
    "INLA": "RPackage",
    "spatstat": "RPackage",
    "gstat": "RPackage",
    "mgwr": "PythonPackage",
    "PySAL": "PythonPackage",
    "geopandas": "PythonPackage",
}

METHOD_ALIASES = {
    "Geographically Weighted Regression": ["gwr", "geographically weighted regression"],
    "Multiscale Geographically Weighted Regression": ["mgwr", "multiscale geographically weighted"],
    "Geographically and Temporally Weighted Regression": ["gtwr", "geographically and temporally weighted"],
    "Spatial regression": ["spatial regression", "spatial lag", "spatial error", "spatial durbin"],
    "Spatial autocorrelation": ["moran", "lisa", "spatial autocorrelation"],
    "GAM": ["gam", "generalized additive model", "smoother", "tensor product"],
    "Kriging": ["kriging", "variogram", "geostatistics"],
    "Point process": ["point process", "conditional intensity"],
    "Disease mapping": ["disease mapping", "epidemiology", "inla"],
}


def norm_space(value: Any) -> str:
    """Nettoie les espaces."""
    return re.sub(r"\s+", " ", str(value or "")).strip()


def slug(value: Any) -> str:
    """Construit un identifiant stable."""
    text = norm_space(value).lower()
    text = re.sub(r"[^a-z0-9]+", "_", text)
    return text.strip("_") or "unknown"


def add_node(nodes: dict[str, dict[str, Any]], node_id: str, node_type: str, label: str, **props: Any) -> None:
    """Ajoute ou complete un noeud."""
    current = nodes.setdefault(node_id, {"id": node_id, "type": node_type, "label": label, "props": {}})
    current["label"] = current["label"] or label
    current["props"].update({k: v for k, v in props.items() if v not in ("", None, [], {})})


def add_edge(edges: dict[str, dict[str, Any]], source: str, relation: str, target: str, **props: Any) -> None:
    """Ajoute une relation."""
    edge_id = f"{source}|{relation}|{target}"
    edges[edge_id] = {
        "id": edge_id,
        "source": source,
        "relation": relation,
        "target": target,
        "props": {k: v for k, v in props.items() if v not in ("", None, [], {})},
    }


def first_heading(text: str, fallback: str) -> str:
    """Retourne le premier titre Markdown."""
    match = re.search(r"(?m)^#\s+(.+)$", text)
    return norm_space(match.group(1)) if match else fallback


def urls(text: str) -> list[str]:
    """Extrait les URLs presentes dans une fiche."""
    return sorted(set(re.findall(r"https?://[^\s)>\]]+", text)))


def section_bullets(text: str, section_name: str) -> list[str]:
    """Lit les puces d'une section Markdown simple."""
    match = re.search(rf"(?ims)^##\s+{re.escape(section_name)}\s*\n(.*?)(?=^##\s+|\Z)", text)
    if not match:
        return []
    body = match.group(1)
    return [norm_space(m.group(1)) for m in re.finditer(r"(?m)^\s*[-*]\s+(.+)$", body)]


def formula_lines(text: str) -> list[str]:
    """Detecte des lignes contenant des formules R simples."""
    out: list[str] = []
    for line in text.splitlines():
        clean = norm_space(line)
        if "~" in clean and len(clean) <= 220:
            out.append(clean.strip("`"))
    return sorted(set(out))


def detect_methods(text: str) -> list[tuple[str, str]]:
    """Detecte les methodes par alias."""
    lowered = text.lower()
    hits: list[tuple[str, str]] = []
    for label, aliases in METHOD_ALIASES.items():
        for alias in aliases:
            if re.search(r"(?<![a-z0-9_])" + re.escape(alias.lower()) + r"(?![a-z0-9_])", lowered):
                hits.append((label, alias))
                break
    return hits


def detect_packages(text: str) -> list[tuple[str, str]]:
    """Detecte les packages R/Python cites dans une fiche."""
    hits: list[tuple[str, str]] = []
    for package, node_type in PACKAGE_NAMES.items():
        if re.search(r"(?<![A-Za-z0-9_])" + re.escape(package) + r"(?![A-Za-z0-9_])", text):
            hits.append((package, node_type))
    return hits


def package_dataset_id(dataset_ref: str) -> str:
    """Associe Package::dataset au meme identifiant que le catalogue R."""
    package, dataset = dataset_ref.split("::", 1)
    return f"dataset:r:{slug(package)}:{slug(dataset)}"


def process_file(path: Path, nodes: dict[str, dict[str, Any]], edges: dict[str, dict[str, Any]]) -> None:
    """Convertit une fiche web_md en noeuds et relations."""
    text = path.read_text(encoding="utf-8", errors="ignore")
    title = first_heading(text, path.stem)
    sid = f"websource:{slug(path.stem)}"
    source_urls = urls(text)

    add_node(
        nodes,
        sid,
        "WebSource",
        title,
        source="corpus_web_md",
        file=str(path.relative_to(ROOT)),
        urls=source_urls,
        topics=section_bullets(text, "Topics"),
        extraction_targets=section_bullets(text, "Extraction Targets"),
    )

    fid = "source_family:web_documentation"
    add_node(nodes, fid, "SourceFamily", "web_documentation", source="corpus_web_md")
    add_edge(edges, sid, "BELONGS_TO_SOURCE_FAMILY", fid, extraction_source="web_md")

    for url in source_urls:
        uid = f"documentationpage:{slug(url)}"
        add_node(nodes, uid, "DocumentationPage", url, url=url, source="corpus_web_md")
        add_edge(edges, sid, "DOCUMENTED_BY", uid, extraction_source="web_md")

    for label, alias in detect_methods(text):
        mid = f"method:{slug(label)}"
        add_node(nodes, mid, "Method", label, matched_alias=alias, source="web_md")
        add_edge(edges, sid, "MENTIONS_METHOD", mid, matched_alias=alias, extraction_source="web_md")

    for package, node_type in detect_packages(text):
        pid = f"{node_type.lower()}:{slug(package)}"
        add_node(nodes, pid, node_type, package, source="web_md")
        add_edge(edges, sid, "DOCUMENTS_PACKAGE", pid, extraction_source="web_md")

    for formula in formula_lines(text):
        fid = f"formula:web:{slug(path.stem)}:{slug(formula[:80])}"
        add_node(nodes, fid, "Formula", formula, formula_text=formula, source="web_md", file=str(path.relative_to(ROOT)))
        add_edge(edges, sid, "SHOWS_FORMULA", fid, extraction_source="web_md")

    for dataset in sorted(set(re.findall(r"\b[A-Za-z][A-Za-z0-9_.]*::[A-Za-z][A-Za-z0-9_.]*\b", text))):
        did = package_dataset_id(dataset)
        package, dataset_name = dataset.split("::", 1)
        add_node(nodes, did, "Dataset", dataset, web_source="web_md", package=package, dataset=dataset_name)
        add_edge(edges, sid, "USES_DATASET", did, extraction_source="web_md")


def write_jsonl(path: Path, rows: Iterable[dict[str, Any]]) -> None:
    """Ecrit les lignes JSONL."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        for row in rows:
            fh.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")


def main() -> None:
    nodes: dict[str, dict[str, Any]] = {}
    edges: dict[str, dict[str, Any]] = {}
    files = sorted(list(WEB_DIR.glob("*.md")) + list(WEB_DIR.glob("*.Rmd")))
    for path in files:
        process_file(path, nodes, edges)

    write_jsonl(NODE_PATH, sorted(nodes.values(), key=lambda r: r["id"]))
    write_jsonl(EDGE_PATH, sorted(edges.values(), key=lambda r: r["id"]))
    print(f"web files={len(files)}")
    print(f"web nodes={len(nodes)}")
    print(f"web edges={len(edges)}")
    print(f"nodes={NODE_PATH}")
    print(f"edges={EDGE_PATH}")


if __name__ == "__main__":
    main()
