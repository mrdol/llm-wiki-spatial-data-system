"""Parser les fichiers TEI produits par GROBID vers le KG.

Entree:
- corpus/papers/tei/*.tei.xml

Sorties:
- .kg/extracted/tei_nodes.jsonl
- .kg/extracted/tei_edges.jsonl
- .kg/summaries/tei_parse_summary.md

Cette passerelle extrait une premiere couche exploitable: Paper, Author,
Section, Formula, Citation, Method, Dataset, RPackage et Evidence.
"""

from __future__ import annotations

import json
import csv
import re
from pathlib import Path
from typing import Any
from xml.etree import ElementTree as ET


ROOT = Path(__file__).resolve().parents[2]
TEI_DIR = ROOT / "corpus" / "papers" / "tei"
RAW_PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
CONCEPTS_PATH = ROOT / "inst" / "kg" / "concepts.yml"
R_DATASET_DOCS = ROOT / "wiki" / "datasets" / "r_package_docs"
DATASET_MANIFESTS = ROOT / "data" / "manifests" / "datasets"
OUT_DIR = ROOT / ".kg" / "extracted"
SUMMARY_DIR = ROOT / ".kg" / "summaries"
NODE_PATH = OUT_DIR / "tei_nodes.jsonl"
EDGE_PATH = OUT_DIR / "tei_edges.jsonl"
SUMMARY_PATH = SUMMARY_DIR / "tei_parse_summary.md"
NS = {"tei": "http://www.tei-c.org/ns/1.0"}


METHOD_SEEDS = {
    "Geographically Weighted Regression": ["gwr", "geographically weighted regression", "geographically weighted"],
    "MGWR": ["mgwr", "multiscale geographically weighted regression", "multiscale gwr"],
    "Spatial regression": ["spatial regression", "spatial lag", "spatial error", "spatial durbin"],
    "Spatial autocorrelation": ["spatial autocorrelation", "moran", "spatial dependence"],
    "Hedonic price model": ["hedonic price", "hedonic house price", "hedonic regression"],
    "Network distance": ["network distance", "road network distance", "non-euclidean distance", "travel time"],
}

MODEL_MARKERS = [
    "glm",
    "lm",
    "gam",
    "glm.nb",
    "glmer",
    "lmer",
    "gwr",
    "gwr.basic",
    "randomforest",
    "makeclassiftask",
]

COORDINATE_NAMES = {"x", "y", "lon", "long", "longitude", "lat", "latitude", "easting", "northing"}
GENERIC_VARIABLE_NAMES = {
    "area",
    "code",
    "count",
    "data",
    "distance",
    "id",
    "name",
    "number",
    "region",
    "value",
}


def norm_space(value: str) -> str:
    """Nettoie les espaces et les retours ligne."""
    return re.sub(r"\s+", " ", value or "").strip()


def slug(value: str) -> str:
    """Transforme un libelle en fragment d'identifiant KG."""
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "_", value)
    return value.strip("_") or "unknown"


def dataset_node_id(label: str) -> str:
    """Utilise les memes identifiants dataset que les catalogues software."""
    if "::" in label:
        package, dataset = label.split("::", 1)
        return f"dataset:r:{slug(package)}:{slug(dataset)}"
    return f"dataset:{slug(label)}"


def has_model_marker(text: str) -> bool:
    """Verifie qu'une section parle vraiment de modelisation."""
    lowered = text.lower()
    for marker in MODEL_MARKERS:
        marker_l = marker.lower()
        if re.fullmatch(r"[a-z_.]+", marker_l):
            if re.search(r"(?<![a-z0-9_.])" + re.escape(marker_l) + r"(?:\s*\(|\b)", lowered):
                return True
        elif marker_l in lowered:
            return True
    return False


def elem_text(elem: ET.Element | None) -> str:
    """Retourne le texte lisible d'un element XML."""
    if elem is None:
        return ""
    return norm_space(" ".join(elem.itertext()))


