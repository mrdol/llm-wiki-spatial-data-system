---
title: RNN
type: estimator
created: 2026-04-29
updated: 2026-06-04
sources:
  - ISLRv2_corrected_June_2023.pdf
  - Elman 1990, Finding Structure in Time, doi:10.1207/s15516709cog1402_1
  - Hochreiter and Schmidhuber 1997, Long Short-Term Memory, doi:10.1162/neco.1997.9.8.1735
tags: [estimator, neural-network, sequence, temporal, hyperparameters, paper-supported]
---

RNNs are sequence models for ordered observations. In this project they are only
appropriate when the dataset supports meaningful temporal or event sequences.

## Summary

RNNs maintain a hidden state through time. Vanilla RNNs are historically
important but often difficult to train over long horizons; LSTM/GRU-style cells
are practical alternatives when long memory is required.

RNNs should not be used just because a dataset contains dates. The data must
support sequence construction: ordered panels, trajectories, time series, event
streams or gridded temporal windows.

## Estimator Family

- Family: recurrent neural networks.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: ISLR background plus RNN/LSTM references.

## Model Equation

Canonical recurrence:

```math
h_t = \phi(W_x x_t + W_h h_{t-1} + b)
```

```math
\hat{y}_t = g(W_y h_t + c)
```

where `h_t` is the hidden state and `x_t` is the input at time `t`.

## Data Structures It May Fit

- Time series.
- Spatial panels with enough time depth.
- Trajectory data.
- Event sequences.
- Space-time grids after explicit window construction.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `sequence_length` | Input window size | yes | Must be justified by temporal scale. |
| `cell_type` | RNN, GRU, LSTM | yes | LSTM/GRU usually for longer dependencies. |
| `hidden_units` | State dimension | yes | Capacity control. |
| `num_layers` | Recurrent depth | yes | Adds abstraction but raises overfitting risk. |
| `dropout` | Regularization | yes | Important on short panels. |
| `learning_rate` | Optimizer step size | yes | Tune with batch size. |
| `batch_size` | Optimization batch size | later | Implementation-dependent. |

## Cross-validation Policy

Use temporal, spatial or space-time blocked validation. Future observations must
not enter training windows for earlier prediction targets.

## Diagnostics To Inspect

- Train/validation loss curves.
- Error by horizon.
- Error by spatial unit.
- Sensitivity to sequence length.
- Leakage checks in window construction.

## Failure Modes

- Applying RNNs to unordered tabular data.
- Short panels with too little temporal depth.
- Temporal leakage from random splits.
- Poor interpretability compared with coefficient models.
- High variance across random initializations.

## Related Pages

- [[spatiotemporal_data]]
- [[data_leakage]]
- [[svm]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
