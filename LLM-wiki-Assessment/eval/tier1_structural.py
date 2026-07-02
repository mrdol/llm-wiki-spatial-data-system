"""Tier 1 - structural validation for wiki fiches.

Tier 1 is deterministic and should catch missing or empty critical metadata
before any LLM judge is used. Dataset pages still allow explicit "none" for
Dataset DOI because AGENTS.md says DOI is required only when available.
Scientific paper pages are stricter: Paper DOI must be present.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

try:
    import yaml
except ImportError:
    yaml = None

try:
    from langdetect import detect as _langdetect
except ImportError:
    _langdetect = None

try:
    from deep_translator import GoogleTranslator as _GoogleTranslator
except ImportError:
    _GoogleTranslator = None

PROJECT_ROOT = Path(__file__).parent.parent.parent  # LLM-wiki-Assessment/eval/ → llm-wiki-karpathy/
WIKI_ROOT = PROJECT_ROOT / "wiki"

ALLOWED_TYPES = {"dataset", "paper", "source", "concept", "metadata", "estimator", "analysis"}
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
BACKLINK_RE = re.compile(r"\[\[([^\]]+)\]\]")
SECTION_RE = re.compile(r"^## (.+)$", re.MULTILINE)
DOI_RE = re.compile(r"\b10\.\d{4,9}/\S+", re.IGNORECASE)
URL_RE = re.compile(r"https?://\S+|\b[a-z0-9.-]+\.(?:com|org|net|edu|gov|io)\b", re.IGNORECASE)

REGRESSION_STATUS_VALUES = {
    "bon candidat", "a verifier", "à vérifier", "mauvais candidat",
    "mis de cote", "mis de côté", "candidat par analogie -- non verifie",
    "candidat par analogie — non vérifié", "pending",
}
REGRESSION_EVIDENCE_VALUES = {"verbatim", "code", "article", "analogie", "n/a", "pending"}

EXCLUDED_FILES = {"index.md", "log.md", "overview.md", "glossary.md", "eval_queue.md"}

Y_TYPES = {
    "continuous",
    "binary",
    "count",
    "rate",
    "proportion",
    "presence_absence",
    "presence/absence",
    "categorical",
    "ordinal",
    "duration",
    "unknown",
}
X_ROLE_TYPES = {
    "continuous",
    "categorical",
    "spatial",
    "temporal",
    "lagged",
    "imputed",
    "identifier",
    "geometry",
    "timestamp",
    "unknown",
}
NULL_LIKE_VALUES = {"", "null", "none", "n/a", "na", "not available", "not_available", "missing"}
UNKNOWN_LIKE_VALUES = {"unknown", "pending", "to inspect", "data_inspection_pending", "not checked", "not_checked"}


@dataclass
class FieldCheck:
    id: str
    sections: list[str]
    pattern: Optional[str]
    description: str


DATASET_CHECKS: list[FieldCheck] = [
    FieldCheck("dataset_name", ["Dataset Name", "Identity"], r"(?im)dataset\s*(name|id)\s*:", "dataset name or id"),
    FieldCheck("source", ["Source / Warehouse", "Source Access", "Source"], r"(?im)source\s*(family|url|access)?\s*:", "source"),
    FieldCheck("doi", ["Dataset Name", "Identity"], r"(?im)(dataset\s*)?DOI\s*:", "dataset DOI field"),
    FieldCheck("license", ["License Metadata"], r"(?im)(licen[cs]e)\s*(name|present|open)?\s*:", "license"),
    FieldCheck("variables", ["Structured Metadata", "Content Metadata", "Variables"], r"(?im)candidate\s+[yx]\s*(variables?|typology)\s*:", "Y/X variables"),
    FieldCheck("data_type", ["Data Type", "Spatiotemporal"], r"(?im)data\s*type\s*:", "data type"),
    FieldCheck("structure", ["Structure", "Spatiotemporal"], r"(?im)^[-*]\s*structure\s*:", "data structure"),
    FieldCheck("n_obs", ["N (observations)", "Spatiotemporal"], r"(?im)N\s*observations?\s*:", "N observations"),
    FieldCheck("t_periods", ["T (time periods)", "Spatiotemporal"], r"(?im)T\s*(time\s*)?periods?\s*:", "T periods"),
    FieldCheck("nt_profile", ["N/T Profile", "Spatiotemporal"], r"(?im)N/?T\s*profile\s*:", "N/T profile"),
    FieldCheck("spatial_res", ["Spatial Resolution", "Spatiotemporal"], r"(?im)spatial\s*resolution\s*:", "spatial resolution"),
    FieldCheck("temporal_res", ["Temporal Resolution", "Spatiotemporal"], r"(?im)temporal\s*resolution\s*:", "temporal resolution"),
    FieldCheck("spatial_extent", ["Spatial Extent", "Spatiotemporal"], r"(?im)spatial\s*extent\s*:", "spatial extent"),
    FieldCheck("time_range", ["Time Range", "Spatiotemporal"], r"(?im)time\s*range\s*:", "time range"),
    FieldCheck("reproducibility", ["Reproducibility"], r"(?im)reproducib\w+\s*(status|available|code)?\s*:", "reproducibility"),
    FieldCheck("related_pages", ["Related Pages"], None, "## Related Pages"),
]

PAPER_CHECKS: list[FieldCheck] = [
    FieldCheck("paper_title", ["Identity", "Paper Metadata"], r"(?im)(paper\s*)?title\s*:", "paper title"),
    FieldCheck("paper_doi", ["Identity", "Paper Metadata"], r"(?im)(paper\s*)?doi\s*:", "paper DOI"),
    FieldCheck("source_url", ["Source", "Source Access"], r"(?im)source\s*url\s*:", "source URL"),
    FieldCheck("abstract", ["Abstract", "Summary"], r"(?im)abstract\s*:", "abstract"),
    FieldCheck("dataset_linkage", ["Dataset Linkage", "Related Datasets", "Datasets Mentioned"], r"(?im)(related\s*datasets|dataset\s*doi|dataset/archive\s*doi|dataset\s*source\s*url|dataset\s*link)\s*:", "dataset linkage"),
    FieldCheck("modeling_evidence", ["Modeling Evidence"], r"(?im)(modeling\s*evidence|model\s*family|method\s*evidence)\s*:", "modeling evidence"),
    FieldCheck("dataset_access_decision", ["Dataset Access Decision"], r"(?im)(access\s*decision|next\s*action)\s*:", "dataset access decision"),
    FieldCheck("quality_pedigree", ["Quality Pedigree"], r"(?im)quality_pedigree\s*:", "quality pedigree"),
    FieldCheck("related_pages", ["Related Pages"], None, "## Related Pages"),
]

ESTIMATOR_CHECKS: list[FieldCheck] = [
    # Section-name check uses translated titles (any language → English).
    # Body patterns keep a bilingual fallback for concepts that authors
    # may express with a different section name in their language.
    FieldCheck("estimator_family", ["Estimator Family"],
               r"(?im)(estimator\s*family|family\s*:|famille\s*(d.estimateur)?|SAR\b|SEM\b|SARAR\b|GAM\b)",
               "estimator family"),
    FieldCheck("model_equation", ["Model Equation", "Equation"],
               r"(?im)(model\s*equation|canonical\s*form|\$\$)",
               "model equation"),
    FieldCheck("data_structures", ["Data Structures It May Fit", "Data Structures"],
               r"(?im)(data\s*structure|donn.es\s*.ligibles|pertinent\s+(si|pour)|eligible\s+data)",
               "compatible data structures"),
    FieldCheck("hyperparameters", ["Hyperparameters To Optimize", "Hyperparameters"],
               r"(?im)hyperparamet(er|re|è)",
               "hyperparameters"),
    FieldCheck("cv_policy", ["Cross-validation Policy", "Cross-validation"],
               r"(?im)(cross.validat|validation\s+crois|nfold|cv_mode\b|n_?fold)",
               "cross-validation policy"),
    FieldCheck("diagnostics", ["Diagnostics To Inspect", "Diagnostics"],
               r"(?im)diagnostic",
               "diagnostics"),
    FieldCheck("failure_modes", ["Failure Modes"],
               r"(?im)(failure\s*mode|prudence|instab|risque\b|danger\b|limitation)",
               "failure modes"),
    FieldCheck("related_pages", ["Related Pages"], None, "## Related Pages"),
]

MINIMAL_CHECKS = [FieldCheck("related_pages", ["Related Pages"], None, "## Related Pages")]

CHECKS_BY_TYPE = {
    "dataset": DATASET_CHECKS,
    "paper": PAPER_CHECKS,
    "estimator": ESTIMATOR_CHECKS,
    "analysis": MINIMAL_CHECKS,
    "source": MINIMAL_CHECKS,
    "concept": MINIMAL_CHECKS,
    "metadata": MINIMAL_CHECKS,
}

DATASET_ENRICHED_PATTERNS = [
    ("feature_selection block", r"(?im)^\s*feature_selection\s*:"),
    ("modeling_evidence block", r"(?im)^\s*modeling_evidence\s*:"),
    ("quality_pedigree block", r"(?im)^\s*quality_pedigree\s*:"),
]

DATASET_NON_NULL_FIELDS = [
    "Dataset name",
    "Source family",
    "Source URL",
    "License name",
    "License open",
    "Candidate Y variables",
    "Candidate Y typology",
    "Candidate X variables",
    "Candidate X typology",
    "Presence of imputed X",
    "Data type",
    "Structure",
    "N observations",
    "T periods",
    "N/T profile",
    "Spatial resolution",
    "Temporal resolution",
    "Spatial extent",
    "Time range",
]
DATASET_RECOMMENDED_NON_UNKNOWN_FIELDS = {
    "Candidate Y variables",
    "Candidate X variables",
    "Data type",
    "Structure",
    "Spatial resolution",
    "Temporal resolution",
    "Spatial extent",
}


@dataclass
class Tier1Result:
    passed: bool
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    entity_type: str = ""
    frontmatter: dict = field(default_factory=dict)


def _parse_scalar(value: str):
    value = value.strip()
    if value == "[]":
        return []
    if value.startswith("[") and value.endswith("]"):
        inner = value[1:-1].strip()
        return [item.strip().strip("'\"") for item in inner.split(",") if item.strip()]
    if value.lower() in {"true", "false"}:
        return value.lower() == "true"
    return value.strip("'\"")


def _parse_simple_yaml(text: str) -> dict:
    data = {}
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or ":" not in line:
            continue
        key, value = line.split(":", 1)
        data[key.strip()] = _parse_scalar(value)
    return data


def parse_frontmatter(text: str) -> tuple[dict | None, str]:
    if not text.startswith("---"):
        return None, text
    match = re.search(r"(?m)^---\s*$", text[3:])
    if not match:
        return None, text
    end = match.start() + 3
    fm_text = text[3:end].strip()
    try:
        fm = yaml.safe_load(fm_text) if yaml else _parse_simple_yaml(fm_text)
        return fm or {}, text[end + 3 :].strip()
    except Exception:
        return None, text


def get_sections(body: str) -> dict[str, str]:
    sections = {}
    matches = list(SECTION_RE.finditer(body))
    for index, match in enumerate(matches):
        title = match.group(1).strip()
        start = match.end()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(body)
        sections[title] = body[start:end].strip()
    return sections


def _detect_language(text: str) -> str:
    """Detect the dominant language of text. Returns 'en' on failure."""
    if _langdetect is None:
        return "en"
    try:
        return _langdetect(text[:800]) or "en"
    except Exception:
        return "en"


def _translate_section_titles(sections: dict[str, str], src_lang: str) -> dict[str, str]:
    """Return a copy of sections with titles translated to English.

    The section *content* is preserved unchanged so that pattern checks
    still run against the original text. Only the dict keys (titles) are
    translated, allowing section-name checks to work for any source language.
    Falls back to the original titles if the translator is unavailable or
    the network call fails.
    """
    if src_lang == "en" or _GoogleTranslator is None:
        return sections
    try:
        translator = _GoogleTranslator(source=src_lang, target="en")
        return {translator.translate(title): content for title, content in sections.items()}
    except Exception:
        return sections  # graceful fallback: keeps original titles


def _check_field(check: FieldCheck, sections: dict[str, str], body: str) -> bool:
    for section_name in check.sections:
        if section_name in sections and sections[section_name].strip():
            return True
    return bool(check.pattern and re.search(check.pattern, body, re.MULTILINE))


def _field_value(body: str, label: str) -> str | None:
    match = re.search(rf"(?im)^\s*(?:-\s*)?{re.escape(label)}\s*:\s*(.+?)\s*$", body)
    return match.group(1).strip() if match else None


def _section_value(body: str, title: str) -> str | None:
    pattern = rf"(?ims)^##\s+{re.escape(title)}\s*$\n(.*?)(?=^##\s+|\Z)"
    match = re.search(pattern, body)
    return match.group(1).strip() if match else None


def _field_or_section_value(body: str, label: str) -> str | None:
    return _field_value(body, label) or _section_value(body, label)


def _clean_value(value: str | None) -> str:
    if value is None:
        return ""
    value = value.strip().strip("`'\"")
    value = re.sub(r"\s+#.*$", "", value)
    return value.strip()


def _is_null_like(value: str | None) -> bool:
    return _clean_value(value).lower() in NULL_LIKE_VALUES


def _is_unknown_like(value: str | None) -> bool:
    cleaned = _clean_value(value).lower()
    return cleaned in UNKNOWN_LIKE_VALUES or any(token in cleaned for token in UNKNOWN_LIKE_VALUES)


def _has_declared_absent_doi(value: str | None) -> bool:
    return _clean_value(value).lower() in {"none", "null", "not available", "not_available", "no doi", "absent"}


def _field_contains_doi(value: str | None) -> bool:
    return bool(DOI_RE.search(_clean_value(value)))


def _check_backlinks(body: str, warnings: list[str]) -> None:
    all_pages = {path.stem for path in WIKI_ROOT.rglob("*.md")}
    for match in BACKLINK_RE.finditer(body):
        page = match.group(1).strip()
        if page not in all_pages:
            warnings.append(f"Backlink [[{page}]] does not match an existing wiki page")


def _check_typology_values(body: str, errors: list[str]) -> None:
    y_value = (_field_value(body, "Candidate Y typology") or "").lower()
    if y_value and "unknown" not in y_value and not any(t in y_value for t in Y_TYPES):
        errors.append(f"Candidate Y typology contains no allowed value: {', '.join(sorted(Y_TYPES))}")

    x_value = (_field_value(body, "Candidate X typology") or "").lower()
    if x_value and "unknown" not in x_value and not any(t in x_value for t in X_ROLE_TYPES):
        errors.append(f"Candidate X typology contains no allowed role: {', '.join(sorted(X_ROLE_TYPES))}")


def _check_regression_status_block(body: str, errors: list[str], warnings: list[str]) -> None:
    """Validate the '### Statut regression canonique' block (mission 2026-07).

    Skipped entirely when the block is absent (older fiches, or non-package
    dataset fiches that predate this convention) -- this is a progressive
    enrichment, not a mandatory field for every dataset fiche.
    """
    statut = _field_value(body, "Statut")
    evidence = _field_value(body, "Niveau de preuve")
    if statut is None and evidence is None:
        return

    statut_clean = _clean_value(statut).lower()
    evidence_clean = _clean_value(evidence).lower()

    if statut_clean and statut_clean not in {v.lower() for v in REGRESSION_STATUS_VALUES}:
        warnings.append(f"Statut regression canonique non reconnu: {statut!r}")
    if evidence_clean and evidence_clean not in {v.lower() for v in REGRESSION_EVIDENCE_VALUES}:
        warnings.append(f"Niveau de preuve non reconnu: {evidence!r}")

    ref_pub = _field_value(body, "Reference publication")
    formula_pub = _field_value(body, "formula_pub")

    # Une formule "verbatim" doit pointer vers une source identifiable. Une
    # reference bibliographique classique (auteur, annee, revue) sans DOI/URL
    # resolvable reste acceptable (ex: citation d'ouvrage) -- seule l'absence
    # totale de reference est bloquante ; l'absence de DOI/URL est un warning
    # (traceabilite amelioree mais pas obligatoire).
    if evidence_clean == "verbatim":
        if _is_null_like(ref_pub) or _is_unknown_like(ref_pub):
            errors.append(
                "Niveau de preuve 'verbatim' declare mais Reference publication est vide/pending"
            )
        elif not (DOI_RE.search(_clean_value(ref_pub)) or URL_RE.search(_clean_value(ref_pub))):
            warnings.append(
                f"Niveau de preuve 'verbatim' sans URL/DOI resolvable dans Reference "
                f"publication (citation bibliographique simple) : {ref_pub!r}"
            )

    # Un candidat par analogie doit etre etiquete comme tel de facon coherente
    # entre le champ Statut et le champ Niveau de preuve (jamais l'un sans l'autre).
    is_analogie_statut = "analogie" in statut_clean
    is_analogie_evidence = evidence_clean == "analogie"
    if is_analogie_statut != is_analogie_evidence:
        errors.append(
            "Incoherence 'candidat par analogie' : Statut et Niveau de preuve "
            f"doivent tous deux indiquer l'analogie (Statut={statut!r}, Niveau de preuve={evidence!r})"
        )

    # Un "bon candidat" doit avoir une formule documentee (pas none/pending).
    if statut_clean == "bon candidat" and (_is_null_like(formula_pub) or _is_unknown_like(formula_pub)):
        errors.append("Statut 'bon candidat' mais formula_pub est vide/none/pending")


def _check_quality_review_gate(body: str, warnings: list[str]) -> None:
    review_status = (_field_value(body, "review_status") or "").lower()
    proposed_by = (_field_value(body, "evaluator_proposed_by") or "").lower()
    human_required = (_field_value(body, "human_review_required") or "").lower()
    if proposed_by == "llm" and review_status == "reviewed":
        warnings.append("quality_pedigree: LLM-proposed records must not set review_status: reviewed")
    if proposed_by == "llm" and human_required not in {"", "true"}:
        warnings.append("quality_pedigree: LLM-proposed records should set human_review_required: true")


def _check_dataset_non_null_fields(body: str, errors: list[str], warnings: list[str]) -> None:
    for label in DATASET_NON_NULL_FIELDS:
        value = _field_value(body, label)
        if value is None or _is_null_like(value):
            errors.append(f"Critical dataset field is empty or null: {label}")
            continue
        if label in DATASET_RECOMMENDED_NON_UNKNOWN_FIELDS and _is_unknown_like(value):
            warnings.append(f"Dataset field still not enriched: {label} = {value}")

    doi_value = _field_value(body, "Dataset DOI")
    if doi_value is None:
        errors.append("Critical dataset field is missing: Dataset DOI")
    elif _has_declared_absent_doi(doi_value):
        warnings.append("Dataset DOI explicitly absent: verify that the source documents no DOI")
    elif not _field_contains_doi(doi_value):
        errors.append(f"Dataset DOI is not a valid DOI or explicit absence: {doi_value!r}")


def _check_paper_non_null_fields(body: str, errors: list[str], warnings: list[str]) -> None:
    for label in ("Paper title", "Source URL", "Abstract"):
        value = _field_or_section_value(body, label)
        if value is None or _is_null_like(value) or _is_unknown_like(value):
            errors.append(f"Critical scientific paper field is empty or not enriched: {label}")

    doi_value = _field_value(body, "Paper DOI") or _field_value(body, "DOI")
    if doi_value is None or _is_null_like(doi_value) or _is_unknown_like(doi_value):
        errors.append("Critical scientific paper field is empty: Paper DOI")
    elif not _field_contains_doi(doi_value):
        errors.append(f"Paper DOI is not a valid DOI: {doi_value!r}")

    related = (
        _field_value(body, "Related datasets")
        or _field_value(body, "Dataset DOI")
        or _field_value(body, "Dataset/archive DOI")
        or _field_value(body, "Dataset source URL")
    )
    if related is None or _is_null_like(related) or _is_unknown_like(related):
        warnings.append("Scientific paper has no documented linked dataset; check whether this is expected")

    modeling = _field_or_section_value(body, "Modeling Evidence")
    if modeling is None or _is_null_like(modeling) or _is_unknown_like(modeling):
        errors.append("Critical scientific paper field is empty or not enriched: Modeling Evidence")


def run(fiche_path: Path) -> Tier1Result:
    result = Tier1Result(passed=False)
    errors, warnings = result.errors, result.warnings

    if fiche_path.name in EXCLUDED_FILES:
        result.passed = True
        result.entity_type = "excluded"
        return result

    try:
        text = fiche_path.read_text(encoding="utf-8-sig")
    except OSError as exc:
        errors.append(f"Cannot read file: {exc}")
        return result

    frontmatter, body = parse_frontmatter(text)
    if frontmatter is None:
        errors.append("Frontmatter YAML absent or invalid")
        return result

    result.frontmatter = frontmatter
    entity_type = frontmatter.get("type", "")
    result.entity_type = entity_type

    if not frontmatter.get("title"):
        errors.append("Frontmatter field 'title' is missing or empty")
    if entity_type not in ALLOWED_TYPES:
        errors.append(f"Invalid frontmatter field 'type': {entity_type!r}")
    for date_field in ("created", "updated"):
        value = str(frontmatter.get(date_field, ""))
        if not DATE_RE.match(value):
            errors.append(f"Invalid frontmatter field '{date_field}': {value!r}; expected YYYY-MM-DD")
    if "sources" not in frontmatter:
        errors.append("Frontmatter field 'sources' is missing")
    if not frontmatter.get("tags"):
        warnings.append("Frontmatter field 'tags' is empty")

    first_line = next((line for line in body.splitlines() if line.strip()), "")
    if not first_line:
        errors.append("One-line summary is missing after frontmatter")

    sections = get_sections(body)
    doc_lang = _detect_language(body)
    sections_en = _translate_section_titles(sections, doc_lang)
    if doc_lang != "en":
        warnings.append(f"Document language detected: '{doc_lang}' — section titles translated to English for validation")

    for check in CHECKS_BY_TYPE.get(entity_type, MINIMAL_CHECKS):
        if not _check_field(check, sections_en, body):
            errors.append(f"Missing information: {check.description}")

    if entity_type == "dataset":
        _check_dataset_non_null_fields(body, errors, warnings)
        _check_typology_values(body, errors)
        _check_quality_review_gate(body, warnings)
        _check_regression_status_block(body, errors, warnings)
        for label, pattern in DATASET_ENRICHED_PATTERNS:
            if not re.search(pattern, body):
                warnings.append(f"Recommended enrichment missing: {label}")

        body_lower = body.lower()
        is_spatial = (
            bool(re.search(r"(?i)data\s*type\s*:.*spatial", body))
            or "spatio" in body_lower
            or bool(re.search(r"(?i)spatial\s*signal\s*:", body))
        )
        is_panel = bool(re.search(r"(?i)structure\s*:.*panel", body))
        if is_spatial:
            if not re.search(r"(?i)spatial\s*resolution\s*:\s*\S", body):
                errors.append("Spatial data detected but 'Spatial resolution:' is empty")
            if not re.search(r"(?i)spatial\s*extent\s*:\s*\S", body):
                errors.append("Spatial data detected but 'Spatial extent:' is empty")
        if is_panel and not re.search(r"(?i)T\s*periods?\s*:\s*\S", body):
            errors.append("Panel structure detected but 'T periods:' is empty")

    if entity_type == "paper":
        _check_paper_non_null_fields(body, errors, warnings)
        _check_quality_review_gate(body, warnings)

    _check_backlinks(body, warnings)
    result.passed = len(errors) == 0
    return result
