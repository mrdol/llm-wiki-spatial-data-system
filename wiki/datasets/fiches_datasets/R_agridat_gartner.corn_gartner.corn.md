---
title: R_agridat_gartner.corn_gartner.corn
type: dataset
created: 2026-08-15
updated: 2026-09-17
sources:
  - data/final_datasets/sf/R_agridat_gartner.corn_gartner.corn.rds
tags: [dataset, r-package, spatial, point]
---

Yield monitor data from a corn field in Minnesota

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: Etendue mesuree dans le RDS : x [-93.978422, -93.973494], y [43.920994, 43.927265]; CRS non renseigne, repere/unites a documenter.
- Temporal context: colonnes date/time presentes mais traitees comme attributs transactionnels
- Source description: Yield monitor data from a corn field in Minnesota
- Description source: package R `agridat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `mass`, `moist`, `yield`
- Candidate Y typology: continuous
- Candidate X variables: `dist`, `elev`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `long`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown
- Note complementaire (2026-09-17) : `yield` (bushels/acre) materialise le 2026-09-17 -- ce n'est PAS `mass` (flux de masse brut, livres/seconde) mais une transformation documentee du package (voir Reference publication). C'est la vraie variable reponse utilisee par Rakshit et al. (2020).

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mass` | `numeric` | continuous | [0, 48.99] | 0% |
| `moist` | `numeric` | continuous | [14.9, 19.3] | 0% |
| `yield` | `numeric` | continuous | [0, 258.39] | 0% |

> Selection Y/X (claude-sonnet-4-6) : Dans un yield monitor de maïs, 'mass' (masse récoltée) est la variable réponse principale (rendement), et 'moist' (humidité du grain) est une seconde cible agronomique d'intérêt. 'elev' (élévation topographique) et 'dist' (distance parcourue) sont des covariables spatiales explicatives pertinentes ; 'time' et 'T' semblent redondants (même plage), et 'seconds' a une variance quasi nulle (3-4s), rendant ces trois colonnes inutiles comme features.
>
> Correction 2026-09-17 : `mass` seul n'est pas le rendement -- le rendement reel (`yield`, bushels/acre) est une transformation de mass/seconds/moist/dist, documentee dans la doc reelle du package et maintenant materialisee.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `dist` | `integer` | count | 0% |
| `elev` | `numeric` | continuous | 0% |

### Formule — niveau publication

- formula_pub: yield ~ elev [OLS global] ; yield(u,v) ~ beta0(u,v) + beta1(u,v)*elev(u,v) [GWR, noyau gaussien, bande passante 20m par validation croisee spatiale]
- x_terms_pub: elev
- y_term_pub: yield (bushels/acre, transformation documentee de mass/seconds/moist/dist)
- Reference publication: Rakshit, S., Baddeley, A., Stefanova, K., Reeves, K., Chen, K., Cao, Z., Evans, F. & Gibberd, M. (2020), 'Novel approach to the analysis of spatially-varying treatment effects in on-farm experiments', Field Crops Research 255, 107783, DOI 10.1016/j.fcr.2020.107783 (texte integral verifie via corpus/papers/tei/rakshit2020_gartner_dataset.tei.xml, deja disponible localement). Confirme explicitement (section 2.1) : 'The Minnesota and Las Rosas datasets are publicly available by the names of gartner.corn and lasrosas.corn, respectively, in the R-package agridat'. Section 3.1 : 'Yield response in the first example is modelled as a function of the spatial explanatory variable elevation'. Modele global (OLS) : yield ~ elevation, coefficient = -0.55 (p<1e-6), R2=0.154. GWR (noyau gaussien) : bande passante 5.11m (validation croisee leave-one-out, jugee trop petite/bruitee), 12.37m (AICc, egalement jugee trop petite), 20m (validation croisee spatiale -- methode preferee des auteurs, bloc de 61m de cote). 'yield' n'est pas une colonne brute mais une transformation documentee du package (voir Reproduction 2026-09-17).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee ; reproduction directionnelle confirmee (meme signe/significativite), magnitude non exacte -- voir note
- Correspondance Python/R: aucune identifiee
- Note: Reproduction reelle effectuee le 2026-09-17. La transformation exacte 'yield' est documentee dans la doc reelle du package (tools::Rd_db('agridat', 'gartner.corn')) : yield = [mass*seconds*(100-moist)/(100-15.5)/56] / (dist*360/6272640), avec filtre d'aberrants 'yield>50' explicitement donne dans les Examples de la doc. Colonne `yield` materialisee dans le .rds (plus une colonne booleenne `yield_outlier`, 88/4949 lignes sous le seuil, filtrage laisse a l'estimateur plutot que supprime silencieusement). Ajustement OLS global yield~elev (apres filtre yield>50, N=4861) : coefficient=-0.2775 (p<2e-16), R2=0.040 -- MEME SIGNE et MEME NIVEAU DE SIGNIFICATIVITE que le papier (-0.55, p<1e-6), mais magnitude et R2 environ 2 a 4x plus faibles. Reproduction partielle mais coherente directionnellement -- plus proche que Python_geodatasets_geoda.police (aucune coherence directionnelle) mais moins exacte que paper_medicago ou R_SpatialEpi_pennLC_sf_pennLC_sf (reproduction quasi exacte). Ecart residuel non explique avec certitude (possibles differences de nettoyage/projection non entierement documentees dans le texte accessible) -- ne pas inventer de justification precise.

