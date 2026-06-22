"""Extraire les catalogues datasets software vers le KG.

Entrees lues de facon tolerante:
- data/manifests/datasets/software_r_*.jsonl
- data/manifests/datasets/software_python_*.jsonl
- data/manifests/datasets/software_*catalog*.csv
- data/manifests/datasets/software_dataset_literature_links.jsonl
- data/manifests/datasets/software_r_dataset_paper_formula_audit*.csv

Sorties:
- .kg/extracted/catalog_nodes.jsonl
- .kg/extracted/catalog_edges.jsonl

Cette couche complete GROBID: elle ajoute les packages, datasets, variables,
coordonnees, geometries, fichiers auxiliaires et liens papier-dataset connus
dans les catalogues.
"""

from __future__ import annotations

import csv
import json
import re
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[2]
DATASET_DIR = ROOT / "data" / "manifests" / "datasets"
OUT_DIR = ROOT / ".kg" / "extracted"
NODE_PATH = OUT_DIR / "catalog_nodes.jsonl"
EDGE_PATH = OUT_DIR / "catalog_edges.jsonl"

CATALOG_PATTERNS = [
    "software_r_priority_datasets.jsonl",
    "software_r_extracted_datasets.jsonl",
    "software_r_dataset_inventory.jsonl",
    "software_python_priority_datasets.jsonl",
    "software_python_extracted_datasets.jsonl",
    "software_python_dataset_inventory.jsonl",
    "software_catalog_curated_final.csv",
    "software_r_catalog_main_datasets.csv",
    "software_python_catalog_all.csv",
]
LITERATURE_LINKS = "software_dataset_literature_links.jsonl"
AUDIT_LINK_PATTERNS = [
    "software_r_dataset_paper_formula_audit_verified.csv",
    "software_r_dataset_paper_formula_audit.csv",
]


def norm_space(value: Any) -> str:
    """Nettoie une valeur textuelle sans supposer son type."""
    if value is None:
        return ""
    if isinstance(value, (list, tuple)):
        return ", ".join(norm_space(v) for v in value if norm_space(v))
    return re.sub(r"\s+", " ", str(value)).strip()


def slug(value: Any) -> str:
    """Construit un fragment d'identifiant KG stable."""
    text = norm_space(value).lower()
    text = re.sub(r"[^a-z0-9]+", "_", text)
    return text.strip("_") or "unknown"


def add_node(nodes: dict[str, dict[str, Any]], node_id: str, node_type: str, label: str, **props: Any) -> None:
    """Ajoute ou complete un noeud."""
    current = nodes.setdefault(node_id, {"id": node_id, "type": node_type, "label": label, "props": {}})
    current["label"] = current["label"] or label
    current["props"].update({k: v for k, v in props.items() if v not in ("", None, [], {})})


def add_edge(edges: dict[str, dict[str, Any]], source: str, relation: str, target: str, **props: Any) -> None:
    """Ajoute une relation dedupliquee."""
    edge_id = f"{source}|{relation}|{target}"
    edges[edge_id] = {
        "id": edge_id,
        "source": source,
        "relation": relation,
        "target": target,
        "props": {k: v for k, v in props.items() if v not in ("", None, [], {})},
    }


def read_jsonl(path: Path) -> Iterable[dict[str, Any]]:
    """Lit un JSONL en ignorant les lignes vides ou invalides."""
    if not path.exists():
        return []
    rows: list[dict[str, Any]] = []
    with path.open(encoding="utf-8", errors="ignore") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                rows.append(json.loads(line))
            except json.JSONDecodeError:
                continue
    return rows


def sniff_delimiter(path: Path) -> str:
    """Detecte grossierement le separateur CSV."""
    sample = path.read_text(encoding="utf-8-sig", errors="ignore")[:4096]
    return ";" if sample.count(";") > sample.count(",") else ","


def read_csv(path: Path) -> Iterable[dict[str, Any]]:
    """Lit un CSV avec detection simple du separateur."""
    if not path.exists():
        return []
    with path.open(encoding="utf-8-sig", errors="ignore", newline="") as fh:
        reader = csv.DictReader(fh, delimiter=sniff_delimiter(path))
        return list(reader)


def row_value(row: dict[str, Any], *keys: str) -> str:
    """Retourne la premiere valeur non vide parmi plusieurs noms de champs."""
    lowered = {k.lower(): v for k, v in row.items()}
    for key in keys:
        if key in row and norm_space(row.get(key)):
            return norm_space(row.get(key))
        if key.lower() in lowered and norm_space(lowered.get(key.lower())):
            return norm_space(lowered.get(key.lower()))
    return ""


