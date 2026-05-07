---
title: SpBoost
type: estimator
created: 2026-04-23
updated: 2026-05-05
sources:
  - raw/paper/spbbost_article.pdf
  - raw/estimators/spboost_0.6.3/spboost/DESCRIPTION
  - raw/estimators/spboost_0.6.3/spboost/NAMESPACE
  - raw/estimators/spboost_0.6.3/spboost/man/spb_make_boost_control.Rd
  - raw/estimators/spboost_0.6.3/spboost/man/BSPA_SAR_CFE.Rd
  - raw/estimators/spboost_0.6.3/spboost/man/BSPA_SEM_CFE.Rd
  - raw/estimators/spboost_0.6.3/spboost/man/BSPA_SAR_ML.Rd
  - raw/estimators/spboost_0.6.3/spboost/man/predict_spboost.Rd
  - raw/estimators/spboost_0.6.3/spboost/man/build_Wk.Rd
tags: [estimator, spatial, boosting, sar, sem, sarar, nonlinear, hyperparameters]
---

SpBoost est un estimateur de regression spatiale non lineaire. Il combine:

- une structure econometrique spatiale explicite: SAR, SEM ou SARAR;
- une fonction non lineaire des covariables estimee par boosting, GAM, MARS ou XGBoost selon la methode choisie;
- une estimation du parametre spatial par maximum de vraisemblance ou par CFE, c'est-a-dire closed-form estimator.

Dans le systeme, SpBoost est un estimateur prioritaire pour les jeux de donnees spatiaux avec une variable continue `Y`, des variables explicatives `X_candidate`, une matrice de voisinage `W`, et un objectif de regression ou prediction spatiale.

## Ce Que L'estimateur Fait

L'idee simple est la suivante: on ne suppose pas que l'effet des variables explicatives est forcement lineaire, mais on ne veut pas non plus ignorer l'autocorrelation spatiale.

Un modele additif non spatial ecrit:

$$
y_i = f(X_i) + \varepsilon_i
$$

avec:

$$
f(X_i) = \beta_0 + \sum_{j=1}^{p} h_j(X_{ij})
$$

SpBoost ajoute ensuite une structure spatiale.

Pour un SAR:

$$
y = \rho W y + f(X) + \varepsilon
$$

Pour un SEM:

$$
y = f(X) + u
$$

$$
u = \lambda W u + \varepsilon
$$

ce qui revient a:

$$
y = f(X) + (I - \lambda W)^{-1}\varepsilon
$$

Pour un SARAR:

$$
y = \rho W y + f(X) + u
$$

$$
u = \lambda W u + \varepsilon
$$

Donc:

$$
y = \rho W y + f(X) + (I - \lambda W)^{-1}\varepsilon
$$

## Interpretation

| Element | Signification |
|---|---|
| `Y` | variable a expliquer, generalement continue |
| `X_candidate` | variables explicatives disponibles dans la donnee |
| `X_selected` | variables effectivement retenues par le boosting ou par le chercheur |
| `W` | matrice de voisinage spatial normalisee par ligne |
| `rho` | dependance spatiale directe de `Y` sur les voisins: SAR |
| `lambda` | autocorrelation spatiale dans les erreurs: SEM |
| `f(X)` | relation non lineaire entre `Y` et les covariables |
| `mstop` | nombre d'iterations de boosting, donc regularisation principale |
| `nu` | learning rate du boosting |

SpBoost n'est donc pas seulement un `gamboost` avec des coordonnees. La partie spatiale transforme la fonction de perte et modifie l'interpretation du modele.

## API Du Package Local

Une version locale du package existe dans:

`raw/estimators/spboost_0.6.3/spboost`

Le package declare la version `0.6.3` et exporte notamment:

- `spbgam`: fonction generale de haut niveau;
- `BSPA_SAR_ML`, `BSPA_SAR_CFE`: SAR non lineaire avec boosting spline;
- `BSPA_SEM_ML`, `BSPA_SEM_CFE`, `BSPA_SEM_CFE_iter`, `BSPA_SEM_CFE_BRUT`: SEM non lineaire;
- `BSPA_SARAR_ML`, `BSPA_SARAR_CFE`: modele SARAR;
- `GAM_SAR_ML`, `GAM_SAR_CFE`, `GAM_SAR_FIVA`: variantes GAM;
- `MARS_SAR_ML`, `MARS_SAR_CFE`, `MARS_SEM_ML`, `MARS_SEM_CFE`: variantes MARS;
- `XGBOOST_SAR_ML`, `XGBOOST_SAR_CFE`: variantes XGBoost experimentales;
- `predict_spboost`: prediction;
- `build_Wk`: construction de matrices de voisinage par bandes de plus proches voisins;
- `dgp`: simulation de donnees SAR/SEM/SARAR.

