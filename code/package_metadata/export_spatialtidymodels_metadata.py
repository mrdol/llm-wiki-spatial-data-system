"""Exporte les métadonnées wiki vers le package spatialtidymodels.

Ce script fait le pont entre la base de connaissance Markdown du projet et le
package R. Les fiches restent la source humaine principale; les JSON produits
ici sont le format machine minimal lu par `spatialtidymodels`.
"""

from __future__ import annotations

import argparse
import json
import re
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


def evidence(
    estimator: str,
    basis: str,
    source_ref: str,
    pages: str | None = None,
    pdf_pages: str | None = None,
    tables: list[str] | None = None,
    notes: str = "",
) -> dict[str, Any]:
    """Décrit une preuve dataset-estimateur sans mélanger les sources."""
    return {
        "estimator": estimator,
        "basis": basis,
        "source_ref": source_ref,
        "pages": pages,
        "pdf_pages": pdf_pages,
        "tables": tables or [],
        "notes": notes,
    }


DATASET_ALIASES: dict[str, dict[str, Any]] = {
    "Python_libpysal_georgia": {
        "dataset": "georgia",
        "data_object": "georgia",
        "rds": "data/final_datasets/sf/Python_libpysal_georgia.rds",
        "formula": "PctBach ~ PctRural + PctFB + PctBlack + PctEld",
        "response": "PctBach",
        "predictors": ["PctRural", "PctFB", "PctBlack", "PctEld"],
        "coords": ["X", "Y"],
        "coords_crs": "EPSG:26916",
        "coords_source": "prepared projected coordinates",
        "formula_status": "pub",
        "source_ref": "Georgia education example, libpysal/GWmodel",
        "notes": "Petit dataset de reference pour tests rapides.",
        "estimator_evidence": [
            evidence("ols", "benchmark_use", "Georgia education example, libpysal/GWmodel"),
            evidence("gam_spatial", "benchmark_use", "Georgia education example, libpysal/GWmodel"),
            evidence("mgwrsar_gwr", "benchmark_use", "Georgia education example, libpysal/GWmodel"),
            evidence("mgwrsar_mgwr", "benchmark_use", "Georgia education example, libpysal/GWmodel"),
        ],
        "eligibility_basis": "benchmark_use",
        "eligibility_source_ref": "Georgia education examples in libpysal/GWmodel and geographically weighted regression examples.",
        "eligibility_notes": "Dataset spatial continu avec coordonnees projetees; utile pour tester OLS, GAM spatial et familles GWR/MGWR.",
    },
    "Python_geodatasets_spdata.columbus": {
        "dataset": "columbus_crime",
        "data_object": "columbus_crime",
        "rds": "data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds",
        "formula": "CRIME ~ HOVAL + INC",
        "response": "CRIME",
        "predictors": ["HOVAL", "INC"],
        "coords": ["X", "Y"],
        "coords_crs": "EPSG:32617",
        "coords_source": "prepared projected coordinates",
        "formula_status": "pub",
        "source_ref": "spData Columbus / Anselin spatial econometrics examples",
        "notes": "Exemple classique SAR/SEM: CRIME ~ HOVAL + INC.",
        "estimator_evidence": [
            evidence(
                "ols",
                "scientific_evidence",
                "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example.",
                pages="191-192",
                pdf_pages="203-204",
                tables=["12.3"],
                notes="OLS regression with diagnostics for spatial effects, formula CRIME ~ INC + HOUSE/HOVAL.",
            ),
            evidence(
                "sar_lag",
                "scientific_evidence",
                "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example.",
                pages="192-194",
                pdf_pages="204-206",
                tables=["12.4", "12.5"],
                notes="Mixed regressive spatial autoregressive model with W_CRIME.",
            ),
            evidence(
                "sem_error",
                "scientific_evidence",
                "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example.",
                pages="194-196",
                pdf_pages="206-208",
                tables=["12.6", "12.7"],
                notes="ML estimation of the model with spatially dependent error terms.",
            ),
            evidence(
                "sdm_mixed",
                "scientific_evidence",
                "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Chapter 12 Columbus crime example.",
                pages="196-197",
                pdf_pages="208-209",
                tables=["12.8"],
                notes="Spatial Durbin model with W_CRIME, W_INC and W_HOUSE.",
            ),
            evidence(
                "spmoran_esf",
                "benchmark_use",
                "spatialtidymodels package tests on Columbus; method source must be Murakami/spmoran, not Anselin 1988.",
                notes="Benchmark route only until a paper-source relation is curated.",
            ),
            evidence(
                "spmoran_resf",
                "benchmark_use",
                "spatialtidymodels package tests on Columbus; method source must be Murakami/spmoran, not Anselin 1988.",
                notes="Benchmark route only until a paper-source relation is curated.",
            ),
        ],
        "eligibility_basis": "scientific_evidence",
        "eligibility_source_ref": "Anselin, Luc (1988) Spatial Econometrics: Methods and Models, Columbus crime example.",
        "eligibility_notes": "Cas de reference pour OLS, autocorrelation spatiale globale, SAR/SEM et diagnostics de residus spatiaux.",
    },
    "R_GWmodel_LondonHP_londonhp": {
        "dataset": "london_hp",
        "data_object": "london_hp",
        "rds": "data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds",
        "formula": "PURCHASE ~ FLOORSZ + PROF + BATH2",
        "response": "PURCHASE",
        "predictors": ["FLOORSZ", "PROF", "BATH2"],
        "coords": ["X", "Y"],
        "coords_crs": "EPSG:27700",
        "coords_source": "native projected coordinates",
        "formula_status": "used",
        "source_ref": "Lu, Charlton, Harris & Fotheringham (2014), IJGIS",
        "notes": "Formule hedonique confirmee et cible continue.",
        "estimator_evidence": [
            evidence("ols", "scientific_evidence", "Lu, Charlton, Harris & Fotheringham (2014), IJGIS"),
            evidence("gam_spatial", "benchmark_use", "spatialtidymodels package benchmark metadata"),
            evidence("mgwrsar_gwr", "scientific_evidence", "Lu, Charlton, Harris & Fotheringham (2014), IJGIS"),
            evidence("mgwrsar_mgwr", "benchmark_use", "spatialtidymodels package benchmark metadata"),
            evidence("MGWRSAR_0_kc_kv", "benchmark_use", "spatialtidymodels package benchmark metadata"),
            evidence("MGWRSAR_1_kc_kv", "benchmark_use", "spatialtidymodels package benchmark metadata"),
        ],
        "eligibility_basis": "scientific_evidence",
        "eligibility_source_ref": "Lu, Charlton, Harris & Fotheringham (2014), IJGIS, geographically weighted regression with hedonic house price data.",
        "eligibility_notes": "Dataset hedonique utilise pour GWR; bon cas de test pour coefficients locaux et variantes MGWR/MGWRSAR.",
    },
    "Python_geodatasets_spdata.boston": {
        "dataset": "boston_housing",
        "data_object": "boston_housing",
        "rds": "data/final_datasets/sf/Python_geodatasets_spdata.boston.rds",
        "formula": "CMEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + B + LSTAT",
        "response": "CMEDV",
        "predictors": [
            "CRIM",
            "ZN",
            "INDUS",
            "CHAS",
            "NOX",
            "RM",
            "AGE",
            "DIS",
            "RAD",
            "TAX",
            "PTRATIO",
            "B",
            "LSTAT",
        ],
        "coords": ["X", "Y"],
        "coords_crs": "EPSG:32619",
        "coords_source": "prepared projected coordinates",
        "formula_status": "pub",
        "source_ref": "Boston housing hedonic model",
        "notes": "Grand classique hedonique; SDM peut exposer des alias sur CHAS.",
        "estimator_evidence": [
            evidence(name, "benchmark_use", "Boston housing hedonic regression benchmark; package tests and benchmark metadata.")
            for name in ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "spboost_bspa_sar_ml", "spboost_bspa_sar_cfe", "spboost_bspa_sem_ml", "spboost_bspa_sem_cfe", "mgwrsar_gwr", "MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv"]
        ],
        "eligibility_basis": "benchmark_use",
        "eligibility_source_ref": "Boston housing hedonic regression benchmark; package tests and benchmark metadata.",
        "eligibility_notes": "Grand dataset continu utile pour comparer baselines ML, spatialreg, spboost et MGWRSAR; certaines variables binaires peuvent creer des alias.",
    },
    "R_GWmodel_DubVoter_Dub.voter": {
        "dataset": "dub_voter",
        "data_object": "dub_voter",
        "rds": "data/final_datasets/sf/R_GWmodel_DubVoter_Dub.voter.rds",
        "formula": "GenEl2004 ~ DiffAdd + LARent + SC1 + Unempl + LowEduc + Age18_24 + Age25_44 + Age45_64",
        "response": "GenEl2004",
        "predictors": [
            "DiffAdd",
            "LARent",
            "SC1",
            "Unempl",
            "LowEduc",
            "Age18_24",
            "Age25_44",
            "Age45_64",
        ],
        "coords": ["X", "Y"],
        "coords_crs": "EPSG:2157",
        "coords_source": "native projected coordinates",
        "formula_status": "pub",
        "source_ref": "GWmodel DubVoter documentation",
        "notes": "Exemple electoral GWR.",
        "estimator_evidence": [
            evidence("ols", "benchmark_use", "GWmodel DubVoter documentation and GWR examples."),
            evidence("gam_spatial", "benchmark_use", "GWmodel DubVoter documentation and GWR examples."),
            evidence("mgwrsar_gwr", "scientific_evidence", "GWmodel DubVoter documentation and GWR examples."),
            evidence("mgwrsar_mgwr", "benchmark_use", "GWmodel DubVoter documentation and GWR examples."),
        ],
        "eligibility_basis": "benchmark_use",
        "eligibility_source_ref": "GWmodel DubVoter documentation and GWR examples.",
        "eligibility_notes": "Dataset electoral continu avec coordonnees projetees; pertinent pour GWR/GAM spatial.",
    },
    "R_GWmodel_EWHP_ewhp": {
        "dataset": "ewhp",
        "data_object": "ewhp",
        "rds": "data/final_datasets/sf/R_GWmodel_EWHP_ewhp.rds",
        "formula": "PurPrice ~ BldIntWr + BldPostW + Bld60s + Bld70s + Bld80s + TypDetch + TypSemiD + TypFlat + FlrArea",
        "response": "PurPrice",
        "predictors": [
            "BldIntWr",
            "BldPostW",
            "Bld60s",
            "Bld70s",
            "Bld80s",
            "TypDetch",
            "TypSemiD",
            "TypFlat",
            "FlrArea",
        ],
        "coords": ["X", "Y"],
        "coords_crs": "EPSG:27700",
        "coords_source": "native projected coordinates",
        "formula_status": "used",
        "source_ref": "GWmodel EWHP documentation / project formula",
        "notes": "Attention aux dummies de type logement; formule projet sans TYPEFLAT.",
        "estimator_evidence": [
            evidence(name, "benchmark_use", "GWmodel EWHP documentation / project formula.")
            for name in ["ols", "gam_spatial", "mgwrsar_gwr", "mgwrsar_mgwr", "spboost_bspa_sar_ml", "spboost_bspa_sar_cfe"]
        ],
        "eligibility_basis": "benchmark_use",
        "eligibility_source_ref": "GWmodel EWHP documentation / project formula.",
        "eligibility_notes": "Dataset prix immobiliers avec dummies; utile pour tester robustesse aux variables aliasees et prediction spatiale locale.",
    },
    "R_agridat_lasrosas.corn_lasrosas.corn": {
        "dataset": "lasrosas",
        "data_object": "lasrosas",
        "aliases": [
            "lasrosas.corn",
            "Python_geodatasets_geoda.lasrosas",
            "python_geodatasets_geoda_lasrosas",
        ],
        "rds": "data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds",
        "formula": "yield ~ nitro + bv",
        "formula_default_role": "package_default",
        "formula_paper_main_specification": "yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo",
        "formula_ml_or_selected": "yield ~ nitro + bv",
        "formula_roles": ["package_default", "paper_main_specification", "multivariate_constrained", "ml_or_selected"],
        "formula_candidates": {
            "package_default": {
                "formula": "yield ~ nitro + bv",
                "response": "yield",
                "predictors": ["nitro", "bv"],
                "role": "package_benchmark_default",
                "source_type": "project_curated",
                "source_ref": "agridat::lasrosas.corn documentation / current spatialtidymodels benchmark",
                "status": "confirmed_executable",
            },
            "paper_main_specification": {
                "formula": "yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo",
                "response": "yield",
                "predictors": ["nitro", "I(nitro^2)", "topo", "nitro:topo", "I(nitro^2):topo"],
                "role": "paper_main_specification",
                "source_type": "scientific_publication",
                "source_ref": "Bongiovanni and Lowenberg-DeBoer (2000); Anselin, Bongiovanni and Lowenberg-DeBoer (2004, DOI 10.1111/j.0002-9092.2004.00610.x); Rakshit et al. (2020, DOI 10.1016/j.fcr.2020.107783).",
                "status": "confirmed",
            },
            "multivariate_constrained": {
                "formula": "yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo",
                "response": "yield",
                "predictors": ["nitro", "I(nitro^2)", "topo", "nitro:topo", "I(nitro^2):topo"],
                "role": "paper_main_specification",
                "source_type": "scientific_publication",
                "source_ref": "Bongiovanni and Lowenberg-DeBoer (2000); Anselin, Bongiovanni and Lowenberg-DeBoer (2004, DOI 10.1111/j.0002-9092.2004.00610.x); Rakshit et al. (2020, DOI 10.1016/j.fcr.2020.107783).",
                "status": "confirmed",
            },
            "ml_or_selected": {
                "formula": "yield ~ nitro + bv",
                "response": "yield",
                "predictors": ["nitro", "bv"],
                "role": "ml_candidate_features",
                "source_type": "project_curated",
                "source_ref": "agridat::lasrosas.corn documentation / current spatialtidymodels benchmark",
                "status": "confirmed_executable",
            },
        },
        "response": "yield",
        "predictors": ["nitro", "bv"],
        "coords": ["X", "Y"],
        "coords_crs": "EPSG:32720",
        "coords_source": "prepared projected coordinates",
        "formula_status": "used",
        "source_ref": "Las Rosas corn nitrogen response papers / agridat lasrosas.corn project benchmark formula",
        "notes": "Dataset canonique reconcilie avec Python_geodatasets_geoda.lasrosas; formule package par defaut et formule papier complete conservees.",
        "benchmark_status": "ready",
        "benchmark_task": "regression_spatial_validated_paper_and_package_formulas",
        "package_include": "yes",
        "benchmark_missing_items": "aucun blocage automatique detecte; formule papier complete et formule benchmark package documentees",
        "benchmark_readiness_reason": "Dataset Las Rosas reconcilie: agridat::lasrosas.corn est la fiche canonique, Python_geodatasets_geoda.lasrosas est un alias, et les formules papier/package sont conservees comme roles distincts.",
        "estimator_evidence": [
            evidence(name, "benchmark_use", "agridat lasrosas.corn documentation / project regression formula.")
            for name in ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "spboost_bspa_sar_ml", "spboost_bspa_sar_cfe", "mgwrsar_gwr", "MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv"]
        ],
        "eligibility_basis": "benchmark_use",
        "eligibility_source_ref": "agridat lasrosas.corn documentation / project regression formula.",
        "eligibility_notes": "Grand dataset agronomique continu; utile pour tester scalabilite, localite spatiale et tuning MGWRSAR.",
    },
}


