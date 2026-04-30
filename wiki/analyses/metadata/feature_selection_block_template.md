---
title: Feature Selection Block Template
type: analysis
created: 2026-04-29
updated: 2026-04-29
sources: []
tags: [analysis, metadata, variables, feature-selection, template]
---

Generic block for documenting the difference between all available explanatory variables and the subset used for estimation.

## Purpose

Use this block when a paper, README, codebase, metadata page, or data inspection shows that a dataset contains many possible `X` variables, but only a subset is used in an estimation.

## Generic Block

```json
{
  "feature_selection": {
    "x_total_reported": null,
    "x_candidates": [],
    "x_candidate_count": null,
    "x_selected": [],
    "x_selected_count": null,
    "selection_source": "unknown",
    "selection_method": "unknown",
    "selection_reason": null,
    "target_y": null,
    "estimation_context": null,
    "confidence": "low",
    "status": "pending"
  }
}
```

## Field Meanings

- `x_total_reported`: total number of explanatory variables documented by the author, metadata, code, or data inspection.
- `x_candidates`: variables that could plausibly be used as predictors.
- `x_candidate_count`: count of candidate predictors.
- `x_selected`: predictors actually used in a paper or project estimation.
- `x_selected_count`: count of selected predictors.
- `selection_source`: where the information comes from.
- `selection_method`: why variables were retained or removed.
- `selection_reason`: short explanation of the selection logic.
- `target_y`: response variable for which the predictors are selected.
- `estimation_context`: estimator, benchmark, or model where the selected variables are used.
- `confidence`: confidence in the extraction.
- `status`: `pending`, `partial`, or `complete`.

## Example

```json
{
  "feature_selection": {
    "x_total_reported": 30,
    "x_candidates": ["income", "education", "age", "population_density"],
    "x_candidate_count": 30,
    "x_selected": ["income", "education", "population_density"],
    "x_selected_count": 10,
    "selection_source": "full_paper",
    "selection_method": "author_selected",
    "selection_reason": "The paper reports 30 candidate covariates and keeps 10 for the final spatial panel estimation.",
    "target_y": "unemployment_rate",
    "estimation_context": "spatial panel regression",
    "confidence": "high",
    "status": "complete"
  }
}
```

## Related Pages

- [[variable_typology]]
- [[modeling_evidence]]
- [[catalog_registry_schema_v3]]