def parse_listish(value: Any) -> list[str]:
    """Transforme listes JSON ou chaines en liste courte de valeurs."""
    if value is None:
        return []
    if isinstance(value, list):
        return [norm_space(v) for v in value if norm_space(v)]
    text = norm_space(value)
    if not text or text.upper() == "NA":
        return []
    if text.startswith("[") and text.endswith("]"):
        try:
            parsed = json.loads(text.replace("'", '"'))
            if isinstance(parsed, list):
                return [norm_space(v) for v in parsed if norm_space(v)]
        except Exception:
            pass
    return [v for v in (norm_space(x) for x in re.split(r"[;,|]", text)) if v]


def variable_type(name: str) -> str:
    """Classe une variable selon son nom."""
    n = name.lower()
    if n in {"geometry", "geom", "shape"} or "geometry" in n:
        return "GeometryColumn"
    if re.search(r"\b(lat|latitude|lon|long|longitude|xcoord|ycoord|easting|northing|coord)\b", n):
        return "CoordinateVariable"
    if re.search(r"\b(date|time|year|month|day|period|timestamp)\b", n):
        return "TimeVariable"
    if re.search(r"\b(id|code|geoid|fips|name|label|uri)\b", n):
        return "IdentifierVariable"
    return "Variable"


def dataset_id(language: str, package: str, dataset: str) -> str:
    """Construit l'identifiant d'un dataset software."""
    prefix = "dataset"
    if package and dataset:
        return f"{prefix}:{slug(language)}:{slug(package)}:{slug(dataset)}"
    return f"{prefix}:{slug(language)}:{slug(dataset or package)}"


def package_node_type(language: str) -> str:
    """Choisit RPackage ou PythonPackage."""
    return "PythonPackage" if language.lower().startswith("python") else "RPackage"


def add_source_family(nodes: dict[str, dict[str, Any]], edges: dict[str, dict[str, Any]], source: str, family: str) -> None:
    """Ajoute le noeud famille de source et sa relation."""
    if not family:
        return
    fid = f"source_family:{slug(family)}"
    add_node(nodes, fid, "SourceFamily", family, source="catalog")
    add_edge(edges, source, "BELONGS_TO_SOURCE_FAMILY", fid, extraction_source="catalog")