ESTIMATOR_REGISTRY: list[dict[str, Any]] = [
    {
        "estimator": "ols",
        "package": "stats",
        "backend": "stats::glm",
        "requires_coords": False,
        "requires_W": False,
        "spatial_args": "",
        "tunable_parameters": "",
        "notes": "Baseline lineaire.",
    },
    {
        "estimator": "gam_spatial",
        "package": "mgcv",
        "backend": "mgcv::gam",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords",
        "tunable_parameters": "",
        "notes": "Baseline GAM avec lisseur spatial s(x, y).",
        "wiki_key": "gam",
    },
    {
        "estimator": "gamboost",
        "package": "mboost",
        "backend": "mboost::gamboost",
        "requires_coords": False,
        "requires_W": False,
        "spatial_args": "",
        "tunable_parameters": "mstop",
        "notes": "Baseline GAMBoost gradient-based via mboost::gamboost().",
        "wiki_key": "gamboost",
    },
    {
        "estimator": "earth",
        "package": "earth",
        "backend": "earth::earth",
        "requires_coords": False,
        "requires_W": False,
        "spatial_args": "",
        "tunable_parameters": "",
        "notes": "Baseline MARS native tidymodels sur X seules.",
        "wiki_key": "mars",
    },
    {
        "estimator": "earth_xy",
        "package": "earth",
        "backend": "earth::earth",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords_as_covariates",
        "tunable_parameters": "",
        "notes": "Baseline MARS native tidymodels sur X et coordonnees brutes.",
        "wiki_key": "mars",
    },
    {
        "estimator": "random_forest",
        "package": "ranger",
        "backend": "ranger::ranger",
        "requires_coords": False,
        "requires_W": False,
        "spatial_args": "",
        "tunable_parameters": "",
        "notes": "Baseline random forest native tidymodels sur X seules.",
    },
    {
        "estimator": "random_forest_xy",
        "package": "ranger",
        "backend": "ranger::ranger",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords_as_covariates",
        "tunable_parameters": "",
        "notes": "Baseline random forest native tidymodels sur X et coordonnees brutes.",
        "wiki_key": "random_forest",
    },
    {
        "estimator": "xgboost",
        "package": "xgboost",
        "backend": "xgboost::xgb.train",
        "requires_coords": False,
        "requires_W": False,
        "spatial_args": "",
        "tunable_parameters": "",
        "notes": "Baseline XGBoost native tidymodels sur X seules.",
    },
    {
        "estimator": "xgboost_xy",
        "package": "xgboost",
        "backend": "xgboost::xgb.train",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords_as_covariates",
        "tunable_parameters": "",
        "notes": "Baseline XGBoost native tidymodels sur X et coordonnees brutes.",
        "wiki_key": "xgboost",
    },
    {
        "estimator": "spatialml_grf",
        "package": "SpatialML",
        "backend": "SpatialML::grf",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords/bandwidth/kernel",
        "tunable_parameters": "bandwidth",
        "notes": "Geographical Random Forest: une foret locale par observation; kernel adaptatif, bandwidth = voisins.",
        "wiki_key": "spatialml_grf",
    },
    {
        "estimator": "spatialrf",
        "package": "spatialRF",
        "backend": "spatialRF::rf_spatial",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords/distance_matrix/MEM",
        "tunable_parameters": "",
        "notes": "Spatial Random Forest avec predicteurs spatiaux/MEM pour reduire l'autocorrelation residuelle.",
        "wiki_key": "spatialrf",
    },
    {
        "estimator": "rfgls",
        "package": "RandomForestsGLS",
        "backend": "RandomForestsGLS::RFGLS_estimate_spatial",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords/covariance/n_neighbors",
        "tunable_parameters": "k_neighbors",
        "notes": "Random Forest GLS pour donnees spatialement dependantes via approximation NNGP/Vecchia.",
        "wiki_key": "rfgls",
    },
    {
        "estimator": "sar_lag",
        "package": "spatialreg",
        "backend": "spatialreg::lagsarlm",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords/W/k_neighbors/style/zero_policy",
        "tunable_parameters": "k_neighbors",
        "notes": "SAR lag via fit_sar().",
    },
    {
        "estimator": "sem_error",
        "package": "spatialreg",
        "backend": "spatialreg::errorsarlm",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords/W/k_neighbors/style/zero_policy",
        "tunable_parameters": "k_neighbors",
        "notes": "SEM error via fit_sem().",
    },
    {
        "estimator": "sdm_mixed",
        "package": "spatialreg",
        "backend": "spatialreg::lagsarlm(Durbin)",
        "requires_coords": True,
        "requires_W": False,
        "spatial_args": "coords/W/k_neighbors/style/zero_policy",
        "tunable_parameters": "k_neighbors",
        "notes": "SDM mixed via fit_sdm().",
    },
]

