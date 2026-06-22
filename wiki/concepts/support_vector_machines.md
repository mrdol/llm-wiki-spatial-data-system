---
title: Support Vector Machines
type: concept
created: 2026-06-04
updated: 2026-06-04
sources:
  - Cortes and Vapnik 1995, doi:10.1007/BF00994018
tags: [concept, machine-learning, svm, kernel]
---

Support vector machines are margin-based estimators using support vectors and,
optionally, kernels.

## Modeling Relevance

SVM can be a useful baseline for moderate-size feature matrices. It requires
strict fold-local preprocessing because scaling before splitting creates
leakage.

## Related Pages

- [[svm]]
- [[data_leakage]]
