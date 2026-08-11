# CONTEXT.md - Vocabulaire partage du projet

Lire ce fichier en premier a chaque session. Il definit les termes utilises
partout dans le projet: wiki, CLAUDE.md, AGENTS.md, scripts et fiches.

---

## Projet en une phrase

Constitution d'une banque de datasets spatiaux, principalement sous forme
d'objets `sf` R, pour benchmarker des estimateurs de spatial ML et
d'econometrie spatiale sous tidymodels.

---

## Termes fondamentaux

**Fiche** = **page wiki** -- synonymes. Fichier `.md` dans `wiki/`.
Types: `dataset`, `estimator`, `analysis`, `source`, `concept`, `metadata`.

**sf** -- Simple Features, package R. Format canonique final des datasets
spatiaux tabulaires, y compris ceux d'origine Python.

**N** -- Nombre d'unites spatiales: logements, communes, points, polygones.

**T** -- Nombre de periodes temporelles. `T = 1` signifie dataset
cross-sectionnel.

**Profil N/T** -- Caracterisation de la structure spatio-temporelle d'un
dataset.

**Y** -- Variable cible ou reponse, notation majuscule.

**X** -- Variables explicatives ou covariables, notation majuscule.

**x, y** -- Coordonnees spatiales, notation minuscule. Convention du projet:
les coordonnees spatiales doivent etre unifiees en `x` et `y` dans l'objet
final quand c'est possible. Dans les scripts tidymodels actuels, elles sont
standardisees en `coord_x` et `coord_y` apres reprojection metrique.

**Colonnes de coordonnees et identifiants** -- Les colonnes `x`/`y`,
`coord_x`/`coord_y` et les colonnes identifiantes (`id`, `fid`, `gid`, `code`,
`key`, `index`, etc.) ne sont pas des covariables X candidates. Elles doivent
etre documentees separement.

**Typologie Y** -- `continuous`, `count`, `binary`, `rate`, `compositional`,
`ordinal`, `unknown`.

**Typologie X** -- `spatial`, `temporal`, `socio-economic`, `environmental`,
`categorical`, `identifier`, `continuous`, `lagged`, `imputed`, `unknown`.

---

**Benchmark readiness** -- Bloc obligatoire pour les fiches `paper_*.md` et
les futures fiches issues d'entrepots. Il distingue un dataset seulement trouve
ou telecharge d'un dataset utilisable dans `spatialtidymodels`.

**package_include** -- Champ du bloc `benchmark_readiness`. Valeurs autorisees:
`yes`, `no`, `manual_review`. `yes` signifie que le dataset peut guider le
package; `manual_review` signifie qu'il est interessant mais pas promu
automatiquement; `no` signifie qu'il reste documentaire ou hors perimetre.

**Mode secours Claude** -- Exception explicite ou Claude peut produire ou
modifier des fiches/scripts quand Codex est indisponible. Ce mode exige un audit
des modifications et ne permet jamais de promouvoir un dataset papier/entrepot
sans `benchmark_readiness`.
---

## Vocabulaire spatial et tidymodels

**W** -- Matrice de voisinage ou de poids spatiaux. Dans le benchmark actuel,
elle est reconstruite par k plus proches voisins, puis normalisee par ligne.
Toute interpretation scientifique doit preciser comment `W` est construite.

**listw** -- Objet de voisinage attendu par `spdep`/`spatialreg`. Il represente
la meme idee que `W`, mais dans le format R de ces packages.

**SAR comme famille spatiale** -- Structure avec lag spatial de la variable
cible, typiquement `y = rho W y + ...`. Le mot SAR decrit ici la forme de
dependance spatiale, pas un estimateur unique.

**SAR baseline lineaire** -- Modele econometrique classique estime par
`spatialreg::lagsarlm()` ou par une route SAR globale equivalente. Les effets
des covariables sont lineaires et globaux: `X beta`.

**SpBoost avec DGP = SAR** -- Modele booste non lineaire qui utilise une
structure SAR pour la dependance spatiale, mais estime `f(X)` par boosting
additif avec `bbs()` et `bols()`. Ce n'est pas le meme estimateur qu'un SAR
lineaire baseline.

**SEM** -- Spatial Error Model. L'autocorrelation spatiale est dans les
erreurs: `u = lambda W u + epsilon`.

**SDM** -- Spatial Durbin Model. Modele SAR enrichi par des lags spatiaux de
covariables, par exemple `W X`.

**SARAR** -- Modele combinant un lag spatial de `Y` et une autocorrelation
spatiale des erreurs.

**DGP** -- Data Generating Process. Dans `spboost`, `DGP = "SAR"` signifie que
la route logicielle utilise une structure SAR. Cela ne signifie pas que le
modele est identique a `spatialreg::lagsarlm()`.

**H / bandwidth adaptatif** -- Dans les routes GWR, MGWR et MGWRSAR du projet,
`H` designe en pratique une taille de voisinage ou de fenetre locale. Son
interpretation depend du backend, du kernel et de l'echelle spatiale.

**Kernel spatial** -- Fonction de ponderation spatiale utilisee par GWR/MGWR,
par exemple `gauss` ou `bisq`.