for name, backend, notes in [
    ("spboost", "spboost::spbgam(BSPA_SAR_ML)", "Alias historique: SpBoost BSPA SAR avec ML pour rho; nu reste fixe."),
    ("spboost_bspa_sar_ml", "spboost::spbgam(BSPA_SAR_ML)", "BSPA SAR; ML estime le parametre spatial rho; nu reste fixe."),
    ("spboost_bspa_sar_cfe", "spboost::spbgam(BSPA_SAR_CFE)", "BSPA SAR; CFE estime le parametre spatial rho; nu reste fixe."),
    ("spboost_bspa_sem_ml", "spboost::spbgam(BSPA_SEM_ML)", "BSPA SEM; ML estime le parametre spatial lambda; nu reste fixe."),
    ("spboost_bspa_sem_cfe", "spboost::spbgam(BSPA_SEM_CFE)", "BSPA SEM; CFE estime le parametre spatial lambda; nu reste fixe."),
]:
    ESTIMATOR_REGISTRY.append(
        {
            "estimator": name,
            "package": "spboost",
            "backend": backend,
            "requires_coords": True,
            "requires_W": False,
            "spatial_args": "coords/k_neighbors",
            "tunable_parameters": "mstop, k_neighbors",
            "notes": notes,
            "wiki_key": "spboost",
        }
    )

