---
title: Tidymodels Parsnip Extension Procedure
type: metadata
created: 2026-07-10
updated: 2026-07-10
sources:
  - https://www.tidymodels.org/learn/develop/models/
  - https://parsnip.tidymodels.org/reference/set_new_model.html
tags: [tidymodels, parsnip, spatial-estimators, tutorial]
---

# Procedure pour integrer un estimateur dans tidymodels/parsnip

Cette fiche resume la procedure officielle tidymodels pour transformer une
fonction de modelisation existante en modele `parsnip`, puis l'applique a la
mission des estimateurs spatiaux (`spboost`, `mgwrsar`, `spatialreg`).

## Objectif

Un estimateur est vraiment integre au format tidymodels quand l'utilisateur
peut ecrire :

```r
library(workflows)
library(tune)
library(spatialtidymodels)

spec <- spatialreg_reg(coords = c("x", "y"), model_type = "SAR") |>
  parsnip::set_engine("spatialreg")

workflow() |>
  add_formula(y ~ x1 + x2 + x + y) |>
  add_model(spec)
```

Le modele doit ensuite fonctionner avec `fit()`, `predict()`, `workflow()`,
`fit_resamples()` et, si des hyperparametres sont declares, `tune_grid()`.

## Procedure officielle parsnip

La documentation tidymodels decrit cinq etapes principales.

1. Enregistrer le type de modele avec `parsnip::set_new_model()`.
2. Declarer le mode avec `parsnip::set_model_mode()`, par exemple
   `"regression"`.
3. Declarer un moteur avec `parsnip::set_model_engine()`, par exemple
   `"spatialreg"`, `"spboost"` ou `"mgwrsar"`.
4. Declarer les arguments traduits avec `parsnip::set_model_arg()`.
   Exemple : `bandwidth` cote parsnip devient `H` cote `mgwrsar`.
5. Declarer le fit et le predict avec `parsnip::set_fit()` et
   `parsnip::set_pred()`.

La documentation insiste aussi sur `set_encoding()`, qui dit a parsnip comment
gerer les indicatrices, l'intercept et les matrices creuses avant d'appeler le
backend natif.

## Table de correspondance pour notre mission

| Estimateur | Modele parsnip vise | Engine | Backend natif | Etat |
|---|---|---|---|---|
| SAR/SEM/SDM | `spatialreg_reg()` | `spatialreg` | `lagsarlm()`, `errorsarlm()` | prototype |
| SpBoost | `spboost_reg()` | `spboost` | `spbgam()` | prototype |
| GWR/MGWR/MGWRSAR | `mgwrsar_reg()` | `mgwrsar` | `MGWRSAR()`, `TDS_MGWR()` | prototype |

## Points specifiques aux modeles spatiaux

Les estimateurs spatiaux ont des contraintes que les exemples classiques
parsnip n'ont pas toujours :

- les coordonnees doivent rester disponibles au moteur ;
- les coordonnees ne doivent pas toujours etre des covariables ordinaires ;
- la matrice `W` doit etre construite de facon reproductible ;
- `W` doit souvent etre reconstruite au predict avec train + test ;
- les folds spatiaux doivent etre controles pour eviter une validation trop
  optimiste ;
- certains backends ont des APIs fragiles pour la prediction hors echantillon.

## Definition de fait pour le package experimental

Le squelette courant est `packages/spatialtidymodels/`.

## Related Pages

- [[tidymodels_spatial_pipeline_status_2026-07]]
- [[R_GWmodel_LondonHP_londonhp]]

Il contient :

- `DESCRIPTION` et `NAMESPACE` ;
- les constructeurs `spatialreg_reg()`, `spboost_reg()`, `mgwrsar_reg()` ;
- les helpers `build_knn_W()`, `build_knn_listw()`, `moran_i_knn()` ;
- des tests `testthat` minimaux.

## Ce qui manque avant une integration publique

- documentation roxygen complete ;
- parametres `dials` propres : `mstop`, `bandwidth`, `kernel`, `k_neighbors` ;
- tests de prediction sur petits datasets ;
- tests `workflow()` et `tune_grid()` ;
- separation claire entre arguments de modele et arguments geographiques ;
- vignette pkgdown ;
- comparaison avec le benchmark manuel pour verifier la parite numerique.

## Critere de sortie

La mission passe du prototype au vrai package quand un utilisateur peut
installer `spatialtidymodels`, appeler `library(spatialtidymodels)`, choisir un
estimateur spatial, l'utiliser dans un `workflow()`, puis le tuner avec
`tune_grid()` sans sourcer manuellement des scripts du dossier `code/`.