def find_text(root: ET.Element, xpath: str) -> str:
    """Lit le premier texte correspondant a un XPath TEI."""
    return elem_text(root.find(xpath, NS))


def find_all_text(root: ET.Element, xpath: str) -> list[str]:
    """Lit tous les textes correspondant a un XPath TEI."""
    values = [elem_text(elem) for elem in root.findall(xpath, NS)]
    return [value for value in values if value]


def load_method_aliases() -> dict[str, list[str]]:
    """Charge les methodes de depart depuis concepts.yml et les graines locales."""
    methods = {label: list(aliases) for label, aliases in METHOD_SEEDS.items()}
    if not CONCEPTS_PATH.exists():
        return methods

    current_key = ""
    current_label = ""
    for line in CONCEPTS_PATH.read_text(encoding="utf-8").splitlines():
        concept_match = re.match(r"\s{2}([A-Za-z0-9_]+):\s*$", line)
        if concept_match:
            current_key = concept_match.group(1)
            current_label = current_key
            continue
        label_match = re.match(r"\s+label:\s*(.+?)\s*$", line)
        if current_key and label_match:
            label = norm_space(label_match.group(1))
            current_label = label
            methods.setdefault(current_label, [current_label, current_key])
            continue
        alias_match = re.match(r"\s+-\s*(.+?)\s*$", line)
        if current_label and alias_match:
            methods.setdefault(current_label, [current_label]).append(norm_space(alias_match.group(1)))
    return methods


def load_dataset_aliases() -> dict[str, list[str]]:
    """Construit des alias de datasets a partir des docs R generees."""
    aliases: dict[str, list[str]] = {}
    if not R_DATASET_DOCS.exists():
        return aliases

    common_dataset_words = {
        "air",
        "car",
        "cars",
        "concrete",
        "house",
        "housing",
        "properties",
        "road",
        "survey",
        "world",
    }

    for doc_path in R_DATASET_DOCS.glob("*/topics/*.md"):
        package = doc_path.parent.parent.name
        dataset = doc_path.stem
        label = f"{package}::{dataset}"
        dataset_aliases = {label}
        if len(dataset) >= 8 and dataset.lower() not in common_dataset_words:
            dataset_aliases.add(dataset)
        try:
            for line in doc_path.read_text(encoding="utf-8", errors="ignore").splitlines()[:30]:
                line = norm_space(line)
                if line.startswith(f"{dataset}:"):
                    title = norm_space(line.split(":", 1)[1])
                    title = re.sub(r"\s*\([^)]*\)\s*", " ", title)
                    title = norm_space(title)
                    if len(title) >= 8:
                        dataset_aliases.add(title)
                if line and "data set" in line.lower():
                    title = re.sub(r"\s*\([^)]*\)\s*", " ", line)
                    title = norm_space(title)
                    if len(title) >= 8:
                        dataset_aliases.add(title)
        except OSError:
            pass
        aliases[label] = sorted(alias for alias in dataset_aliases if len(alias) >= 4)
    return aliases


