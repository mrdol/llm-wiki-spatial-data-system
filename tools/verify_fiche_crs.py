"""Verifie que le CRS declare dans chaque fiche wiki correspond au CRS
reellement embarque dans son .rds final, et detecte les incoherences
internes deja rencontrees dans le corpus (texte de recommandation qui
affirme "CRS inconnu" alors que le CRS est renseigne juste au-dessus).

Contrairement a code/r_catalog/audit_sf_crs_time.R (qui ne traite que les
jeux dont le CRS catalogue est ABSENT, pour en proposer un), cet outil
re-verifie TOUS les jeux sans exception, y compris ceux dont une fiche
affirme deja un CRS -- l'objectif est de detecter une affirmation FAUSSE,
pas seulement un trou.

Etapes :
  1. Regenerer la verite terrain (lit directement les .rds, ignore ce que
     dit la fiche) :
       Rscript code/r_catalog/extract_crs_ground_truth.R
     -> data/manifests/datasets/crs_ground_truth.json
  2. Lancer cette verification :
       python tools/verify_fiche_crs.py
       python tools/verify_fiche_crs.py --only R_gstat_jura_jura.full
       python tools/verify_fiche_crs.py --category MISMATCH
       python tools/verify_fiche_crs.py --json rapport.json

Categories de constat (une fiche peut cumuler plusieurs constats) :
  MISMATCH               - la fiche affirme un EPSG different du CRS reel
                            embarque sur la geometrie active. Le plus grave :
                            corrompt directement les calculs spatiaux.
  CONTRADICTION          - "CRS analyse recommande" affirme que le CRS est
                            inconnu/non geographique alors que CRS EPSG/nom
                            sont deja renseignes juste au-dessus.
  UNSOURCED_CRS_CLAIM    - la fiche affirme un EPSG precis alors que le .rds
                            n'a AUCUN CRS embarque (ni sur la geometrie
                            active ni sur geom_origine), sans phrase de
                            sourcage explicite (ex. "documentation du
                            package", "via documentation", ".rds sans CRS
                            embarque") justifiant d'ou vient ce chiffre.
  GEOM_FIDELITY_MISSING  - le .rds source (geom_origine) est un polygone
                            mais la fiche affiche "Type de geometrie: POINT"
                            sans note de fidelite expliquant la conversion.
  NO_GROUND_TRUTH        - aucune entree de verite terrain pour ce Dataset ID
                            (rds absent, erreur de lecture, ou pas un objet
                            sf) -- verification impossible, pas un constat en
                            soi.

Sortie : rapport texte sur stdout, et en option un JSON detaille.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
FICHES_DIR = ROOT / "wiki" / "datasets" / "fiches_datasets"
GROUND_TRUTH_PATH = ROOT / "data" / "manifests" / "datasets" / "crs_ground_truth.json"

SOURCING_PHRASES = [
    "documentation du package",
    "via documentation",
    "sans crs embarque",
    "documentation gstat",
    "documentation reelle du package",
    "confirme par",
    "verifie via",
    "verifie directement",
    "verifie 20",  # dated verification notes, e.g. "verifie 2026-09-15"
]

FIDELITY_MARKERS = [
    "note de fidelite",
    "geom_origine",
    "st_point_on_surface",
]

CONTRADICTION_MARKER = "non geographique ou inconnu"


def field(text: str, label: str) -> str | None:
    m = re.search(r"(?im)^\s*-\s*" + re.escape(label) + r"\s*:\s*(.+?)\s*$", text)
    return m.group(1).strip() if m else None


def extract_epsg_number(value: str | None) -> int | None:
    if not value:
        return None
    m = re.search(r"\b(\d{4,6})\b", value)
    return int(m.group(1)) if m else None


def load_ground_truth() -> dict[str, dict[str, Any]]:
    if not GROUND_TRUTH_PATH.exists():
        raise SystemExit(
            f"Verite terrain absente : {GROUND_TRUTH_PATH}\n"
            "Generer d'abord avec : Rscript code/r_catalog/extract_crs_ground_truth.R"
        )
    return json.loads(GROUND_TRUTH_PATH.read_text(encoding="utf-8"))


def check_fiche(path: Path, ground_truth: dict[str, dict[str, Any]]) -> dict[str, Any]:
    text = path.read_text(encoding="utf-8", errors="ignore")
    dataset_id_raw = field(text, "Dataset ID")
    dataset_id = dataset_id_raw.strip("`") if dataset_id_raw else path.stem

    epsg_field = field(text, "CRS EPSG")
    nom_field = field(text, "CRS nom")
    reco_field = field(text, "CRS analyse recommande")
    geom_field = field(text, "Type de geometrie")

    findings: list[str] = []
    detail: dict[str, Any] = {
        "file": path.name,
        "dataset_id": dataset_id,
        "fiche_crs_epsg": epsg_field,
        "fiche_crs_nom": nom_field,
        "fiche_geometry_type": geom_field,
    }

    gt = ground_truth.get(dataset_id)
    if gt is None or gt.get("error"):
        detail["ground_truth"] = gt.get("error") if gt else "absent"
        findings.append("NO_GROUND_TRUTH")
        detail["findings"] = findings
        return detail

    real_epsg = gt.get("active_crs_epsg")
    real_input = gt.get("active_crs_input")
    origine_type = (gt.get("origine_geometry_type") or "").upper()
    active_type = (gt.get("active_geometry_type") or "").upper()
    detail["ground_truth"] = {
        "active_crs_epsg": real_epsg,
        "active_crs_input": real_input,
        "active_geometry_type": gt.get("active_geometry_type"),
        "origine_geometry_type": gt.get("origine_geometry_type"),
    }

    fiche_epsg_num = extract_epsg_number(epsg_field)

    # 1. MISMATCH: both sides have a real, comparable EPSG number and they differ.
    if fiche_epsg_num is not None and real_epsg is not None and fiche_epsg_num != real_epsg:
        findings.append("MISMATCH")

    # 2. CONTRADICTION: recommendation falsely claims unknown/non-geographic.
    if reco_field and CONTRADICTION_MARKER in reco_field.lower():
        epsg_known = epsg_field is not None and "unknown" not in epsg_field.lower()
        nom_known = nom_field is not None and nom_field.strip().lower() not in ("unknown", "pending", "")
        if epsg_known or nom_known:
            findings.append("CONTRADICTION")

    # 3. UNSOURCED_CRS_CLAIM: fiche states a specific EPSG but the .rds has none at all,
    #    on neither the active nor the source geometry, without an explicit sourcing phrase.
    if fiche_epsg_num is not None and real_epsg is None:
        origine_epsg = gt.get("origine_crs_epsg")
        if origine_epsg is None:
            lower_text = text.lower()
            if not any(phrase in lower_text for phrase in SOURCING_PHRASES):
                findings.append("UNSOURCED_CRS_CLAIM")

    # 4. GEOM_FIDELITY_MISSING: source is polygon, fiche says point, no fidelity note.
    if geom_field and "POINT" in geom_field.upper() and "POLYGON" in origine_type and "POLYGON" not in active_type:
        lower_text = text.lower()
        if not any(marker in lower_text for marker in FIDELITY_MARKERS):
            findings.append("GEOM_FIDELITY_MISSING")

    detail["findings"] = findings
    return detail


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--only", help="ne verifier qu'un seul Dataset ID (nom de fichier sans .md)")
    parser.add_argument("--category", help="n'afficher que les fiches avec ce constat (ex. MISMATCH)")
    parser.add_argument("--json", type=Path, help="ecrire le rapport detaille complet dans ce fichier JSON")
    args = parser.parse_args()

    ground_truth = load_ground_truth()

    if args.only:
        paths = [FICHES_DIR / f"{args.only}.md"]
        if not paths[0].exists():
            raise SystemExit(f"Fiche introuvable : {paths[0]}")
    else:
        paths = sorted(FICHES_DIR.glob("*.md"))

    results = [check_fiche(p, ground_truth) for p in paths]

    if args.category:
        results_to_show = [r for r in results if args.category in r["findings"]]
    else:
        results_to_show = [r for r in results if r["findings"] and r["findings"] != ["NO_GROUND_TRUTH"]]

    counts: dict[str, int] = {}
    for r in results:
        for f in r["findings"]:
            counts[f] = counts.get(f, 0) + 1

    print(f"Fiches verifiees : {len(results)}")
    print("Repartition des constats :")
    for cat, n in sorted(counts.items(), key=lambda kv: -kv[1]):
        print(f"  {cat}: {n}")
    print()

    if results_to_show:
        print(f"Detail ({len(results_to_show)} fiche(s)) :")
        for r in results_to_show:
            print(f"\n- {r['file']}  [{', '.join(r['findings'])}]")
            print(f"    fiche: CRS EPSG={r['fiche_crs_epsg']!r} CRS nom={r['fiche_crs_nom']!r}")
            gt = r.get("ground_truth")
            if isinstance(gt, dict):
                print(
                    f"    verite terrain: active_crs_epsg={gt['active_crs_epsg']!r} "
                    f"active_crs_input={gt['active_crs_input']!r} "
                    f"active_geom={gt['active_geometry_type']!r} "
                    f"origine_geom={gt['origine_geometry_type']!r}"
                )
    else:
        print("Aucune fiche ne correspond au filtre demande.")

    if args.json:
        args.json.write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"\nRapport complet ecrit dans {args.json}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
