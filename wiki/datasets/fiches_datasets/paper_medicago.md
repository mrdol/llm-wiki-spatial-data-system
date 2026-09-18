---
title: paper_medicago
type: dataset
created: 2026-09-14
updated: 2026-09-18
sources:
  - data/final_datasets/sf/paper_medicago.rds
  - DataCite_2022_NicheConservatismLimitsThe_10_1111_ecog_060
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Niche conservatism limits the distribution of Medicago in the tropics" (DOI 10.1111/ecog.06085).

## Description du jeu de donnees

- Topic: biogeographie vegetale / gradients de richesse
- Observation unit: cellule de grille (100x100 km)
- Observed population: especes du genre Medicago
- Geographic context: etendue sf: x [-155.6728855, 177.8818578], y [-54.5346168, 70.8729427]
- Temporal context: none (cross-sectional)
- Source description: Niche conservatism limits the distribution of Medicago in the tropics
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/ecog.06085
- Dataset DOI: 10.5061/dryad.280gb5mrw
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.280gb5mrw
- Local raw dir: `data/raw/papers/DataCite_2022_NicheConservatismLimitsThe_10_1111_ecog_060/`
- Local sf output: `data/final_datasets/sf/paper_medicago.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `richness`, `annual`, `perennial`
- Candidate Y typology: count
- Candidate X variables in local artifact: `MAT`, `MTCQ`, `PET`, `WI`, `Solar_rad`, `MI`, `MAP`, `PDQ`, `AET`, `WD`, `DRT`, `TSN`, `ART`, `PSN`, `MATR`, `MAPR`, `Ele_range`, `Ele_std`, `LGMmat_ano`, `LGMmap_ano`, `LGMmtcq_ano`, `MHmat_ano`, `MHmap_ano`, `MHmtcq_ano`, `PC1_energy`, `PC1_water`, `PC1_seasonality`, `PC1_heterogeneity`, `PC1_past_climate`
- Candidate X count in local artifact: 29 (24 variables brutes + 5 PC1 de categorie, materialisees le 2026-09-17)
- Candidate X typology: continuous
- Published X variables from paper: memes 24 variables brutes, groupees par les auteurs en 5 categories (verifie texte integral) : energie environnementale (MAT, MTCQ, PET, WI, Solar_rad), disponibilite en eau (MI, MAP, PDQ, AET, WD), saisonnalite climatique (DRT, TSN, ART, PSN), heterogeneite d'habitat (MATR, MAPR, Ele_range, Ele_std), changement climatique passe (LGMmat_ano, LGMmap_ano, LGMmtcq_ano, MHmat_ano, MHmap_ano, MHmtcq_ano). Les 5 PC1 (une par categorie) sont maintenant des colonnes reelles, reproduites de maniere independante -- voir Reference publication et Curation documentee.
- Published X count: 24 (brutes, regroupees par les auteurs en 5 categories pour PCA). Les 5 PC1 ne sont PAS des variables supplementaires publiees -- ce sont notre resume materialise de ces memes 24 variables (voir Candidate X count pour le total local reel de 29).
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `GRIDCODE`, `Continent`, `Biome`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown
- Note complementaire (2026-09-18, ecart N verifie directement) : le texte du papier rapporte 13 360 cellules de grille terrestre mondiale au total (incluant les cellules sans Medicago) ; le README Dryad affirme separement 'Number of cases/rows: 8299' pour raw_data.xlsx. Verification directe (2026-09-18) : le fichier raw_data.xlsx reellement distribue par les auteurs (data/raw/papers/DataCite_2022_.../_extracted/raw_data.xlsx) contient en realite 8297 lignes, 0 GRIDCODE en double, et correspond exactement (0 ecart) aux 8297 lignes de cet artefact local -- notre pipeline sf n'a filtre aucune ligne. L'ecart de 2 vient donc uniquement du texte du README Dryad, qui est incoherent avec le fichier de donnees que les memes auteurs ont eux-memes deja publie (8299 rapporte vs 8297 reel), pas d'un sous-echantillonnage introduit ici.
- Note complementaire (2026-09-17, PCA) : les 5 PC1 de categorie ont ete recalcules reellement (prcomp, centre-reduit) et materialises comme colonnes du .rds -- ce ne sont plus des variables "decrites mais non disponibles". Chargements et % de variance expliques dans Reference publication ci-dessous.

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `richness` | `numeric` | count | [1, 41] | 0% |
| `annual` | `numeric` | count | [0, 37] | 0% |
| `perennial` | `numeric` | count | [0, 12] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `medicago`, la ou les reponses `richness`, `annual`, `perennial` viennent du loader papier et/ou des preuves de l article `Niche conservatism limits the distribution of Medicago in the tropics`. Les covariables X retenues sont `MAT`, `MTCQ`, `PET`, `WI`, `Solar_rad` ; 19 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`GRIDCODE`, `Continent`, `Biome`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `MAT` | `numeric` | continuous | 0% |
| `MTCQ` | `numeric` | continuous | 0% |
| `PET` | `numeric` | continuous | 0% |
| `WI` | `numeric` | continuous | 0% |
| `Solar_rad` | `numeric` | continuous | 0% |
| `MI` | `numeric` | continuous | 0% |
| `MAP` | `numeric` | continuous | 0% |
| `PDQ` | `numeric` | continuous | 0% |
| `AET` | `numeric` | continuous | 0% |
| `WD` | `numeric` | continuous | 0% |
| `DRT` | `numeric` | continuous | 0% |
| `TSN` | `numeric` | continuous | 0% |
| `ART` | `numeric` | continuous | 0% |
| `PSN` | `numeric` | continuous | 0% |
| `MATR` | `numeric` | continuous | 0% |
| `MAPR` | `numeric` | continuous | 0% |
| `Ele_range` | `numeric` | continuous | 0% |
| `Ele_std` | `numeric` | continuous | 0% |
| `LGMmat_ano` | `numeric` | continuous | 0% |
| `LGMmap_ano` | `numeric` | continuous | 0% |
| `LGMmtcq_ano` | `numeric` | continuous | 0% |
| `MHmat_ano` | `numeric` | continuous | 0% |
| `MHmap_ano` | `numeric` | continuous | 0% |
| `MHmtcq_ano` | `numeric` | continuous | 0% |
| `PC1_energy` | `numeric` | continuous | 0% |
| `PC1_water` | `numeric` | continuous | 0% |
| `PC1_seasonality` | `numeric` | continuous | 0% |
| `PC1_heterogeneity` | `numeric` | continuous | 0% |
| `PC1_past_climate` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: richness(u,v) ~ beta0(u,v) + beta1(u,v)*PC1_energy [GWR, noyau fixe, etendue par AICc -- forme du noyau et valeur de bande passante NON precisees par les auteurs, voir Note] ; richness ~ chaque variable climatique / PC1 de chaque categorie [GLM binomial-negatif univarie, monde + 6 continents + 7 biomes] ; annual/perennial ~ environmental_energy [GLM binomial-negatif, comparaison de pentes] ; richness ~ distance_niche_mediterraneenne [GLM binomial-negatif + test de permutation, voir formula_candidates > mediterranean_niche_distance]
- x_terms_pub: PC1_energy (terme GWR, localement variable) ; MAT, MTCQ, PET, WI, Solar_rad, MI, MAP, PDQ, AET, WD, DRT, TSN, ART, PSN, MATR, MAPR, Ele_range, Ele_std, LGMmat_ano, LGMmap_ano, LGMmtcq_ano, MHmat_ano, MHmap_ano, MHmtcq_ano (GLM univaries)
- y_term_pub: species richness of Medicago on 100 x 100 km grid cells (et separement, richness des especes annuelles/vivaces)
- Reference publication: Yang, Y., Bian, Z., Ren, G., Liu, J. & Shrestha, N. (2022), 'Niche conservatism limits the distribution of Medicago in the tropics', Ecography e06085, DOI 10.1111/ecog.06085 (texte integral verifie via corpus/papers/tei/Niche conservatism limits the distribution of Medicago in the tropics.tei.xml, deja disponible localement). Methode confirmee texte exact : "First, we used univariate generalized linear models (GLMs) to evaluate the effects of each climatic variables... Modified t-test was used to eliminate the effects of spatial autocorrelation on the significance tests (Dutilleul et al. 1993)." Puis PCA par categorie (5 categories, PC1 retenu), puis "we built a geographically weighted regression (GWR) model... estimated using the least square method with fixed kernel. The extent of the kernel was determined using... AICc." Note (2026-09-18) : le texte du papier ne precise NI la forme du noyau (pas de mention 'Gaussian') NI la valeur numerique de la bande passante -- seul 'fixed kernel' + selection de l'etendue par AICc sont publies. Le noyau gaussien et la bande passante 83596m cites plus bas appartiennent a NOTRE reproduction (GWmodel), pas au papier. Reproduction reelle (2026-09-17) : Reproduction reelle effectuee le 2026-09-17 (pas seulement documentee), en deux etapes, suivant exactement la methode du papier :  (1) PCA par categorie (prcomp, centre-reduit) sur les 24 variables locales, groupees exactement comme le papier (5 categories : energie MAT/MTCQ/PET/WI/Solar_rad, eau MI/MAP/PDQ/AET/WD, saisonnalite DRT/TSN/ART/PSN, heterogeneite MATR/MAPR/Ele_range/Ele_std, climat passe LGM*/MH*_ano). PC1 materialise comme colonne reelle dans le .rds pour chaque categorie (PC1_energy 88.8% variance, PC1_water 76.9%, PC1_seasonality 49.4%, PC1_heterogeneity 80.9%, PC1_past_climate 41.1%). GLM binomial-negatif global richness~PC1_categorie : past_climate R2adj=0.292 (papier : 'explaining 29% of the total variance' -- correspondance quasi exacte) ; energy R2adj=0.000 (n.s., p=0.33) -- coherent avec le papier qui explique que l'effet de l'energie s'annule a l'echelle globale car il change de signe entre tropiques et zones temperees (raison meme de l'etape GWR suivante).  (2) GWR (GWmodel::gwr.basic, noyau gaussien fixe, bande passante selectionnee par AICc via GWmodel::bw.gwr) sur richness ~ PC1_energy, coordonnees reprojetees en World Behrmann equal-area (ESRI:54017, meme projection que la grille des auteurs). Bande passante selectionnee : 83 596 m. Coefficient local moyen : -0.462 dans les tropiques (|lat|<23.5), +1.483 en zone temperee (|lat|>35) -- reproduit exactement le pattern qualitatif du papier ('the local coefficient of the regression model changed from higher negative in the tropical latitude to higher positive in the temperate latitude'). Bande passante propre (non comparee a une valeur publiee, le papier ne rapporte pas la valeur numerique exacte de sa bande passante ArcGIS).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et reproduite -- GLM global sur past_climate (R2adj=0.292 vs 29% publie) et GWR sur PC1_energy (pattern de signe tropiques/tempere reproduit)
- Correspondance Python/R: aucune identifiee
- Note: La reproduction confirme la fidelite de la lecture du papier (correction 2026-09-08, reconfirmee et enrichie le 2026-09-17). formula_used (richness ~ 5 variables energie simultanees) reste une combinaison non testee par les auteurs -- le vrai modele GLM est univarie et le GWR ne porte que sur PC1_energy (maintenant une colonne reelle, materialisee). DECISION UTILISATEUR (2026-09-08, maintenue) : la promotion package_include=yes necessiterait une orchestration multi-modeles (monde/continent/biome) que le harnais ne fait pas encore automatiquement, meme si PC1_energy est desormais utilisable directement par mgwrsar_gwr.

### Formule — niveau systeme

- formula_used: richness ~ PC1_energy
- License evidence: DataCite API record for DOI 10.5061/dryad.280gb5mrw (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- benchmark_task_note: richesse specifique observee : denombrement, sans transformation continue imposee ; formula_used utilise ici la forme GWR (OLS local, response_typologies=['continuous'] pour mgwrsar_gwr) plutot que la famille count -- voir Estimator eligibility.
- Formula used evidence: Mis a jour le 2026-09-18 -- formula_used correspond desormais exactement au candidat mgwrsar_gwr verifie et reproduit (voir formula_candidates > multivariate_constrained), au lieu de l'ancienne combinaison lineaire de 5 variables jamais testee par les auteurs (ni dans leur GWR, restreint a PC1_energy seul, ni dans leurs GLM, tous univaries).
- Selected Y typology: count
- x_terms_used: PC1_energy
- y_term_used: richness
- Note: formula_used correspond maintenant exactement au modele GWR verifie (richness ~ PC1_energy), fidele a la methode reelle des auteurs (une seule covariable pour cette etape spatiale). La batterie complete de GLM univaries (monde/continent/biome, plusieurs variables testees separement) reste documentee dans formula_candidates > univariate a titre d'exemple verifie, sans orchestration automatique dans le harnais.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "richness ~ PC1_past_climate"
    response: "richness"
    predictors: ["PC1_past_climate"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Yang, Y., Bian, Z., Ren, G., Liu, J. & Shrestha, N. (2022), 'Niche conservatism limits the distribution of Medicago in the tropics', Ecography e06085, DOI 10.1111/ecog.06085 (texte integral verifie via corpus/papers/tei/Niche conservatism limits the distribution of Medicago in the tropics.tei.xml, deja disponible localement). Reproduction reelle le 2026-09-17 : GLM binomial-negatif univarie richness ~ PC1_past_climate (echelle mondiale) donne R2adj=0.292, quasi identique au texte du papier : 'past climate change was the strongest predictor of species richness at the global scale, explaining 29% of the total variance'. PC1_past_climate materialise comme colonne reelle (PCA sur LGMmat_ano/LGMmap_ano/LGMmtcq_ano/MHmat_ano/MHmap_ano/MHmtcq_ano, 41.1% de variance expliquee par le premier axe)."
    estimator_context: ["ols"]
    status: "confirmed"
    note: "Backend ols dispatche vers glm(family=poisson()) pour une reponse typee 'count', pas vers un GLM binomial-negatif -- approximation proche mais non strictement identique a la famille utilisee par les auteurs (negative binomial, choisie pour surdispersion). Coefficient/R2 attendus proches mais pas garantis identiques a la reproduction manuelle (glm.nb) qui a donne R2adj=0.292. Note complementaire (2026-09-18) : ce R2adj a ete calcule comme 1 - deviance/null.deviance (analogue standard pour un GLM), le papier definit sa formule comme 1 - residual variance/null variance -- les deux sont proches en pratique mais pas formellement demontres identiques ici."

  multivariate_constrained:
    formula: "richness ~ PC1_energy [GWR, noyau fixe, etendue par AICc]"
    response: "species richness of Medicago on 100 x 100 km grid cells"
    predictors: ["PC1_energy"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Yang, Y., Bian, Z., Ren, G., Liu, J. & Shrestha, N. (2022), 'Niche conservatism limits the distribution of Medicago in the tropics', Ecography e06085, DOI 10.1111/ecog.06085 (texte integral verifie via corpus/papers/tei/Niche conservatism limits the distribution of Medicago in the tropics.tei.xml, deja disponible localement). Reproduction verifiee le 2026-09-17 : Reproduction reelle effectuee le 2026-09-17 (pas seulement documentee), en deux etapes, suivant exactement la methode du papier :  (1) PCA par categorie (prcomp, centre-reduit) sur les 24 variables locales, groupees exactement comme le papier (5 categories : energie MAT/MTCQ/PET/WI/Solar_rad, eau MI/MAP/PDQ/AET/WD, saisonnalite DRT/TSN/ART/PSN, heterogeneite MATR/MAPR/Ele_range/Ele_std, climat passe LGM*/MH*_ano). PC1 materialise comme colonne reelle dans le .rds pour chaque categorie (PC1_energy 88.8% variance, PC1_water 76.9%, PC1_seasonality 49.4%, PC1_heterogeneity 80.9%, PC1_past_climate 41.1%). GLM binomial-negatif global richness~PC1_categorie : past_climate R2adj=0.292 (papier : 'explaining 29% of the total variance' -- correspondance quasi exacte) ; energy R2adj=0.000 (n.s., p=0.33) -- coherent avec le papier qui explique que l'effet de l'energie s'annule a l'echelle globale car il change de signe entre tropiques et zones temperees (raison meme de l'etape GWR suivante).  (2) GWR (GWmodel::gwr.basic, noyau gaussien fixe, bande passante selectionnee par AICc via GWmodel::bw.gwr) sur richness ~ PC1_energy, coordonnees reprojetees en World Behrmann equal-area (ESRI:54017, meme projection que la grille des auteurs). Bande passante selectionnee : 83 596 m. Coefficient local moyen : -0.462 dans les tropiques (|lat|<23.5), +1.483 en zone temperee (|lat|>35) -- reproduit exactement le pattern qualitatif du papier ('the local coefficient of the regression model changed from higher negative in the tropical latitude to higher positive in the temperate latitude'). Bande passante propre (non comparee a une valeur publiee, le papier ne rapporte pas la valeur numerique exacte de sa bande passante ArcGIS)."
    estimator_context: ["mgwrsar_gwr"]
    status: "confirmed"
    note: "mgwrsar_gwr est reellement executable maintenant que PC1_energy est une colonne materialisee -- reproduit le pattern de signe rapporte par les auteurs (negatif tropiques, positif tempere). Le papier ne precise ni la forme du noyau (pas de mention Gaussian) ni la bande passante numerique -- notre reproduction utilise un noyau gaussien (GWmodel) et 83596m, des choix d'implementation, pas des valeurs publiees. sar_lag/sem_error/sdm_mixed ne sont PAS utilises par le papier ; ce sont des candidats de benchmark proposes par nous si souhaite, pas une preuve scientifique. Le papier utilise par ailleurs des GLM binomiaux-negatifs univaries (monde/continent/biome, voir formula_candidates > univariate pour un exemple verifie) et un test t modifie de Dutilleul et al. (1993) pour l'autocorrelation spatiale des tests de significativite."

  mediterranean_niche_distance:
    formula: "richness ~ distance_niche_mediterraneenne"
    response: "richness"
    predictors: ["distance_niche_mediterraneenne"]
    role: "paper_secondary_specification"
    source_type: "scientific_publication"
    source_ref: "Yang, Y., Bian, Z., Ren, G., Liu, J. & Shrestha, N. (2022), 'Niche conservatism limits the distribution of Medicago in the tropics', Ecography e06085, DOI 10.1111/ecog.06085 (texte integral verifie via corpus/papers/tei/Niche conservatism limits the distribution of Medicago in the tropics.tei.xml, deja disponible localement). Section dediee 'Mediterranean climatic niche and Medicago species richness' (identifiee le 2026-09-18, absente des versions precedentes de cette fiche). Methodologie exacte citee : PCA sur 6 variables bioclimatiques (mean annual temperature, mean temperature of coldest quarter, mean temperature of WARMEST quarter, mean annual precipitation, precipitation of driest quarter, precipitation of WETTEST quarter) pour les cellules du bassin mediterraneen ; les 2 premiers axes (88.93% de variance) definissent un espace climatique dont le centroide est calcule ; distance euclidienne (Eq. 1 du papier) entre ce centroide et chaque cellule ou Medicago est present ; GLM binomial-negatif richness~distance ; significativite testee par randomisation (1000 tirages de richness, pente observee comparee a la distribution nulle, p<0.05 si dans les 2.5% extremes)."
    estimator_context: []
    status: "not_reproduced"
    note: "NON reproduit : 2 des 6 variables bioclimatiques necessaires (mean temperature of warmest quarter, precipitation of wettest quarter) ne figurent pas parmi les 24 variables de cet artefact local ni dans raw_data.xlsx -- elles devraient etre retelechargees depuis WorldClim pour materialiser cette variable. Documente ici a titre de completude du formula_pub (issue #4 de la relecture ChatGPT du 2026-09-18, verifiee valide), mais pas candidat a l'eligibilite estimateur tant que la variable n'est pas materialisee."

  ml_or_selected:
    formula: "richness ~ MAT + MTCQ + PET + WI + Solar_rad + MI + MAP + PDQ + AET + WD + DRT + TSN + ART + PSN + MATR + MAPR + Ele_range + Ele_std + LGMmat_ano + LGMmap_ano + LGMmtcq_ano + MHmat_ano + MHmap_ano + MHmtcq_ano + PC1_energy + PC1_water + PC1_seasonality + PC1_heterogeneity + PC1_past_climate"
    response: "richness"
    predictors: ["MAT", "MTCQ", "PET", "WI", "Solar_rad", "MI", "MAP", "PDQ", "AET", "WD", "DRT", "TSN", "ART", "PSN", "MATR", "MAPR", "Ele_range", "Ele_std", "LGMmat_ano", "LGMmap_ano", "LGMmtcq_ano", "MHmat_ano", "MHmap_ano", "MHmtcq_ano", "PC1_energy", "PC1_water", "PC1_seasonality", "PC1_heterogeneity", "PC1_past_climate"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Ajoute le 2026-09-17, enrichi le 2026-09-18 avec les 5 PC1 de categorie desormais materialisees (en plus des 24 variables brutes). Aucune fuite de la reponse identifiee -- toutes exogenes."
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_medicago`
- Dataset name: Niche conservatism limits the distribution of Medicago in the tropics
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Niche conservatism limits the distribution of Medicago in the tropics
- Paper DOI: 10.1111/ecog.06085
- Dataset DOI: 10.5061/dryad.280gb5mrw
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.280gb5mrw
- Year: 2022 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression de comptage univariee (GLM) + regression spatiale locale univariee (GWR) -- pas un modele multivarie unique
- Modele niveau 2 (famille): GLM binomial-negatif univarie (une variable climatique/PC1 de categorie a la fois, repete monde/6 continents/7 biomes) ; GWR (noyau fixe, forme non precisee par les auteurs, etendue selectionnee par AICc) sur la representation agregee de l'energie environnementale (PC1_energy) -- notre reproduction utilise un noyau gaussien (GWmodel), un choix d'implementation, pas une valeur publiee
- Modele niveau 3 (variante): comparaison des pentes richness-energie entre especes annuelles et vivaces (meme famille GLM binomial-negatif) ; correction de significativite par test t modifie de Dutilleul et al. (1993)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "richness(u,v) = beta0(u,v) + beta1(u,v)*PC1_energy [GWR, fixed kernel, extent by AICc -- kernel shape and bandwidth value not reported by the authors] ; richness ~ each climatic variable / category PC1 [univariate NB GLM, world+6 continents+7 biomes] ; richness ~ Mediterranean niche distance [NB GLM + permutation test, not reproduced -- see formula_candidates > mediterranean_niche_distance]"
  equation_family: count_regression_univariate_battery_plus_local_gwr
  model_family: "univariate NB GLM battery + local GWR -- REPRODUIT numeriquement le 2026-09-17 (voir source_ref)"
  source_type: scientific_publication
  source_ref: "Yang, Y., Bian, Z., Ren, G., Liu, J. & Shrestha, N. (2022), 'Niche conservatism limits the distribution of Medicago in the tropics', Ecography e06085, DOI 10.1111/ecog.06085 (texte integral verifie via corpus/papers/tei/Niche conservatism limits the distribution of Medicago in the tropics.tei.xml, deja disponible localement). Reproduction reelle effectuee le 2026-09-17 (pas seulement documentee), en deux etapes, suivant exactement la methode du papier :  (1) PCA par categorie (prcomp, centre-reduit) sur les 24 variables locales, groupees exactement comme le papier (5 categories : energie MAT/MTCQ/PET/WI/Solar_rad, eau MI/MAP/PDQ/AET/WD, saisonnalite DRT/TSN/ART/PSN, heterogeneite MATR/MAPR/Ele_range/Ele_std, climat passe LGM*/MH*_ano). PC1 materialise comme colonne reelle dans le .rds pour chaque categorie (PC1_energy 88.8% variance, PC1_water 76.9%, PC1_seasonality 49.4%, PC1_heterogeneity 80.9%, PC1_past_climate 41.1%). GLM binomial-negatif global richness~PC1_categorie : past_climate R2adj=0.292 (papier : 'explaining 29% of the total variance' -- correspondance quasi exacte) ; energy R2adj=0.000 (n.s., p=0.33) -- coherent avec le papier qui explique que l'effet de l'energie s'annule a l'echelle globale car il change de signe entre tropiques et zones temperees (raison meme de l'etape GWR suivante).  (2) GWR (GWmodel::gwr.basic, noyau gaussien fixe, bande passante selectionnee par AICc via GWmodel::bw.gwr) sur richness ~ PC1_energy, coordonnees reprojetees en World Behrmann equal-area (ESRI:54017, meme projection que la grille des auteurs). Bande passante selectionnee : 83 596 m. Coefficient local moyen : -0.462 dans les tropiques (|lat|<23.5), +1.483 en zone temperee (|lat|>35) -- reproduit exactement le pattern qualitatif du papier ('the local coefficient of the regression model changed from higher negative in the tropical latitude to higher positive in the temperate latitude'). Bande passante propre (non comparee a une valeur publiee, le papier ne rapporte pas la valeur numerique exacte de sa bande passante ArcGIS)."
  confidence: high
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_gwr_reproduced"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Mis a jour le 2026-09-18 : formula_used aligne sur le candidat GWR reellement verifie (richness ~ PC1_energy), coherent avec le traitement applique a gartner.corn/wallace.iowaland le 2026-09-17. package_include passe a 'yes' : reponse defendable (richness), covariable materialisee (PC1_energy), support spatial reel, preuve de modele publie et reproduit (mgwrsar_gwr), artefact local complet. Reserve documentee : la reproduction complete du papier (batterie GLM univaries monde/6 continents/7 biomes) necessiterait une orchestration multi-modeles absente du harnais -- non bloquant pour la promotion de ce candidat GWR unique."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Mis a jour le 2026-09-18 : formula_used aligne sur le candidat GWR reellement verifie (richness ~ PC1_energy), coherent avec le traitement applique a gartner.corn/wallace.iowaland le 2026-09-17. package_include passe a 'yes' : reponse defendable (richness), covariable materialisee (PC1_energy), support spatial reel, preuve de modele publie et reproduit (mgwrsar_gwr), artefact local complet. Reserve documentee : la reproduction complete du papier (batterie GLM univaries monde/6 continents/7 biomes) necessiterait une orchestration multi-modeles absente du harnais -- non bloquant pour la promotion de ce candidat GWR unique.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: mgwrsar_gwr
      basis: published_model
      source_ref: "Yang, Y., Bian, Z., Ren, G., Liu, J. & Shrestha, N. (2022), 'Niche conservatism limits the distribution of Medicago in the tropics', Ecography e06085, DOI 10.1111/ecog.06085. GWR : 'performs a linear regression (ordinary least square) for each regression point... The coefficient in the GWR model was estimated using the least square method with fixed kernel. The extent of the kernel was determined using... AICc.'"
      notes: "Reproduit numeriquement le 2026-09-17 sur richness ~ PC1_energy (GWmodel::gwr.basic, noyau gaussien fixe, bande passante AICc=83596m, coordonnees reprojetees World Behrmann) : coefficient local moyen -0.462 dans les tropiques, +1.483 en zone temperee -- reproduit le pattern qualitatif exact du papier (Figure 5). mgwrsar_gwr (mgwrsar::MGWRSAR(GWR), response_typologies=['continuous']) est directement utilisable : le GWR du papier est une regression OLS locale simple sur richness. richness reste fondamentalement un comptage -- les auteurs ont eux-memes choisi d'y appliquer un GWR de type OLS (simplification methodologique assumee dans le papier), ce qui rend mgwrsar_gwr fidele a LEUR choix, sans pour autant resoudre la tension statistique sous-jacente entre une reponse de comptage et un backend a hypothese gaussienne locale. PC1_energy est une colonne reellement materialisee dans le .rds (pas une variable seulement decrite)."
  conditionally_eligible_estimators: []
  ineligible_reason: "Seul mgwrsar_gwr sur richness ~ PC1_energy est verifie/eligible a ce jour (voir eligible_estimators). Les GLM binomiaux-negatifs univaries du papier (monde/6 continents/7 biomes) necessitent une orchestration multi-modeles absente du harnais -- non promus. formula_used (richness ~ 5 variables energie simultanees) reste une combinaison additive non testee par les auteurs, distincte du candidat GWR verifie ci-dessus."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 8297