La route recommandee dans le systeme est:

```r
spboost::spbgam(
  formula = ...,
  data = ...,
  W = ...,
  DGP = "SAR",
  method = "BSPA_SAR_CFE",
  control = ...
)
```

## Noms Des Methodes

Le nom d'une methode contient deux informations.

| Prefixe | Sens |
|---|---|
| `BSPA` | boosting additif avec base-learners `mboost`, par exemple `bbs()` |
| `GAM` | modele additif generalise via `mgcv` |
| `MARS` | splines adaptatives multivariees via `earth` |
| `XGBOOST` | boosting d'arbres, route experimentale |
| `LM` | specification lineaire |
| `BLA` | baseline lineaire ou additive selon la fonction |

| Suffixe | Sens |
|---|---|
| `ML` | estimation par maximum de vraisemblance |
| `CFE` | estimation closed-form du parametre spatial |
| `FIVA` | approche instrumentale/control function pour SAR |

Exemples:

- `BSPA_SAR_CFE`: SAR, boosting spline, estimation CFE de `rho`;
- `BSPA_SEM_CFE`: SEM, boosting spline, estimation CFE de `lambda`;
- `BSPA_SARAR_ML`: SARAR, boosting spline, estimation ML de `rho` et `lambda`;
- `GAM_SAR_ML`: SAR avec effet non lineaire estime par GAM.

## Hyperparametres A Documenter

| Parametre | Ou | Role |
|---|---|---|
| `DGP` | `spbgam()` | classe spatiale: `SAR`, `SEM`, `SARAR` |
| `method` | `spbgam()` | variante logicielle et mode d'estimation |
| `W` | `spbgam()` | matrice spatiale principale |
| `W2` | `spbgam()` | seconde matrice pour SARAR si differente de `W` |
| `formula` | `spbgam()` | relation entre `Y` et `X_selected` |
| `control_gamboost` | `control` | objet `mboost::boost_control()` |
| `mstop` | `boost_control()` | nombre d'iterations |
| `nu` | `boost_control()` | learning rate |
| `mstop_criterion` | `control` | critere interne de choix de `mstop`, par exemple `spatial` ou `sem_spatial` |
| `mstop_init` | `control` | limite initiale pour la recherche de `mstop` |
| `nfold` | `control` | nombre de folds de validation croisee |
| `ncore` | `control` | parallelisation |
| `cv_mode_spatial` | `control` | validation aleatoire ou blocs spatiaux si configure |
| `rho_bounds` | fonctions CFE directes | bornes admissibles pour `rho` |
| `fallback` | fonctions CFE directes | strategie si la solution CFE exacte est instable |
| `tol` | fonctions CFE directes | tolerance numerique |

## Formules R

Pour les methodes `BSPA_*`, la formule utilise la syntaxe `mboost`.

Effet non lineaire:

```r
Y ~ bbs(X1) + bbs(X2) + bbs(X3)
```

Effet lineaire:

```r
Y ~ bols(X1) + bols(X2)
```

Melange lineaire et non lineaire:

```r
Y ~ bbs(X1) + bols(X2) + bbs(X3)
```

Le lisseur spatial explicite doit etre evite au debut:

```r
Y ~ bbs(X1) + bbs(X2) + bspatial(longitude, latitude)
```

Cette specification peut etre dangereuse si les covariables sont deja spatialement structurees, car `bspatial(longitude, latitude)` peut absorber le signal que `rho` ou `lambda` doivent mesurer.

## Pertes Spatiales

Pour un modele non spatial:

$$
L(f) =
\sum_i
\left[
y_i - f(X_i)
\right]^2
$$

Pour un SAR:

$$
L_{\mathrm{SAR}}(f;\rho) =
\sum_i
\left[
y_i - \rho (Wy)_i - f(X_i)
\right]^2
$$

Pour un SEM:

$$
L_{\mathrm{SEM}}(f;\lambda) =
\sum_i
\left[
\left((I - \lambda W)(y - f(X))\right)_i
\right]^2
$$

Pour un SARAR:

$$
L_{\mathrm{SARAR}}(f;\rho,\lambda) =
\sum_i
\left[
\left((I - \lambda W)(y - \rho Wy - f(X))\right)_i
\right]^2
$$

Ces equations expliquent pourquoi la matrice `W` est centrale. Si `W` est mal construite, mal normalisee ou non documentee, l'estimation n'est pas interpretable.

## CFE

Le CFE, closed-form estimator, sert a estimer rapidement le parametre spatial sans recalculer constamment:

$$
\log |I - \rho W|
$$

Pour le SAR, le package estime des regressions auxiliaires puis calcule une solution fermee pour `rho`.

Schema:

$$
y = \hat f_0(X) + e_0
$$

$$
Wy = \hat f_1(X) + e_1
$$

$$
W^2y = \hat f_2(X) + e_2
$$

Puis:

$$
a = e_1^\top e_2
$$

$$
b = e_0^\top e_2 + e_1^\top e_1
$$

$$
c = e_0^\top e_1
$$

$$
D = b^2 - 4ac
$$

Si la solution est valide:

$$
\hat\rho_{\mathrm{CFE}} =
\frac{b - \sqrt{D}}{2a}
$$

Si elle n'est pas valide, le package peut utiliser une approximation de secours selon `fallback`.

## Donnees Eligibles

SpBoost est pertinent si le dataset possede:

- une variable `Y` continue;
- plusieurs variables explicatives candidates;
- des coordonnees ou geometries permettant de construire `W`;
- une question de regression ou de prediction;
- un risque d'autocorrelation spatiale ou d'heterogeneite spatiale;
- une metadata permettant de distinguer `X_candidate` et `X_selected`.

SpBoost n'est pas prioritaire pour:

- classification pure sans adaptation probit/logit validee;
- rasters sans table d'observations;
- fonds de carte sans `Y`;
- donnees ou `W` ne peut pas etre construit de facon defendable.

## Workflow Manuel R

Un exemple complet est disponible dans:

`R/estimators/manual_spboost_example.R`

Etapes recommandees:

1. Installer le package local depuis `raw/estimators/spboost_0.6.3/spboost`.
2. Charger `spboost` et `mboost`.
3. Simuler ou charger une table avec `Y`, `X_candidate`, coordonnees et `W`.
4. Choisir une formule `mboost`, par exemple `Y ~ bbs(X1) + bbs(X2)`.
5. Choisir `DGP = "SAR"` ou `DGP = "SEM"`.
6. Commencer avec `method = "BSPA_SAR_CFE"` pour SAR ou `method = "BSPA_SEM_CFE"` pour SEM.
7. Regarder `rho` ou `lambda`, `rmse`, les variables selectionnees et les residus.
8. Comparer avec une version non spatiale et un modele SAR/SEM lineaire.
9. Sauvegarder `Y`, `X_candidate`, `X_selected`, `W`, formule, methode, `mstop`, `nu` et validation dans la metadata.

## Integration Dans Le Systeme

Le wrapper est:

`R/estimators/fit_spboost.R`

Il appelle:

```r
spboost::spbgam()
```

Le package n'est pas installe automatiquement par le systeme. Le wrapper echoue volontairement si `spboost` n'est pas disponible dans la bibliotheque R active.

Exemple via le wrapper:

```r
source("R/estimators/load_estimators.R")

fit <- fit_spboost(
  data = df,
  y = "Y",
  x = c("X1", "X2", "X3"),
  config = list(
    W = W,
    formula = Y ~ bbs(X1) + bbs(X2) + bbs(X3),
    DGP = "SAR",
    method = "BSPA_SAR_CFE",
    control = list(
      control_gamboost = mboost::boost_control(mstop = 300, nu = 0.1),
      mstop_criterion = "spatial",
      nfold = 5,
      ncore = 1
    )
  )
)
```

## Diagnostics A Lire

- valeur estimee de `rho` pour SAR;
- valeur estimee de `lambda` pour SEM;
- `rmse`;
- `mstop` selectionne;
- variables selectionnees par le boosting;
- sensibilite a la construction de `W`;
- autocorrelation spatiale des residus;
- performance sur validation spatiale bloquee;
- difference entre `BSPA_*_CFE` et `BSPA_*_ML`.

## Points De Prudence

- `W` doit etre normalisee par ligne et documentee.
- `mstop` trop grand peut sur-apprendre.
- `nu` trop grand peut rendre le boosting instable.
- `bspatial(longitude, latitude)` peut masquer le signal SAR/SEM.
- Les methodes XGBoost du package sont a traiter comme experimentales tant qu'elles ne sont pas validees dans le systeme.
- Les predictions avec `predict_spboost` demandent une matrice `W` compatible avec les donnees d'apprentissage et les nouvelles observations.

## Metadata A Stocker

Pour chaque usage de SpBoost, enregistrer:

- `Y`;
- typologie de `Y`;
- `X_candidate`;
- `X_selected`;
- formule R;
- `DGP`;
- `method`;
- construction de `W`;
- `mstop`;
- `nu`;
- `mstop_criterion`;
- `rho` ou `lambda`;
- validation croisee;
- validation spatiale externe;
- presence ou absence de `bspatial`;
- raison scientifique de l'utilisation de SpBoost.

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[gamboost]]
- [[mgwrsar]]
- [[xgboost]]
- variable typology
- modeling evidence
