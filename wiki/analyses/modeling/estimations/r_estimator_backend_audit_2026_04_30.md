---
title: R Estimator Backend Audit 2026-04-30
type: analysis
created: 2026-04-30
updated: 2026-05-12
sources:
  - data/manifests/runs/estimator_software_registry.jsonl
  - Code_scrapping/R/estimators/load_estimators.R
  - Code_scrapping/R/utils/estimator_common.R
tags: [analysis, modeling, estimators, r, reticulate]
---

Audit of the R-first implementation route for the project allowlisted estimators.

## Summary

The modeling layer now has a first implementation map that privileges R-native packages and keeps Python-only routes behind R wrappers with `reticulate`.

The canonical machine-readable registry is `data/manifests/runs/estimator_software_registry.jsonl`.

## Classification

- Page type: `analysis`
- Location rationale: this page is a backend implementation audit, not a stable estimator reference fiche and not a metadata schema.
- Canonical location: `wiki/analyses/modeling/estimations/`
- Stable estimator definitions remain in `wiki/estimators/`.
- Implementation code has been moved under `Code_scrapping/R/`; old `R/...` paths should be treated as historical paths only.

## Backend Decisions

| Estimator | R route | Python route | Status | Action |
|---|---|---|---|---|
| XGBoost | `xgboost` | optional `reticulate` fallback | `native_r` | Use R first |
| LightGBM | `lightgbm` | optional `reticulate` fallback | `native_r` | Use R first, watch installation |
| GAMBoost | `mboost` | none selected | `native_r` | Use R first |
| Random Forest | `ranger` | not needed | `native_r` | Use R first |
| MARS | `earth` | none selected | `native_r` | Use R first |
| INLA | `INLA` | none selected | `native_r` | Use R first |
| SVC | `mgcv` spatially varying smooth variant | optional Python `mgwr` route | `r_native_variant` | Validate against estimator fiche |
| STVC | `mgcv` spatio-temporal smooth variant | none selected | `r_native_variant` | Validate against estimator fiche |
| MGWR | `GWmodel` | optional Python `mgwr` route | `native_r` | Use R first |
| MGWRSAR | `mgwrsar` | none selected | `native_r` | Confirm exact package API before production fitting |
| SpBoost | local package `spboost` | none selected | `native_r_local_package` | Install local source and validate first fits |
| RNN | R wrapper around `tensorflow.keras` | Python backend through `reticulate` | `r_wrapper_python` | Keep Python hidden behind R |
| SVM | `e1071` | not needed | `native_r` | Use R first |

## Wrapper Files

- `Code_scrapping/R/estimators/fit_xgboost.R`
- `Code_scrapping/R/estimators/fit_lightgbm.R`
- `Code_scrapping/R/estimators/fit_gamboost.R`
- `Code_scrapping/R/estimators/fit_random_forest.R`
- `Code_scrapping/R/estimators/fit_mars.R`
- `Code_scrapping/R/estimators/fit_inla.R`
- `Code_scrapping/R/estimators/fit_svc.R`
- `Code_scrapping/R/estimators/fit_stvc.R`
- `Code_scrapping/R/estimators/fit_mgwr.R`
- `Code_scrapping/R/estimators/fit_mgwrsar.R`
- `Code_scrapping/R/estimators/fit_spboost.R`
- `Code_scrapping/R/estimators/fit_rnn_reticulate.R`
- `Code_scrapping/R/estimators/fit_svm.R`

## Source Traceability

- Registry source: `data/manifests/runs/estimator_software_registry.jsonl`
- Loader source: `Code_scrapping/R/estimators/load_estimators.R`
- Common wrapper utilities: `Code_scrapping/R/utils/estimator_common.R`
- Local package/material evidence: `raw/estimators/`
- Traceability conclusion: this page summarizes local implementation routing decisions anchored in the registry and wrapper files. It should be evaluated as an analysis page, not as an estimator fiche.

## Open Validation Points

- Confirm whether `GWmodel::gwr.multiscale` covers the project MGWR definition sufficiently.
- Confirm the exact public fitting function exposed by the installed `mgwrsar` package.
- Validate the local `spboost` package installation and first `spbgam()` fits before any production run.
- Decide whether SVC and STVC should remain `mgcv` smooth variants or move to a more specialized spatial package.
- Add estimator-specific tests once the first modeling dataset is fixed.

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: local_code_and_registry_analysis
  provenance_score: 4
  provenance_evidence: "The audit is anchored in the estimator software registry and local R wrapper files under Code_scrapping/R."
  rigour_score: 3
  rigour_evidence: "Backend choices are explicit, but several open validation points remain before production fitting."
  evidence_score: 4
  evidence_evidence: "The page names the registry, loader, wrapper files and local raw estimator materials used as evidence."
  coherence_score: 4
  coherence_evidence: "The page is classified as an analysis and routed to wiki/analyses/modeling/estimations, matching AGENTS.md routing."
  claim_discipline_score: 3
  claim_discipline_evidence: "The page separates backend routing decisions from estimator theory and leaves uncertain package/API checks as open validation points."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: not_applicable
    citation_checked_at: null
    citation_interpretation: not_applicable
    citation_evidence: "This is a local implementation audit, not a dataset or paper claim."
  delta1_risk: medium
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[r_estimator_implementation_policy_v1]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
