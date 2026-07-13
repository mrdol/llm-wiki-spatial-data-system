# spatialtidymodels

Package experimental pour transformer les estimateurs spatiaux du benchmark
`llm-wiki-karpathy` en specs `parsnip` compatibles avec `workflows`,
`tune_grid()` et les conventions tidymodels.

## Etat actuel

- `spatialreg_reg()` : spec parsnip pour SAR, SEM et SDM via `spatialreg`.
- `spboost_reg()` : spec parsnip pour SpBoost via `spboost`.
- `mgwrsar_reg()` : spec parsnip pour GWR/MGWR/MGWRSAR via `mgwrsar`.
- `build_knn_W()` / `build_knn_listw()` : helpers communs pour construire `W`.

Ce package est encore un squelette de developpement. Les fichiers proviennent
des wrappers valides dans `code/R/estimators/` et doivent maintenant etre
stabilises avec tests et documentation roxygen.