for name, backend, requires_w, tunable, notes in [
    ("mgwrsar_gwr", "mgwrsar::MGWRSAR(GWR)", False, "bandwidth", "GWR local via mgwrsar_reg(Model='GWR'); benchmark kernel fixed to gauss."),
    ("mgwrsar_sar", "mgwrsar::MGWRSAR(SAR)", True, "", "SAR global via mgwrsar_reg(Model='SAR')."),
    ("mgwrsar_mgwr", "mgwrsar::TDS_MGWR", True, "", "MGWR multiscale via mgwrsar_reg(Model='tds_mgwr')."),
    ("mgwrsar_mgwrsar", "mgwrsar::MGWRSAR(MGWRSAR_1_0_kv)", True, "bandwidth", "MGWRSAR autocorrele via mgwrsar_reg(Model='MGWRSAR_1_0_kv'); benchmark kernel fixed to gauss."),
    ("MGWRSAR_0_kc_kv", "mgwrsar::MGWRSAR(MGWRSAR_0_kc_kv)", True, "bandwidth, k_neighbors, fixed_vars", "MGWRSAR mixte: lambda constant, coefficients fixes et locaux; W_opt par CV; benchmark kernel fixed to gauss."),
    ("MGWRSAR_1_kc_kv", "mgwrsar::MGWRSAR(MGWRSAR_1_kc_kv)", True, "bandwidth, k_neighbors, fixed_vars", "MGWRSAR mixte: lambda local, coefficients fixes et locaux; W_opt par CV; benchmark kernel fixed to gauss."),
]:
    ESTIMATOR_REGISTRY.append(
        {
            "estimator": name,
            "package": "mgwrsar",
            "backend": backend,
            "requires_coords": True,
            "requires_W": requires_w,
            "spatial_args": "coords/W/bandwidth/kernel/fixed_vars" if "kc_kv" in name else "coords/W/bandwidth/kernel",
            "tunable_parameters": tunable,
            "notes": notes,
            "wiki_key": "mgwrsar",
        }
    )