def load_dataset_variables() -> dict[str, list[str]]:
    """Lit les variables connues des datasets depuis les docs R et les catalogues."""
    variables: dict[str, set[str]] = {}

    def add_vars(label: str, values: list[str]) -> None:
        clean = {
            value
            for value in (norm_space(v) for v in values)
            if re.match(r"^[A-Za-z_][A-Za-z0-9_.]*$", value)
        }
        if clean:
            variables.setdefault(label, set()).update(clean)

    if R_DATASET_DOCS.exists():
        for doc_path in R_DATASET_DOCS.glob("*/topics/*.md"):
            package = doc_path.parent.parent.name
            dataset = doc_path.stem
            label = f"{package}::{dataset}"
            found: list[str] = []
            try:
                for line in doc_path.read_text(encoding="utf-8", errors="ignore").splitlines():
                    match = re.match(r"^([A-Za-z_][A-Za-z0-9_.]*)\s*:\s*(.+)$", norm_space(line))
                    if not match:
                        continue
                    name, details = match.groups()
                    if name == dataset:
                        continue
                    if re.search(r"\b(numeric|integer|factor|logical|character|date|sf|sfc|geometry)\b", details.lower()):
                        found.append(name)
            except OSError:
                pass
            add_vars(label, found)

    for csv_name in ("software_r_catalog_main_datasets.csv", "software_catalog_curated_final.csv"):
        path = DATASET_MANIFESTS / csv_name
        if not path.exists():
            continue
        text = path.read_text(encoding="utf-8-sig", errors="ignore")
        delimiter = ";" if text[:4096].count(";") > text[:4096].count(",") else ","
        rows = [row for row in csv.DictReader(text.splitlines(), delimiter=delimiter)]
        for row in rows:
            package = norm_space(row.get("package"))
            dataset = norm_space(row.get("dataset") or row.get("main_object") or row.get("bundle"))
            raw_vars = norm_space(row.get("variables") or row.get("columns_preview"))
            if not package or not dataset or not raw_vars:
                continue
            values = [norm_space(v) for v in re.split(r"[;,|]", raw_vars)]
            add_vars(f"{package}::{dataset}", values)

    return {label: sorted(values) for label, values in variables.items()}


def build_variable_dataset_index(dataset_variables: dict[str, list[str]]) -> dict[str, set[str]]:
    """Construit un index rapide variable -> datasets candidats."""
    index: dict[str, set[str]] = {}
    for label, variables in dataset_variables.items():
        for var in variables:
            key = var.lower()
            if len(key) < 3 or key in COORDINATE_NAMES or key in GENERIC_VARIABLE_NAMES:
                continue
            index.setdefault(key, set()).add(label)
    return index


def add_node(nodes: dict[str, dict[str, Any]], node_id: str, node_type: str, label: str, **props: Any) -> None:
    """Ajoute ou complete un noeud du KG."""
    current = nodes.setdefault(node_id, {"id": node_id, "type": node_type, "label": label, "props": {}})
    current["label"] = current["label"] or label
    current["props"].update({key: value for key, value in props.items() if value not in ("", None, [])})


def add_edge(edges: dict[str, dict[str, Any]], source: str, relation: str, target: str, **props: Any) -> None:
    """Ajoute une relation KG dedupliquee."""
    edge_id = f"{source}|{relation}|{target}"
    edges[edge_id] = {
        "id": edge_id,
        "source": source,
        "relation": relation,
        "target": target,
        "props": {key: value for key, value in props.items() if value not in ("", None, [])},
    }


def paper_id(doi: str, tei_path: Path) -> str:
    """Calcule l'identifiant Paper, prioritairement a partir du DOI."""
    doi = doi.lower().strip()
    if doi:
        return f"paper:doi:{doi}"
    return f"paper:tei:{slug(tei_path.stem)}"


def author_name(author: ET.Element) -> str:
    """Reconstruit le nom d'un auteur TEI."""
    surname = find_text(author, ".//tei:surname")
    forenames = find_all_text(author, ".//tei:forename")
    name = norm_space(" ".join([*forenames, surname]))
    name = name.replace("& ", "")
    return name


def candidate_pdf(tei_path: Path) -> str:
    """Trouve le PDF local probable a partir du nom du TEI."""
    stem = tei_path.name.removesuffix(".tei.xml")
    pdf_path = RAW_PDF_DIR / f"{stem}.pdf"
    if pdf_path.exists():
        return str(pdf_path.relative_to(ROOT))
    return ""


def detect_aliases(text: str, aliases: dict[str, list[str]], *, max_hits: int = 20) -> list[tuple[str, str]]:
    """Detecte les labels dont au moins un alias apparait dans le texte."""
    lowered = text.lower()
    hits: list[tuple[str, str]] = []
    for label, label_aliases in aliases.items():
        for alias in label_aliases:
            alias_clean = norm_space(alias)
            if not alias_clean:
                continue
            pattern = r"(?<![A-Za-z0-9_])" + re.escape(alias_clean.lower()) + r"(?![A-Za-z0-9_])"
            if re.search(pattern, lowered):
                hits.append((label, alias_clean))
                break
        if len(hits) >= max_hits:
            break
    return hits