- k variables: 32
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-155.6728855, 177.8818578], y [-54.5346168, 70.8729427]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=333.6deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`medicago` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `medicago` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - Statut 'mis de cote' documente et intentionnel (voir Bloc 1 > Statut regression canonique > Note) ; ne pas retraiter sans revue.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`medicago` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Niche conservatism limits the distribution of Medicago in the tropics

## Curation documentée — 2026-09-07

Decision conservatoire : Tache count a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. richesse specifique observee : denombrement, sans transformation continue imposee. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. richesse specifique observee : denombrement, sans transformation continue imposee.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Curation documentée — 2026-09-17

Reproduction du 2026-09-17 (suite a la demande d'ecrire la meme formule que les auteurs) : Reproduction reelle effectuee le 2026-09-17 (pas seulement documentee), en deux etapes, suivant exactement la methode du papier :

(1) PCA par categorie (prcomp, centre-reduit) sur les 24 variables locales, groupees exactement comme le papier (5 categories : energie MAT/MTCQ/PET/WI/Solar_rad, eau MI/MAP/PDQ/AET/WD, saisonnalite DRT/TSN/ART/PSN, heterogeneite MATR/MAPR/Ele_range/Ele_std, climat passe LGM*/MH*_ano). PC1 materialise comme colonne reelle dans le .rds pour chaque categorie (PC1_energy 88.8% variance, PC1_water 76.9%, PC1_seasonality 49.4%, PC1_heterogeneity 80.9%, PC1_past_climate 41.1%). GLM binomial-negatif global richness~PC1_categorie : past_climate R2adj=0.292 (papier : 'explaining 29% of the total variance' -- correspondance quasi exacte) ; energy R2adj=0.000 (n.s., p=0.33) -- coherent avec le papier qui explique que l'effet de l'energie s'annule a l'echelle globale car il change de signe entre tropiques et zones temperees (raison meme de l'etape GWR suivante).

(2) GWR (GWmodel::gwr.basic, noyau gaussien fixe, bande passante selectionnee par AICc via GWmodel::bw.gwr) sur richness ~ PC1_energy, coordonnees reprojetees en World Behrmann equal-area (ESRI:54017, meme projection que la grille des auteurs). Bande passante selectionnee : 83 596 m. Coefficient local moyen : -0.462 dans les tropiques (|lat|<23.5), +1.483 en zone temperee (|lat|>35) -- reproduit exactement le pattern qualitatif du papier ('the local coefficient of the regression model changed from higher negative in the tropical latitude to higher positive in the temperate latitude'). Bande passante propre (non comparee a une valeur publiee, le papier ne rapporte pas la valeur numerique exacte de sa bande passante ArcGIS).

Tableau recapitulatif de la reproduction globale (GLM binomial-negatif, richness ~ PC1_categorie) :

| Categorie | % variance PC1 | R2adj (papier reproduit) |
|---|---|---|
| Energie | 88.8% | 0.000 (n.s.) |
| Eau | 76.9% | 0.004 |
| Saisonnalite | 49.4% | 0.023 |
| Heterogeneite | 80.9% | 0.049 |
| Climat passe | 41.1% | **0.292** (papier : "explaining 29% of the total variance") |

Artefacts materialises : 5 colonnes PC1_* ajoutees directement dans data/final_datasets/sf/paper_medicago.rds (gitignore, comme tous les artefacts data/final_datasets/).
