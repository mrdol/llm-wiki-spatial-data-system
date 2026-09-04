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

## Catalogue de datasets

`available_benchmark_datasets()` lit `inst/metadata/datasets.json` (genere par
`code/package_metadata/export_spatialtidymodels_metadata.py` a partir des
fiches wiki) et expose actuellement 155 datasets marques
`package_include: "yes"` sur 289 fiches papier/package au total.

Ce registre pointe vers les `.rds` sources sous `data/final_datasets/sf/` du
depot `llm-wiki-karpathy` (via le champ `rds` de chaque entree). 16 datasets
(les 7 historiques `georgia`, `columbus_crime`, `london_hp`, `boston_housing`,
`dub_voter`, `ewhp`, `lasrosas`, plus 9 datasets papier cross-sectionnels
ajoutes le 2026-08-18 : `paper_covid_sociodemographic_risk`,
`paper_spatial_confounding_diabetes`, `paper_florida_crash_gsvcm`,
`paper_wildfire_bootleg_severity`, `paper_amphibian_functional_diversity`,
`paper_dragonfly_diversity_europe`, `paper_wang_henan_cultivated_land_quality`,
`paper_seshat_social_complexity`, `paper_airbnb_europe_prices`) sont en plus
embarques comme objets `data()` natifs du package
(`data-raw/prepare-benchmark-data.R`). Les candidats panel restants
(`paper_gwqlasso_*`, `paper_groundfish_cpue`, `paper_hiv_southern_africa`,
`paper_midwest_crop_yield`) sont laisses de cote pour une prochaine vague.
Pour quelqu'un travaillant dans ce depot, les 155 datasets sont directement
utilisables via `benchmark_spatial_dataset()` ; en dehors du depot, seuls les
16 datasets embarques le sont sans configuration supplementaire. Ce n'est pas
un probleme pour l'usage interne actuel, mais c'est un point a traiter avant
toute publication du package (distribution des donnees, cf. audit
CRAN-readiness).

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

Le registre porte aussi une taxonomie `family`/`role`/`reference_estimator`/
`variant_family` (colonnes de `available_benchmark_estimators()`), qui
identifie quel estimateur est la reference "canonique" d'une famille
statistique (SAR, SEM, GWR, ...) et lesquels en sont des variantes -- c'est
ce que consomme `compare_estimator_variant()` par convention et ce qu'un
futur dashboard pourra utiliser pour grouper les estimateurs sans coder ces
relations en dur. Definie une seule fois dans `ESTIMATOR_TAXONOMY`
(`code/package_metadata/export_spatialtidymodels_metadata.py`), pas editee a
la main dans le JSON installe. `register_spatial_estimator()` accepte les
memes champs (`family`, `reference_estimator`, `variant_family`) pour un
estimateur enregistre par l'utilisateur.

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

## Comparer un candidat a un estimateur de reference

Pour repondre a la question "est-ce que ma nouvelle variante d'un estimateur
fait mieux que l'estimateur de reference ?" sur plusieurs jeux de donnees a la
fois, deux couches s'ajoutent au-dessus du benchmark: une orchestration
multi-dataset x multi-schema CV, puis une comparaison statistique. Aucune des
deux ne trace de graphique -- un futur dashboard ne fera qu'afficher ce que
ces fonctions retournent.

```r
suite <- benchmark_spatial_suite(
  datasets = c("columbus_crime", "georgia", "london_hp"),
  estimators = c("sar_lag", "spboost_bspa_sar_ml"),
  cv_schemes = c("near_prediction", "block_spatial")
)

suite$results           # dataset x estimateur x cv_scheme
suite$resample_results  # dataset x estimateur x cv_scheme x fold
```

`datasets` accepte directement des noms enregistres dans
`available_benchmark_datasets()` (charges via `load_benchmark_dataset()`), ou
des `spatial_dataset_spec()` construites a la main comme
`benchmark_spatial_datasets()`.

```r
cmp <- compare_estimator_variant(
  suite,
  reference = "sar_lag",
  candidate = "spboost_bspa_sar_ml",
  primary_metric = "rmse",
  secondary_metrics = c("mae", "moran_abs", "duration_sec")
)

cmp$verdict    # "SUPERIOR" | "EQUIVALENT" | "INFERIOR" | "UNSTABLE" | "INSUFFICIENT_EVIDENCE"
cmp$summary    # win rate (+ IC de Wilson), delta median, p-value Wilcoxon, taux d'echec...
cmp$per_case   # une ligne par dataset x cv_scheme, avec le delta et le WIN/TIE/LOSS
print(cmp)
```

Le delta rapporte est toujours "positif = le candidat fait mieux", quelle que
soit la metrique. Un cas est classe `WIN`/`TIE`/`LOSS` par rapport a une zone
d'equivalence (`rope`, 1% par defaut) pour eviter qu'un delta de +0.001%
compte comme une victoire.

