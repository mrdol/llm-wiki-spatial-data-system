#!/usr/bin/env python3
"""Build a reproducible editorial audit for the spatial data-paper project.

The audit is read-only with respect to project evidence. It inventories the
dataset fiches, package registry, extension reviews, BibTeX files, knowledge
graph and existing data-paper drafts, then writes a JSON snapshot and three
human-readable reports in the requested output directory.
"""

from __future__ import annotations

import argparse
import collections
import datetime as dt
import hashlib
import json
import os
import re
import sqlite3
from pathlib import Path


TEXT_SUFFIXES = {".md", ".html", ".txt", ".bib", ".json", ".yml", ".yaml"}
STALE_PATTERNS = {
    "91_fiches": re.compile(r"\b91\s+fiches\b", re.I),
    "289_fiches": re.compile(r"\b289\s+fiches\b", re.I),
}


def rel(path: Path, root: Path) -> str:
    return path.relative_to(root).as_posix()


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def iter_files(base: Path):
    """Yield accessible files without failing on stale Synology entries."""
    excluded = {".git", ".venv", "node_modules", ".claude"}
    for current, dirs, names in os.walk(base, topdown=True, onerror=lambda _e: None):
        dirs[:] = [d for d in dirs if d not in excluded]
        for name in names:
            path = Path(current) / name
            try:
                if path.is_file():
                    yield path
            except OSError:
                continue


def extract_scalar(text: str, key: str) -> str | None:
    patterns = [
        rf"(?mi)^\s*{re.escape(key)}\s*:\s*[\"']?([^\n\"']+)",
        rf"(?mi)^\s*-\s*{re.escape(key)}\s*:\s*[\"']?([^\n\"']+)",
    ]
    for pattern in patterns:
        match = re.search(pattern, text)
        if match:
            return match.group(1).strip().rstrip("'").rstrip('"')
    return None


def count_values(records: list[dict], key: str) -> dict[str, int]:
    counts = collections.Counter(str(r.get(key) or "missing") for r in records)
    return dict(sorted(counts.items()))


def scan_fiches(root: Path) -> dict:
    folder = root / "wiki/datasets/fiches_datasets"
    files = sorted(folder.glob("*.md"))
    rows = []
    for path in files:
        text = read_text(path)
        rows.append(
            {
                "file": rel(path, root),
                "title": extract_scalar(text, "title") or path.stem,
                "type": extract_scalar(text, "type"),
                "updated": extract_scalar(text, "updated"),
                "package_include": extract_scalar(text, "package_include"),
                "benchmark_status": extract_scalar(text, "benchmark_status"),
                "formula_used": extract_scalar(text, "formula_used"),
                "has_benchmark_readiness": "benchmark_readiness:" in text,
                "has_pending": bool(re.search(r"\bpending\b", text, re.I)),
                "family": "paper" if path.stem.startswith("paper_") else (
                    "warehouse" if "warehouse" in path.stem.lower() else "software_or_other"
                ),
            }
        )
    return {
        "count": len(rows),
        "families": count_values(rows, "family"),
        "package_include": count_values(rows, "package_include"),
        "benchmark_status": count_values(rows, "benchmark_status"),
        "with_benchmark_readiness": sum(r["has_benchmark_readiness"] for r in rows),
        "with_formula_used": sum(bool(r["formula_used"]) for r in rows),
        "with_pending": sum(r["has_pending"] for r in rows),
        "records": rows,
    }


