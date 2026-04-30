---
title: RNN
type: estimator
created: 2026-04-29
updated: 2026-04-29
sources: [ISLRv2_corrected_June_2023.pdf]
tags: [estimator, neural-network, sequence, temporal, hyperparameters]
---

Recurrent neural network estimator family for ordered temporal or sequential prediction tasks.

## Summary

RNN is a standalone candidate estimator for datasets where the ordering of observations carries predictive information. It should not be used only because a dataset has dates; the data must support meaningful sequence construction.

## Estimator Family

- Family: recurrent neural networks
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Evidence status: background support from [[islr2_statistical_learning]], dedicated RNN paper still useful for later enrichment

## Model Equation

Canonical recurrence:

`h_t = phi(W_x x_t + W_h h_{t-1} + b)`

`y_hat_t = g(W_y h_t + c)`

Where:

- `x_t` is the input feature vector at step `t`
- `h_t` is the hidden state
- `phi` is a nonlinear activation or recurrent cell update
- `g` maps the hidden representation to the prediction target

Evidence status: `canonical_form_pending_dedicated_rnn_paper`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| [[islr2_statistical_learning]] | background | General neural-network and resampling reference, not a dedicated RNN source |
| dedicated RNN paper | missing | Add before treating architecture choices as paper-supported |

## Data Structures It May Fit

- Ordered time series
- Spatial panels converted into ordered temporal sequences
- Trajectory data
- Event sequences
- Spatio-temporal grids only after explicit sequence-window construction

## Compatible Variable Typologies

- Candidate `Y`: continuous, binary, categorical, count, rate, or proportion depending on output layer and loss
- Candidate `X`: temporal, lagged, continuous, categorical embeddings, spatial features, engineered sequence windows
- Required: explicit temporal order or sequence index

## Main Use Cases

- Forecasting
- Sequence classification
- Temporal pattern extraction
- Benchmarking against tree-based and spatial estimators when temporal dependence is central

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `sequence_length` | Input time-window length | yes | project_candidate | Must be defined from the dataset temporal structure |
| `hidden_units` | Latent state dimension | yes | project_candidate | Controls representation capacity |
| `num_layers` | Recurrent depth | yes | project_candidate | Controls temporal abstraction |
| `cell_type` | Vanilla RNN, GRU, or LSTM | later | project_candidate | Needs implementation and source decision |
| `dropout` | Neural regularization | yes | project_candidate | Controls overfitting |
| `learning_rate` | Optimizer step size | yes | project_candidate | Tune with batch size and optimizer |
| `batch_size` | Optimization batch size | later | implementation_supported | Depends on implementation |

## Cross-validation Policy

The cross-validation design is external to this fiche.

RNN validation must prevent temporal leakage: future observations must not influence training windows used to predict earlier periods.

## Diagnostics To Inspect

- Train/validation loss curves
- Temporal leakage checks
- Sequence-window sensitivity
- Error by time period
- Error by spatial unit if the input is a spatial panel

## Failure Modes

- Using RNN on unordered tabular data
- Temporal leakage from random splits
- Overfitting on short panels
- Unstable results when sequence length is arbitrary
- Poor interpretability compared with spatial coefficient models

## Dataset Compatibility Notes

RNN is plausible only when the dataset has enough temporal depth or event order to justify sequence learning.

## Related Pages

- [[svm]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[spatiotemporal_data]]
- [[data_leakage]]