Le verdict ne repose pas seulement sur un seuil de pourcentage de victoires:
par defaut, `compare_estimator_variant()` exige aussi qu'un test de Wilcoxon
signe (Demsar, 2006, JMLR -- reference standard pour comparer deux algorithmes
sur plusieurs jeux de donnees) sur les deltas soit significatif avant de
conclure `SUPERIOR` ou `INFERIOR`. Un taux de victoire de 70% sur seulement 4
cas ne suffit generalement pas -- le verdict retombe alors sur `EQUIVALENT`
plutot que de sur-interpreter un petit echantillon. Les seuils sont
ajustables via `comparison_rules()`:

```r
rules <- comparison_rules(
  min_win_rate = 0.70,             # seuil de victoire pour SUPERIOR/INFERIOR
  max_large_loss_rate = 0.10,      # tolerance aux echecs importants isoles
  large_loss_threshold = 0.10,     # ce qui compte comme une degradation "importante"
  max_failure_rate_increase = 0.05,# force UNSTABLE si le candidat plante trop plus souvent
  rope = 0.01,                     # zone d'equivalence WIN/TIE/LOSS
  alpha = 0.05,                    # seuil de significativite Wilcoxon
  min_cases_for_verdict = 10L      # sinon INSUFFICIENT_EVIDENCE
)

compare_estimator_variant(suite, reference = "sar_lag", candidate = "spboost_bspa_sar_ml", rules = rules)
```

Cette couche est intentionnellement independante de toute interface: un
dashboard (pas encore construit) devra seulement appeler
`compare_estimator_variant()` et afficher `cmp$verdict`/`cmp$summary`, pour
qu'un utilisateur puisse reproduire exactement la meme conclusion en console.

### Verdict SPECIALIZED -- avantage systematique sur un sous-groupe

Un candidat peut ne pas gagner globalement tout en gagnant de facon fiable
sur un sous-ensemble identifiable de datasets (ex. forte autocorrelation
spatiale de Y, grands N, une famille de geometrie). Passer `groups` --
un `data.frame` avec une colonne `dataset` et une seule colonne de
regroupement, fournie par l'utilisateur (le moteur ne calcule aucune
meta-donnee lui-meme) -- active cette analyse :

```r
groups <- data.frame(
  dataset = c("columbus_crime", "georgia", "..."),
  moran_bucket = c("high_moran", "low_moran", "...")
)

cmp <- compare_estimator_variant(
  suite,
  reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
  groups = groups
)

cmp$subgroups$table         # win rate, delta median, n par sous-groupe
cmp$subgroups$specialized_in # sous-groupes qui remplissent les criteres
```

Le verdict ne devient `"SPECIALIZED"` que si le candidat n'est **pas** deja
`SUPERIOR`/`INFERIOR` globalement -- un sous-groupe gagnant ne remplace
jamais une victoire ou une defaite globale claire, il ne remplace que
`EQUIVALENT`/`INCONCLUSIVE`. Par defaut, un sous-groupe n'a pas besoin
d'atteindre sa propre significativite Wilcoxon (`min_cases_for_subgroup =
5` suffit) -- c'est deliberement un signal exploratoire/generateur
d'hypothese, documente comme tel, pas une preuve confirmatoire ; passer
`comparison_rules(require_significance_for_subgroup = TRUE)` pour l'exiger.

## Tester sa propre variante d'un estimateur

`register_spatial_estimator()` branche un estimateur "maison" au benchmark
sans toucher au code interne du package -- c'est le point d'entree pour
quelqu'un qui vient de developper une nouvelle variante (un SAR non lineaire,
un SAR boosting different de `spboost`, etc.) et veut la comparer a
l'estimateur de reference existant.

Le contrat est volontairement minimal:

```r
register_spatial_estimator(
  id = "my_nonlinear_sar",
  fit = function(formula, data, coords) {
    # construire W ici avec build_knn_W()/build_knn_listw() si necessaire,
    # puis ajuster le modele
    my_nonlinear_sar_fit(formula, data, coords)
  },
  predict = function(fit, new_data) {
    my_nonlinear_sar_predict(fit, new_data) # vecteur numerique
  },
  family = "sar",
  reference_estimator = "sar_lag",
  requires_coords = TRUE,
  requires_W = TRUE,
  notes = "Variante non lineaire du SAR classique"
)
```

L'estimateur enregistre apparait immediatement dans
`available_benchmark_estimators()` et peut etre utilise partout ou un nom
d'estimateur integre le serait:

```r
suite <- benchmark_spatial_suite(
  datasets = c("columbus_crime", "georgia", "london_hp"),
  estimators = c("sar_lag", "my_nonlinear_sar"),
  cv_schemes = c("near_prediction", "block_spatial")
)

compare_estimator_variant(suite, reference = "sar_lag", candidate = "my_nonlinear_sar")
```

`registered_spatial_estimators()` liste les estimateurs enregistres dans la
session courante, `unregister_spatial_estimator(id)` les retire.

Deux limites assumees dans cette premiere version:

- `requires_W = TRUE` est pour l'instant seulement une metadonnee affichee ;
  le package ne construit pas encore automatiquement `W` pour un estimateur
  enregistre. Construire `W` dans `fit` avec `build_knn_W()` ou
  `build_knn_listw()` (deja exportees).
- Le tuning (`benchmark_spatial(tune = TRUE)`) n'est pas encore cable pour les
  estimateurs enregistres -- fixer les hyperparametres dans la fermeture de
  `fit` en attendant.

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