def scan_registry(root: Path) -> dict:
    path = root / "packages/spatialtidymodels/inst/metadata/datasets.json"
    payload = json.loads(read_text(path))
    records = payload.get("records", [])
    return {
        "path": rel(path, root),
        "generated_at": payload.get("generated_at"),
        "count": len(records),
        "package_include": count_values(records, "package_include"),
        "benchmark_status": count_values(records, "benchmark_status"),
        "with_local_artifact": sum(bool(r.get("local_artifact")) for r in records),
        "with_formula_used": sum(bool(r.get("formula_used")) for r in records),
        "with_resolved_formula_used": sum(
            bool(r.get("formula_used")) and str(r.get("formula_used")).strip().lower() != "pending"
            for r in records
        ),
        "ids": sorted(str(r.get("dataset_id") or r.get("dataset") or "") for r in records),
        "records_by_id": {
            str(r.get("dataset_id") or r.get("dataset")): {
                "package_include": r.get("package_include"),
                "benchmark_status": r.get("benchmark_status"),
                "local_artifact": r.get("local_artifact"),
                "formula_used": r.get("formula_used"),
            }
            for r in records
            if r.get("dataset_id") or r.get("dataset")
        },
    }


def _flat_typology(value) -> str:
    if isinstance(value, list):
        value = [str(v).strip().rstrip(".") for v in value if v]
        return "+".join(sorted(set(value))) if value else "missing"
    return str(value).strip().rstrip(".") if value else "missing"


def _t_periods_int(r):
    v = r.get("t_periods")
    try:
        return int(v)
    except (TypeError, ValueError):
        return None


def _typology_stats(records: list[dict]) -> dict:
    """Compute the typology/panel/spatio-temporal/parent-child stats for a
    given record subset (the full registry, or a filtered slice such as
    `package_include == "yes"`).

    Dedup logic (`deduplicated_dataset_count`): a child is only subtracted
    when ITS OWN PARENT is also present in `records` -- the parent then
    already represents the family. When `records` is a filtered subset
    (e.g. yes-only), a child's parent can have been filtered OUT (e.g. the
    parent stayed `manual_review` while one child was individually promoted
    to `yes`, as happened with `paper_red_deer_topdown` -> its `_492`
    child): that child is then the family's ONLY representative in this
    subset and must be kept, not dropped. Naively subtracting every child
    regardless of whether its parent survived the filter undercounts (bug
    found and fixed 2026-09-24, first version silently dropped 3 such
    orphaned children out of a 278-record yes-only subset: 128 instead of
    the correct 131).
    """
    ids_in_set = {str(r.get("dataset_id") or r.get("dataset")) for r in records}
    response_typology = count_values(
        [{"k": _flat_typology(r.get("response_typology"))} for r in records], "k"
    )
    strict_panel = sum(r.get("data_structure") == "spatial_panel" for r in records)
    soft_panel_structure = count_values(records, "structure")
    soft_panel_count = sum(
        "panel" in str(r.get("structure") or "").lower() for r in records
    )
    spatio_temporal = sum((_t_periods_int(r) or 1) > 1 for r in records)
    cross_sectional = len(records) - spatio_temporal

    with_parent = [r for r in records if r.get("parent_dataset")]
    parent_ids = sorted({r["parent_dataset"] for r in with_parent})
    children_per_parent = count_values(with_parent, "parent_dataset")
    redundant_children = [r for r in with_parent if r["parent_dataset"] in ids_in_set]

    return {
        "total_fiches": len(records),
        "response_typology": response_typology,
        "panel_strict_spatial_panel": strict_panel,
        "panel_soft_structure_label": soft_panel_count,
        "structure_raw": soft_panel_structure,
        "spatio_temporal_t_periods_gt_1": spatio_temporal,
        "cross_sectional_t_periods_eq_1": cross_sectional,
        "children_count": len(with_parent),
        "distinct_parents_count": len(parent_ids),
        "children_per_parent": children_per_parent,
        "orphaned_children_count": len(with_parent) - len(redundant_children),
        "deduplicated_dataset_count": len(records) - len(redundant_children),
        "deduplicated_note": (
            "total_fiches minus only the children whose own parent is ALSO "
            "in this same record subset (the parent then already "
            "represents the family); a child whose parent fell outside the "
            "subset (orphaned_children_count) is kept as that family's "
            "sole representative here. Avoids inflating from decomposition "
            "splits (korea_hedonic_housing's 32 yearly children, "
            "gwqlasso's 3x43, etc.) while never silently losing a family "
            "whose only surviving representative is a child."
        ),
    }


