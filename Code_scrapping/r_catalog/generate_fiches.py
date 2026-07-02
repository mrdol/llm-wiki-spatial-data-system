#!/usr/bin/env python3
"""Generate dataset fiches from the unified sf metadata export.

Inputs:
  - data/sf_catalog_metadata.json, produced by export_sf_metadata.R
  - wiki/datasets/r_package_docs/<package>/topics/*.md for R help enrichment

Outputs:
  - wiki/datasets/packages/<dataset_id>.md

Schema: wiki/metadata/catalog_registry_schema_v3.md (Tier 1-compatible).
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
from datetime import date
from pathlib import Path
from typing import Any


TODAY = date.today().isoformat()

LLM_MODEL = "claude-sonnet-4-6"

LLM_SYSTEM_PROMPT = (
    "Tu es un assistant qui aide a preparer des datasets spatiaux pour du "
    "spatial machine learning (benchmarks d'estimateurs : GAM, GWR, RandomForest, "
    "XGBoost, etc.). On te donne la liste typee des colonnes d'un objet sf "
    "(hors coordonnees x/y et identifiants, deja exclus en amont). Ta tache : "
    "identifier quelles colonnes sont des candidates Y (variable reponse plausible) "
    "et quelles colonnes sont des candidates X (covariable explicative plausible). "
    "Tu n'es PAS oblige de classer toutes les colonnes : ignore les colonnes "
    "purement administratives ou redondantes (ex: codes de zone, noms de lieux, "
    "libelles geographiques) qui ne sont ni une cible ni une covariable utile. "
    "Une colonne ne peut pas etre a la fois Y et X. Reponds UNIQUEMENT avec un "
    "objet JSON de la forme : "
    '{"y_candidates": ["NOM1", ...], "x_candidates": ["NOM2", ...], '
    '"rationale": "1-2 phrases expliquant le choix"}. '
    "N'utilise que des noms de colonnes presents dans la liste fournie."
)

# Resolution manuelle des groupes suspects issus de sf_catalog_metadata.json.
CONFIRMED_KEEP = {
    "R_surveillance_hagelloch_hagelloch",    # spatio-temporel: 188 cas x pas de temps
    "R_surveillance_hagelloch_hagelloch.df", # spatial pur: 1 ligne par cas
    "R_gstat_jura_jura.pred",
    "R_gstat_jura_jura.val",
}
CONFIRMED_DISCARD = {
    "R_gstat_jura_prediction.dat",
    "R_gstat_jura_validation.dat",
}

DATASET_NOTES = {
    "R_surveillance_hagelloch_hagelloch": (
        "> **Note** - Version spatio-temporelle : 188 cas individuels x plusieurs pas de temps "
        "(N=70 500 lignes). Complementaire a `hagelloch.df`, version spatiale pure (N=188)."
    ),
    "R_surveillance_hagelloch_hagelloch.df": (
        "> **Note** - Version spatiale : 1 ligne par cas individuel (N=188). "
        "Complementaire a `hagelloch`, version spatio-temporelle (N=70 500)."
    ),
}

ADE4_NOTE = (
    "> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule "
    "sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.)."
)

# X typologies valides pour Tier 1
VALID_X_TYPES = {
    "continuous", "categorical", "spatial", "temporal",
    "lagged", "imputed", "identifier", "geometry", "timestamp", "unknown",
}

# Mapping des typologies statistiques (export_sf_metadata.R) vers les roles X
# valides du schema Tier 1 (qui n'a pas de notion "count"/"binary"/"rate").
X_TYPOLOGY_TO_ROLE = {
    "count": "continuous",
    "binary": "categorical",
    "rate": "continuous",
}


def repo_root() -> Path:
    here = Path(__file__).resolve()
    for parent in (here.parent, *here.parents):
        if (parent / ".git").exists() and (parent / "wiki").exists():
            return parent
    raise RuntimeError("Impossible de trouver la racine du repo llm-wiki-karpathy.")


def load_json(path: Path) -> dict[str, Any]:
    raw = path.read_bytes()
    end = raw.find(b"\x00")
    if end != -1:
        raw = raw[:end]
    return json.loads(raw.decode("utf-8"))


def load_cache(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError):
        return {}


def save_cache(path: Path, cache: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(cache, indent=2, ensure_ascii=False), encoding="utf-8", newline="\n")


def variables_fingerprint(variables: list[dict[str, Any]]) -> str:
    sig = "|".join(sorted(f"{v['name']}:{v['typology']}" for v in variables))
    return hashlib.sha256(sig.encode("utf-8")).hexdigest()[:16]


def classify_yx_llm(
    did: str,
    variables: list[dict[str, Any]],
    intro: str,
    cache: dict[str, Any],
    client: Any,
    refresh: bool,
) -> dict[str, Any]:
    """Demande au LLM de selectionner les candidats Y/X parmi `variables`.

    Resultat mis en cache par dataset_id + empreinte des colonnes/typologies,
    pour eviter de rappeler le LLM a chaque regeneration de fiche.
    """
    if not variables:
        return {"y_candidates": [], "x_candidates": [], "rationale": "Aucune variable disponible."}

    fp = variables_fingerprint(variables)
    cache_key = f"{did}::{fp}"
    if not refresh and cache_key in cache:
        return cache[cache_key]

    if client is None:
        return {"y_candidates": [], "x_candidates": [], "rationale": "LLM non disponible (ANTHROPIC_API_KEY absent)."}

    var_lines = "\n".join(
        f"- {v['name']} (classe={v['class']}, typologie={v['typology']}, "
        f"plage={v.get('range') or 'NA'}, NA={v['pct_na']}%)"
        for v in variables
    )
    user_prompt = (
        f"Description du dataset : {intro}\n\n"
        f"Colonnes disponibles ({len(variables)}) :\n{var_lines}\n\n"
        "Identifie les candidats Y et X selon les regles du system prompt."
    )

    try:
        response = client.messages.create(
            model=LLM_MODEL,
            max_tokens=4096,
            system=LLM_SYSTEM_PROMPT,
            messages=[{"role": "user", "content": user_prompt}],
        )
        raw_text = (response.content[0].text or "").strip()
        match = re.search(r"\{[\s\S]+\}", raw_text)
        if not match:
            raise ValueError(f"Reponse LLM non parseable: {raw_text[:200]}")
        result = json.loads(match.group())
    except Exception as exc:  # noqa: BLE001 - on degrade proprement
        print(f"  WARN LLM  {did}: {exc}", file=sys.stderr)
        result = {"y_candidates": [], "x_candidates": [], "rationale": f"Erreur LLM: {exc}"}

    valid_names = {v["name"] for v in variables}
    result["y_candidates"] = [n for n in result.get("y_candidates", []) if n in valid_names]
    result["x_candidates"] = [
        n for n in result.get("x_candidates", []) if n in valid_names and n not in result["y_candidates"]
    ]
    cache[cache_key] = result
    return result


# Correspondance Python<->R : datasets identiques distribues sous deux
# enveloppes de package differentes pour un meme jeu de donnees sous-jacent.
# Alimentee/maintenue au fil des decouvertes (voir mission formules de
# regression 2026-07, tools/regression_formulas_2026-07/regression_findings.py
# pour le detail des sources ayant motive chaque paire).
PYTHON_R_HOMOLOGS: dict[str, str] = {
    "Python_libpysal_georgia": "R_GWmodel_GeorgiaCounties_Gedu.counties",
    "R_GWmodel_GeorgiaCounties_Gedu.counties": "Python_libpysal_georgia",
    "R_GWmodel_LondonBorough_londonborough": "R_GWmodel_LondonHP_londonhp",
    "R_GWmodel_LondonHP_londonhp": "R_GWmodel_LondonBorough_londonborough",
    "R_agridat_lasrosas.corn_lasrosas.corn": "Python_geodatasets_geoda.lasrosas",
    "Python_geodatasets_geoda.lasrosas": "R_agridat_lasrosas.corn_lasrosas.corn",
    "R_sp_meuse_meuse": "R_gstat_meuse.all_meuse.all",
    "R_gstat_meuse.all_meuse.all": "R_sp_meuse_meuse",
    "R_spdep_oldcol_COL.OLD": "Python_geodatasets_spdata.columbus",
    "Python_geodatasets_spdata.columbus": "R_spdep_oldcol_COL.OLD",
}

_FORMULA_PUB_RE = re.compile(r"(?im)^-\s*formula_pub\s*:\s*(.+?)\s*$")
_REGRESSION_STATUS_RE = re.compile(r"(?im)^-\s*Statut\s*:\s*(.+?)\s*$")
_REGRESSION_EVIDENCE_RE = re.compile(r"(?im)^-\s*Niveau de preuve\s*:\s*(.+?)\s*$")
_REGRESSION_METHOD_RE = re.compile(r"(?im)^-\s*Methode d'estimation\s*:\s*(.+?)\s*$")
_REFERENCE_PUB_RE = re.compile(r"(?im)^-\s*Reference publication\s*:\s*(.+?)\s*$")


def find_homolog_formula(did: str, wiki_out: Path) -> dict[str, str] | None:
    """Cherche si un homologue Python/R de `did` a deja une fiche avec formule.

    Retourne un dict {formula, status, evidence, method, source, homolog_id}
    si l'homologue existe et porte une formule non 'pending'/'none', sinon None.
    Tache 3 (mission 2026-07) : propager systematiquement la formule vers la
    fiche de l'autre langage plutot que de la re-chercher independamment.
    """
    homolog_id = PYTHON_R_HOMOLOGS.get(did)
    if not homolog_id:
        return None
    homolog_path = wiki_out / f"{homolog_id}.md"
    if not homolog_path.exists():
        return None
    text = homolog_path.read_text(encoding="utf-8-sig")
    m = _FORMULA_PUB_RE.search(text)
    if not m:
        return None
    formula = m.group(1).strip()
    if not formula or formula.lower().startswith(("pending", "none")):
        return None
    status_m = _REGRESSION_STATUS_RE.search(text)
    evidence_m = _REGRESSION_EVIDENCE_RE.search(text)
    method_m = _REGRESSION_METHOD_RE.search(text)
    source_m = _REFERENCE_PUB_RE.search(text)
    return {
        "formula": formula,
        "status": (status_m.group(1).strip() if status_m else "a verifier"),
        "evidence": (evidence_m.group(1).strip() if evidence_m else "n/a"),
        "method": (method_m.group(1).strip() if method_m else "n/a"),
        "source": (source_m.group(1).strip() if source_m else "n/a"),
        "homolog_id": homolog_id,
    }


OPEN_LICENSE_KEYWORDS = ("mit", "bsd", "gpl", "cc0", "apache", "cecill", "lgpl", "artistic", "mpl")


def license_is_open(license_name: str | None) -> str:
    if not license_name:
        return "unknown"
    lowered = license_name.lower()
    return "yes" if any(kw in lowered for kw in OPEN_LICENSE_KEYWORDS) else "unknown"


def first_existing(paths: list[Path]) -> Path | None:
    for path in paths:
        if path.exists():
            return path
    return None


def find_doc(wiki_doc: Path, package: str, dataset: str) -> Path | None:
    base_dir = wiki_doc / package / "topics"
    if not base_dir.is_dir():
        return None
    base = re.split(r"\.(df|pred|val|dat|c|sf)$", dataset.lower())[0]
    candidates = [dataset, dataset.lower(), base]
    return first_existing([base_dir / f"{name}.md" for name in candidates])


def parse_doc(path: Path | None) -> dict[str, str | None]:
    if not path:
        return {"description": None, "y_hint": None, "references": None, "version": None, "epsg": None}
    text = path.read_text(encoding="utf-8", errors="replace")

    version_match = re.search(r"\(version ([0-9.]+)\)", text)
    version = version_match.group(1) if version_match else None

    desc_match = re.search(
        r"Description\s*\n+\s*(.*?)(?:\n\s*\n|\nFormat|\nUsage|\nArguments|\nValue)",
        text, re.DOTALL,
    )
    description = None
    if desc_match:
        raw = " ".join(desc_match.group(1).split())
        description = raw[:350].rstrip(",") + ("..." if len(raw) > 350 else "")

    y_hint = None
    for pattern in (
        r"(median value[s]? of [^.\n]+)",
        r"(response (?:variable )?is [^.\n]+)",
        r"(number of (?:cases|deaths|events)[^.\n]+)",
        r"(dependent variable[^.\n]+)",
        r"(Y(?:\s+variable)? is (?:the |a )?[^.\n]+)",
    ):
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            y_hint = " ".join(match.group(1).split())
            break

    ref_match = re.search(r"References\s*\n+(.*?)(?:\n\s*\n\s*[A-Z][a-z]|\Z)", text, re.DOTALL)
    references = None
    if ref_match:
        references = " ".join(ref_match.group(1).split())[:400]

    # CRS explicitement documente dans le texte d'aide (ex: "EPSG:32717" ou
    # "EPSG: 4326") -- repli deterministe quand le .rds lui-meme n'a pas de
    # CRS embarque (sf::st_crs() renvoie NA).
    epsg_match = re.search(r"EPSG:?\s*(\d{4,5})", text, re.IGNORECASE)
    epsg = epsg_match.group(1) if epsg_match else None

    return {"description": description, "y_hint": y_hint, "references": references,
            "version": version, "epsg": epsg}


def make_fiche(
    entry: dict[str, Any],
    doc: dict[str, str | None],
    cache: dict[str, Any],
    client: Any,
    refresh_llm: bool,
    wiki_out: Path | None = None,
) -> str:
    did = entry["dataset_id"]
    package = entry["package"]
    dataset = entry.get("dataset", did)
    source_lang = str(entry.get("source_lang") or "R").lower()

    b1 = entry["bloc1"]
    b4 = entry["bloc4"]
    b5 = entry["bloc5"]
    qc = entry.get("qc", {})
    bbox = b5.get("bbox", {})

    # Tags
    geom_tag = (b5.get("geom_type") or "geometry").lower()
    lang_tag = "python-package" if source_lang == "python" else "r-package"
    tags = f"[dataset, {lang_tag}, spatial, {geom_tag}]"

    # Intro
    version = doc.get("version")
    if source_lang == "python":
        source_family = "python-package"
        source_url = f"https://pypi.org/project/{package}/"
        source_label = f"package Python `{package}`"
    else:
        source_family = "r-package"
        source_url = f"https://CRAN.R-project.org/package={package}"
        source_label = f"package R `{package}`"
    if version:
        source_label_versioned = f"{source_label} (version {version})"
    else:
        source_label_versioned = source_label

    intro = doc.get("description") or f"Dataset spatial issu du {source_label} (`{dataset}`)."

    # External enrichment (enrich_web.py) — package license/year (deterministic,
    # PyPI/CRAN APIs) and publication DOI/formula (LLM + web_search, cached).
    pkg_meta = cache.get("package_metadata", {}).get(f"{source_lang}::{package}", {})
    web_meta = cache.get("web_enrichment", {}).get(did, {})

    license_name = pkg_meta.get("license")
    year_value = pkg_meta.get("year") or "unknown"
    pub_doi = web_meta.get("publication_doi") or "pending"
    pub_ref = web_meta.get("reference_publication") or doc.get("references") or "pending"
    pub_formula = web_meta.get("formula_pub") or "pending"
    pub_x_terms = ", ".join(web_meta.get("x_terms_pub") or []) or "pending"
    pub_y_term = web_meta.get("y_term_pub") or "pending"

    # Y/X candidates — selected by LLM (claude-sonnet-4-6) from the unified,
    # statistically-typed variable list (no Y/X presupposition at script level).
    all_vars = b1.get("variables", [])
    var_by_name = {v["name"]: v for v in all_vars}
    llm_result = classify_yx_llm(did, all_vars, intro, cache, client, refresh_llm)
    llm_rationale = llm_result.get("rationale") or "n/a"

    y_cands = [var_by_name[n] for n in llm_result.get("y_candidates", []) if n in var_by_name]
    y_vars = [c["name"] for c in y_cands]
    y_types = list(dict.fromkeys(c["typology"] for c in y_cands))
    if y_vars:
        y_vars_str = ", ".join(f"`{v}`" for v in y_vars)
        y_types_str = ", ".join(y_types)
    else:
        y_vars_str = "not identified by LLM classification — manual review required"
        y_types_str = "unknown"

    # X candidates — remap invalid typologies
    # Convention CONTEXT.md: x/y coordinates and identifier columns are NOT
    # candidate covariates — they are reported separately (coord_cands / id_cands).
    x_cands = [var_by_name[n] for n in llm_result.get("x_candidates", []) if n in var_by_name]
    x_vars = [c["name"] for c in x_cands]
    x_types = list(dict.fromkeys(
        c["typology"] if c["typology"] in VALID_X_TYPES
        else X_TYPOLOGY_TO_ROLE.get(c["typology"], "categorical")
        for c in x_cands
    ))
    if x_vars:
        x_vars_str = ", ".join(f"`{v}`" for v in x_vars)
        x_types_str = ", ".join(x_types)
    else:
        x_vars_str = "not identified by LLM classification — manual review required"
        x_types_str = "unknown"

    coord_cands = b1.get("coordinate_columns", [])
    id_cands = b1.get("identifier_columns", [])
    coord_str = ", ".join(f"`{c['name']}`" for c in coord_cands) or "none detected"
    id_str = ", ".join(f"`{c['name']}`" for c in id_cands) or "none detected"

    # Y/X detail tables
    y_rows = "".join(
        f"| `{y['name']}` | `{y['class']}` | {y['typology']} | {y['range']} | {y['pct_na']}% |\n"
        for y in y_cands
    ) or "| — | — | aucun candidat detecte | — | — |\n"
    x_rows = "".join(
        f"| `{x['name']}` | `{x['class']}` | {x['typology']} | {x['pct_na']}% |\n"
        for x in x_cands
    ) or "| — | — | aucun candidat | — |\n"

    # Y note from doc
    y_note = ""
    if doc.get("y_hint"):
        y_note = f"\n> Note doc : {doc['y_hint']}\n"
    if package == "ade4":
        y_note += f"\n{ADE4_NOTE}\n"
    if did in DATASET_NOTES:
        y_note += f"\n{DATASET_NOTES[did]}\n"
    y_note += f"\n> Selection Y/X ({LLM_MODEL}) : {llm_rationale}\n"

    # Formula
    has_formule = b1.get("has_formule_in_catalogue")
    formula_note = " (referencee dans catalogue)" if has_formule else ""

    # Statut regression canonique (Tache 1-4, mission 2026-07) -- propagation
    # automatique depuis un homologue Python/R si sa fiche existe deja et
    # porte une formule non-pending (Tache 3), et seulement si web_meta n'a
    # pas deja fourni de formule. Sinon, tout reste "pending" : la recherche
    # manuelle / le jugement d'analogie restent une decision explicite du LLM
    # ou de l'utilisateur au moment de la revue, jamais une regle de
    # similarite textuelle automatique (voir skill enrich-metadata).
    homolog_result = find_homolog_formula(did, wiki_out) if wiki_out else None
    if homolog_result and pub_formula == "pending":
        pub_formula = homolog_result["formula"]
        pub_ref = homolog_result["source"]
        if "~" in pub_formula:
            pub_y_term, pub_x_terms = (part.strip() for part in pub_formula.split("~", 1))
        regression_status = homolog_result["status"]
        regression_evidence = homolog_result["evidence"]
        regression_method = homolog_result["method"]
        regression_homolog = homolog_result["homolog_id"]
        regression_note = (
            f"Formule identifiee via la documentation du package equivalent "
            f"`{homolog_result['homolog_id']}` -- meme jeu de donnees sous-jacent "
            f"(propagation automatique Tache 3, a confirmer par revue manuelle)."
        )
    else:
        regression_status = "pending"
        regression_evidence = "n/a"
        regression_method = "n/a"
        regression_homolog = PYTHON_R_HOMOLOGS.get(did, "aucune identifiee")
        regression_note = "n/a"

    # Spatiotemporal
    N = b4.get("N")
    T = b4.get("T", 1)
    profil_nt = b4.get("profil_nt", "unknown")
    data_type = b4.get("data_type", "spatial")
    structure = b4.get("structure", "coupe_transversale")
    t_var = b4.get("T_var") or "none"

    geom_type = b5.get("geom_type") or ""
    gt_up = geom_type.upper()
    if "MULTIPOINT" in gt_up or ("POINT" in gt_up and "POLYGON" not in gt_up):
        spatial_res = "point observation"
    elif "MULTIPOLYGON" in gt_up or "POLYGON" in gt_up:
        spatial_res = "areal unit (polygon)"
    elif "LINE" in gt_up:
        spatial_res = "linear feature"
    else:
        spatial_res = f"spatial feature ({geom_type})" if geom_type else "unknown"

    if T == 1:
        temporal_res = "not applicable (cross-sectional dataset)"
        time_range_str = "not applicable (cross-sectional dataset)"
    else:
        temporal_res = "pending inspection"
        time_range_str = "pending inspection"

    crs = b5.get("crs_epsg") or "unknown"
    if crs == "NA_pending_lookup":
        doc_epsg = doc.get("epsg")
        if doc_epsg:
            crs = doc_epsg
            crs_display = f"{doc_epsg} (source: documentation du package, .rds sans CRS embarque)"
            spatial_extent = (
                f"x [{bbox.get('xmin')}, {bbox.get('xmax')}], "
                f"y [{bbox.get('ymin')}, {bbox.get('ymax')}] (EPSG:{doc_epsg}, via documentation)"
            )
        else:
            crs_display = "unknown [lookup required]"
            spatial_extent = (
                f"x [{bbox.get('xmin')}, {bbox.get('xmax')}], "
                f"y [{bbox.get('ymin')}, {bbox.get('ymax')}] (CRS unknown)"
            )
    else:
        crs_display = crs
        spatial_extent = (
            f"x [{bbox.get('xmin')}, {bbox.get('xmax')}], "
            f"y [{bbox.get('ymin')}, {bbox.get('ymax')}] (EPSG:{crs})"
        )

    crs_name = b5.get("crs_name") or "unknown"
    ca = b5.get("crs_analyse_recommande") or {}
    ca_epsg = ca.get("epsg") or "pending"
    ca_label = ca.get("label") or "pending"
    ca_note_str = ca.get("note") or ""
    if ca_label != "pending":
        crs_analyse = f"{ca_epsg} ({ca_label})"
        if ca_note_str:
            crs_analyse += f" — {ca_note_str}"
    else:
        crs_analyse = f"pending — {ca_note_str}" if ca_note_str else "pending"

    # QC block
    qc_lines = []
    if qc.get("vars_high_na"):
        qc_lines.append(f"WARN: Variables avec NA > 20% : {', '.join(qc['vars_high_na'])}")
    if qc.get("crs_missing"):
        qc_lines.append("WARN: CRS absent — lookup EPSG necessaire.")
    if qc.get("geom_complex"):
        qc_lines.append("WARN: Geometrie heterogene (GEOMETRYCOLLECTION) — a homogeneiser.")
    qc_block = "\n".join(qc_lines) if qc_lines else "Aucune anomalie detectee."

    return f"""\
