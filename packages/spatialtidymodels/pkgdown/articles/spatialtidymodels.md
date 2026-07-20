# Demarrer avec spatialtidymodels

Cette fiche pkgdown documente le chemin vise pour passer du benchmark manuel a
une extension tidymodels reutilisable. Le package est une extension en
developpement: il est teste dans le projet, mais il n'est pas encore une API
publique stabilisee.

## Separation des arguments

Arguments de modele:

- `mstop` pour le nombre d'iterations de `spboost`;
- `bandwidth` pour la bande passante GWR/MGWR/MGWRSAR;
- `kernel` pour le noyau spatial;
- `model_type` ou `DGP` pour la famille statistique.

Arguments geographiques:

- `coords` indique les colonnes de coordonnees conservees dans le workflow;
- `W` permet de fournir directement une matrice de poids ou un objet `listw`;
- `k_neighbors` indique le nombre de voisins utilises pour construire W quand
  `W` n'est pas fourni;
- `style` controle la standardisation `spdep::nb2listw()`;
- `zero_policy` controle le comportement `spdep` pour les observations sans
  voisin.

Ces arguments sont formalises par `spatial_knn_args()`. Les specs peuvent les
recevoir directement, ce qui donne une API plus courte pour l'utilisateur tout
en gardant une separation claire dans le code du package.

## Workflow de base

### Raccourci type glm()

```r
library(spatialtidymodels)

fit <- fit_sar(
  y ~ x1 + x2,
  data = train,
  coords = c("x_coord", "y_coord"),
  k_neighbors = 8
)

predict(fit, new_data = test)
diagnose_spatial(fit, data = train)
```

Les fonctions `fit_sar()`, `fit_sem()` et `fit_sdm()` construisent en interne
la spec parsnip, le workflow et l'ajustement. Elles sont faites pour les tests
rapides et l'usage interactif.

`diagnose_spatial()` ajoute une couche benchmark/econometrie: RMSE, MAE, AIC,
log-vraisemblance, parametre spatial et Moran I des residus. Quand la formule
est disponible, une baseline `ols_baseline` est calculee automatiquement pour
voir si le modele spatial apporte quelque chose par rapport a OLS.

### Workflow explicite

```r
library(spatialtidymodels)
library(parsnip)
library(workflows)

spec <- sar_reg(coords = c("x_coord", "y_coord"), k_neighbors = 8) |>
  set_engine("spatialreg")

wf <- workflow() |>
  add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
  add_model(spec)

fit <- fit(wf, data = train)
predict(fit, new_data = test)
```

## Tuning de base

```r
library(tune)
library(rsample)
library(yardstick)

spec <- sar_reg(coords = c("x_coord", "y_coord"), k_neighbors = tune()) |>
  set_engine("spatialreg")

grid <- data.frame(k_neighbors = c(4L, 8L, 12L))

tune_grid(
  wf |> update_model(spec),
  resamples = vfold_cv(train, v = 3),
  grid = grid,
  metrics = metric_set(rmse)
)
```

## Benchmark automatique

```r
bench <- benchmark_spatial(
  y ~ x1 + x2,
  data = train,
  coords = c("x_coord", "y_coord"),
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

Pour plusieurs datasets, on declare chaque jeu avec sa formule et ses
coordonnees:

```r
bench_set <- benchmark_spatial_datasets(
  datasets = list(
    spatial_dataset_spec("columbus_crime", columbus, CRIME ~ HOVAL + INC, c("X", "Y")),
    spatial_dataset_spec("london_hp", london_hp, PURCHASE ~ FLOORSZ + PROF + BATH2, c("X", "Y"))
  ),
  estimators = c("ols", "sar_lag")
)

bench_set$results
```

`lsl` n'est pas utilise dans ces tests de regression continue parce que sa
cible scientifique est binaire. Les routes `spmoran_esf` et `spmoran_resf`
restent connues dans le registre, mais ne sont pas encore automatisees dans le
package.

## Parite avec le benchmark manuel

La verification de parite numerique compare, a split identique:

1. la formule utilisee par le benchmark manuel;
2. les colonnes de coordonnees et la matrice W;
3. les hyperparametres fixes ou tunes;
4. les predictions produites par le workflow package;
5. les predictions produites par le chemin manuel historique.

Une difference acceptable doit etre expliquee par une difference de backend,
de prediction hors-echantillon ou de construction de W. Sinon, le package doit
etre corrige avant de remplacer le benchmark manuel.

Etat actuel:

| Dataset | Estimateurs | Resultat |
|---|---|---|
| `columbus_crime` | `sar_lag`, `sem_error`, `sdm_mixed` | 27/27 folds, `max_abs_diff = 0` |
| `london_hp` | `sar_lag`, `sem_error`, `sdm_mixed` | 33/33 folds, `max_abs_diff = 0` |
| `boston_housing` | `sar_lag`, `sem_error` | 22/22 folds, `max_abs_diff = 0` |
| `boston_housing` | `sdm_mixed` | echec identique cote manuel/package: `CHAS1` / `lag.CHAS1` aliases |

Le script de parite se trouve dans:

```r
source("packages/spatialtidymodels/inst/parity/compare_with_manual_benchmark.R")
run_spatialtidymodels_parity_check("london_hp")
```
