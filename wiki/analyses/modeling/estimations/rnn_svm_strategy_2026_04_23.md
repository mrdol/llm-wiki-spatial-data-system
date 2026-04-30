---
title: RNN and SVM documentation and modeling strategy
type: analysis
created: 2026-04-23
updated: 2026-04-23
sources: [ISLRv2_corrected_June_2023.pdf]
tags: [analysis, estimator, rnn, svm, strategy, modeling]
---

Strategy note for interpreting RNN and SVM as two separate candidate methods in the allowed estimator registry.

## Recommendation

Keep [[rnn]] and [[svm]] as a combined administrative fiche for two separate methods: recurrent neural networks and support vector machines.

The clean operational definition should be:
- RNN: standalone sequence model for temporal or sequential data
- SVM: standalone margin-based model for classification or regression
- hybrid RNN-SVM: deprecated as a default interpretation; only possible later if a dedicated source and modeling need justify it

## Why This Is Defensible

- The supervisor's notation means both methods are intended candidates, not necessarily one hybrid method.
- SVM can be a strong tabular benchmark when features are properly scaled.
- RNN can make sense only if the final dataset bank contains temporal or sequence-like data.
- Generic SVM and neural-network background can be supported by [[islr2_statistical_learning]], while RNN-specific details still need a dedicated paper.

## What Documentation Is Still Missing

- A paper or technical reference for the RNN family to be used.
- A precise definition of the RNN block:
  - vanilla RNN
  - GRU
  - LSTM
  - other recurrent encoder
- A precise definition of the SVM block:
  - classification SVM
  - support vector regression
  - linear kernel
  - RBF or other nonlinear kernel
- A decision on whether SVM will be used for classification, regression, or both.

## Hyperparameter Strategy

Treat the hyperparameters as two independent groups.

RNN feature extractor:
- `sequence_length`
- `hidden_units`
- `num_layers`
- `dropout`
- `learning_rate`
- `batch_size`
- `epochs`
- cell type, if the implementation allows RNN, GRU, or LSTM variants

SVM:
- `svm_C`
- `svm_kernel`
- `svm_gamma`
- `epsilon`, if using support vector regression
- class weights, if classification is imbalanced

## Cross-validation Boundary

The cross-validation scheme remains outside the estimator fiche and will be fixed by the project owner.

For RNN, the future validation policy must explicitly avoid temporal leakage:
- sequence windows must not leak future information
- representation learning must be performed inside the training split
- scaling and feature extraction must be fit inside the training split only

## When To Use

Use RNN only if:
- the dataset has meaningful temporal ordering
- the target benefits from sequence history
- simpler temporal baselines have already been tested
- a dedicated RNN reference has been added or the method is explicitly treated as exploratory

Use SVM if:
- the dataset can be represented as a scaled feature matrix
- the sample size is compatible with the implementation
- nonlinear kernels or margin-based decision boundaries are plausible

## When Not To Use

Do not use RNN if:
- the dataset is a simple cross-section
- temporal order is weak or artificial
- sample size is too small for representation learning

Do not use SVM if:
- feature scaling cannot be made reliable
- the dataset is too large for the selected SVM implementation
- the modeling goal requires transparent coefficient interpretation

## Immediate Next Step

Find and add one dedicated RNN reference to `raw/paper/`.

Until then:
- keep [[rnn]] and [[svm]] as an allowed placeholder
- do not promote RNN hyperparameters from `project_candidate` to `paper_supported`
- use [[islr2_statistical_learning]] for generic SVM, neural-network, and resampling background

## Related Pages

- [[rnn]] and [[svm]]
- [[estimator_fiche_schema_v1]]
- [[restricted_estimator_policy_v1]]
- [[islr2_statistical_learning]]

