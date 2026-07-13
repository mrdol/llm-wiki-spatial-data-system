# Demarrer avec spatialtidymodels

Cette fiche pkgdown documente le chemin vise pour passer du benchmark manuel a
une extension tidymodels reutilisable.

## Separation des arguments

Arguments de modele:

- `mstop` pour le nombre d'iterations de `spboost`;
- `bandwidth` pour la bande passante GWR/MGWR/MGWRSAR;
- `kernel` pour le noyau spatial;
- `model_type` ou `DGP` pour la famille statistique.

Arguments geographiques:

- `coords` indique les colonnes de coordonnees conservees dans le workflow;
- `k_neighbors` indique le nombre de voisins utilises pour construire W.

## Workflow minimal

```r
library(spatialtidymodels)
library(parsnip)
library(workflows)

spec <- spatialreg_reg(
  coords = c("x_coord", "y_coord"),
  model_type = "SAR",
  k_neighbors = 8
) |>
  set_engine("spatialreg")

wf <- workflow() |>
  add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
  add_model(spec)

fit <- fit(wf, data = train)
predict(fit, new_data = test)
```

## Tuning minimal

```r
library(tune)
library(rsample)
library(yardstick)

spec <- spatialreg_reg(
  coords = c("x_coord", "y_coord"),
  model_type = "SAR",
  k_neighbors = tune()
) |>
  set_engine("spatialreg")

grid <- data.frame(k_neighbors = c(4L, 8L, 12L))

tune_grid(
  wf |> update_model(spec),
  resamples = vfold_cv(train, v = 3),
  grid = grid,
  metrics = metric_set(rmse)
)
```

## Parite avec le benchmark manuel

La verification de parite numerique doit comparer, a split identique:

1. la formule utilisee par le benchmark manuel;
2. les colonnes de coordonnees et la matrice W;
3. les hyperparametres fixes ou tunes;
4. les predictions produites par le workflow package;
5. les predictions produites par le chemin manuel historique.

Une difference acceptable doit etre expliquee par une difference de backend,
de prediction hors-echantillon ou de construction de W. Sinon, le package doit
etre corrige avant de remplacer le benchmark manuel.