ESTIMATOR_REGISTRY.extend(
    [
        {
            "estimator": "spmoran_esf",
            "package": "spmoran",
            "backend": "spmoran::esf",
            "requires_coords": True,
            "requires_W": False,
            "spatial_args": "coords",
            "tunable_parameters": "enum, vif",
            "notes": "Eigenvector spatial filtering via spmoran::esf().",
            "wiki_key": "spmoran",
        },
        {
            "estimator": "spmoran_resf",
            "package": "spmoran",
            "backend": "spmoran::resf",
            "requires_coords": True,
            "requires_W": False,
            "spatial_args": "coords",
            "tunable_parameters": "enum",
            "notes": "Random-effects eigenvector spatial filtering via spmoran::resf().",
            "wiki_key": "spmoran",
        },
    ]
)


def strip_front_matter(text: str) -> str:
    if text.startswith("---"):
        parts = text.split("---", 2)
        if len(parts) == 3:
            return parts[2]
    return text


def yaml_title(text: str, fallback: str) -> str:
    match = re.search(r"^title:\s*(.+)$", text, flags=re.MULTILINE)
    return match.group(1).strip().strip('"') if match else fallback


def strip_inline_code(value: str | None) -> str | None:
    if value is None:
        return None
    value = value.strip().strip('"')
    if len(value) >= 2 and value.startswith("`") and value.endswith("`"):
        return value[1:-1].strip()
    return value


def bullet_value(text: str, label: str) -> str | None:
    pattern = rf"^\s*-\s*{re.escape(label)}\s*:\s*(.+?)\s*$"
    match = re.search(pattern, text, flags=re.IGNORECASE | re.MULTILINE)
    if not match:
        return None
    return match.group(1).strip().strip('"')


def backtick_list(value: str | None) -> list[str]:
    if not value:
        return []
    found = re.findall(r"`([^`]+)`", value)
    if found:
        return found
    return [item.strip() for item in re.split(r",|\+", value) if item.strip() and item.strip().lower() != "none"]


def formula_parts(formula: str | None) -> tuple[str | None, list[str]]:
    if not formula or "~" not in formula:
        return None, []
    lhs, rhs = formula.split("~", 1)
    predictors = [x.strip(" `") for x in rhs.split("+") if x.strip()]
    return lhs.strip(" `"), predictors


def leading_description(body: str) -> str | None:
    match = re.search(r"\A\s*(.*?)(?:\n##\s+|\Z)", body, re.DOTALL)
    if not match:
        return None
    value = " ".join(match.group(1).split())
    return value or None


def infer_description_metadata(dataset_id: str, description: str | None, data_type: str | None) -> dict[str, str]:
    text = " ".join([dataset_id, description or ""]).lower()
    topic = f"spatial dataset ({data_type or 'unknown'})"
    observation_unit = "spatial observation"
    observed_population = "pending"

    if any(word in text for word in ("house", "housing", "home_sales", "property", "properties", "price", "purchase")):
        topic = "real estate / housing prices"
        observation_unit = "house, real-estate transaction, or residential area"
        observed_population = "housing market described by the source documentation"
    if any(word in text for word in ("crime", "columbus", "police")):
        topic = "urban crime"
        observation_unit = "neighborhood, urban area, or police event"
        observed_population = "spatial units or events related to crime"
    if any(word in text for word in ("education", "school", "student", "bachelor", "pctbach")):
        topic = "education and socio-demographics"
        observation_unit = "administrative or school-related spatial unit"
        observed_population = "local education or socio-demographic population"
    if any(word in text for word in ("corn", "yield", "crop", "agri", "tomato", "herbicide", "wheat")):
        topic = "agriculture / crop yield"
        observation_unit = "field plot, experimental plot, or agricultural observation"
        observed_population = "agricultural observations described by the source documentation"
    if any(word in text for word in ("voter", "election", "elect", "vote")):
        topic = "elections and voting behavior"
        observation_unit = "electoral district, polling unit, or administrative unit"
        observed_population = "voting population or election results"
    if any(word in text for word in ("health", "disease", "lung", "loaloa", "case", "mortality", "cancer")):
        topic = "public health / spatial epidemiology"
        observation_unit = "individual, health case, or health-related spatial unit"
        observed_population = "health population described by the source documentation"
    if any(word in text for word in ("population", "census", "sdoh", "demographic", "income")) and topic.startswith("spatial dataset"):
        topic = "territorial socio-demographics"
        observation_unit = "census or administrative unit"
        observed_population = "territorial population described by the source documentation"

    return {
        "topic": topic,
        "observation_unit": observation_unit,
        "observed_population": observed_population,
    }


def parse_inline_list(value: str) -> list[str]:
    value = value.strip()
    if not (value.startswith("[") and value.endswith("]")):
        return []
    inner = value[1:-1].strip()
    if not inner:
        return []
    return [item.strip().strip("\"'") for item in inner.split(",") if item.strip()]


def clean_yaml_scalar(value: str) -> str:
    value = value.strip()
    if value in {"", "null", "None", "NA"}:
        return ""
    if (value.startswith('"') and value.endswith('"')) or (value.startswith("'") and value.endswith("'")):
        return value[1:-1]
    return value