---
title: {did}
type: dataset
created: {TODAY}
updated: {TODAY}
sources:
  - {entry["rds_path"]}
tags: {tags}
---

{intro}

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: {y_vars_str}
- Candidate Y typology: {y_types_str}
- Candidate X variables: {x_vars_str}
- Candidate X typology: {x_types_str}
- Coordinates (x, y — excluded from X candidates): {coord_str}
- Identifier columns (excluded from X candidates): {id_str}
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
{y_rows}
{y_note}
#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
{x_rows}

### Formule — niveau publication

- formula_pub: {pub_formula}{formula_note}
- x_terms_pub: {pub_x_terms}
- y_term_pub: {pub_y_term}
- Reference publication: {pub_ref}

### Statut regression canonique

- Statut: {regression_status}
- Niveau de preuve: {regression_evidence}
- Methode d'estimation: {regression_method}
- Correspondance Python/R: {regression_homolog}
- Note: {regression_note}

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `{did}`
- Dataset name: {package}::{dataset}
- Source family: {source_family}
- Source: {source_label_versioned}
- Source URL: {source_url}
- Dataset DOI: none
- Publication DOI: {pub_doi}
- Year: {year_value}

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: {"true" if regression_status not in ("pending", "mauvais candidat") else "false"}
  equation_text: "{pub_formula if pub_formula != 'pending' else 'null'}"
  equation_family: unknown
  model_family: "{regression_method}"
  source_type: unknown
  source_ref: "{pub_ref if pub_ref != 'pending' else 'null'}"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: {data_type}
