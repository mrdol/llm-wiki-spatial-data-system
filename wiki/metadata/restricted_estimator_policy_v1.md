---
title: Restricted Estimator Policy v1
type: metadata
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [metadata, estimators, policy, allowlist]
---

Project-wide estimator allowlist used by catalog records and discovery logic.

## Policy

Only the following estimators are allowed in this project:

- `XGBoost`
- `LightGBM`
- `GAMBoost`
- `Random Forest`
- `MARS`
- `INLA`
- `STVC`
- `SVC`
- `MGWR`
- `MGWRSAR`
- `SpBoost`
- `RNN`
- `SVM`

## Enforcement Rules

- Only listed estimators are allowed in the project.
- Every dataset record must assess whether at least one allowed estimator is plausible.
- Dataset records must store candidate estimators in `methodological_selection.candidate_estimators[]`.
- Each candidate estimator entry must include a justification grounded in documented dataset characteristics.
- Discovery logic must ignore non-allowlisted estimator names when ranking or recommending datasets.
- Legacy estimator pages may remain in the wiki as methodological references, but they are not project-approved unless they appear in this allowlist.
- If estimator suitability has not yet been validated for a dataset, use:
  - `estimator_assessment_status: pending`
  - `at_least_one_allowed_estimator_plausible: null`
  - `candidate_estimators: []`
- If a dataset is assessed and none of the allowed estimators is plausible, store:
  - `at_least_one_allowed_estimator_plausible: false`
  - one or more rejected candidate entries with explicit justification

## Required Dataset Fields

- `methodological_selection.estimator_assessment_status`
- `methodological_selection.at_least_one_allowed_estimator_plausible`
- `methodological_selection.candidate_estimators[]`
- `methodological_selection.estimator_policy_ref`

## Current Implication

- Existing dataset records should not carry free-form approved-estimator suggestions.
- Historical references such as [[grubel_lloyd_index]] remain useful for methodological context but are outside the restricted project registry.

## Related Pages

- [[catalog_registry_schema_v3]]
- [[discovery_policy_v3]]
- [[grubel_lloyd_index]]
- [[rnn]]
- [[svm]]
