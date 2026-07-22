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
- `spboost_reg()` : spec parsnip generique pour SpBoost via `spboost`.
- `spboost_bspa_sar_ml()`, `spboost_bspa_sar_cfe()`,
  `spboost_bspa_sem_ml()`, `spboost_bspa_sem_cfe()` : specs explicites pour
  les quatre routes BSPA principales. `ML` et `CFE` sont deux methodes
  d'estimation du parametre spatial (`rho` ou `lambda`), pas deux familles
  spatiales differentes.
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
    "ols", "gam_spatial", "earth", "earth_xy",
    "random_forest", "random_forest_xy", "xgboost", "xgboost_xy",
    "sar_lag", "sem_error", "sdm_mixed",
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
`gamboost`, `earth`, `earth_xy`, `random_forest`, `random_forest_xy`, `xgboost`,
`xgboost_xy`, `sar_lag`, `sem_error`, `sdm_mixed`, `spboost`,
`spboost_bspa_sar_ml`, `spboost_bspa_sar_cfe`, `spboost_bspa_sem_ml`,
`spboost_bspa_sem_cfe`, `mgwrsar_gwr`, `mgwrsar_sar`, `mgwrsar_mgwr`,
`mgwrsar_mgwrsar`, `spmoran_esf` et `spmoran_resf`. Les suffixes `_xy`
ajoutent les coordonnees comme covariables brutes; ils ne construisent pas de
matrice `W`.

Pour les datasets deja enregistres dans le package, il n'est plus necessaire
de recopier la formule:

```r
available_benchmark_datasets()

bench <- benchmark_spatial_dataset(
  "columbus_crime",
  estimators = c("sar_lag", "spboost", "mgwrsar_gwr"),
  tune = TRUE,
  tuning_grids = list(
    sar_lag = data.frame(k_neighbors = c(4L, 8L)),
    spboost = expand.grid(
      mstop = c(50L, 100L, 200L),
      k_neighbors = c(4L, 8L)
    ),
    mgwrsar_gwr = data.frame(
      bandwidth = c(20L, 40L),
      kernel = c("bisq", "gauss")
    )
  )
)

bench$results
```

`benchmark_spatial_dataset()` charge le `.rds`, recupere la formule et les
coordonnees depuis `R/benchmark-datasets.R`, applique `complete.cases()` sur
les colonnes utiles, puis appelle `benchmark_spatial()`.

Par defaut, `bench$results` contient un diagnostic in-sample. Pour comparer la
generalisation des estimateurs, utiliser un schema hors-echantillon:

```r
bench <- benchmark_spatial_dataset(
  "columbus_crime",
  estimators = c("ols", "random_forest", "sar_lag"),
  cv_scheme = "holdout_10pct"
)

bench$results
bench$resample_results
```

Les schemas disponibles sont:

```r
cv_scheme = "holdout_10pct"   # train/test simple, 90/10
cv_scheme = "near_prediction" # un point test par cellule quadtree
cv_scheme = "block_spatial"   # blocs spatiaux contigus via blockCV
cv_scheme = "vfold_cv"        # v-fold classique rsample
cv_scheme = "custom"          # folds prepares par l'utilisateur
cv_scheme = "in_sample"       # diagnostic sur toutes les donnees
```

Dans ces modes hors-echantillon, `bench$results` contient les moyennes par
estimateur et `bench$resample_results` contient les scores fold par fold.

Le registre utilisateur est maintenant plus explicite:

```r
available_benchmark_estimators()
```

Il indique pour chaque estimateur son statut, son backend, le package R requis,
les arguments spatiaux attendus, les parametres tunables et si la dependance
est installee. Les objets retournes par `benchmark_spatial()` et
`benchmark_spatial_datasets()` ont aussi une methode `print()` courte: afficher
l'objet suffit pour voir la formule, les estimateurs lances, les fits reussis
ou echoues et la table de resultats principale.

## Tuning dans le benchmark automatique

`benchmark_spatial()` peut lancer `tune::tune_grid()` avant le fit final pour
les routes supportees. Les autres estimateurs restent ajustes avec leurs
valeurs fixes.

```r
bench <- benchmark_spatial(
  CRIME ~ HOVAL + INC,
  data = columbus,
  coords = c("X", "Y"),
  estimators = c("sar_lag", "spboost", "mgwrsar_gwr"),
  tune = TRUE,
  tuning_grids = list(
    sar_lag = data.frame(k_neighbors = c(4L, 8L)),
    spboost = expand.grid(
      mstop = c(50L, 100L, 200L),
      k_neighbors = c(4L, 8L)
    ),
    mgwrsar_gwr = data.frame(
      bandwidth = c(20L, 40L),
      kernel = c("bisq", "gauss")
    )
  )
)

bench$tuning$sar_lag$best
bench$tuning$spboost$best
bench$tuning$mgwrsar_gwr$best
bench$results
```

Parametres actuellement tunes par cette couche:

- `sar_lag`, `sem_error`, `sdm_mixed`: `k_neighbors`;
- `gamboost`: `mstop` ;
- `spboost` et les variantes `spboost_bspa_*`: `mstop` et `k_neighbors`;
  `nu` reste fixe via `spboost_nu`;
- `mgwrsar_gwr`, `mgwrsar_mgwrsar`: `bandwidth` et `kernel`.

Si `resamples` est absent, le package cree un `rsample::vfold_cv()` classique.
Pour une validation spatiale plus stricte, construire les folds en amont et les
passer avec `resamples = ...`.

## Visualiser les resultats

Le package expose trois familles de graphiques apres estimation.

Comparer les estimateurs d'un benchmark:

```r
plot_benchmark_comparison(bench, metric = "rmse")
plot_benchmark_comparison(bench, metric = "mae")
```

Visualiser une grille de tuning:

```r
plot_tuning_curve(
  bench$tuning$mgwrsar_gwr$grid,
  x = "bandwidth",
  color = "kernel"
)

plot_tuning_curve(
  bench$tuning$spboost$grid,
  x = "mstop"
)
```

Inspecter un fold near-prediction:

```r
near <- make_spatial_resamples(
  columbus,
  coords = c("X", "Y"),
  cv_scheme = "near_prediction",
  near_n_reps = 3,
  near_test_size = 10
)

plot_near_prediction_fold(near, data = columbus, coords = c("X", "Y"), fold = "rep_1")
```

Visualiser les predictions ou les residus d'un fit individuel:

```r
fit <- fit_sar(
  CRIME ~ HOVAL + INC,
  data = columbus,
  coords = c("X", "Y"),
  k_neighbors = 8
)

plot_spatial_predictions(fit, columbus, coords = c("X", "Y"))
plot_spatial_predictions(fit, columbus, coords = c("X", "Y"), truth = "CRIME", type = "residual")
```

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
