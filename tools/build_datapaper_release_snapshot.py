#!/usr/bin/env python3
"""Build the publication-release snapshot used by the data descriptor.

The snapshot deliberately separates internal catalogue admission, technical
readiness and verified redistribution.  It never interprets
``package_include=yes`` as a licence decision or as evidence that a benchmark
was executed.
"""

from __future__ import annotations

import argparse
import csv
import importlib.util
import json
import sqlite3
import sys
from collections import Counter
from datetime import datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "packages/spatialtidymodels/inst/metadata/datasets.json"
FICHES = ROOT / "wiki/datasets/fiches_datasets"
DEFAULT_TSV = ROOT / "extensions_projet_2026-09/redaction_datapaper/snapshot_noyau_publiable_2026-09-27.tsv"
DEFAULT_MD = ROOT / "extensions_projet_2026-09/redaction_datapaper/SNAPSHOT_NOYAU_PUBLIABLE_2026-09-27.md"


def load_readiness_module():
    path = ROOT / "tools/check_dataset_fiche_readiness.py"
    spec = importlib.util.spec_from_file_location("fiche_readiness", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def present(value) -> bool:
    if value is None:
        return False
    if isinstance(value, (list, dict, tuple, set)):
        return bool(value)
    return str(value).strip().lower() not in {"", "none", "null", "na", "n/a", "unknown", "pending"}


def artifact_check(path: Path) -> tuple[bool, str, int]:
    if not path.is_file():
        return False, "missing", 0
    size = path.stat().st_size
    if size <= 0:
        return False, "empty", size
    suffix = path.suffix.lower()
    if suffix == ".gpkg":
        try:
            with sqlite3.connect(f"file:{path.as_posix()}?mode=ro", uri=True) as con:
                result = con.execute("PRAGMA quick_check").fetchone()[0]
                has_contents = con.execute(
                    "SELECT count(*) FROM sqlite_master WHERE name='gpkg_contents'"
                ).fetchone()[0]
            ok = result == "ok" and has_contents == 1
            return ok, "gpkg_quick_check_ok" if ok else f"gpkg_check:{result}", size
        except Exception as exc:  # pragma: no cover - diagnostic path
            return False, f"gpkg_error:{type(exc).__name__}", size
    if suffix == ".rds":
        head = path.read_bytes()[:6]
        valid = head.startswith((b"X\n", b"A\n", b"B\n", b"\x1f\x8b", b"BZh", b"\xfd7zXZ"))
        return valid, "rds_signature_ok" if valid else f"rds_unknown_signature:{head.hex()}", size
    return True, "nonempty_unparsed_format", size


def deduplicated_count(rows: list[dict]) -> int:
    ids = {r["dataset_id"] for r in rows}
    redundant_children = sum(bool(r["parent_dataset"] and r["parent_dataset"] in ids) for r in rows)
    return len(rows) - redundant_children


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tsv", type=Path, default=DEFAULT_TSV)
    parser.add_argument("--md", type=Path, default=DEFAULT_MD)
    args = parser.parse_args()

    records = json.loads(REGISTRY.read_text(encoding="utf-8"))["records"]
    readiness = load_readiness_module()
    readiness_by_id = {}
    for fiche in sorted(FICHES.glob("*.md")):
        result = readiness.evaluate(fiche, ROOT)
        readiness_by_id[result.dataset_id] = result

    rows = []
    for rec in records:
        if rec.get("package_include") != "yes":
            continue
        dataset_id = str(rec.get("dataset_id") or rec.get("dataset"))
        local = ROOT / str(rec.get("local_artifact") or "")
        artefact_ok, artefact_check, actual_size = artifact_check(local)
        gate = readiness_by_id.get(dataset_id)
        gate_ok = bool(gate and gate.passes_package_gate)
        formula_ok = present(rec.get("formula_used")) and str(rec.get("formula_used")).lower() != "pending"
        technical_ready = all(
            [
                rec.get("benchmark_status") == "ready",
                rec.get("benchmark_ready") is True,
                gate_ok,
                artefact_ok,
                formula_ok,
                present(rec.get("response")),
                present(rec.get("predictors")),
            ]
        )
        rights_ready = rec.get("license_verified") is True and rec.get("redistribution_allowed") is True
        publication_ready = technical_ready and rights_ready
        blockers = []
        if rec.get("benchmark_status") != "ready": blockers.append("benchmark_status_not_ready")
        if rec.get("benchmark_ready") is not True: blockers.append("benchmark_ready_false")
        if not gate_ok: blockers.append("fiche_gate_failed")
        if not artefact_ok: blockers.append("artifact_integrity_failed")
        if not formula_ok: blockers.append("formula_unresolved")
        if not present(rec.get("response")): blockers.append("response_missing")
        if not present(rec.get("predictors")): blockers.append("predictors_missing")
        if rec.get("license_verified") is not True: blockers.append("license_not_verified")
        if rec.get("redistribution_allowed") is not True: blockers.append("redistribution_not_approved")
        rows.append(
            {
                "dataset_id": dataset_id,
                "source_dataset_id": rec.get("source_dataset_id") or dataset_id,
                "parent_dataset": rec.get("parent_dataset") or "",
                "source_family": rec.get("source_family") or "",
                "benchmark_status": rec.get("benchmark_status") or "",
                "benchmark_ready": rec.get("benchmark_ready") is True,
                "fiche_gate_pass": gate_ok,
                "technical_ready": technical_ready,
                "license_name": rec.get("license_name") or "",
                "license_verified": rec.get("license_verified") is True,
                "redistribution_allowed": rec.get("redistribution_allowed") is True,
                "publication_ready": publication_ready,
                "local_artifact": rec.get("local_artifact") or "",
                "artifact_format": local.suffix.lower().lstrip("."),
                "artifact_size_bytes": actual_size,
                "artifact_integrity": artefact_check,
                "formula_status": rec.get("formula_status") or "",
                "response_typology": "+".join(rec.get("response_typology") or []),
                "has_response": present(rec.get("response")),
                "has_predictors": present(rec.get("predictors")),
                "has_coordinates": present(rec.get("coords")),
                "has_crs": present(rec.get("coords_crs")),
                "t_periods": rec.get("t_periods") or "",
                "is_spatial_panel": rec.get("data_structure") == "spatial_panel",
                "has_weights_reference": any(
                    present(rec.get(k))
                    for k in ("spatial_weights_file", "w_file", "spatial_weights_source")
                ),
                "blockers": ";".join(blockers),
            }
        )

    args.tsv.parent.mkdir(parents=True, exist_ok=True)
    with args.tsv.open("w", encoding="utf-8-sig", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), delimiter="\t", lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)

    technical = [r for r in rows if r["technical_ready"]]
    publishable = [r for r in rows if r["publication_ready"]]
    named_licence = [r for r in rows if present(r["license_name"])]
    formats = Counter(r["artifact_format"] or "missing" for r in rows)
    technical_sources = len({r["source_dataset_id"] for r in technical})
    publishable_sources = len({r["source_dataset_id"] for r in publishable})
    source_representatives = {}
    for row in technical:
        source_representatives.setdefault(row["source_dataset_id"], row)
    licence_families = Counter(r["license_name"] or "missing" for r in source_representatives.values())
    licence_table = "\n".join(
        f"| {name.replace('|', '/')} | {count} |" for name, count in licence_families.most_common()
    )
    generated_at = datetime.now().astimezone().isoformat(timespec="seconds")

    md = f"""# Snapshot du noyau publiable

Date : **{generated_at}**  
Source : registre du package, 392 fiches et contrôle `check_dataset_fiche_readiness.py`.

## Résultat

| Niveau | Enregistrements | Familles parent--enfant | Sources déclarées distinctes |
|---|---:|---:|---:|
| Catalogue interne | {len(records)} | non recalculé ici | non utilisé comme taille publiée |
| Admis dans le registre (`package_include=yes`) | {len(rows)} | {deduplicated_count(rows)} | {len({r['source_dataset_id'] for r in rows})} |
| Techniquement prêts après contrôle croisé | {len(technical)} | {deduplicated_count(technical)} | {technical_sources} |
| Licence vérifiée et redistribution autorisée | {sum(r['license_verified'] and r['redistribution_allowed'] for r in rows)} | 0 | 0 |
| **Noyau actuellement publiable** | **{len(publishable)}** | **{deduplicated_count(publishable)}** | **{publishable_sources}** |

Le noyau publiable est actuellement vide au sens strict. Ce résultat ne signifie
pas que les données sont fermées. Il signifie que les deux décisions
`license_verified=true` et `redistribution_allowed=true` n'ont encore été
enregistrées pour aucune entrée. Un nom de licence présent dans une fiche ne
remplace pas cette vérification.

## Contrôles techniques

- {len(rows)} artefacts candidats ont été localisés et soumis à un contrôle de
  présence, taille et signature de format ; formats : {dict(formats)}.
- {sum(r['artifact_integrity'] in {'rds_signature_ok', 'gpkg_quick_check_ok'} for r in rows)} artefacts
  passent ce contrôle structurel de premier niveau.
- {sum(r['fiche_gate_pass'] for r in rows)} fiches admises passent le gate documentaire.
- {sum(r['benchmark_ready'] for r in rows)} entrées admises ont `benchmark_ready=true`.
- {len(technical)} entrées satisfont simultanément le statut `ready`, le gate
  documentaire, le drapeau `benchmark_ready`, l'intégrité du fichier, une
  réponse, des prédicteurs et une formule résolue.
- {len(named_licence)} entrées admises portent un nom de licence non vide et
  non `unknown`, mais aucune n'est encore juridiquement validée dans le registre.

## Couverture des {len(technical)} candidats techniquement prêts

| Champ | Nombre renseigné |
|---|---:|
| Réponse | {sum(r['has_response'] for r in technical)} |
| Prédicteurs | {sum(r['has_predictors'] for r in technical)} |
| Coordonnées déclarées | {sum(r['has_coordinates'] for r in technical)} |
| CRS déclaré | {sum(r['has_crs'] for r in technical)} |
| Plus d'une période | {sum(str(r['t_periods']).isdigit() and int(r['t_periods']) > 1 for r in technical)} |
| Panel spatial explicite | {sum(r['is_spatial_panel'] for r in technical)} |
| Référence à des poids spatiaux | {sum(r['has_weights_reference'] for r in technical)} |

## File d'audit des licences au niveau des sources

| Licence déclarée | Sources distinctes à vérifier |
|---|---:|
{licence_table}

La vérification doit être réalisée au niveau des {technical_sources} sources,
et non répétée pour leurs {len(technical)} enregistrements analytiques. Les
licences CC0 et CC BY 4.0 constituent la première priorité documentaire, car
elles couvrent la majorité des sources candidates. Les mentions `unknown`,
`probable`, `hérité du parent`, `other-open`, les licences sans texte reconnu
et les conditions imposant de contacter le déposant restent bloquantes jusqu'à
examen de la source officielle. Une licence de logiciel ne doit pas être
supposée couvrir automatiquement un fichier de données sans preuve.

## Incohérences bloquant deux admissions

- `paper_leishmaniasis_occurrence` porte `package_include=yes` et
  `benchmark_status=ready`, mais `benchmark_ready=false` à cause d'une typologie
  de réponse encore signalée comme non résolue.
- `R_gstat_DE_RB_2005_DE_RB_2005` porte les drapeaux de préparation, mais sa
  fiche échoue au gate car le bloc d'éligibilité des estimateurs manque.

## Décision pour le manuscrit

Les nombres 392 et 278 ne doivent pas remplir les champs du résumé ou de
`Data Records`. Le manuscrit peut décrire le protocole et signaler
{len(technical)} candidats techniquement prêts, mais la taille de la banque
publiée restera indéterminée jusqu'à l'audit des licences et des droits de
redistribution. Après cet audit, le présent script devra être relancé sans
modifier manuellement le TSV.

Le détail des {len(rows)} admissions se trouve dans `{args.tsv.name}`.
"""
    args.md.write_text(md, encoding="utf-8", newline="\n")
    print(json.dumps({
        "admitted": len(rows),
        "technical_ready": len(technical),
        "publication_ready": len(publishable),
        "admitted_families": deduplicated_count(rows),
        "technical_families": deduplicated_count(technical),
        "technical_sources": technical_sources,
        "tsv": str(args.tsv),
        "md": str(args.md),
    }, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