def process_dataset_row(
    row: dict[str, Any],
    source_file: str,
    nodes: dict[str, dict[str, Any]],
    edges: dict[str, dict[str, Any]],
) -> None:
    """Convertit une ligne de catalogue software en noeuds KG."""
    language = row_value(row, "source_language", "language")
    package = row_value(row, "package", "source_package", "import_name", "pip_name")
    dataset = row_value(row, "dataset", "main_object", "dataset_key", "name", "bundle")
    if not dataset and not package:
        return
    if not language:
        language = "Python" if row_value(row, "pip_name", "import_name", "dataset_key") else "R"

    did = dataset_id(language, package, dataset)
    label = f"{package}::{dataset}" if package and dataset else dataset or package
    add_node(
        nodes,
        did,
        "Dataset",
        label,
        source="software_catalog",
        source_file=source_file,
        language=language,
        package=package,
        dataset=dataset,
        description=row_value(row, "description", "description_bundle"),
        family=row_value(row, "family"),
        download_status=row_value(row, "download_status"),
        local_csv=row_value(row, "local_csv"),
        local_geojson=row_value(row, "local_geojson"),
        url=row_value(row, "url", "download_url", "source"),
        n=row_value(row, "n", "nrows", "rows"),
        k=row_value(row, "k", "ncols", "columns"),
    )

    add_source_family(nodes, edges, did, row_value(row, "source_family") or "software")

    if package:
        ptype = package_node_type(language)
        pid = f"{ptype.lower()}:{slug(package)}"
        add_node(nodes, pid, ptype, package, source="software_catalog", language=language)
        add_edge(edges, pid, "PROVIDES_DATASET", did, extraction_source=source_file)

    for raw_var in parse_listish(row.get("columns_preview")) + parse_listish(row.get("variables")):
        vtype = variable_type(raw_var)
        vid = f"{vtype.lower()}:{slug(label)}:{slug(raw_var)}"
        add_node(nodes, vid, vtype, raw_var, source="software_catalog", dataset=label)
        relation = {
            "CoordinateVariable": "HAS_COORDINATE",
            "GeometryColumn": "HAS_GEOMETRY",
            "TimeVariable": "HAS_TIME",
            "IdentifierVariable": "HAS_IDENTIFIER",
        }.get(vtype, "HAS_VARIABLE")
        add_edge(edges, did, relation, vid, extraction_source=source_file)

    for y in parse_listish(row.get("y")):
        vid = f"responsevariable:{slug(label)}:{slug(y)}"
        add_node(nodes, vid, "ResponseVariable", y, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_RESPONSE", vid, extraction_source=source_file)

    for x in parse_listish(row.get("x")):
        vid = f"covariate:{slug(label)}:{slug(x)}"
        add_node(nodes, vid, "Covariate", x, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_COVARIATE", vid, extraction_source=source_file)

    geometry_type = row_value(row, "geometry_type", "has_geom")
    if geometry_type and geometry_type.upper() != "NA":
        gid = f"geometrycolumn:{slug(label)}:{slug(geometry_type)}"
        add_node(nodes, gid, "GeometryColumn", geometry_type, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_GEOMETRY", gid, extraction_source=source_file)

    for aux in parse_listish(row.get("auxiliary_files")):
        aid = f"auxiliaryfile:{slug(label)}:{slug(aux)}"
        add_node(nodes, aid, "AuxiliaryFile", aux, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_AUXILIARY_FILE", aid, extraction_source=source_file)

    url = row_value(row, "url", "download_url", "source")
    if url.startswith("http"):
        uid = f"documentationpage:{slug(url)}"
        add_node(nodes, uid, "DocumentationPage", url, url=url, source="software_catalog")
        add_edge(edges, did, "DOCUMENTED_BY", uid, extraction_source=source_file)


def process_literature_link(
    row: dict[str, Any],
    source_file: str,
    nodes: dict[str, dict[str, Any]],
    edges: dict[str, dict[str, Any]],
) -> None:
    """Ajoute les liens papier-dataset issus du catalogue de litterature."""
    dataset = row_value(row, "dataset")
    title = row_value(row, "paper_title", "title")
    doi = row_value(row, "paper_doi", "doi").replace("https://doi.org/", "")
    if not dataset or not title:
        return

    did = f"dataset:literature:{slug(dataset)}"
    add_node(nodes, did, "Dataset", dataset, source="literature_link_catalog")
    add_source_family(nodes, edges, did, "scientific_literature")

    pid = f"paper:doi:{doi.lower()}" if doi else f"paper:literature:{slug(title)}"
    add_node(
        nodes,
        pid,
        "Paper",
        title,
        source="literature_link_catalog",
        doi=doi,
        year=row_value(row, "paper_year"),
        venue=row_value(row, "venue"),
        openalex_id=row_value(row, "openalex_id"),
        is_oa=row.get("is_oa"),
        oa_url=row_value(row, "oa_url"),
    )
    add_edge(edges, pid, "USES_DATASET", did, extraction_source=source_file, query=row_value(row, "query"))


def repair_formula_text(formula: str) -> str:
    """Nettoie une formule issue d'un champ d'audit manuel."""
    formula = norm_space(formula)
    formula = re.sub(r"\s*~\s*", " ~ ", formula)
    formula = re.sub(r"\s*\+\s*", " + ", formula)
    formula = re.sub(r"\(\s*1\s*\|\s*", "(1|", formula)
    if formula.startswith("lmer("):
        missing = formula.count("(") - formula.count(")")
        if missing > 0:
            formula += ")" * missing
    return norm_space(formula)


def split_audit_formulas(value: str) -> list[str]:
    """Separe plusieurs formules stockees dans une meme cellule d'audit."""
    text = norm_space(value)
    if not text:
        return []
    parts = re.split(r"\s+\|\s+(?=(?:[A-Za-z_][A-Za-z0-9_.]*\s*~|[A-Za-z_][A-Za-z0-9_.]*\s*\())", text)
    formulas: list[str] = []
    for part in parts:
        formula = repair_formula_text(part)
        if "~" not in formula:
            continue
        if formula not in formulas:
            formulas.append(formula)
    return formulas or [repair_formula_text(text)]


def process_audit_link(
    row: dict[str, Any],
    source_file: str,
    nodes: dict[str, dict[str, Any]],
    edges: dict[str, dict[str, Any]],
) -> None:
    """Ajoute les liens dataset-papier-documentation issus de l'audit manuel."""
    package = row_value(row, "package")
    dataset = row_value(row, "dataset")
    if not dataset:
        return

    did = dataset_id("R", package, dataset)
    label = f"{package}::{dataset}" if package else dataset
    add_node(nodes, did, "Dataset", label, source="dataset_paper_formula_audit", package=package, dataset=dataset)
    add_source_family(nodes, edges, did, "software")

    doc_path = row_value(row, "doc_path")
    source_url = row_value(row, "source_url", "doi_url")
    if doc_path:
        doc_id = f"documentationpage:{slug(doc_path)}"
        add_node(nodes, doc_id, "DocumentationPage", doc_path, source="dataset_paper_formula_audit", file=doc_path)
        add_edge(edges, did, "DOCUMENTED_BY", doc_id, extraction_source=source_file)
    if source_url.startswith("http"):
        doc_id = f"documentationpage:{slug(source_url)}"
        add_node(nodes, doc_id, "DocumentationPage", source_url, source="dataset_paper_formula_audit", url=source_url)
        add_edge(edges, did, "DOCUMENTED_BY", doc_id, extraction_source=source_file)

    title = row_value(row, "paper_or_book_title", "title")
    doi = row_value(row, "doi").replace("https://doi.org/", "")
    if title or doi:
        pid = f"paper:doi:{doi.lower()}" if doi else f"paper:audit:{slug(package)}:{slug(dataset)}:{slug(title)}"
        add_node(
            nodes,
            pid,
            "Paper",
            title or doi,
            source="dataset_paper_formula_audit",
            doi=doi,
            doi_url=row_value(row, "doi_url"),
            doi_verified=row_value(row, "doi_verified"),
            doi_type=row_value(row, "doi_type"),
            authors=row_value(row, "authors"),
            year=row_value(row, "year"),
            venue=row_value(row, "venue"),
            publisher=row_value(row, "publisher"),
            local_raw_match=row_value(row, "local_raw_match"),
        )
        add_edge(edges, pid, "USES_DATASET", did, extraction_source=source_file)

        formula_text = row_value(row, "model_or_equation_found_locally")
        if formula_text:
            for index, formula in enumerate(split_audit_formulas(formula_text), start=1):
                fid = f"formula:audit:{slug(package)}:{slug(dataset)}:{slug(formula)[:96]}"
                add_node(
                    nodes,
                    fid,
                    "Formula",
                    formula,
                    source="dataset_paper_formula_audit",
                    dataset=label,
                    package=package,
                    formula_text=formula,
                    formula_group=formula_text,
                    formula_index=index,
                    model_keywords=row_value(row, "model_keywords"),
                )
                add_edge(edges, pid, "SHOWS_FORMULA", fid, extraction_source=source_file)
                add_edge(edges, did, "SHOWS_FORMULA", fid, extraction_source=source_file)


def write_jsonl(path: Path, rows: Iterable[dict[str, Any]]) -> None:
    """Ecrit des lignes JSONL."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        for row in rows:
            fh.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")


def main() -> None:
    nodes: dict[str, dict[str, Any]] = {}
    edges: dict[str, dict[str, Any]] = {}

    for name in CATALOG_PATTERNS:
        path = DATASET_DIR / name
        if not path.exists():
            continue
        rows = read_jsonl(path) if path.suffix == ".jsonl" else read_csv(path)
        for row in rows:
            process_dataset_row(row, name, nodes, edges)

    links_path = DATASET_DIR / LITERATURE_LINKS
    for row in read_jsonl(links_path):
        process_literature_link(row, LITERATURE_LINKS, nodes, edges)

    seen_audit_rows: set[tuple[str, str, str, str]] = set()
    for name in AUDIT_LINK_PATTERNS:
        path = DATASET_DIR / name
        if not path.exists():
            continue
        for row in read_csv(path):
            key = (
                row_value(row, "package"),
                row_value(row, "dataset"),
                row_value(row, "doi"),
                row_value(row, "source_url"),
            )
            if key in seen_audit_rows:
                continue
            seen_audit_rows.add(key)
            process_audit_link(row, name, nodes, edges)

    write_jsonl(NODE_PATH, sorted(nodes.values(), key=lambda r: r["id"]))
    write_jsonl(EDGE_PATH, sorted(edges.values(), key=lambda r: r["id"]))

    print(f"catalog nodes={len(nodes)}")
    print(f"catalog edges={len(edges)}")
    print(f"nodes={NODE_PATH}")
    print(f"edges={EDGE_PATH}")


if __name__ == "__main__":
    main()