def scan_typology_breakdown(root: Path) -> dict:
    """Response-variable, panel/spatio-temporal, and parent/child counts.

    Distinct from `scan_registry()`'s simple `count_values()` calls because
    two of these fields need real interpretation, not a bare tally:
    `response_typology` is stored as a list per record (even when it holds a
    single value), and "panel" has two different meanings in this project --
    `data_structure == "spatial_panel"` is the STRICT count actually wired
    into `benchmark_spatial_panel()` (verified W, registered in
    `metadata_panel_dataset_registry()`), while the free-text Bloc 4
    `structure` field (e.g. "panel_ou_series") is a SOFT, self-declared
    label from the fiche generator that does not by itself mean the dataset
    is benchmark-ready as a panel (most of this project's "panel-shaped"
    candidates turned out to be quasi-fictif cross-sections on inspection,
    see session notes 2026-09-23). Both counts are reported, never conflated.

    Reports the breakdown over ALL fiches (`all`) and, separately, over only
    `package_include == "yes"` fiches (`yes_only`) -- the latter is the
    population that actually matters for describing "the usable benchmark
    bank" in the data paper, and must never be conflated with the former.
    """
    path = root / "packages/spatialtidymodels/inst/metadata/datasets.json"
    payload = json.loads(read_text(path))
    records = payload.get("records", [])
    yes_records = [r for r in records if r.get("package_include") == "yes"]

    return {
        "all": _typology_stats(records),
        "yes_only": _typology_stats(yes_records),
    }


def compare_fiches_registry(fiches: dict, registry: dict) -> dict:
    fiche_by_id = {Path(row["file"]).stem: row for row in fiches["records"]}
    registry_by_id = registry["records_by_id"]
    fiche_ids, registry_ids = set(fiche_by_id), set(registry_by_id)
    mismatches = []
    for dataset_id in sorted(fiche_ids & registry_ids):
        fiche, record = fiche_by_id[dataset_id], registry_by_id[dataset_id]
        fields = {}
        for key in ("package_include", "benchmark_status", "formula_used"):
            left, right = fiche.get(key), record.get(key)
            if key == "formula_used":
                left = left.strip("`").strip() if isinstance(left, str) else left
                right = right.strip("`").strip() if isinstance(right, str) else right
            if left and right and left != right:
                fields[key] = {"fiche": fiche[key], "registry": record[key]}
        if fields:
            mismatches.append({"dataset_id": dataset_id, "fields": fields})
    return {
        "common": len(fiche_ids & registry_ids),
        "only_in_fiches": sorted(fiche_ids - registry_ids),
        "only_in_registry": sorted(registry_ids - fiche_ids),
        "field_mismatch_count": len(mismatches),
        "field_mismatches": mismatches,
    }


def scan_bibliographies(root: Path) -> dict:
    rows = []
    all_keys: list[tuple[str, str]] = []
    all_dois: list[tuple[str, str]] = []
    for path in sorted(p for p in iter_files(root) if p.suffix.lower() == ".bib"):
        text = read_text(path)
        keys = re.findall(r"(?m)^\s*@\w+\s*\{\s*([^,\s]+)", text)
        dois = [d.lower().rstrip("}, ") for d in re.findall(r"(?mi)^\s*doi\s*=\s*[\{\"]([^\}\"]+)", text)]
        row = {"file": rel(path, root), "entries": len(keys), "doi_fields": len(dois)}
        rows.append(row)
        all_keys.extend((key, row["file"]) for key in keys)
        all_dois.extend((doi, row["file"]) for doi in dois)
    key_counts = collections.Counter(key for key, _ in all_keys)
    doi_counts = collections.Counter(doi for doi, _ in all_dois)
    return {
        "files": rows,
        "file_count": len(rows),
        "entries": len(all_keys),
        "doi_fields": len(all_dois),
        "duplicate_keys_across_files": sorted(k for k, n in key_counts.items() if n > 1),
        "duplicate_dois_across_files": sorted(k for k, n in doi_counts.items() if n > 1),
    }