### Formule — niveau systeme

- formula_used: yield ~ elev
- Formula used evidence: formula_pub confirmee et partiellement reproduite (voir Statut regression canonique) -- `yield` materialise le 2026-09-17, remplace l'ancienne formule generique `mass ~ dist + elev`.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: elev
- y_term_used: yield

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "yield ~ elev"
    response: "yield"
    predictors: ["elev"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Rakshit, S., Baddeley, A., Stefanova, K., Reeves, K., Chen, K., Cao, Z., Evans, F. & Gibberd, M. (2020), 'Novel approach to the analysis of spatially-varying treatment effects in on-farm experiments', Field Crops Research 255, 107783, DOI 10.1016/j.fcr.2020.107783 (texte integral verifie via corpus/papers/tei/rakshit2020_gartner_dataset.tei.xml, deja disponible localement). Confirme explicitement (section 2.1) : 'The Minnesota and Las Rosas datasets are publicly available by the names of gartner.corn and lasrosas.corn, respectively, in the R-package agridat'. Section 3.1 : 'Yield response in the first example is modelled as a function of the spatial explanatory variable elevation'. Modele global (OLS) : yield ~ elevation, coefficient = -0.55 (p<1e-6), R2=0.154. GWR (noyau gaussien) : bande passante 5.11m (validation croisee leave-one-out, jugee trop petite/bruitee), 12.37m (AICc, egalement jugee trop petite), 20m (validation croisee spatiale -- methode preferee des auteurs, bloc de 61m de cote). 'yield' n'est pas une colonne brute mais une transformation documentee du package (voir Reproduction 2026-09-17)."
    estimator_context: ["ols"]
    status: "confirmed"

  multivariate_constrained:
    formula: "yield(u,v) ~ beta0(u,v) + beta1(u,v)*elev(u,v) [GWR, noyau gaussien, bande passante 20m]"
    response: "yield"
    predictors: ["elev"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Rakshit, S., Baddeley, A., Stefanova, K., Reeves, K., Chen, K., Cao, Z., Evans, F. & Gibberd, M. (2020), 'Novel approach to the analysis of spatially-varying treatment effects in on-farm experiments', Field Crops Research 255, 107783, DOI 10.1016/j.fcr.2020.107783 (texte integral verifie via corpus/papers/tei/rakshit2020_gartner_dataset.tei.xml, deja disponible localement). Confirme explicitement (section 2.1) : 'The Minnesota and Las Rosas datasets are publicly available by the names of gartner.corn and lasrosas.corn, respectively, in the R-package agridat'. Section 3.1 : 'Yield response in the first example is modelled as a function of the spatial explanatory variable elevation'. Modele global (OLS) : yield ~ elevation, coefficient = -0.55 (p<1e-6), R2=0.154. GWR (noyau gaussien) : bande passante 5.11m (validation croisee leave-one-out, jugee trop petite/bruitee), 12.37m (AICc, egalement jugee trop petite), 20m (validation croisee spatiale -- methode preferee des auteurs, bloc de 61m de cote). 'yield' n'est pas une colonne brute mais une transformation documentee du package (voir Reproduction 2026-09-17)."
    estimator_context: ["mgwrsar_gwr"]
    status: "confirmed"
    note: "Bande passante publiee (20m, validation croisee spatiale) tres inferieure a celle typiquement selectionnee par AICc classique (12.37m selon les auteurs eux-memes, jugee trop petite/bruitee) -- mgwrsar_gwr utiliserait par defaut une selection AICc standard, pas la methode de validation croisee spatiale proposee par les auteurs (non implementee dans le harnais)."

  ml_or_selected:
    formula: "yield ~ elev + dist"
    response: "yield"
    predictors: ["elev", "dist"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Ajoute le 2026-09-17. Seuls 2 X candidats disponibles au-dela de yield/mass/moist (qui sont les ingredients de yield, donc exclus pour eviter la fuite)."
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_agridat_gartner.corn_gartner.corn`
- Dataset name: agridat::gartner.corn
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2011

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression spatiale locale (GWR) sur donnees de rendement agricole
- Modele niveau 2 (famille): local likelihood / geographically weighted regression (Gaussian kernel)
- Modele niveau 3 (variante): OLS global (baseline) + GWR avec selection de bande passante par validation croisee spatiale (methode proposee par les auteurs, alternative a AICc/LOOCV classiques)

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "yield ~ elev [OLS global, coef=-0.55, R2=0.154] ; yield(u,v) = beta0(u,v) + beta1(u,v)*elev(u,v) [GWR, bande passante 20m]"
  equation_family: local_likelihood_gwr
  model_family: "GWR (Gaussian kernel) -- reproduit partiellement le 2026-09-17 (meme signe/significativite, magnitude ~2-4x plus faible localement)"
  source_type: scientific_publication
  source_ref: "Rakshit, S., Baddeley, A., Stefanova, K., Reeves, K., Chen, K., Cao, Z., Evans, F. & Gibberd, M. (2020), 'Novel approach to the analysis of spatially-varying treatment effects in on-farm experiments', Field Crops Research 255, 107783, DOI 10.1016/j.fcr.2020.107783 (texte integral verifie via corpus/papers/tei/rakshit2020_gartner_dataset.tei.xml, deja disponible localement). Confirme explicitement (section 2.1) : 'The Minnesota and Las Rosas datasets are publicly available by the names of gartner.corn and lasrosas.corn, respectively, in the R-package agridat'. Section 3.1 : 'Yield response in the first example is modelled as a function of the spatial explanatory variable elevation'. Modele global (OLS) : yield ~ elevation, coefficient = -0.55 (p<1e-6), R2=0.154. GWR (noyau gaussien) : bande passante 5.11m (validation croisee leave-one-out, jugee trop petite/bruitee), 12.37m (AICc, egalement jugee trop petite), 20m (validation croisee spatiale -- methode preferee des auteurs, bloc de 61m de cote). 'yield' n'est pas une colonne brute mais une transformation documentee du package (voir Reproduction 2026-09-17). Reproduction reelle effectuee le 2026-09-17. La transformation exacte 'yield' est documentee dans la doc reelle du package (tools::Rd_db('agridat', 'gartner.corn')) : yield = [mass*seconds*(100-moist)/(100-15.5)/56] / (dist*360/6272640), avec filtre d'aberrants 'yield>50' explicitement donne dans les Examples de la doc. Colonne `yield` materialisee dans le .rds (plus une colonne booleenne `yield_outlier`, 88/4949 lignes sous le seuil, filtrage laisse a l'estimateur plutot que supprime silencieusement). Ajustement OLS global yield~elev (apres filtre yield>50, N=4861) : coefficient=-0.2775 (p<2e-16), R2=0.040 -- MEME SIGNE et MEME NIVEAU DE SIGNIFICATIVITE que le papier (-0.55, p<1e-6), mais magnitude et R2 environ 2 a 4x plus faibles. Reproduction partielle mais coherente directionnellement -- plus proche que Python_geodatasets_geoda.police (aucune coherence directionnelle) mais moins exacte que paper_medicago ou R_SpatialEpi_pennLC_sf_pennLC_sf (reproduction quasi exacte). Ecart residuel non explique avec certitude (possibles differences de nettoyage/projection non entierement documentees dans le texte accessible) -- ne pas inventer de justification precise."
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 4949
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: colonnes date/time presentes mais traitees comme attributs transactionnels

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-93.9784, -93.9735], y [43.921, 43.9273] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_published_formula_partially_reproduced"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Modele publie identifie ET partiellement reproduit le 2026-09-17 (Rakshit et al. 2020, DOI verifie, gartner.corn explicitement nomme dans le papier). yield materialise depuis la transformation documentee du package agridat. OLS et GWR (mgwrsar_gwr) tous deux eligibles avec preuve publiee -- package_include passe a 'yes' : reponse defendable (yield), covariable (elev), support spatial (coordonnees reelles), preuve de modele publie (deux estimateurs), artefact local complet (yield materialise)."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Modele publie identifie ET partiellement reproduit le 2026-09-17 (Rakshit et al. 2020, DOI verifie, gartner.corn explicitement nomme dans le papier). yield materialise depuis la transformation documentee du package agridat. OLS et GWR (mgwrsar_gwr) tous deux eligibles avec preuve publiee -- package_include passe a 'yes' : reponse defendable (yield), covariable (elev), support spatial (coordonnees reelles), preuve de modele publie (deux estimateurs), artefact local complet (yield materialise).

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `agridat`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: ols
      basis: published_model
      source_ref: "Rakshit, S., Baddeley, A., Stefanova, K., Reeves, K., Chen, K., Cao, Z., Evans, F. & Gibberd, M. (2020), 'Novel approach to the analysis of spatially-varying treatment effects in on-farm experiments', Field Crops Research 255, 107783, DOI 10.1016/j.fcr.2020.107783 (texte integral verifie via corpus/papers/tei/rakshit2020_gartner_dataset.tei.xml, deja disponible localement)."
      notes: "yield~elev reproduit directionnellement le 2026-09-17 (meme signe negatif, meme niveau de significativite p<1e-6/p<2e-16) mais magnitude/R2 environ 2-4x plus faibles que publie (-0.2775/R2=0.040 vs -0.55/R2=0.154). Ecart non explique avec certitude."
    - estimator: mgwrsar_gwr
      basis: published_model
      source_ref: "Rakshit, S., Baddeley, A., Stefanova, K., Reeves, K., Chen, K., Cao, Z., Evans, F. & Gibberd, M. (2020), 'Novel approach to the analysis of spatially-varying treatment effects in on-farm experiments', Field Crops Research 255, 107783, DOI 10.1016/j.fcr.2020.107783 (texte integral verifie via corpus/papers/tei/rakshit2020_gartner_dataset.tei.xml, deja disponible localement)."
      notes: "GWR reellement utilise par les auteurs sur ce jeu exact (Minnesota, gartner.corn). Bande passante publiee (20m, validation croisee spatiale) tres differente de ce que mgwrsar_gwr selectionnerait par defaut (AICc classique, ~12.37m selon les auteurs eux-memes) -- la methode de selection de bande passante des auteurs n'est pas implementee dans le harnais, mais le modele (GWR gaussien sur yield~elev) l'est."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- deux estimateurs eligibles avec preuve publiee, reproduction directionnelle confirmee pour ols."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Curation documentée — 2026-09-17

Recherche du 2026-09-17 (suite a un echange avec un autre agent IA ayant identifie Rakshit et al. 2020). Rakshit, S., Baddeley, A., Stefanova, K., Reeves, K., Chen, K., Cao, Z., Evans, F. & Gibberd, M. (2020), 'Novel approach to the analysis of spatially-varying treatment effects in on-farm experiments', Field Crops Research 255, 107783, DOI 10.1016/j.fcr.2020.107783 (texte integral verifie via corpus/papers/tei/rakshit2020_gartner_dataset.tei.xml, deja disponible localement). Confirme explicitement (section 2.1) : 'The Minnesota and Las Rosas datasets are publicly available by the names of gartner.corn and lasrosas.corn, respectively, in the R-package agridat'. Section 3.1 : 'Yield response in the first example is modelled as a function of the spatial explanatory variable elevation'. Modele global (OLS) : yield ~ elevation, coefficient = -0.55 (p<1e-6), R2=0.154. GWR (noyau gaussien) : bande passante 5.11m (validation croisee leave-one-out, jugee trop petite/bruitee), 12.37m (AICc, egalement jugee trop petite), 20m (validation croisee spatiale -- methode preferee des auteurs, bloc de 61m de cote). 'yield' n'est pas une colonne brute mais une transformation documentee du package (voir Reproduction 2026-09-17).

Reproduction reelle effectuee le 2026-09-17. La transformation exacte 'yield' est documentee dans la doc reelle du package (tools::Rd_db('agridat', 'gartner.corn')) : yield = [mass*seconds*(100-moist)/(100-15.5)/56] / (dist*360/6272640), avec filtre d'aberrants 'yield>50' explicitement donne dans les Examples de la doc. Colonne `yield` materialisee dans le .rds (plus une colonne booleenne `yield_outlier`, 88/4949 lignes sous le seuil, filtrage laisse a l'estimateur plutot que supprime silencieusement). Ajustement OLS global yield~elev (apres filtre yield>50, N=4861) : coefficient=-0.2775 (p<2e-16), R2=0.040 -- MEME SIGNE et MEME NIVEAU DE SIGNIFICATIVITE que le papier (-0.55, p<1e-6), mais magnitude et R2 environ 2 a 4x plus faibles. Reproduction partielle mais coherente directionnellement -- plus proche que Python_geodatasets_geoda.police (aucune coherence directionnelle) mais moins exacte que paper_medicago ou R_SpatialEpi_pennLC_sf_pennLC_sf (reproduction quasi exacte). Ecart residuel non explique avec certitude (possibles differences de nettoyage/projection non entierement documentees dans le texte accessible) -- ne pas inventer de justification precise.