**Lissage / spline / base learner** -- Dans SpBoost, `bbs()` est un base
learner spline pour une covariable continue; `bols()` est un base learner
lineaire, utilise notamment pour les variables binaires. Dans GAM, "lissage"
renvoie plutot aux termes `mgcv::s()`. Toujours preciser le backend.

**Baseline** -- Modele de comparaison. Un baseline peut etre simple (`glm`) ou
techniquement avance (`xgboost_xy`, `sar_lag`), tant qu'il sert de reference
comparative stable.

**Workflow tidymodels propre** -- Route ou un estimateur est expose sous forme
de specification `parsnip`, injecte dans `workflows::workflow()`, evalue sur
des folds `rsample`, tune par `tune::tune_grid()` quand c'est applicable, puis
score avec des metriques `yardstick`.

**Extension en developpement** -- Statut actuel du package
`packages/spatialtidymodels`. Le code est versionne, teste et utilisable dans
le projet, mais il n'est pas encore un package public stabilise. Preferer ce
terme a "minimal" quand les routes ont deja des tests de workflow/parite.

**Prototype valide** -- Route technique qui a passe les tests locaux attendus
pour son perimetre. Exemple courant: `sar_lag`, `sem_error` et `sdm_mixed`
ont une parite numerique exacte avec le benchmark manuel sur `columbus_crime`.

**Experimental** -- A reserver aux routes dont le comportement reste instable
ou incomplet, par exemple `spmoran_resf` tant que certains folds produisent
des predictions `NA`. Ne pas utiliser pour tout le package par habitude.

**Parite numerique** -- Comparaison ligne par ligne entre les predictions du
benchmark manuel et celles du package `spatialtidymodels` sur les memes
resamples. Une parite `max_abs_diff = 0` signifie que la migration package ne
change pas les predictions sur le perimetre teste.

**Scoring direct fold par fold** -- Route provisoire ou assumee pour les
estimateurs qui ne sont pas encore de vrais moteurs `parsnip`. Le benchmark
appelle une fonction `score = function(split, y_resp) ...` pour chaque fold.

---

## Trois familles de sources

1. **Packages R/Python** -- priorite actuelle.
2. **Datasets lies a des papers scientifiques**.
3. **Entrepots et portails institutionnels** -- Zenodo, Dryad, GBIF,
   Copernicus, INSEE, Eurostat, etc.

---

## Pipeline de connaissance

```text
raw/ -> KG (.kg/graph.sqlite) -> wiki/ -> eval -> data/final_datasets/
```

**KG** -- Knowledge graph SQLite. Premiere couche d'acces structure. Toujours
consulter le KG avant de lire le wiki complet quand la question porte sur les
noeuds, edges, datasets ou sources.

**raw/** -- Sources brutes, immuables, lecture seule pour tous les agents.

---

## Evaluation des fiches

| Score | Label | Action automatique |
|---|---|---|
| >= 0.75 | PASS | Fiche approuvee |
| 0.50-0.74 | AMBER | Ajoutee a `wiki/eval_queue.md` |
| < 0.50 | REJECTED | Rapport dans `.eval/rejected/` |
| Tier 1 FAIL | BLOCKED | Commit bloque, erreurs a corriger |

**Tier 1** -- Controle structurel automatique.

**Tier 2** -- Controle semantique LLM-as-judge.

**Tier 3** -- Gestionnaire de file AMBER.

**Cap 0.74** -- Si `sources: []` ou fichier raw absent, le score est plafonne
a 0.74 quelle que soit la qualite interne du contenu.

**Critere null** -- Un critere `null` n'est jamais un pass implicite.

---

## Estimateurs du projet

GAM, GAMBoost, INLA, LightGBM, MARS, MGWR, MGWRSAR, RandomForest, RNN,
SPBoost, STVC, SVC, SVM, XGBoost, SAR, SEM, SDM, ESF, RE-ESF.

---

## Agents

**Quality gate** (Claude / Cowork) -- evalue les fiches, maintient
`wiki/eval_queue.md`. Manuel complet: `CLAUDE.md`.

**Injecting agent** (Codex) -- cree et injecte les fiches dans `wiki/`.
Manuel complet: `AGENTS.md`.

Regle inter-agents: le quality gate ne modifie jamais une fiche. L'injecting
agent ne valide jamais sa propre evaluation.


**Reconstructions air-quality monitor-level** -- Les datasets `paper_pm25_aqs_ma_2016_monitor_covariates`, `paper_no2_aqs_ma_2016_monitor_covariates` et `paper_o3_aqs_ma_2016_monitor_covariates` sont des reconstructions publiques partielles au niveau station EPA AQS, pas des repetitions exactes des matrices d'apprentissage des papiers Di/Requia. Le script responsable est `tools/build_air_quality_monitor_covariates.R`. Il recupere les observations EPA AirData, l'elevation USGS EPQS, les variables meteo/radiation NASA POWER, la classe NLCD 2016 et la densite de routes TIGER/Line. Les predictions finales de grille des auteurs sont conservees dans les RDS comme diagnostic mais exclues des formules benchmark pour eviter la fuite d'information. Les `.rds` dans `data/final_datasets/sf/` restent regenerables localement et sont ignores par Git par defaut.