def detect_dataset_labels_in_section(
    text: str,
    dataset_aliases: dict[str, list[str]],
    dataset_variables: dict[str, list[str]],
    variable_dataset_index: dict[str, set[str]],
    *,
    max_hits: int = 12,
) -> list[tuple[str, str]]:
    """Detecte un dataset par alias ou par cooccurrence de ses variables."""
    known_labels = set(dataset_aliases)
    hits = [
        (dataset_ref, "explicit_ref")
        for dataset_ref in sorted(set(re.findall(r"\b[A-Za-z][A-Za-z0-9_.]*::[A-Za-z][A-Za-z0-9_.]*\b", text)))
        if dataset_ref in known_labels
    ][:max_hits]
    seen = {label for label, _ in hits}
    lowered = text.lower()
    model_context = has_model_marker(text)
    if not model_context:
        return hits

    tokens = set(re.findall(r"[A-Za-z_][A-Za-z0-9_.]*", lowered))
    candidate_counts: dict[str, set[str]] = {}
    for token in tokens:
        for label in variable_dataset_index.get(token, set()):
            if label not in seen:
                candidate_counts.setdefault(label, set()).add(token)

    for label, token_hits in sorted(candidate_counts.items(), key=lambda item: len(item[1]), reverse=True):
        if label in seen:
            continue
        variables = dataset_variables.get(label, [])
        if len(variables) < 3:
            continue
        found = [var for var in variables if var.lower() in token_hits]
        has_distinctive_var = any(len(var) >= 6 or "_" in var for var in found)
        if len(found) >= 3 and has_distinctive_var:
            hits.append((label, "variables:" + ",".join(found[:8])))
            seen.add(label)
        if len(hits) >= max_hits:
            break
    return hits


def explicit_formula_candidates(text: str) -> list[str]:
    """Extrait des formules R conservees explicitement avec le symbole ~."""
    if not has_model_marker(text):
        return []
    candidates: list[str] = []
    for match in re.finditer(r"\b[A-Za-z_][A-Za-z0-9_.]*\s*~\s*[^,;()]{3,180}", text):
        formula = norm_space(match.group(0)).strip("` ")
        formula = re.sub(r"\s*~\s*", " ~ ", formula)
        formula = re.sub(r"\s*\+\s*", " + ", formula)
        formula = norm_space(formula)
        lhs = norm_space(formula.split("~", 1)[0]).lower()
        if lhs in MODEL_MARKERS or re.search(r"~\s*\+", formula):
            continue
        if "+" in formula or "." in formula:
            candidates.append(formula)
    return sorted(set(candidates))


def formula_terms(formula: str) -> tuple[str, list[str]]:
    """Separe une formule simple en reponse et covariables."""
    if "~" not in formula:
        return "", []
    lhs, rhs = formula.split("~", 1)
    response = norm_space(lhs)
    covariates: list[str] = []
    for raw in rhs.split("+"):
        term = norm_space(raw)
        if not term or term == ".":
            continue
        term = re.sub(r"^I\((.*)\)$", r"\1", term)
        covariates.append(term)
    return response, covariates


def infer_formula_from_variables(text: str, variables: list[str]) -> str:
    """Reconstruit une formule quand GROBID a casse les + et le ~."""
    lowered = text.lower()
    if not has_model_marker(text):
        return ""

    positions: list[tuple[int, str]] = []
    for var in variables:
        if var.lower() in COORDINATE_NAMES:
            continue
        match = re.search(r"(?<![A-Za-z0-9_.])" + re.escape(var.lower()) + r"(?![A-Za-z0-9_.])", lowered)
        if match:
            positions.append((match.start(), var))
    ordered = []
    seen: set[str] = set()
    for _, var in sorted(positions):
        if var.lower() not in seen:
            ordered.append(var)
            seen.add(var.lower())

    if len(ordered) < 3:
        return ""
    response = ordered[0]
    predictors = [var for var in ordered[1:] if var.lower() != response.lower()]
    if len(predictors) < 2:
        return ""
    return f"{response} ~ {' + '.join(predictors[:10])}"


