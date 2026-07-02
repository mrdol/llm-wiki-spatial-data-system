"""Extraire les catalogues datasets software vers le KG.

Source principale (generation juin 2026):
- data/manifests/datasets/software_catalog_combined.RData
  -> objet R `catalogue_combine_complet` (union R + Python, dedupliquee).
  Lu directement via le paquet `rdata` (encodage latin1).

Entrees complementaires lues de facon tolerante si presentes:
- data/manifests/datasets/software_*catalog*.jsonl / *.csv (retro-compatibilite)
- data/manifests/datasets/software_dataset_literature_links.jsonl
- data/manifests/datasets/software_r_dataset_paper_formula_audit*.csv

Sorties:
- .kg/extracted/catalog_nodes.jsonl
- .kg/extracted/catalog_edges.jsonl

Cette couche complete GROBID: elle ajoute les packages, datasets, variables,
coordonnees, geometries, fichiers auxiliaires et liens papier-dataset connus
dans les catalogues.

Dependance: `rdata` (pip install rdata). Si absent, les .RData sont ignores
avec un avertissement et seules les entrees a plat sont traitees.
"""

from __future__ import annotations

import csv
import json
import math
import os
import re
import shutil
import subprocess
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[2]
DATASET_DIR = ROOT / "data" / "manifests" / "datasets"
OUT_DIR = ROOT / ".kg" / "extracted"
NODE_PATH = OUT_DIR / "catalog_nodes.jsonl"
EDGE_PATH = OUT_DIR / "catalog_edges.jsonl"

