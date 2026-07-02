\
# -*- coding: utf-8 -*-
"""Compute the Tache 5 dashboard statistics from regression_findings.FINDINGS
and the current wiki/datasets/packages/*.md fiches. Writes CSV + JSON outputs.
"""
import csv
import json
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from regression_findings import FINDINGS
import task4_full_pass as _t4  # Tache 4, 2nd pass (2026-07-02): analogy review of the 59
                                 # mauvais_candidat/a_verifier fiches -- patches FINDINGS in place.
for _did, _upd in _t4.UPGRADES.items():
    FINDINGS[_did].update(_upd)
_t4.apply_no_analogy_notes()

ROOT = Path(__file__).resolve().parents[2]
PKG_DIR = ROOT / "wiki" / "datasets" / "packages"
OUT_DIR = ROOT / "data" / "manifests" / "datasets"

STATUS_LABEL = {
    "bon_candidat": "bon candidat",
    "a_verifier": "a verifier",
    "mauvais_candidat": "mauvais candidat",
    "mis_de_cote": "mis de cote",
    "candidat_par_analogie": "candidat par analogie -- non verifie",
}

# datasets whose N/T panel-vs-cross-section bug was corrected in this mission (Tache 2)
NT_FIXED = {
    "Python_geodatasets_geoda.charleston2", "Python_geodatasets_geoda.hickory2",
    "Python_geodatasets_geoda.lansing2", "Python_geodatasets_geoda.home_sales",
    "Python_libpysal_chicagoSDOH", "R_agridat_gartner.corn_gartner.corn",
    "R_spDataLarge_pol_pres15_pol_pres15", "R_spData_house_house",
}
# fiches whose License name field was corrected in this mission (Tache 2)
LICENSE_FIXED = {
    "R_agridat_gartner.corn_gartner.corn", "R_agridat_wallace.iowaland_wallace.iowaland",
    "R_agridat_lasrosas.corn_lasrosas.corn", "R_agridat_usgs.herbicides_usgs.herbicides",
    "R_agridat_ortiz.tomato.covs_ortiz.tomato.covs",
}
# Python/R homolog pairs resolved in this mission (Tache 3) -- counted once per pair
HOMOLOG_PAIRS_RESOLVED = [
    ("Python_libpysal_georgia", "R_GWmodel_GeorgiaCounties_Gedu.counties"),
    ("R_GWmodel_LondonBorough_londonborough", "R_GWmodel_LondonHP_londonhp"),
    ("R_agridat_lasrosas.corn_lasrosas.corn", "Python_geodatasets_geoda.lasrosas"),
    ("R_sp_meuse_meuse", "R_gstat_meuse.all_meuse.all"),
    ("R_spdep_oldcol_COL.OLD", "Python_geodatasets_spdata.columbus"),
]

status_counter = Counter()
evidence_by_status = Counter()  # (status, evidence)
method_counter = Counter()

for did, f in FINDINGS.items():
    status_counter[f["status"]] += 1
    if f.get("evidence"):
        evidence_by_status[(f["status"], f["evidence"])] += 1
    if f.get("method") and f["status"] in ("bon_candidat", "candidat_par_analogie"):
        # normalize to a short family label for aggregation
        m = f["method"].lower()
        if "gwr" in m or "geographically weighted" in m:
            fam = "GWR"
        elif "poisson" in m or "binomial" in m or "glmm" in m or "logistique" in m or "glm" in m:
            fam = "GLM/GLMM"
        elif "krigeage" in m or "kriging" in m:
            fam = "Krigeage"
        elif "bayesien" in m or "car)" in m or "bym" in m:
            fam = "Bayesien hierarchique"
        elif "sem" in m or "sar" in m or "spatial lag" in m or "spatial error" in m or "autoregress" in m:
            fam = "SEM/SAR"
        elif "twinsir" in m:
            fam = "twinSIR (survie epidemique)"
        elif "pls" in m:
            fam = "PLS"
        elif "splines" in m:
            fam = "Splines"
        elif "ols" in m:
            fam = "OLS"
        else:
            fam = f["method"]
        method_counter[fam] += 1

n_bon = status_counter["bon_candidat"]
n_verif = status_counter["a_verifier"]
n_mauvais = status_counter["mauvais_candidat"]
n_analogie = status_counter["candidat_par_analogie"]
n_cote = status_counter["mis_de_cote"]
total = sum(status_counter.values())

evidence_totals = Counter()
for (status, ev), c in evidence_by_status.items():
    evidence_totals[ev] += c

homolog_pairs_n = len(HOMOLOG_PAIRS_RESOLVED)
nt_fixed_n = len(NT_FIXED)
license_fixed_n = len(LICENSE_FIXED)

summary = {
    "generated_for": "wiki/datasets/packages (98 fiches, couche 'Bons candidats spatial' retenus)",
    "total_fiches": total,
    "regression_status": {
        STATUS_LABEL[k]: v for k, v in status_counter.items()
    },
    "evidence_level_bon_et_analogie": dict(evidence_totals),
    "estimation_methods_bon_candidats_et_analogie": dict(method_counter),
    "python_r_homolog_pairs_resolved": homolog_pairs_n,
    "homolog_pairs_detail": [f"{a} <-> {b}" for a, b in HOMOLOG_PAIRS_RESOLVED],
    "nt_metadata_bugs_fixed": nt_fixed_n,
    "nt_metadata_bugs_fixed_detail": sorted(NT_FIXED),
    "license_fields_corrected": license_fixed_n,
    "license_fields_corrected_detail": sorted(LICENSE_FIXED),
}

OUT_DIR.mkdir(parents=True, exist_ok=True)
json_path = OUT_DIR / "banque_regression_dashboard_2026-07.json"
json_path.write_text(json.dumps(summary, indent=2, ensure_ascii=False), encoding="utf-8", newline="\n")

csv_path = OUT_DIR / "banque_regression_dashboard_2026-07.csv"
with csv_path.open("w", encoding="utf-8", newline="") as fh:
    writer = csv.writer(fh)
    writer.writerow(["dataset_id", "regression_status", "evidence_level", "method", "homolog"])
    for did, f in sorted(FINDINGS.items()):
        writer.writerow([did, STATUS_LABEL[f["status"]], f.get("evidence") or "", f.get("method") or "", f.get("homolog") or ""])

print(json.dumps(summary, indent=2, ensure_ascii=False))
print(f"\nWrote {json_path}")
print(f"Wrote {csv_path}")