def section_formula_candidates(text: str, labels: list[str], dataset_variables: dict[str, list[str]]) -> list[tuple[str, str]]:
    """Retourne les formules detectees et le dataset auquel les rattacher."""
    out: list[tuple[str, str]] = []
    explicit = explicit_formula_candidates(text)
    for label in labels:
        for formula in explicit:
            out.append((label, formula))
        inferred = infer_formula_from_variables(text, dataset_variables.get(label, []))
        if inferred:
            out.append((label, inferred))
    deduped: list[tuple[str, str]] = []
    seen: set[tuple[str, str]] = set()
    for item in out:
        if item not in seen:
            deduped.append(item)
            seen.add(item)
    return deduped


def formula_label(formula: ET.Element, index: int) -> str:
    """Retourne le label imprime d'une formule si GROBID l'a trouve."""
    label = elem_text(formula.find("tei:label", NS))
    return label or str(index)


def parse_one_tei(
    tei_path: Path,
    method_aliases: dict[str, list[str]],
    dataset_aliases: dict[str, list[str]],
    dataset_variables: dict[str, list[str]],
    variable_dataset_index: dict[str, set[str]],
    nodes: dict[str, dict[str, Any]],
    edges: dict[str, dict[str, Any]],
) -> dict[str, Any]:
    """Parse un TEI et ajoute ses noeuds/relations dans les collecteurs."""
    root = ET.parse(tei_path).getroot()
    title = find_text(root, ".//tei:titleStmt/tei:title[@level='a']") or find_text(root, ".//tei:titleStmt/tei:title")
    doi = find_text(root, ".//tei:idno[@type='DOI']")
    published = root.find(".//tei:publicationStmt/tei:date", NS)
    published_when = published.attrib.get("when", "") if published is not None else ""
    keywords = find_all_text(root, ".//tei:textClass/tei:keywords/tei:term")
    abstract = find_text(root, ".//tei:profileDesc/tei:abstract")
    pid = paper_id(doi, tei_path)

    add_node(
        nodes,
        pid,
        "Paper",
        title or tei_path.stem,
        doi=doi,
        published=published_when,
        keywords=keywords,
        abstract=abstract,
        tei_file=str(tei_path.relative_to(ROOT)),
        pdf_file=candidate_pdf(tei_path),
        source="grobid_tei",
    )

    seen_authors: set[str] = set()
    for author in root.findall(".//tei:sourceDesc//tei:analytic/tei:author", NS):
        name = author_name(author)
        if not name or name in seen_authors:
            continue
        seen_authors.add(name)
        aid = f"author:{slug(name)}"
        add_node(nodes, aid, "Author", name, source="grobid_tei")
        add_edge(edges, pid, "HAS_AUTHOR", aid, extraction_source="grobid_tei")

    body_text_parts: list[str] = []
    section_infos: list[tuple[str, str, str]] = []
    section_count = 0
    for index, div in enumerate(root.findall(".//tei:text/tei:body/tei:div", NS), start=1):
        head = elem_text(div.find("tei:head", NS)) or f"Section {index}"
        paragraphs = find_all_text(div, "tei:p")
        section_text = norm_space(" ".join(paragraphs))
        body_text_parts.append(head)
        body_text_parts.append(section_text)
        sid = f"{pid}:section:{index}"
        add_node(
            nodes,
            sid,
            "Section",
            head,
            order=index,
            text_preview=section_text[:800],
            source="grobid_tei",
        )
        add_edge(edges, pid, "HAS_SECTION", sid, extraction_source="grobid_tei", order=index)
        section_infos.append((sid, head, section_text))
        section_count += 1

    full_text = norm_space(" ".join([title, abstract, *body_text_parts]))

    for label, alias in detect_aliases(full_text, method_aliases, max_hits=50):
        mid = f"method:{slug(label)}"
        eid = f"{pid}:evidence:method:{slug(label)}"
        add_node(nodes, mid, "Method", label, matched_alias=alias, source="concept_alias")
        add_node(nodes, eid, "Evidence", f"Evidence for {label}", snippet=alias, source="grobid_tei")
        add_edge(edges, pid, "MENTIONS_METHOD", mid, evidence_id=eid, confidence=0.75, extraction_source="alias_match")
        add_edge(edges, eid, "SUPPORTS", mid, extraction_source="alias_match")

    for label, alias in detect_aliases(full_text, dataset_aliases, max_hits=50):
        did = dataset_node_id(label)
        eid = f"{pid}:evidence:dataset:{slug(label)}"
        add_node(nodes, did, "Dataset", label, matched_alias=alias, source="r_dataset_docs")
        add_node(nodes, eid, "Evidence", f"Evidence for {label}", snippet=alias, source="grobid_tei")
        add_edge(edges, pid, "USES_DATASET", did, evidence_id=eid, confidence=0.65, extraction_source="alias_match")
        add_edge(edges, eid, "SUPPORTS", did, extraction_source="alias_match")
        if "::" in label:
            package = label.split("::", 1)[0]
            rid = f"rpackage:{slug(package)}"
            add_node(nodes, rid, "RPackage", package, source="r_dataset_docs")
            add_edge(edges, pid, "USES_PACKAGE", rid, evidence_id=eid, confidence=0.65, extraction_source="dataset_package")
            add_edge(edges, rid, "PROVIDES_DATASET", did, extraction_source="r_dataset_docs")

    for sid, head, section_text in section_infos:
        scope = norm_space(f"{head} {section_text}")
        dataset_hits = detect_dataset_labels_in_section(
            scope,
            dataset_aliases,
            dataset_variables,
            variable_dataset_index,
            max_hits=12,
        )
        labels = [label for label, _ in dataset_hits]
        for label, alias in dataset_hits:
            did = dataset_node_id(label)
            eid = f"{sid}:evidence:dataset:{slug(label)}"
            add_node(nodes, did, "Dataset", label, matched_alias=alias, section_source="section_dataset_match")
            add_node(nodes, eid, "Evidence", f"Section evidence for {label}", snippet=alias, source="grobid_tei")
            add_edge(edges, pid, "USES_DATASET", did, evidence_id=eid, confidence=0.7, extraction_source="section_match")
            add_edge(edges, eid, "SUPPORTS", did, extraction_source="section_match")
        for label, formula_text in section_formula_candidates(scope, labels, dataset_variables):
            did = dataset_node_id(label)
            fid = f"formula:tei:{slug(label)}:{slug(formula_text)[:96]}"
            model_family = "binomial" if "binomial" in scope.lower() else ""
            add_node(
                nodes,
                fid,
                "Formula",
                formula_text,
                formula_text=formula_text,
                dataset=label,
                section_id=sid,
                paper_id=pid,
                model_family=model_family,
                source="tei_section_inference",
            )
            add_edge(edges, pid, "SHOWS_FORMULA", fid, extraction_source="tei_section_inference")
            add_edge(edges, sid, "SHOWS_FORMULA", fid, extraction_source="tei_section_inference")
            add_edge(edges, did, "SHOWS_FORMULA", fid, extraction_source="tei_section_inference")

            response, covariates = formula_terms(formula_text)
            if response:
                rid = f"responsevariable:{slug(label)}:{slug(response)}"
                add_node(nodes, rid, "ResponseVariable", response, source="tei_formula_inference", dataset=label)
                add_edge(edges, did, "HAS_RESPONSE", rid, extraction_source="tei_formula_inference", formula_id=fid)
            for covariate in covariates:
                cid = f"covariate:{slug(label)}:{slug(covariate)}"
                add_node(nodes, cid, "Covariate", covariate, source="tei_formula_inference", dataset=label)
                add_edge(edges, did, "HAS_COVARIATE", cid, extraction_source="tei_formula_inference", formula_id=fid)

    formulas = root.findall(".//tei:formula", NS)
    for index, formula in enumerate(formulas, start=1):
        text = elem_text(formula)
        if not text:
            continue
        fid = f"{pid}:formula:{index}"
        add_node(
            nodes,
            fid,
            "Formula",
            f"Formula {formula_label(formula, index)}",
            formula_text=text,
            order=index,
            source="grobid_tei",
        )
        add_edge(edges, pid, "HAS_FORMULA", fid, extraction_source="grobid_tei", order=index)

    citation_count = 0
    for index, bibl in enumerate(root.findall(".//tei:text/tei:back//tei:listBibl/tei:biblStruct", NS), start=1):
        cited_title = find_text(bibl, ".//tei:analytic/tei:title") or find_text(bibl, ".//tei:monogr/tei:title")
        if not cited_title:
            continue
        cid = f"{pid}:citation:{index}"
        cited_year = find_text(bibl, ".//tei:date")
        add_node(nodes, cid, "Citation", cited_title, year=cited_year, order=index, source="grobid_tei")
        add_edge(edges, pid, "CITES", cid, extraction_source="grobid_tei", order=index)
        citation_count += 1

    return {
        "tei_file": str(tei_path.relative_to(ROOT)),
        "paper_id": pid,
        "title": title,
        "doi": doi,
        "authors": len(seen_authors),
        "sections": section_count,
        "formulas": len(formulas),
        "citations": citation_count,
    }


