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

Pour les routes `spboost_bspa_*`, `ML` et `CFE` sont deux methodes
d'estimation du parametre spatial (`rho` pour SAR, `lambda` pour SEM), pas
deux familles spatiales differentes. Dans le benchmark automatique, `nu` reste
fixe via `spboost_nu`; on tune seulement `mstop` et `k_neighbors`.

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

Pour savoir ce que le package sait lancer:

```r
available_benchmark_estimators()
```

La table indique le statut de chaque route, le package R requis, les arguments
spatiaux attendus, les parametres tunables et si la dependance est installee
dans la session courante.

Pour savoir quels datasets ont deja une formule enregistree:

```r
available_benchmark_datasets()
```

On peut ensuite lancer un benchmark sans recopier la formule:

```r
bench <- benchmark_spatial_dataset(
  "columbus_crime",
  estimators = c("sar_lag", "spboost"),
  tune = TRUE,
  tuning_grids = list(
    sar_lag = data.frame(k_neighbors = c(4L, 8L)),
    spboost = expand.grid(
      mstop = c(50L, 100L, 200L),
      k_neighbors = c(4L, 8L)
    )
  )
)

bench$results
```

```r
bench <- benchmark_spatial(
  y ~ x1 + x2,
  data = train,
  coords = c("x_coord", "y_coord"),
  estimators = c(
    "ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed",
    "spboost", "spboost_bspa_sar_cfe",
    "mgwrsar_gwr", "mgwrsar_sar", "mgwrsar_mgwr", "mgwrsar_mgwrsar"
  ),
  spboost_mstop = 100,
  mgwrsar_bandwidth = 20
)

bench$results
```

Afficher directement `bench` donne un resume console court: formule,
coordonnees, estimateurs demandes, fits reussis ou echoues et metriques
principales.

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
cible scientifique est binaire.

### Tuning integre au benchmark

```r
bench <- benchmark_spatial(
  y ~ x1 + x2,
  data = train,
  coords = c("x_coord", "y_coord"),
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

bench$tuning
bench$results
```

Cette couche tune actuellement `k_neighbors` pour `sar_lag`, `sem_error` et
`sdm_mixed`, `mstop` et `k_neighbors` pour `spboost` et les variantes
`spboost_bspa_*`, puis `bandwidth`/`kernel` pour `mgwrsar_gwr` et
`mgwrsar_mgwrsar`. Si aucun `resamples` n'est fourni, un
`rsample::vfold_cv()` classique est cree. Pour un protocole spatial strict,
les folds doivent etre construits en amont et passes via `resamples`.

## Visualisation apres estimation

Les objets retournes par le package peuvent etre visualises sans relire les
anciens fichiers CSV/RDS du benchmark manuel.

Pour comparer les estimateurs:

```r
plot_benchmark_comparison(bench, metric = "rmse")
plot_benchmark_comparison(bench, metric = "mae")
```

Pour afficher une courbe de tuning:

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

Pour verifier un fold near-prediction:

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

Pour tracer les predictions ou les residus d'un fit individuel:

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