- Structure: {structure}
- N observations: {N}
- T periods: {T}
- Variable temporelle: {t_var}
- N/T profile: {profil_nt}

## Bloc 5 — Resolution et etendue

- Spatial resolution: {spatial_res}
- Temporal resolution: {temporal_res}
- Spatial extent: {spatial_extent}
- Time range: {time_range_str}
- Type de geometrie: {geom_type}
- CRS EPSG: {crs_display}
- CRS nom: {crs_name}
- CRS analyse recommande: {crs_analyse}

## Bloc 6 — Reproductibilite

- License present: {"yes" if license_name else "unknown"}
- License name: {license_name or "unknown"}
- License URL: {source_url if license_name else "unknown"}
- License open: {license_is_open(license_name)}
- Reproducibility status: available via {source_label}
- Code available: yes (package examples and vignettes)
- Repository: {source_family}

## Quality Control

{qc_block}

## Related Pages

- Source: {source_label}
"""


def should_keep(entry: dict[str, Any]) -> bool:
    did = entry["dataset_id"]
    if did in CONFIRMED_DISCARD:
        return False
    if did in CONFIRMED_KEEP:
        return True
    return entry.get("status") in ("ok", None, "")


def parse_args() -> argparse.Namespace:
    root = repo_root()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json-in", type=Path, default=root / "data" / "sf_catalog_metadata.json")
    parser.add_argument("--wiki-doc", type=Path, default=root / "wiki" / "datasets" / "r_package_docs")
    parser.add_argument("--wiki-out", type=Path, default=root / "wiki" / "datasets" / "packages")
    parser.add_argument("--overwrite", action="store_true", help="regenerer les fiches existantes")
    parser.add_argument("--dry-run", action="store_true", help="afficher le bilan sans ecrire")
    parser.add_argument("--llm-cache", type=Path, default=root / "data" / "yx_llm_cache.json")
    parser.add_argument("--no-llm", action="store_true", help="desactiver la classification Y/X par LLM")
    parser.add_argument("--refresh-llm", action="store_true", help="ignorer le cache LLM et rappeler le modele")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    data = load_json(args.json_in)
    args.wiki_out.mkdir(parents=True, exist_ok=True)

    try:
        from dotenv import load_dotenv
        load_dotenv(repo_root() / ".env")
    except ImportError:
        pass

    cache = load_cache(args.llm_cache)
    client = None
    if not args.no_llm:
        api_key = os.environ.get("ANTHROPIC_API_KEY")
        if not api_key:
            print("  WARN: ANTHROPIC_API_KEY absent — classification Y/X par LLM desactivee.", file=sys.stderr)
        else:
            try:
                import anthropic
                client = anthropic.Anthropic(api_key=api_key)
            except ImportError:
                print("  WARN: package 'anthropic' absent — classification Y/X par LLM desactivee.", file=sys.stderr)

    n_ok = n_skip = n_discard = n_nodoc = 0
    for entry in data.get("datasets", []):
        did = entry["dataset_id"]

        if not should_keep(entry):
            n_discard += 1
            print(f"  ECARTE  {did}")
            continue

        package = entry["package"]
        dataset = entry.get("dataset", did)
        doc_path = find_doc(args.wiki_doc, package, dataset)
        if not doc_path:
            n_nodoc += 1
        doc = parse_doc(doc_path)

        out_path = args.wiki_out / f"{did}.md"
        if out_path.exists() and not args.overwrite:
            n_skip += 1
            print(f"  SKIP    {did}")
            continue

        content = make_fiche(entry, doc, cache, client, args.refresh_llm, wiki_out=args.wiki_out)

        if not args.dry_run:
            out_path.write_text(content, encoding="utf-8", newline="\n")
            save_cache(args.llm_cache, cache)
        n_ok += 1
        doc_note = f"(doc: {doc_path.name})" if doc_path else "(sans doc)"
        action = "WOULD" if args.dry_run else "OK"
        print(f"  {action:<7} {did} {doc_note}")

    print("\n=== BILAN ===")
    print(f"  Generes  : {n_ok}")
    print(f"  Sautes   : {n_skip}")
    print(f"  Ecartes  : {n_discard}")
    print(f"  Sans doc : {n_nodoc}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