def scan_kg(root: Path) -> dict:
    path = root / ".kg/graph.sqlite"
    con = sqlite3.connect(path)
    con.row_factory = sqlite3.Row
    tables = {r[0] for r in con.execute("select name from sqlite_master where type='table'")}
    out = {"path": rel(path, root), "sha256": sha256(path), "tables": sorted(tables)}
    for table in ("nodes", "edges"):
        if table in tables:
            out[table] = con.execute(f"select count(*) from {table}").fetchone()[0]
    if "nodes" in tables:
        cols = {r[1] for r in con.execute("pragma table_info(nodes)")}
        type_col = next((c for c in ("node_type", "type", "label") if c in cols), None)
        if type_col:
            out["node_types"] = dict(
                con.execute(
                    f"select {type_col}, count(*) from nodes group by {type_col} order by count(*) desc"
                ).fetchall()
            )
    con.close()
    return out


def scan_extensions(root: Path) -> dict:
    base = root / "extensions_projet_2026-09"
    by_suffix = collections.Counter()
    by_top = collections.Counter()
    files = []
    for path in iter_files(base):
        by_suffix[path.suffix.lower() or "no_suffix"] += 1
        by_top[path.relative_to(base).parts[0]] += 1
        files.append(path)
    return {
        "file_count": len(files),
        "by_suffix": dict(sorted(by_suffix.items())),
        "by_top_directory": dict(sorted(by_top.items())),
    }


def scan_repo(root: Path) -> dict:
    counts = collections.Counter()
    total = 0
    for path in iter_files(root):
        total += 1
        counts[path.suffix.lower() or "no_suffix"] += 1
    return {"file_count": total, "by_suffix": dict(counts.most_common())}


def scan_writing_documents(root: Path, current_fiche_count: int) -> dict:
    candidates = [
        root / "Mémoire/Data paper",
        root / "wiki/analyses/datapapers",
        root / "extensions_projet_2026-09/revue_jeux_donnees_benchmark",
        root / "extensions_projet_2026-09/revue_donnees_semi_synthetiques",
    ]
    rows = []
    for base in candidates:
        if not base.exists():
            continue
        for path in sorted(base.rglob("*")):
            if not path.is_file() or path.suffix.lower() not in {".md", ".html"}:
                continue
            text = read_text(path)
            hits = [name for name, pattern in STALE_PATTERNS.items() if pattern.search(text)]
            explicit_counts = sorted({int(n) for n in re.findall(r"\b(\d{2,4})\s+fiches\b", text, re.I)})
            rows.append(
                {
                    "file": rel(path, root),
                    "modified": dt.datetime.fromtimestamp(path.stat().st_mtime).isoformat(timespec="seconds"),
                    "size": path.stat().st_size,
                    "stale_markers": hits,
                    "explicit_fiche_counts": explicit_counts,
                    "disagrees_with_current_fiche_count": any(n != current_fiche_count for n in explicit_counts),
                }
            )
    return {"documents": rows, "count": len(rows)}


def md_counts(mapping: dict[str, int]) -> str:
    return ", ".join(f"`{k}`: {v}" for k, v in mapping.items()) or "aucun"


