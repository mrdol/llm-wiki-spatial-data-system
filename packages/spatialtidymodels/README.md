# spatialtidymodels

Extension tidymodels en developpement pour transformer les estimateurs
spatiaux du benchmark `llm-wiki-karpathy` en specs `parsnip` compatibles avec
`workflows`, `tune_grid()` et les conventions tidymodels.

## Etat actuel

- `spatialreg_reg()` : spec parsnip generique pour SAR, SEM et SDM via `spatialreg`.
- `sar_reg()`, `sem_reg()`, `sdm_reg()` : specs explicites qui fixent le
  type de modele spatialreg et rendent les workflows plus lisibles.
- `spatial_knn_args()` : contrat commun des arguments geographiques
  (`coords`, `W`, `k_neighbors`, `style`, `zero_policy`).
- `spboost_reg()` : spec parsnip pour SpBoost via `spboost`.
- `mgwrsar_reg()` : spec parsnip pour GWR/MGWR/MGWRSAR via `mgwrsar`.
- `build_knn_W()` / `build_knn_listw()` : helpers communs pour construire `W`.

Ce package est une extension interne en developpement: le code est versionne,
teste localement et utilisable dans le projet, mais pas encore stabilise comme
API publique ou package CRAN.

## API utilisateur stabilisee en premier

L'entree recommandee pour les modeles `spatialreg` est maintenant:

```r
library(spatialtidymodels)
library(parsnip)

spec <- sar_reg(
  coords = c("X", "Y"),
  k_neighbors = 8,
  style = "W",
  zero_policy = TRUE
) |>
  set_engine("spatialreg") |>
  set_mode("regression")
```

`coords`, `W`, `k_neighbors`, `style` et `zero_policy` sont des arguments
geographiques: ils definissent la structure spatiale utilisee par le backend.
Ils ne doivent pas etre confondus avec les arguments econometriques du modele.
Si `W` est fourni, il est utilise au fit; sinon le package construit un
voisinage kNN depuis `coords`.

Pour un usage plus proche de `glm(formula, data)`, les raccourcis suivants
construisent automatiquement la spec, le workflow et le fit:

```r
fit <- fit_sar(
  CRIME ~ HOVAL + INC,
  data = columbus,
  coords = c("X", "Y"),
  k_neighbors = 8
)

predict(fit, new_data = columbus)
```

Les variantes equivalentes sont `fit_sem()` et `fit_sdm()`.

Pour comparer rapidement un modele spatial a OLS sur les diagnostics utiles au
benchmark:

```r
diagnose_spatial(fit, data = columbus)
```

La table retourne notamment RMSE, MAE, AIC, log-vraisemblance, parametre
spatial (`rho` ou `lambda`) et Moran I des residus. Quand la formule est connue,
une ligne `ols_baseline` est ajoutee automatiquement.

Pour lancer automatiquement plusieurs estimateurs sur le meme jeu:

```r
bench <- benchmark_spatial(
  CRIME ~ HOVAL + INC,
  data = columbus,
  coords = c("X", "Y"),
  estimators = c(
    "ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed",
    "spboost", "mgwrsar_gwr", "mgwrsar_sar", "mgwrsar_mgwr",
    "mgwrsar_mgwrsar"
  ),
  spboost_mstop = 100,
  mgwrsar_bandwidth = 20
)

bench$results
```

`available_benchmark_estimators()` liste les estimateurs deja automatises et
ceux qui sont connus mais encore a brancher dans le benchmark package.
`benchmark_spatial_datasets()` permet aussi de lancer la meme liste
d'estimateurs sur plusieurs jeux de donnees declares par
`spatial_dataset_spec()`. Les tests package utilisent `columbus_crime` et
`london_hp`; `lsl` est volontairement laisse hors de ces tests de regression
car sa cible scientifique est binaire.

Routes automatisees dans cette couche package: `ols`, `gam_spatial`,
`sar_lag`, `sem_error`, `sdm_mixed`, `spboost`, `mgwrsar_gwr`,
`mgwrsar_sar`, `mgwrsar_mgwr` et `mgwrsar_mgwrsar`. Les routes
`spmoran_esf` et `spmoran_resf` restent connues mais non automatisees dans le
package.

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