def write_jsonl(path: Path, rows: list[dict[str, Any]]) -> None:
    """Ecrit des lignes JSON pour le constructeur de graphe."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        for row in rows:
            fh.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")


def write_summary(rows: list[dict[str, Any]], node_count: int, edge_count: int) -> None:
    """Produit un resume lisible de l'extraction TEI."""
    SUMMARY_DIR.mkdir(parents=True, exist_ok=True)
    lines = [
        "# TEI parse summary",
        "",
        f"- TEI files: {len(rows)}",
        f"- Nodes: {node_count}",
        f"- Edges: {edge_count}",
        "",
        "| DOI | Title | Authors | Sections | Formulas | Citations |",
        "|---|---|---:|---:|---:|---:|",
    ]
    for row in rows:
        title = (row.get("title") or "").replace("|", " ")
        lines.append(
            f"| {row.get('doi', '')} | {title[:90]} | {row['authors']} | {row['sections']} | {row['formulas']} | {row['citations']} |"
        )
    SUMMARY_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    tei_files = sorted(TEI_DIR.glob("*.tei.xml"))
    method_aliases = load_method_aliases()
    dataset_aliases = load_dataset_aliases()
    dataset_variables = load_dataset_variables()
    variable_dataset_index = build_variable_dataset_index(dataset_variables)
    nodes: dict[str, dict[str, Any]] = {}
    edges: dict[str, dict[str, Any]] = {}
    summaries = [
        parse_one_tei(path, method_aliases, dataset_aliases, dataset_variables, variable_dataset_index, nodes, edges)
        for path in tei_files
    ]

    write_jsonl(NODE_PATH, sorted(nodes.values(), key=lambda row: row["id"]))
    write_jsonl(EDGE_PATH, sorted(edges.values(), key=lambda row: row["id"]))
    write_summary(summaries, len(nodes), len(edges))

    print(f"TEI files found: {len(tei_files)}")
    print(f"nodes={NODE_PATH}")
    print(f"edges={EDGE_PATH}")
    print(f"summary={SUMMARY_PATH}")


if __name__ == "__main__":
    main()