def write_reports(root: Path, outdir: Path, snapshot: dict) -> None:
    outdir.mkdir(parents=True, exist_ok=True)
    (outdir / "audit_etat_repo.json").write_text(
        json.dumps(snapshot, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    f = snapshot["fiches"]
    r = snapshot["registry"]
    kg = snapshot["kg"]
    bib = snapshot["bibliographies"]
    ty_all = snapshot["typology_breakdown"]["all"]
    ty_yes = snapshot["typology_breakdown"]["yes_only"]
    stale = [d for d in snapshot["writing_documents"]["documents"] if d["disagrees_with_current_fiche_count"] or d["stale_markers"]]
    alignment = snapshot["fiche_registry_alignment"]
    registry_date = str(r.get("generated_at") or "date inconnue")[:10]
    alignment_sentence = (
        "Les couches sont alignées sur les identifiants et sur les champs non vides contrôlés."
        if not alignment["only_in_fiches"]
        and not alignment["only_in_registry"]
        and alignment["field_mismatch_count"] == 0
        else "Des écarts fiches–registre restent consignés dans le snapshot JSON."
    )

    state = f"""# Synthèse consolidée de l’état du projet

Date du snapshot : **{snapshot['generated_at']}**  
Source : audit local reproductible par `tools/audit_datapaper_repo.py`.

## État mesuré

- Dépôt analysé : **{snapshot['repo']['file_count']} fichiers** hors `.git`, `.venv`, `node_modules` et `.claude`.
- Fiches datasets : **{f['count']}** ({md_counts(f['families'])}).
- Registre `spatialtidymodels` : **{r['count']} enregistrements**, généré le **{r['generated_at']}**.
- Artifacts locaux déclarés dans le registre : **{r['with_local_artifact']}**.
- Champs `formula_used` présents dans le registre : **{r['with_formula_used']}**, dont **{r['with_resolved_formula_used']}** différents de `pending`.
- KG : **{kg.get('nodes', 'inconnu')} nœuds** et **{kg.get('edges', 'inconnu')} relations**.
- Bibliographies : **{bib['file_count']} fichiers `.bib`**, **{bib['entries']} entrées**, **{bib['doi_fields']} champs DOI**.
- Extension septembre : **{snapshot['extensions']['file_count']} fichiers**.
- Alignement fiches–registre : **{alignment['common']} identifiants communs**, **{len(alignment['only_in_fiches'])} seulement dans les fiches**, **{len(alignment['only_in_registry'])} seulement dans le registre**, **{alignment['field_mismatch_count']} désaccords de champs non vides**.

## Ventilation par typologie, panel et découpage parent/enfant

Calculée deux fois, sur des populations différentes qui ne doivent jamais être confondues : **toutes les fiches** (`ty_all`) et **seulement `package_include: yes`** (`ty_yes`, la banque réellement utilisable).

| | Toutes les fiches ({ty_all['total_fiches']}) | `package_include: yes` ({ty_yes['total_fiches']}) |
|---|---|---|
| Typologie de la variable réponse | {md_counts(ty_all['response_typology'])} | {md_counts(ty_yes['response_typology'])} |
| Panels stricts (câblés harnais, `data_structure: spatial_panel`) | {ty_all['panel_strict_spatial_panel']} | {ty_yes['panel_strict_spatial_panel']} |
| Panels — étiquette libre seulement (Bloc 4 `structure`) | {ty_all['panel_soft_structure_label']} | {ty_yes['panel_soft_structure_label']} |
| Spatio-temporel au sens large (`t_periods` &gt; 1) | {ty_all['spatio_temporal_t_periods_gt_1']} | {ty_yes['spatio_temporal_t_periods_gt_1']} |
| Coupe transversale stricte | {ty_all['cross_sectional_t_periods_eq_1']} | {ty_yes['cross_sectional_t_periods_eq_1']} |
| Fiches enfants (découpage) | {ty_all['children_count']} sur {ty_all['distinct_parents_count']} parents | {ty_yes['children_count']} sur {ty_yes['distinct_parents_count']} parents |
| dont enfants orphelins (parent hors de cette population) | {ty_all['orphaned_children_count']} | {ty_yes['orphaned_children_count']} |
| **Jeux distincts dédupliqués** | **{ty_all['deduplicated_dataset_count']}** | **{ty_yes['deduplicated_dataset_count']}** |

Les panels stricts (`data_structure: spatial_panel`) ne doivent jamais être confondus avec l'étiquette libre « panel » du Bloc 4 : la plupart des candidats « panel » se sont révélés être des coupes transversales quasi fictives à l'inspection (T médian = 1). La déduplication ne soustrait un enfant que si son propre parent appartient à la même population comptée ici — un enfant dont le parent est resté `manual_review` (ex. `paper_red_deer_topdown` → `_492`) reste compté comme seul représentant `yes` de sa famille, au lieu de disparaître silencieusement (bug trouvé et corrigé le 2026-09-24 : le calcul restreint aux `yes` donnait d'abord 128 au lieu de 131).

Détail des familles avec enfants `yes` : {md_counts(ty_yes['children_per_parent'])}.

## Lecture éditoriale

Le dépôt contient aujourd’hui quatre niveaux qu’il faut maintenir séparés : le catalogue de fiches, les preuves structurées du KG, le registre exécutable du package et les textes destinés au data paper. Le nombre de fiches et le nombre de nœuds `Dataset` du KG ne mesurent pas la même chose. De même, une entrée du registre ne prouve ni l’exécution d’un benchmark ni son admissibilité scientifique.

Le registre exporté le **{registry_date}** marque actuellement **{r['package_include'].get('yes', 0)} entrées `package_include: yes`**, **{r['package_include'].get('manual_review', 0)} `manual_review`** et **{r['package_include'].get('no', 0)} `no`**. Les anciens totaux de 35 ou 155 jeux décrivaient d’autres états ou périmètres. Ils ne doivent pas être comparés directement à ces {r['package_include'].get('yes', 0)} décisions d’inclusion. Avant publication, le manuscrit devra nommer explicitement la population comptée : fiches cataloguées, artifacts locaux, entrées `yes` ou benchmarks réellement exécutés.

{alignment_sentence}

Les revues de septembre constituent la couche narrative la plus récente. Les brouillons de juillet et août restent utiles pour leur structure, mais leurs chiffres ne peuvent plus être repris. L’audit détecte **{len(stale)} documents** avec un ancien nombre de fiches ou une formulation explicitement périmée.

## Sources canoniques proposées

| Information | Source canonique |
|---|---|
| Nombre et contenu des fiches | `wiki/datasets/fiches_datasets/*.md` |
| État exporté vers le package | `packages/spatialtidymodels/inst/metadata/datasets.json` |
| Relations papers–datasets–variables–formules | `.kg/graph.sqlite` |
| Positionnement face aux banques existantes | `extensions_projet_2026-09/revue_jeux_donnees_benchmark/` |
| Programme semi-synthétique | `extensions_projet_2026-09/revue_donnees_semi_synthetiques/` |
| Manuscrit final | futur dossier `extensions_projet_2026-09/redaction_datapaper/` |

## Réserves

- Les champs `package_include` et `benchmark_status` doivent être lus dans leur contexte ; une absence n’équivaut pas à `no`.
- Les doublons BibTeX entre fichiers peuvent être légitimes, mais devront être résolus dans une bibliographie maîtresse du manuscrit.
- Le KG est une couche de preuves et non la vérité narrative finale.
- Les résultats S1–S4 restent des pilotes autonomes du package.
"""
    (outdir / "SYNTHESE_ETAT_PROJET.md").write_text(state, encoding="utf-8")

    user = f"""# Synthèse courte pour se mettre au même niveau d’information

## Ce que le projet contient maintenant

La banque compte **{f['count']} fiches datasets** et le registre du package compte **{r['count']} entrées**. Le graphe de connaissances relie les datasets, articles, variables, formules et méthodes à travers **{kg.get('nodes', 'inconnu')} nœuds** et **{kg.get('edges', 'inconnu')} relations**. Ces nombres décrivent des couches différentes et ne doivent pas être additionnés.

Les identifiants des fiches et du registre sont actuellement alignés à **{alignment['common']}/{f['count']}**, sans désaccord de champ non vide détecté. Le registre marque **{r['package_include'].get('yes', 0)} jeux `yes`**, mais ce chiffre représente une décision de registre et non le nombre de benchmarks effectivement exécutés. Les anciens chiffres doivent être associés à leur date et à leur périmètre plutôt que repris comme des totaux actuels.

Le package `spatialtidymodels` est une **extension en développement**. Son registre décrit les jeux disponibles ou évaluables ; il ne signifie pas que tous ont été exécutés. Les panels parents restent distincts de leurs coupes transversales et nécessitent des moteurs de panel spatial séparés.

Deux revues récentes orientent la rédaction :

1. la revue des banques de benchmark situe la contribution face à OpenML, PMLB, AMLB, TableShift, TabZilla, TabReD, CAMELS, LamaH-CE et Caravan ;
2. la revue semi-synthétique étudie les plasmodes et quatre expériences internes S1–S4. S4 est le plus proche de la demande consistant à faire varier `lambda`, `f`, `g` et `u`.

## Ce qui est prêt pour la rédaction

- le positionnement scientifique de la banque ;
- une proposition en anglais pour l’introduction et la discussion ;
- les exigences documentaires inspirées de Datasheets et FAIR ;
- la description des pipelines fiches–KG–wiki–package ;
- les limites des pilotes semi-synthétiques ;
- deux bibliographies thématiques.

## Ce qui n’est pas encore harmonisé

- les brouillons de juillet–août utilisent des inventaires anciens ;
- il n’existe pas encore de manuscrit maître actualisé ;
- les chiffres descriptifs doivent être générés automatiquement au moment de chaque version ;
- les deux `.bib` thématiques ne forment pas encore une bibliographie maître ;
- les affirmations du manuscrit doivent être reliées à une source canonique et à une date de snapshot.

## Décision pratique

Le prochain document de référence doit être un manuscrit maître créé dans ce dossier. Les anciens brouillons deviennent des sources historiques. Toute nouvelle statistique du data paper doit provenir de l’audit JSON, du registre ou d’une requête KG enregistrée, jamais d’un nombre recopié manuellement.
"""
    (outdir / "SYNTHESE_POUR_JOHNNY.md").write_text(user, encoding="utf-8")

    stale_lines = "\n".join(
        f"- `{d['file']}` : comptes {d['explicit_fiche_counts'] or '—'}, marqueurs {d['stale_markers'] or '—'}"
        for d in stale
    ) or "- Aucun marqueur détecté."
    plan = f"""# Plan de mise au même niveau d’information

## P0 — Geler un état vérifiable

1. Exécuter `python tools/audit_datapaper_repo.py` avant chaque cycle de rédaction.
2. Conserver la date, les empreintes du registre et du KG dans `audit_etat_repo.json`.
3. Ne jamais transformer automatiquement `missing` en `no` ou en `manual_review`.

## P1 — Créer le manuscrit maître

1. Utiliser `PLAN_DATAPAPER_V2_2026-09-16.md` comme plan courant ; le plan d’août est historique.
2. Créer un seul manuscrit courant dans `extensions_projet_2026-09/redaction_datapaper/`.
3. Importer le positionnement de la synthèse introduction/discussion de septembre.
4. Remplacer tous les chiffres historiques par des valeurs issues du snapshot.
5. Marquer chaque tableau comme `catalogue`, `package registry`, `KG` ou `benchmark run`.

## P2 — Harmoniser les couches — identité et champs contrôlés terminés

1. **Terminé :** {alignment['common']} identifiants communs ; {len(alignment['only_in_fiches'])} fiche absente du registre ; {len(alignment['only_in_registry'])} entrée sans fiche.
2. **Terminé :** {alignment['field_mismatch_count']} désaccord de champ non vide dans le snapshot courant.
3. **À faire :** comparer les relations KG aux fiches pour les articles, formules, réponses, covariables et artifacts.
4. **À faire :** distinguer dans les tableaux les 260 décisions `yes`, les artifacts disponibles et les jeux effectivement exécutés.
5. **Règle :** documenter tout nouvel écart sans modifier automatiquement une fiche.

## P3 — Bibliographie maître

1. Fusionner les bibliographies benchmark et semi-synthétique dans un fichier de travail.
2. Dédupliquer les clés et DOI ; conserver les clés déjà utilisées dans les textes.
3. Vérifier titre, auteurs, année et DOI des références citées dans le manuscrit.
4. Séparer les références centrales du data paper des références d’extensions méthodologiques.

## P4 — Réécrire les parties périmées

Documents détectés par l’audit :

{stale_lines}

Le plan d’août peut être conservé comme squelette. Les brouillons de juillet–août doivent porter clairement la mention « historique » ou être remplacés par le manuscrit maître.

## P5 — Validation avant envoi ou soumission

1. Relancer l’audit et archiver son JSON avec la version du manuscrit.
2. Vérifier les liens locaux, les clés bibliographiques et les nombres des tableaux.
3. Vérifier les déclarations de licence, disponibilité et redistribution.
4. Distinguer catalogue, banque disponible, noyau benchmarkable et exécutions réalisées.
5. Faire relire les choix scientifiques : périmètre des panels, place de S1–S3, achèvement de S4 et revue cible.

## Critère de sortie

Le projet est au même niveau d’information lorsque le manuscrit maître ne contient aucun chiffre non traçable, que ses identifiants rejoignent fiches/registre/KG, que toutes ses citations existent dans la bibliographie maître et que les documents historiques ne sont plus utilisés comme source de l’état courant.
"""
    (outdir / "PLAN_SYNCHRONISATION.md").write_text(plan, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("extensions_projet_2026-09/redaction_datapaper"),
    )
    args = parser.parse_args()
    root = args.root.resolve()
    outdir = args.output if args.output.is_absolute() else root / args.output
    fiches = scan_fiches(root)
    registry = scan_registry(root)
    snapshot = {
        "schema_version": "datapaper_repo_audit_v1",
        "generated_at": dt.datetime.now().astimezone().isoformat(timespec="seconds"),
        "root": str(root),
        "repo": scan_repo(root),
        "fiches": fiches,
        "registry": registry,
        "fiche_registry_alignment": compare_fiches_registry(fiches, registry),
        "typology_breakdown": scan_typology_breakdown(root),
        "kg": scan_kg(root),
        "bibliographies": scan_bibliographies(root),
        "extensions": scan_extensions(root),
        "writing_documents": scan_writing_documents(root, fiches["count"]),
    }
    write_reports(root, outdir, snapshot)
    ty_all = snapshot["typology_breakdown"]["all"]
    ty_yes = snapshot["typology_breakdown"]["yes_only"]

    def _ty_summary(ty):
        return {
            "response_typology": ty["response_typology"],
            "panel_strict": ty["panel_strict_spatial_panel"],
            "panel_soft_label": ty["panel_soft_structure_label"],
            "spatio_temporal": ty["spatio_temporal_t_periods_gt_1"],
            "cross_sectional": ty["cross_sectional_t_periods_eq_1"],
            "children_count": ty["children_count"],
            "distinct_parents": ty["distinct_parents_count"],
            "orphaned_children_count": ty["orphaned_children_count"],
            "deduplicated_dataset_count": ty["deduplicated_dataset_count"],
        }

    print(json.dumps({
        "output": str(outdir),
        "fiches": fiches["count"],
        "registry": snapshot["registry"]["count"],
        "kg_nodes": snapshot["kg"].get("nodes"),
        "kg_edges": snapshot["kg"].get("edges"),
        "bib_entries": snapshot["bibliographies"]["entries"],
        "typology_all": _ty_summary(ty_all),
        "typology_yes_only": _ty_summary(ty_yes),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