# Catalogues .RData (nouvelle generation): (nom_fichier, nom_objet_R).
# `catalogue_combine_complet` est l'union dedupliquee R + Python.
RDATA_CATALOGS = [
    ("software_catalog_combined.RData", "catalogue_combine_complet"),
]
SF_INDEX_PATH = ROOT / "data" / "Final_datasets" / "sf" / "catalogue_sf_index.RData"
SF_INDEX_OBJECT = "index_sf"
SF_AUDIT_PATH = ROOT / "data" / "Final_datasets" / "sf" / "catalogue_sf_metadata_audit.RData"
# Catalogues a plat encore lus s'ils existent (retro-compatibilite). Les anciens
# fichiers software_r_*/software_python_* obsoletes ont ete retires de cette liste.
CATALOG_PATTERNS = [
    "software_python_catalog_classified.jsonl",
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


def clean_doi(value: Any) -> str:
    """Normalise un DOI et ignore les sentinelles de DOI absent."""
    doi = norm_space(value).replace("https://doi.org/", "").replace("http://doi.org/", "")
    if doi.lower() in {"unknown", "unknown_not_found", "na", "n/a", "none", "null"}:
        return ""
    return doi


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


def clean_cell(value: Any) -> Any:
    """Normalise une cellule issue d'un data.frame R (NA/NaN -> chaine vide)."""
    if value is None:
        return ""
    if isinstance(value, float) and math.isnan(value):
        return ""
    text = str(value)
    if text.strip() in {"nan", "NaN", "NA", "<NA>", "None"}:
        return ""
    return value


def read_rdata_table(path: Path, object_name: str) -> Iterable[dict[str, Any]]:
    """Lit un data.frame stocke dans un .RData (encodage latin1) en liste de dicts.

    Renvoie une liste vide (avec avertissement) si `rdata` est absent ou si la
    lecture echoue, afin de ne jamais bloquer la construction du graphe.
    """
    if not path.exists():
        return []
    try:
        import rdata as _rdata  # import tolerant: dependance optionnelle
    except ImportError:
        return read_rdata_table_with_r(path, object_name)
    try:
        converted = _rdata.conversion.convert(
            _rdata.parser.parse_file(path), default_encoding="latin1"
        )
    except Exception as exc:  # noqa: BLE001 - on degrade proprement
        print(f"[WARN] lecture Python de {path.name} echouee: {exc}; essai via Rscript")
        return read_rdata_table_with_r(path, object_name)

    frame = converted.get(object_name)
    if frame is None or not hasattr(frame, "to_dict"):
        for value in converted.values():
            if hasattr(value, "to_dict") and hasattr(value, "columns"):
                frame = value
                break
    if frame is None or not hasattr(frame, "to_dict"):
        print(f"[WARN] objet '{object_name}' introuvable dans {path.name}")
        return []

    rows: list[dict[str, Any]] = []
    for record in frame.to_dict(orient="records"):
        rows.append({str(key): clean_cell(val) for key, val in record.items()})
    return rows


def find_rscript() -> str | None:
    """Trouve Rscript dans PATH ou dans l'installation R utilisateur Windows."""
    executable = shutil.which("Rscript")
    if executable:
        return executable
    local_app_data = os.environ.get("LOCALAPPDATA")
    if local_app_data:
        candidates = sorted(
            (Path(local_app_data) / "Programs" / "R").glob("R-* /bin/Rscript.exe".replace(" ", "")),
            reverse=True,
        )
        if candidates:
            return str(candidates[0])
    return None


def read_rdata_table_with_r(path: Path, object_name: str) -> list[dict[str, Any]]:
    """Fallback sans fichier intermediaire: RData -> JSON sur stdout via Rscript."""
    rscript = find_rscript()
    if not rscript:
        print(f"[WARN] ni paquet 'rdata' ni Rscript: {path.name} ignore")
        return []
    expression = (
        "args <- commandArgs(TRUE); e <- new.env(parent=emptyenv()); "
        "load(args[1], envir=e); n <- args[2]; "
        "x <- if (exists(n, envir=e, inherits=FALSE)) get(n, envir=e) else "
        "Filter(is.data.frame, as.list(e))[[1]]; "
        "cat(jsonlite::toJSON(x, dataframe='rows', na='null', null='null', "
        "auto_unbox=TRUE, digits=NA))"
    )
    try:
        result = subprocess.run(
            [rscript, "--vanilla", "-e", expression, str(path), object_name],
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        records = json.loads(result.stdout)
        print(f"[RData] {path.name}:{object_name} -> {len(records)} lignes (Rscript)")
        return [{str(key): clean_cell(value) for key, value in row.items()} for row in records]
    except Exception as exc:  # noqa: BLE001 - le pipeline peut continuer sans cette source
        print(f"[WARN] lecture RData via Rscript echouee {path.name}: {exc}")
        return []


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


def as_bool(value: Any) -> bool:
    """Interprete les booleens R/JSON sans transformer 'FALSE' en vrai."""
    if isinstance(value, bool):
        return value
    return norm_space(value).lower() in {"true", "t", "1", "yes", "oui"}


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
    dataset = row_value(row, "dataset", "dataset_name", "main_object", "dataset_key", "name", "bundle", "source_entry")
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
        record_id=row_value(row, "record_id"),
        language=language,
        package=package,
        dataset=dataset,
        role=row_value(row, "role"),
        usage_role=row_value(row, "usage_role"),
        classification_reason=row_value(row, "classification_reason"),
        description=row_value(row, "description", "description_bundle"),
        family=row_value(row, "family"),
        theme=row_value(row, "theme"),
        final_category=row_value(row, "final_category"),
        duplicate_status=row_value(row, "duplicate_status"),
        download_status=row_value(row, "download_status"),
        local_files=row_value(row, "local_files", "local_csv", "local_geojson"),
        url=row_value(row, "url", "download_url", "source_url", "source"),
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

    for y in parse_listish(row.get("y")) + parse_listish(row.get("candidate_y_variables")) + parse_listish(row.get("group_y_variables")):
        vid = f"responsevariable:{slug(label)}:{slug(y)}"
        add_node(nodes, vid, "ResponseVariable", y, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_RESPONSE", vid, extraction_source=source_file)

    for x in parse_listish(row.get("x")) + parse_listish(row.get("candidate_x_variables")) + parse_listish(row.get("group_x_variables")):
        vid = f"covariate:{slug(label)}:{slug(x)}"
        add_node(nodes, vid, "Covariate", x, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_COVARIATE", vid, extraction_source=source_file)

    for ident in parse_listish(row.get("identifier_variables")):
        vid = f"identifiervariable:{slug(label)}:{slug(ident)}"
        add_node(nodes, vid, "IdentifierVariable", ident, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_IDENTIFIER", vid, extraction_source=source_file)

    for coord in parse_listish(row.get("coordinate_columns")):
        vid = f"coordinatevariable:{slug(label)}:{slug(coord)}"
        add_node(nodes, vid, "CoordinateVariable", coord, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_COORDINATE", vid, extraction_source=source_file)

    for dt in parse_listish(row.get("datetime_columns")):
        vid = f"timevariable:{slug(label)}:{slug(dt)}"
        add_node(nodes, vid, "TimeVariable", dt, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_TIME", vid, extraction_source=source_file)

    geometry_type = row_value(row, "geometry_type", "has_geom")
    if not geometry_type and row_value(row, "has_geometry").lower() in {"yes", "true", "oui", "1"}:
        geometry_type = "geometry"
    if geometry_type and geometry_type.upper() != "NA":
        gid = f"geometrycolumn:{slug(label)}:{slug(geometry_type)}"
        add_node(nodes, gid, "GeometryColumn", geometry_type, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_GEOMETRY", gid, extraction_source=source_file)

    for aux in parse_listish(row.get("auxiliary_files")):
        aid = f"auxiliaryfile:{slug(label)}:{slug(aux)}"
        add_node(nodes, aid, "AuxiliaryFile", aux, source="software_catalog", dataset=label)
        add_edge(edges, did, "HAS_AUXILIARY_FILE", aid, extraction_source=source_file)

    url = row_value(row, "url", "download_url", "source_url", "source")
    if url.startswith("http"):
        uid = f"documentationpage:{slug(url)}"
        add_node(nodes, uid, "DocumentationPage", url, url=url, source="software_catalog")
        add_edge(edges, did, "DOCUMENTED_BY", uid, extraction_source=source_file)

    paper_title = row_value(row, "paper_title")
    paper_doi = clean_doi(row_value(row, "paper_doi"))
    paper_id = None
    if paper_title or paper_doi:
        paper_id = f"paper:doi:{paper_doi.lower()}" if paper_doi else f"paper:catalog:{slug(label)}:{slug(paper_title)}"
        add_node(
            nodes,
            paper_id,
            "Paper",
            paper_title or paper_doi,
            source="software_catalog",
            doi=paper_doi,
            doi_status=row_value(row, "paper_doi_status"),
            reference_evidence=row_value(row, "paper_reference_evidence"),
            evidence_status=row_value(row, "paper_evidence_status"),
            use_summary=row_value(row, "paper_use_summary"),
            model_keywords=row_value(row, "paper_model_keywords"),
        )
        add_edge(edges, paper_id, "USES_DATASET", did, extraction_source=source_file)

    formula_text = row_value(row, "formula_text", "paper_formula_or_equation")
    if formula_text and formula_text.upper() != "NA":
        formula_text = clean_catalog_formula(formula_text)
    else:
        formula_text = ""
    if formula_text:
        fid = f"formula:catalog:{slug(label)}:{slug(formula_text)[:96]}"
        add_node(
            nodes,
            fid,
            "Formula",
            formula_text,
            source="software_catalog",
            dataset=label,
            package=package,
            formula_text=formula_text,
        )
        add_edge(edges, did, "SHOWS_FORMULA", fid, extraction_source=source_file)
        if paper_id:
            add_edge(edges, paper_id, "SHOWS_FORMULA", fid, extraction_source=source_file)


def process_sf_index_row(
    row: dict[str, Any],
    source_file: str,
    nodes: dict[str, dict[str, Any]],
    edges: dict[str, dict[str, Any]],
    duplicate_keys: set[tuple[str, str, str]],
) -> str | None:
    """Enrichit un Dataset avec le resultat reel de sa conversion en objet sf."""
    language = row_value(row, "source_language") or "R"
    package = row_value(row, "package")
    dataset = row_value(row, "dataset")
    if not package or not dataset:
        return None

    base_did = dataset_id(language, package, dataset)
    key = (language.lower(), package.lower(), dataset.lower())
    record_id = row_value(row, "record_id")
    # Certains libelles de catalogue regroupent plusieurs objets reels (par
    # exemple les quatre tables de gstat::jura). Le record_id evite d'ecraser
    # leurs fichiers sf, tailles et reponses dans un seul noeud.
    did = (
        f"{base_did}:record:{slug(record_id)}"
        if key in duplicate_keys and record_id
        else base_did
    )
    child_suffix = f":record:{slug(record_id)}" if key in duplicate_keys and record_id else ""
    label = f"{package}::{dataset}"
    usable = as_bool(row.get("utilisable"))
    sf_path = row_value(row, "sf_path")
    geometry_family = row_value(row, "famille_geometrie")
    add_node(
        nodes,
        did,
        "Dataset",
        label,
        language=language,
        package=package,
        dataset=dataset,
        sf_ready=usable,
        sf_path=sf_path if usable else "",
        sf_format="RDS" if usable else "",
        sf_geometry_family=geometry_family,
        sf_original_geometry_type=row_value(row, "geom_type_origine"),
        sf_crs_input=row_value(row, "crs_input"),
        sf_projected=as_bool(row.get("est_projete")),
        sf_has_time=as_bool(row.get("a_variable_T")),
        sf_conversion_reason=row_value(row, "raison"),
        n=row.get("n"),
        k=row.get("k"),
        response_variable=row_value(row, "variable_reponse"),
        response_type=row_value(row, "type_reponse"),
        response_continuous=as_bool(row.get("reponse_continue")),
        response_source=row_value(row, "reponse_source"),
        has_formula=as_bool(row.get("has_formule")),
        sf_index_source=source_file,
        record_id=record_id,
    )

    if package:
        ptype = package_node_type(language)
        pid = f"{ptype.lower()}:{slug(package)}"
        add_node(nodes, pid, ptype, package, source="sf_conversion_index", language=language)
        add_edge(edges, pid, "PROVIDES_DATASET", did, extraction_source=source_file)
    add_source_family(nodes, edges, did, "software")

    if not usable:
        return did

    if geometry_family:
        gid = f"geometrycolumn:{slug(label)}:{slug(geometry_family)}{child_suffix}"
        add_node(
            nodes,
            gid,
            "GeometryColumn",
            geometry_family,
            source="sf_conversion_index",
            dataset=label,
            original_type=row_value(row, "geom_type_origine"),
            crs=row_value(row, "crs_input"),
        )
        add_edge(edges, did, "HAS_GEOMETRY", gid, extraction_source=source_file)

    if as_bool(row.get("a_variable_T")):
        tid = f"timevariable:{slug(label)}:t{child_suffix}"
        add_node(nodes, tid, "TimeVariable", "T", source="sf_conversion_index", dataset=label)
        add_edge(edges, did, "HAS_TIME", tid, extraction_source=source_file)

    response = row_value(row, "variable_reponse")
    if response:
        rid = f"responsevariable:{slug(label)}:{slug(response)}{child_suffix}"
        add_node(
            nodes,
            rid,
            "ResponseVariable",
            response,
            source="sf_conversion_index",
            dataset=label,
            response_type=row_value(row, "type_reponse"),
            continuous=as_bool(row.get("reponse_continue")),
        )
        add_edge(edges, did, "HAS_RESPONSE", rid, extraction_source=source_file)

    if sf_path:
        aid = f"auxiliaryfile:{slug(label)}:sf_rds{child_suffix}"
        add_node(
            nodes,
            aid,
            "AuxiliaryFile",
            sf_path,
            source="sf_conversion_index",
            dataset=label,
            file=sf_path,
            format="RDS",
        )
        add_edge(edges, did, "HAS_AUXILIARY_FILE", aid, extraction_source=source_file)
    return did


def process_sf_audit_row(
    row: dict[str, Any],
    sf_node_by_record: dict[str, str],
    nodes: dict[str, dict[str, Any]],
) -> None:
    """Ajoute les verdicts controles sans modifier le CRS des fichiers RDS."""
    record_id = row_value(row, "record_id")
    did = sf_node_by_record.get(record_id)
    if not did:
        return
    if "verdict_temporel" in row:
        verdict = row_value(row, "verdict_temporel")
        add_node(
            nodes,
            did,
            "Dataset",
            "",
            sf_has_time=verdict in {"confirme", "confirme_T_a_reconstruire"},
            temporal_audit_verdict=verdict,
            temporal_source_columns=row_value(row, "datetime_columns_catalogue"),
            temporal_T_matches=row_value(row, "T_identique_a"),
        )
    if "crs_candidat" in row:
        confidence = row_value(row, "confiance")
        candidate = row_value(row, "crs_candidat")
        add_node(
            nodes,
            did,
            "Dataset",
            "",
            crs_audit_candidate=candidate,
            crs_audit_confidence=confidence,
            crs_audit_provenance=row_value(row, "provenance"),
            crs_audit_verified=confidence == "eleve" and as_bool(row.get("transformation_4326_plausible")),
            crs_audit_evidence=row_value(row, "preuve"),
        )


def dedupe_cross_package(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Retire les doublons d'un meme jeu de donnees expose par plusieurs packages.

    Cas typique: la meme donnee GeoDa publiee a la fois par `geodatasets` et
    `libpysal`, ou un jeu present dans `spData` et `spdep`. Deux lignes sont
    considerees identiques si elles partagent (description, n, k). Dans chaque
    groupe couvrant plusieurs packages, on conserve la ligne du package au plus
    haut `information_score` (tie-break: variables les plus completes), et on
    supprime les lignes des autres packages.
    """
    def score(row: dict[str, Any]) -> float:
        try:
            return float(norm_space(row.get("information_score")) or 0)
        except (TypeError, ValueError):
            return 0.0

    def numkey(value: Any) -> str:
        """Normalise un compteur (205.0 -> 205, 'nan'/'' -> '') pour comparer RData et JSONL."""
        text = norm_space(value)
        if not text or text.lower() in {"nan", "na"}:
            return ""
        match = re.match(r"^(\d+)(?:\.0+)?$", text)
        return match.group(1) if match else text

    def signature(row: dict[str, Any]) -> tuple[str, str, str]:
        return (norm_space(row.get("description")).lower()[:80], numkey(row.get("n")), numkey(row.get("k")))

    groups: dict[tuple[str, str, str], list[dict[str, Any]]] = {}
    for row in rows:
        if norm_space(row.get("description")) and numkey(row.get("n")) and numkey(row.get("k")):
            groups.setdefault(signature(row), []).append(row)

    drop_ids: set[int] = set()
    dropped = 0
    for grp in groups.values():
        packages = {norm_space(r.get("package")) for r in grp}
        if len(packages) <= 1:
            continue
        best = max(grp, key=lambda r: (score(r), len(norm_space(r.get("variables"))), norm_space(r.get("package"))))
        keep_pkg = norm_space(best.get("package"))
        for r in grp:
            if norm_space(r.get("package")) != keep_pkg:
                drop_ids.add(id(r))
                dropped += 1

    if dropped:
        print(f"[dedup] doublons inter-packages retires: {dropped}")
    return [r for r in rows if id(r) not in drop_ids]


def process_literature_link(
    row: dict[str, Any],
    source_file: str,
    nodes: dict[str, dict[str, Any]],
    edges: dict[str, dict[str, Any]],
) -> None:
    """Ajoute les liens papier-dataset issus du catalogue de litterature."""
    dataset = row_value(row, "dataset")
    title = row_value(row, "paper_title", "title")
    doi = clean_doi(row_value(row, "paper_doi", "doi"))
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


def balance_parens(formula: str) -> str:
    """Equilibre les parentheses d'une formule tronquee par l'extraction."""
    opened, closed = formula.count("("), formula.count(")")
    if opened > closed:
        formula = formula + (")" * (opened - closed))
    elif closed > opened:
        excess = closed - opened
        chars = list(formula)
        for i in range(len(chars) - 1, -1, -1):
            if excess == 0:
                break
            if chars[i] == ")":
                chars[i] = ""
                excess -= 1
        formula = "".join(chars)
    return formula


def clean_catalog_formula(formula: str) -> str:
    """Nettoie une formule de catalogue : equilibre les parentheses et rejette
    le texte casse (assignation <-, accesseur $, separateur ;). Renvoie "" si
    inexploitable."""
    formula = norm_space(formula)
    if not formula or "~" not in formula:
        return ""
    formula = re.sub(r"\s*~\s*", " ~ ", formula)
    formula = re.sub(r"\s*\+\s*", " + ", formula)
    formula = norm_space(balance_parens(formula))
    if re.search(r"<-|[$;]", formula):
        return ""
    rhs = formula.split("~", 1)[1]
    if not re.search(r"[A-Za-z]", rhs):
        return ""
    return formula


def repair_formula_text(formula: str) -> str:
    """Nettoie une formule issue d'un champ d'audit manuel."""
    formula = norm_space(formula)
    formula = re.sub(r"\s*~\s*", " ~ ", formula)
    formula = re.sub(r"\s*\+\s*", " + ", formula)
    formula = re.sub(r"\(\s*1\s*\|\s*", "(1|", formula)
    return norm_space(balance_parens(formula))


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

    catalog_rows: list[tuple[str, dict[str, Any]]] = []
    for name, object_name in RDATA_CATALOGS:
        path = DATASET_DIR / name
        for row in read_rdata_table(path, object_name):
            catalog_rows.append((name, row))

    for name in CATALOG_PATTERNS:
        path = DATASET_DIR / name
        if not path.exists():
            continue
        rows = read_jsonl(path) if path.suffix == ".jsonl" else read_csv(path)
        for row in rows:
            catalog_rows.append((name, row))

    # Deduplication inter-packages avant injection dans le graphe.
    kept_ids = {id(row) for row in dedupe_cross_package([row for _, row in catalog_rows])}
    for name, row in catalog_rows:
        if id(row) in kept_ids:
            process_dataset_row(row, name, nodes, edges)

    # L'index de conversion est la source de verite sur les objets sf reellement
    # construits. Il enrichit les memes noeuds Dataset apres le catalogue general.
    sf_rows = list(read_rdata_table(SF_INDEX_PATH, SF_INDEX_OBJECT))
    sf_key_counts: dict[tuple[str, str, str], int] = {}
    for row in sf_rows:
        key = (
            row_value(row, "source_language").lower(),
            row_value(row, "package").lower(),
            row_value(row, "dataset").lower(),
        )
        sf_key_counts[key] = sf_key_counts.get(key, 0) + 1
    duplicate_sf_keys = {key for key, count in sf_key_counts.items() if count > 1}
    sf_node_by_record: dict[str, str] = {}
    for row in sf_rows:
        did = process_sf_index_row(row, SF_INDEX_PATH.name, nodes, edges, duplicate_sf_keys)
        if did:
            sf_node_by_record[row_value(row, "record_id")] = did
    if sf_rows:
        ready_count = sum(as_bool(row.get("utilisable")) for row in sf_rows)
        print(f"[sf] index={len(sf_rows)}; prets={ready_count}; rejetes={len(sf_rows) - ready_count}")

    for object_name in ("audit_crs", "audit_time"):
        audit_rows = list(read_rdata_table(SF_AUDIT_PATH, object_name))
        for row in audit_rows:
            process_sf_audit_row(row, sf_node_by_record, nodes)
        if audit_rows:
            print(f"[sf-audit] {object_name}={len(audit_rows)}")

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