def parse_estimator_eligibility(body: str) -> list[dict[str, Any]]:
    """Lit le bloc curatorial dataset-estimateur depuis une fiche Markdown.

    Le parser reste volontairement petit : les fiches utilisent un sous-ensemble
    YAML stable, sans ancrages ni structures imbriquees.
    """
    match = re.search(r"(?ms)```yaml\s*\n\s*estimator_eligibility:\s*(.*?)\n```", body)
    if not match:
        return []

    rows: list[dict[str, Any]] = []
    current: dict[str, Any] | None = None
    block = match.group(1)
    for raw_line in block.splitlines():
        line = raw_line.rstrip()
        if not line.strip():
            continue
        new_item = re.match(r"\s*-\s+estimator:\s*(.+?)\s*$", line)
        if new_item:
            if current:
                rows.append(current)
            current = {
                "estimator": clean_yaml_scalar(new_item.group(1)),
                "basis": "benchmark_use",
                "source_ref": "",
                "pages": None,
                "pdf_pages": None,
                "tables": [],
                "notes": "",
            }
            continue
        field = re.match(r"\s+([A-Za-z_]+):\s*(.*?)\s*$", line)
        if field and current is not None:
            key, value = field.group(1), field.group(2)
            if key == "tables":
                current[key] = parse_inline_list(value)
            else:
                current[key] = clean_yaml_scalar(value)
    if current:
        rows.append(current)
    rows = [row for row in rows if row.get("estimator")]
    if rows:
        return rows

    # Paper fiches generated by `generate_fiches_papers.R` use a compact
    # YAML form. Expand it to the row-oriented evidence format expected by
    # the package registry while keeping the fiche as the human source.
    compact_fields: dict[str, str] = {}
    for raw_line in block.splitlines():
        field = re.match(r"\s+([A-Za-z_]+):\s*(.*?)\s*$", raw_line.rstrip())
        if field:
            compact_fields[field.group(1)] = field.group(2)

    eligible = parse_inline_list(compact_fields.get("eligible_estimators", "[]"))
    conditional = parse_inline_list(compact_fields.get("conditionally_eligible_estimators", "[]"))
    source_ref = (
        bullet_value(body, "Reference publication")
        or bullet_value(body, "source_ref")
        or bullet_value(body, "Paper DOI")
        or "dataset fiche estimator_eligibility block"
    )
    out: list[dict[str, Any]] = []
    for estimator in eligible:
        out.append(
            {
                "estimator": estimator,
                "basis": "scientific_evidence",
                "source_ref": source_ref,
                "pages": None,
                "pdf_pages": None,
                "tables": [],
                "notes": "Expanded from compact estimator_eligibility block.",
            }
        )
    for estimator in conditional:
        out.append(
            {
                "estimator": estimator,
                "basis": "benchmark_use",
                "source_ref": source_ref,
                "pages": None,
                "pdf_pages": None,
                "tables": [],
                "notes": "Conditionally eligible; expanded from compact estimator_eligibility block.",
            }
        )
    return out


def parse_benchmark_readiness(body: str) -> dict[str, Any]:
    """Lit le bloc `benchmark_readiness` des fiches datasets.

    Ce bloc separe les datasets seulement documentes des datasets assez propres
    pour guider automatiquement `spatialtidymodels`.
    """
    out: dict[str, Any] = {
        "benchmark_status": "not_assessed",
        "benchmark_task": "unknown",
        "package_include": "manual_review",
        "has_local_rds": None,
        "benchmark_missing_items": "",
        "benchmark_readiness_reason": "",
    }
    match = re.search(r"(?ms)```yaml\s*\n\s*benchmark_readiness:\s*(.*?)\n```", body)
    if match:
        block = match.group(1)
    else:
        plain = re.search(
            r"(?ms)^benchmark_readiness:\s*\n(.*?)(?=\n(?:## |# |[A-Za-z][A-Za-z0-9_ -]*:\s*$)|\Z)",
            body,
        )
        if not plain:
            return out
        block = plain.group(1)
    key_map = {
        "benchmark_status": "benchmark_status",
        "benchmark_task": "benchmark_task",
        "package_include": "package_include",
        "has_local_rds": "has_local_rds",
        "missing_items": "benchmark_missing_items",
        "reason": "benchmark_readiness_reason",
    }
    for raw_line in block.splitlines():
        field = re.match(r"\s*([A-Za-z_]+):\s*(.*?)\s*$", raw_line.rstrip())
        if not field:
            continue
        key, value = field.group(1), clean_yaml_scalar(field.group(2))
        target = key_map.get(key)
        if not target:
            continue
        if target == "has_local_rds":
            out[target] = value.lower() == "true"
        else:
            out[target] = value
    return out


def is_pending_value(value: Any) -> bool:
    if value is None:
        return True
    text = str(value).strip().strip("`").strip().lower()
    return text in {"", "pending", "none", "unknown", "n/a", "na", "unavailable", "not_found"}


def package_promotion_blockers(
    *,
    body: str,
    benchmark_readiness: dict[str, Any],
    formula_used: str | None,
    response: str | None,
    predictors: list[str],
    local_artifact: str | None,
    source_url: str | None,
    source_ref: str | None,
) -> list[str]:
    """Return blockers that prevent a fiche from becoming package benchmark-ready.

    This is deliberately stricter than the wiki fiche parser: the wiki can
    document partial/pending candidates, but `spatialtidymodels` should only
    expose records that have an executable local Y/X benchmark.
    """
    blockers: list[str] = []
    if benchmark_readiness.get("package_include") != "yes":
        blockers.append("package_include_not_yes")
    if benchmark_readiness.get("benchmark_status") != "ready":
        blockers.append("benchmark_status_not_ready")
    if is_pending_value(formula_used):
        blockers.append("formula_used_missing_or_pending")
    if is_pending_value(response):
        blockers.append("response_missing")
    if not predictors:
        blockers.append("predictors_missing")
    if is_pending_value(local_artifact):
        blockers.append("local_artifact_missing")
    if is_pending_value(source_url) and is_pending_value(source_ref):
        blockers.append("source_missing")
    if "## Estimator eligibility" not in body:
        blockers.append("estimator_eligibility_block_missing")
    if "Selection Y/X" not in body:
        blockers.append("selection_yx_block_missing")
    task = str(benchmark_readiness.get("benchmark_task") or "").lower()
    if any(token in task for token in ("classification", "presence_absence", "binary_panel")):
        blockers.append("current_package_regression_only")
    return blockers


