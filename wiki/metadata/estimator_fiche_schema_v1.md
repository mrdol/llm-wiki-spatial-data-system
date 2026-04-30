---
title: Estimator fiche schema v1
type: metadata
created: 2026-04-23
updated: 2026-04-23
sources: []
tags: [metadata, estimator, schema, hyperparameters, modeling]
---

Schema for estimator fiches used to document allowed modeling methods, paper evidence, and tuning-relevant hyperparameters.

## Purpose

Estimator fiches are caret-like method cards for the project modeling phase.

They are not experiment logs. They define what must be known before modeling starts:
- what the estimator is for
- what data structures it can plausibly handle
- which hyperparameters control model behavior
- which diagnostics should be inspected
- which papers support the method entry
- how the estimator relates to the project catalog

## Scope Rule

Only estimators listed in [[restricted_estimator_policy_v1]] may receive project fiches.

Allowed estimator fiches:
- [[xgboost]]
- [[lightgbm]]
- [[gamboost]]
- [[random_forest]]
- [[mars]]
- [[inla]]
- [[stvc]]
- [[svc]]
- [[mgwr]]
- [[mgwrsar]]
- [[spboost]]
- [[rnn]]
- [[svm]]

## Cross-validation Rule

The cross-validation design is external to the estimator fiche.

Each fiche must state:
- the project owner will define the cross-validation scheme
- the fiche only records hyperparameters that may be tuned inside that scheme
- the fiche must not hard-code fold count, fold geometry, blocking, temporal split, spatial split, or nested-validation design unless the project owner later adds a dedicated validation-policy page

## Required Frontmatter

```yaml
---
title: <Estimator display name>
type: estimator
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [paper filenames used as evidence]
tags: [estimator, modeling, hyperparameters]
---
```

## Required Sections

Every estimator fiche must contain:
- Summary
- Estimator Family
- Model Equation
- Paper Evidence Status
- Data Structures It May Fit
- Main Use Cases
- Hyperparameters To Optimize
- Secondary Hyperparameters
- Hyperparameter Interactions
- Cross-validation Policy
- Diagnostics To Inspect
- Failure Modes
- Minimal Tuning Workflow
- Dataset Compatibility Notes
- Open Questions From Papers
- Related Pages

## Hyperparameter Evidence Levels

Use one of these evidence statuses for each hyperparameter:
- `paper_supported`: directly documented in one or more source papers
- `implementation_supported`: documented in a package or software implementation but not yet checked against papers
- `project_candidate`: plausible tuning field pending paper extraction
- `not_applicable`: field intentionally excluded

## Hyperparameter Table Format

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `<name>` | What it controls | yes/no/later | paper_supported/project_candidate/etc. | Constraint, default, or interaction note |

## Model Equation Format

Each fiche should include a short canonical equation or objective before the paper evidence table:

- use plain Markdown with LaTeX-style inline or display math
- define the main symbols immediately below the equation
- mark the equation as `canonical_form_pending_paper_extraction` when it has not yet been checked against the source paper
- keep implementation-specific objectives separate from the conceptual model if they differ

## Dataset Compatibility Fields

Each fiche should assess compatibility against catalog metadata:
- spatial support required
- temporal support required
- response variable type
- predictor requirements
- minimum data volume
- missing-data sensitivity
- compatible `Y` typologies
- compatible `X` typologies
- compatible modeling evidence families where relevant
- plausible catalog datasets

Do not mark a dataset as compatible unless the catalog record contains enough metadata to justify the claim.

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[catalog_registry_schema_v3]]
- [[discovery_policy_v3]]
