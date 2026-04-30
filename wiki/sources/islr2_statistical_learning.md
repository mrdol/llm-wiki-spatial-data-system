---
title: An Introduction to Statistical Learning with Applications in R
type: source
created: 2026-04-23
updated: 2026-04-23
sources: [ISLRv2_corrected_June_2023.pdf]
tags: [source, textbook, statistical-learning, svm, neural-networks, resampling]
---

Official statistical learning textbook used as a general modeling reference for resampling, SVMs, tree methods, and neural networks.

## Bibliographic Metadata

- Title: *An Introduction to Statistical Learning with Applications in R*
- Edition: Second edition
- Authors: Gareth James, Daniela Witten, Trevor Hastie, Robert Tibshirani
- Publisher: Springer
- Series: Springer Texts in Statistics
- DOI: `10.1007/978-1-0716-1418-1`
- Official book page: `https://www.statlearning.com/`
- Springer page: `https://link.springer.com/book/10.1007/978-1-0716-1418-1`

## Local File

- Local path: `data/downloads/reference_books/ISLRv2_corrected_June_2023.pdf`
- Manifest: `data/manifests/reference_books/islr2.json`
- SHA256: `7ed447d1a513c5dd95240a829603310f1d319a14a8079ddfb180c6a3d9d9a6ff`

## Project Role

- Use as a general statistical learning reference.
- Use for background on resampling, tuning, support vector machines, tree-based methods, and neural networks.
- Do not treat it as a dedicated paper source for a hybrid RNN-SVM estimator.

## Estimator Relevance

| Estimator | Relevance | Evidence role |
|---|---|---|
| [[random_forest]] | High | General tree and ensemble background |
| [[xgboost]] | Indirect | Boosting background, not specific XGBoost paper evidence |
| [[lightgbm]] | Indirect | Boosting background, not specific LightGBM paper evidence |
| [[rnn]] | Partial | General neural-network background, not dedicated recurrent-network evidence |
| [[svm]] | Partial | SVM background for margins, kernels, and tuning |

## Use Constraints

- Keep source-specific claims tied to the textbook.
- Do not infer project-specific validation design from this book because the cross-validation policy will be fixed by the project owner.
- Use it to structure terminology and generic tuning concepts, not to replace method-specific papers.

## Related Pages

- [[estimator_fiche_schema_v1]]
- [[restricted_estimator_policy_v1]]
- [[random_forest]]
- [[xgboost]]
- [[lightgbm]]
- [[rnn]] and [[svm]]

