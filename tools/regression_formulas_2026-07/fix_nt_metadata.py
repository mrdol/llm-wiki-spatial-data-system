\
# -*- coding: utf-8 -*-
"""Task 2 - fix confirmed N/T profiling bugs: a per-observation continuous/
timestamp/date attribute was mistaken for a repeated-panel time dimension
on datasets that are actually single cross-sections (or repeated
cross-sections of distinct units, not a true panel of the same N units
observed T times).

Confirmed by cross-checking wiki/datasets/r_package_docs/<package>/topics/
(or, for Python-only packages, by inspecting the variable list directly)
against the fiche's declared Structure/T periods/Variable temporelle.
"""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]  # tools/regression_formulas_2026-07/ -> repo root
PKG_DIR = ROOT / "wiki" / "datasets" / "packages"

FIXES = {
    "Python_geodatasets_geoda.charleston2": {
        "n_bucket": "N_petit_T_1",
        "reason": "PCTIME (variable de taux/pourcentage, ex. part du temps de trajet) comptait 40 valeurs uniques sur 42 lignes et a ete prise a tort pour un axe temporel repete ; ce dataset est une coupe transversale de census tracts (croise avec le pattern PCTIME identique sur hickory2/lansing2).",
    },
    "Python_geodatasets_geoda.hickory2": {
        "n_bucket": "N_petit_T_1",
        "reason": "PCTIME comptait autant de valeurs uniques que de lignes (T=N=29) — signature typique d'une variable continue prise a tort pour un axe temporel repete ; coupe transversale de census tracts.",
    },
    "Python_geodatasets_geoda.lansing2": {
        "n_bucket": "N_petit_T_1",
        "reason": "PCTIME (variable de taux/pourcentage) comptait 42 valeurs uniques sur 46 lignes et a ete prise a tort pour un axe temporel repete ; coupe transversale de census tracts (meme pattern que charleston2/hickory2).",
    },
    "Python_geodatasets_geoda.home_sales": {
        "n_bucket": "N_grand_T_1",
        "reason": "`date` est la date de vente propre a chaque transaction individuelle (King County house sales) — chaque ligne est une vente distincte, pas une unite spatiale suivie repetee dans le temps ; ce n'est pas un panel au sens N unites x T periodes. `date`/`fact_date` reste une covariable pertinente (utilisee comme terme dans la formule publiee) mais ne definit pas un axe T.",
    },
    "Python_libpysal_chicagoSDOH": {
        "n_bucket": "N_grand_T_1",
        "reason": "YEARS_LOST est un indicateur de sante (annees de vie perdues), pas une variable temporelle : sa cardinalite (617 valeurs uniques sur 791 lignes) a ete prise a tort pour un axe temporel repete. Dataset census-tract-level en coupe transversale (Chicago Social Determinants of Health).",
    },
    "R_agridat_gartner.corn_gartner.corn": {
        "n_bucket": "N_grand_T_1",
        "reason": "`time` est un horodatage GPS par point de mesure du moniteur de rendement (yield monitor), pas un axe temporel repete (confirme par wiki/datasets/r_package_docs/agridat/topics/gartner.corn.md : 'GPS time, in seconds', une seule campagne de recolte le 5 nov. 2011). T=N=4949 etait le signal de la meme erreur de profilage que sur home_sales/chicagoSDOH.",
    },
    "R_spDataLarge_pol_pres15_pol_pres15": {
        "n_bucket": "N_grand_T_1",
        "reason": "Erreur de generation confirmee (voir mission) : ce dataset est un objet sf de polygones electoraux polonais (2495 unites administratives, elections 2015), sans structure panel — les tours 1 et 2 de l'election sont des paires de colonnes (I_*/II_*) dans la meme ligne, pas des periodes repetees. Confirme par wiki/datasets/r_package_docs/spDataLarge/topics/pol_pres15.md ('sf data frame object with 2495 areal units and 65 variables').",
    },
    "R_spData_house_house": {
        "n_bucket": "N_grand_T_1",
        "reason": "`sdate` est la date de vente individuelle de chaque maison (25 357 ventes distinctes, comte de Lucas OH, 1993-1998) — chaque ligne est une transaction unique, pas une unite spatiale suivie repetee. Confirme par wiki/datasets/r_package_docs/spData/topics/house.md ('25,357 single family homes sold ... 1993-1998'). T=1444 (nombre de dates de vente distinctes) ne constitue pas un axe panel.",
    },
}


def fix_fiche(did: str, info: dict) -> None:
    path = PKG_DIR / f"{did}.md"
    text = path.read_text(encoding="utf-8-sig")

    text, n1 = re.subn(r"(?m)^- Data type: spatio-temporel\s*$", "- Data type: spatial", text, count=1)
    text, n2 = re.subn(r"(?m)^- Structure: panel\s*$", "- Structure: coupe_transversale", text, count=1)
    text, n3 = re.subn(r"(?m)^- T periods: \d+\s*$", "- T periods: 1", text, count=1)
    text, n4 = re.subn(r"(?m)^- Variable temporelle: .+$", "- Variable temporelle: none", text, count=1)
    text, n5 = re.subn(r"(?m)^- N/T profile: \S+\s*$", f"- N/T profile: {info['n_bucket']}", text, count=1)
    text, n6 = re.subn(
        r"(?m)^- Temporal resolution: pending inspection\s*$",
        "- Temporal resolution: not applicable (cross-sectional dataset)",
        text, count=1,
    )
    text, n7 = re.subn(
        r"(?m)^- Time range: pending inspection\s*$",
        "- Time range: not applicable (cross-sectional dataset)",
        text, count=1,
    )

    # Append correction note right after the Bloc 4 field block
    note = f"\n> **Correction metadonnees (Tache 2, juillet 2026)** — {info['reason']}\n"
    text = re.sub(
        r"(- N/T profile: \S+\n)",
        lambda m: m.group(1) + note,
        text, count=1,
    )

    path.write_text(text, encoding="utf-8", newline="\n")
    print(f"{did}: subs={n1},{n2},{n3},{n4},{n5},{n6},{n7}")


def main():
    for did, info in FIXES.items():
        fix_fiche(did, info)


if __name__ == "__main__":
    main()