def parse_dataset_fiche(path: Path, repo_root: Path) -> dict[str, Any]:
    text = path.read_text(encoding="utf-8", errors="replace")
    body = strip_front_matter(text)
    dataset_id = bullet_value(body, "Dataset ID") or path.stem
    dataset_id = dataset_id.strip("`")
    formula_used = strip_inline_code(bullet_value(body, "formula_used"))
    formula_pub = strip_inline_code(bullet_value(body, "formula_pub"))
    formula_candidate_1 = strip_inline_code(bullet_value(body, "formula_candidate_1"))
    formula = formula_used or formula_pub or formula_candidate_1
    response, predictors = formula_parts(formula)
    coords = backtick_list(bullet_value(body, "Coordinates (x, y — excluded from X candidates)"))
    if not coords:
        coords = backtick_list(bullet_value(body, "Coordinates (x, y — excluded from X candidates)"))
    source_description = bullet_value(body, "Source description") or leading_description(body)
    description_fallbacks = infer_description_metadata(
        dataset_id,
        source_description,
        bullet_value(body, "Data type"),
    )
    estimator_evidence = parse_estimator_eligibility(body)
    benchmark_readiness = parse_benchmark_readiness(body)
    local_artifact = next(
        iter(re.findall(r"data/final_datasets/sf/[^\s\]]+\.(?:rds|gpkg)", text)),
        None,
    )
    local_rds = next(iter(re.findall(r"data/final_datasets/sf/[^\s\]]+\.rds", text)), None)
    source_url = bullet_value(body, "Source URL")
    source_ref = _source_ref(body)
    promotion_blockers = package_promotion_blockers(
        body=body,
        benchmark_readiness=benchmark_readiness,
        formula_used=formula_used,
        response=response,
        predictors=predictors or backtick_list(bullet_value(body, "Candidate X variables")),
        local_artifact=local_artifact,
        source_url=source_url,
        source_ref=source_ref,
    )
    publication_doi = bullet_value(body, "Publication DOI") or bullet_value(body, "Paper DOI")
    record = {
        "dataset": re.sub(r"[^A-Za-z0-9]+", "_", dataset_id).strip("_").lower(),
        "dataset_id": dataset_id,
        "title": yaml_title(text, path.stem),
        "topic": bullet_value(body, "Topic") or description_fallbacks["topic"],
        "observation_unit": bullet_value(body, "Observation unit") or description_fallbacks["observation_unit"],
        "observed_population": bullet_value(body, "Observed population") or description_fallbacks["observed_population"],
        "geographic_context": bullet_value(body, "Geographic context"),
        "temporal_context": bullet_value(body, "Temporal context"),
        "source_description": source_description,
        "description_source": bullet_value(body, "Description source"),
        "description_confidence": bullet_value(body, "Description confidence"),
        "wiki_path": str(path.relative_to(repo_root)).replace("\\", "/"),
        "data_object": None,
        "rds": local_rds,
        "local_artifact": local_artifact,
        "formula": formula,
        "formula_pub": formula_pub,
        "formula_used": formula_used,
        "formula_candidate_1": formula_candidate_1,
        "formula_candidate_2": bullet_value(body, "formula_candidate_2"),
        "response": response,
        "predictors": predictors or backtick_list(bullet_value(body, "Candidate X variables")),
        "coords": coords,
        "coords_crs": _epsg_value(bullet_value(body, "CRS EPSG")),
        "coords_source": "wiki dataset fiche",
        "recommended_cv": ["holdout_10pct", "near_prediction", "block_spatial"],
        "mode": "regression",
        "formula_status": _formula_status(body, formula_used, formula_pub),
        "source_family": bullet_value(body, "Source family"),
        "source_ref": source_ref,
        "source_url": source_url,
        "dataset_doi": _none_to_null(bullet_value(body, "Dataset DOI")),
        "publication_doi": _none_to_null(publication_doi),
        "license_name": bullet_value(body, "License name"),
        "data_type": bullet_value(body, "Data type"),
        "structure": bullet_value(body, "Structure"),
        "n_observations": _int_or_none(bullet_value(body, "N observations")),
        "t_periods": _int_or_none(bullet_value(body, "T periods")),
        "benchmark_ready": len(promotion_blockers) == 0,
        "benchmark_status": benchmark_readiness.get("benchmark_status"),
        "benchmark_task": benchmark_readiness.get("benchmark_task"),
        "package_include": benchmark_readiness.get("package_include"),
        "package_promotion_blockers": promotion_blockers,
        "benchmark_missing_items": benchmark_readiness.get("benchmark_missing_items"),
        "benchmark_readiness_reason": benchmark_readiness.get("benchmark_readiness_reason"),
        "eligible_estimators": [],
        "estimator_evidence": estimator_evidence,
        "eligibility_basis": "not_assessed",
        "eligibility_source_ref": None,
        "eligibility_notes": "",
        "notes": "",
    }
    if estimator_evidence:
        scientific_rows = [row for row in estimator_evidence if row.get("basis") == "scientific_evidence"]
        first_rows = scientific_rows or estimator_evidence
        record["eligibility_basis"] = first_rows[0].get("basis") or "benchmark_use"
        record["eligibility_source_ref"] = first_rows[0].get("source_ref")
        record["eligibility_notes"] = "Relations dataset-estimateur lues depuis la fiche Markdown."
        record["eligible_estimators"] = [
            row["estimator"]
            for row in estimator_evidence
            if row.get("basis") == "scientific_evidence"
        ]
        record["benchmark_estimators"] = [
            row["estimator"]
            for row in estimator_evidence
            if row.get("basis") in {"scientific_evidence", "benchmark_use"}
        ]
    if dataset_id in DATASET_ALIASES:
        record.update(DATASET_ALIASES[dataset_id])
        if estimator_evidence:
            record["estimator_evidence"] = estimator_evidence
            scientific_rows = [row for row in estimator_evidence if row.get("basis") == "scientific_evidence"]
            first_rows = scientific_rows or estimator_evidence
            record["eligibility_basis"] = first_rows[0].get("basis") or "benchmark_use"
            record["eligibility_source_ref"] = first_rows[0].get("source_ref")
            record["eligibility_notes"] = "Relations dataset-estimateur lues depuis la fiche Markdown."
        alias_description = " ".join(
            str(record.get(field) or "")
            for field in ("source_description", "formula", "source_ref", "notes")
        )
        alias_fallbacks = infer_description_metadata(
            dataset_id,
            alias_description,
            record.get("data_type"),
        )
        current_topic = str(record.get("topic") or "")
        current_observation_unit = str(record.get("observation_unit") or "")
        if (
            not current_topic
            or current_topic.startswith("spatial dataset")
            or current_topic.startswith("dataset spatial")
        ):
            record["topic"] = alias_fallbacks["topic"]
        if (
            not current_observation_unit
            or current_observation_unit == "spatial observation"
            or current_observation_unit.startswith("observation spatiale")
        ):
            record["observation_unit"] = alias_fallbacks["observation_unit"]
        if not record.get("observed_population") or record.get("observed_population") == "pending":
            record["observed_population"] = alias_fallbacks["observed_population"]
        evidence_rows = record.get("estimator_evidence", [])
        if evidence_rows:
            record["eligible_estimators"] = [
                row["estimator"]
                for row in evidence_rows
                if row.get("basis") == "scientific_evidence"
            ]
            record["benchmark_estimators"] = [
                row["estimator"]
                for row in evidence_rows
                if row.get("basis") in {"scientific_evidence", "benchmark_use"}
            ]
        record["benchmark_ready"] = True
    return record


