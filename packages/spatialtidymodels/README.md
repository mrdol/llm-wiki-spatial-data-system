# spatialtidymodels

Extension tidymodels en developpement pour transformer les estimateurs
spatiaux du benchmark `llm-wiki-karpathy` en specs `parsnip` compatibles avec
`workflows`, `tune_grid()` et les conventions tidymodels.

## Etat actuel

- `spatialreg_reg()` : spec parsnip pour SAR, SEM et SDM via `spatialreg`.
- `spboost_reg()` : spec parsnip pour SpBoost via `spboost`.
- `mgwrsar_reg()` : spec parsnip pour GWR/MGWR/MGWRSAR via `mgwrsar`.
- `build_knn_W()` / `build_knn_listw()` : helpers communs pour construire `W`.

Ce package est une extension interne en developpement: le code est versionne,
teste localement et utilisable dans le projet, mais pas encore stabilise comme
API publique ou package CRAN.

## Parite package / benchmark manuel

Les routes `spatialreg` ont ete comparees ligne par ligne au benchmark manuel
sur les memes resamples:

| Dataset | Estimateurs | Resultat |
|---|---|---|
| `columbus_crime` | `sar_lag`, `sem_error`, `sdm_mixed` | 27/27 folds, `max_abs_diff = 0` |
| `london_hp` | `sar_lag`, `sem_error`, `sdm_mixed` | 33/33 folds, `max_abs_diff = 0` |
| `boston_housing` | `sar_lag`, `sem_error` | 22/22 folds, `max_abs_diff = 0` |
| `boston_housing` | `sdm_mixed` | echec reproduit cote manuel et package: `CHAS1` / `lag.CHAS1` aliases |

Le cas `boston_housing` montre que la parite peut aussi documenter un echec
reproductible. Ici, le probleme n'est pas une divergence package/benchmark,
mais une colinearite du design SDM pour une covariable binaire.