def _epsg_value(value: str | None) -> str | None:
    if not value:
        return None
    match = re.search(r"(\d{4,5})", value)
    return f"EPSG:{match.group(1)}" if match else value


def _none_to_null(value: str | None) -> str | None:
    if not value or value.lower() in {"none", "pending", "unknown"}:
        return None
    return value


def _int_or_none(value: str | None) -> int | None:
    if not value:
        return None
    match = re.search(r"\d+", value)
    return int(match.group(0)) if match else None


def _formula_status(body: str, formula_used: str | None, formula_pub: str | None) -> str:
    status = bullet_value(body, "Statut")
    if status and status.lower() in {"resolved", "resolu", "résolu"}:
        return "pub" if formula_pub else "used"
    if formula_pub:
        return "pub"
    if formula_used:
        return "used"
    return "pending"


def _source_ref(body: str) -> str | None:
    for label in ("Reference publication", "source_ref", "Source"):
        value = bullet_value(body, label)
        if value:
            return value
    match = re.search(r"source_ref:\s*\"([^\"]+)\"", body)
    return match.group(1) if match else None


def parse_estimator_fiches(paths: list[Path], repo_root: Path) -> dict[str, dict[str, Any]]:
    # Les fiches estimateurs enrichissent le registre package sans remplacer les
    # noms courts validés côté API.
    out: dict[str, dict[str, Any]] = {}
    for path in paths:
        text = path.read_text(encoding="utf-8", errors="replace")
        key = path.stem.lower()
        out[key] = {
            "wiki_key": key,
            "title": yaml_title(text, path.stem),
            "wiki_path": str(path.relative_to(repo_root)).replace("\\", "/"),
            "metadata_status": "wiki_fiche_found",
        }
    return out


def build_estimators_json(
    estimator_fiches: dict[str, dict[str, Any]],
    dataset_records: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for item in ESTIMATOR_REGISTRY:
        row = dict(item)
        wiki_key = row.pop("wiki_key", row["estimator"]).lower()
        wiki = estimator_fiches.get(wiki_key, {})
        row.update(
            {
                "status": "automatic",
                "mode": "regression",
                "automatic": True,
                "test_datasets": [
                    dataset["dataset"]
                    for dataset in dataset_records
                    if dataset.get("benchmark_ready")
                    and row["estimator"] in dataset.get("benchmark_estimators", dataset.get("eligible_estimators", []))
                ],
                "wiki_key": wiki_key,
                "wiki_path": wiki.get("wiki_path"),
                "metadata_status": wiki.get("metadata_status", "package_registry_only"),
            }
        )
        rows.append(row)
    return rows


def write_json(path: Path, records: list[dict[str, Any]], source_dirs: dict[str, str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "schema_version": "spatialtidymodels_metadata_v1",
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "source": source_dirs,
        "records": records,
    }
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def export_metadata(repo_root: Path) -> tuple[Path, Path]:
    dataset_dir = repo_root / "wiki" / "datasets" / "fiches_datasets"
    estimator_dir = repo_root / "wiki" / "estimators"
    package_metadata_dir = repo_root / "packages" / "spatialtidymodels" / "inst" / "metadata"

    dataset_records = [
        parse_dataset_fiche(path, repo_root)
        for path in sorted(dataset_dir.glob("*.md"))
    ]
    estimator_fiches = parse_estimator_fiches(sorted(estimator_dir.glob("*.md")), repo_root)
    estimator_records = build_estimators_json(estimator_fiches, dataset_records)

    datasets_json = package_metadata_dir / "datasets.json"
    estimators_json = package_metadata_dir / "estimators.json"
    source_dirs = {
        "datasets": "wiki/datasets/fiches_datasets",
        "estimators": "wiki/estimators",
        "pipeline": "grobid -> kg -> wiki -> package/inst/metadata -> R API",
    }
    write_json(datasets_json, dataset_records, source_dirs)
    write_json(estimators_json, estimator_records, source_dirs)
    return datasets_json, estimators_json


def main() -> None:
    parser = argparse.ArgumentParser(description="Export spatialtidymodels metadata JSON files.")
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=Path(__file__).resolve().parents[2],
        help="Repository root. Defaults to the llm-wiki-karpathy root.",
    )
    args = parser.parse_args()
    datasets_json, estimators_json = export_metadata(args.repo_root.resolve())
    print(f"Wrote {datasets_json}")
    print(f"Wrote {estimators_json}")


if __name__ == "__main__":
    main()
