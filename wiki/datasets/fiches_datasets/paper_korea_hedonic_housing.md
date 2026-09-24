---
title: paper_korea_hedonic_housing
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_korea_hedonic_housing.rds
  - DatasetFirst_10_5281_zenodo_14715630
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Hedonic dataset of the metropolitan housing market -- Cases in South Korea" (DOI 10.1016/j.dib.2021.106877).

## Description du jeu de donnees

- Topic: economie immobiliere / prix hedoniques en Coree du Sud
- Observation unit: transaction immobiliere
- Observed population: transactions residentielles, 4 villes coreennes (Busan, Daegu, Daejeon, Gwangju), N=178719
- Geographic context: Etendue mesuree dans le RDS : x [126.771905, 129.255899], y [35.048503, 36.453431]; CRS EPSG:4326.
- Temporal context: 46 distinct periods (variable: Year)
- Source description: Hedonic dataset of the metropolitan housing market -- Cases in South Korea
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1016/j.dib.2021.106877
- Dataset DOI: 10.5281/zenodo.14715630
- Source URL: https://doi.org/10.5281/zenodo.14715630
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_14715630/`
- Local sf output: `data/final_datasets/sf/paper_korea_hedonic_housing.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Housing.price`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Area`, `Floor`, `Year`, `Subway.distance`, `Subway.network.distance`, `Maximum.floor`, `Households`, `Buildings`, `Parking.space`, `Heating`, `Top.school`, `High.school`, `CBD`, `Green.space.distance`, `Waterfront.distance`, `Bus.stops`, `Population`, `Male`, `Female`, `Sex.ratio`, `Medium.age`, `Young.population.ratio`, `Elderly.population.ratio`, `Population.density`, `Higher.degree.ratio`, `Spring`, `Fall`, `Winter`
- Candidate X count in local artifact: 28
- Candidate X typology: continuous, categorical
- Published X variables from paper: Area (Size, surface, m2), Floor (etage), Subway.distance (Network distance to nearest subway station -- variable confirmee comme la plus importante par l'etude d'application liee), Population.density (densite de population locale), Green.space.distance (distance a un espace vert)
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `City`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Housing.price` | `numeric` | continuous | [1000, 414340] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `korea_hedonic_housing`, la ou les reponses `Housing.price` viennent du loader papier et/ou des preuves de l article `Hedonic dataset of the metropolitan housing market -- Cases in South Korea`. Les covariables X retenues sont `Area`, `Floor`, `Subway.distance`, `Population.density`, `Green.space.distance` ; 23 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`City`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Area` | `numeric` | continuous | 0% |
| `Floor` | `numeric` | continuous | 0% |
| `Year` | `numeric` | continuous | 0% |
| `Subway.distance` | `numeric` | continuous | 0% |
| `Subway.network.distance` | `numeric` | continuous | 0% |
| `Maximum.floor` | `numeric` | continuous | 0% |
| `Households` | `numeric` | continuous | 0% |
| `Buildings` | `numeric` | continuous | 0% |
| `Parking.space` | `numeric` | continuous | 0% |
| `Heating` | `numeric` | binary | 0% |
| `Top.school` | `numeric` | continuous | 0% |
| `High.school` | `numeric` | continuous | 0% |
| `CBD` | `numeric` | continuous | 0% |
| `Green.space.distance` | `numeric` | continuous | 0% |
| `Waterfront.distance` | `numeric` | continuous | 0% |
| `Bus.stops` | `numeric` | continuous | 0% |
| `Population` | `numeric` | continuous | 0% |
| `Male` | `numeric` | continuous | 0% |
| `Female` | `numeric` | continuous | 0% |
| `Sex.ratio` | `numeric` | continuous | 0% |
| `Medium.age` | `numeric` | continuous | 0% |
| `Young.population.ratio` | `numeric` | continuous | 0% |
| `Elderly.population.ratio` | `numeric` | continuous | 0% |
| `Population.density` | `numeric` | continuous | 0% |
| `Higher.degree.ratio` | `numeric` | continuous | 0% |
| `Spring` | `numeric` | binary | 0% |
| `Fall` | `numeric` | binary | 0% |
| `Winter` | `numeric` | binary | 0% |

### Formule - niveau publication

- formula_pub: Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 -- article 'data descriptor' officiel de ce meme jeu de donnees (26 variables en 4 categories : housing properties, local demographics, local amenities, seasonal controls). Etude d'application liee trouvee : Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900, confirmant 'network distance to nearest subway station' comme la variable la plus importante pour expliquer le prix, avec les caracteristiques du logement]
- x_terms_pub: Area (Size, surface, m2), Floor (etage), Subway.distance (Network distance to nearest subway station -- variable confirmee comme la plus importante par l'etude d'application liee), Population.density (densite de population locale), Green.space.distance (distance a un espace vert)
- y_term_pub: Housing.price (prix du logement -- Condominium price, KRW)
- Reference publication: CONFIRME et ETENDU (session 2026-08-16 puis 2026-09-23) : le papier 'data descriptor' officiel de ce jeu de donnees a ete retrouve -- Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 (texte consulte via PMC, article en libre acces). Structure officielle confirmee : 26 variables en 4 categories (housing properties, demographie locale, amenites locales, controles saisonniers). Etude d'application du meme jeu identifiee et LUE INTEGRALEMENT le 2026-09-23 (PDF complet fourni par l'utilisateur -- aucun TEI n'existe pour ce papier, cherche par DOI et par titre dans 452 TEI + 422 PDF bruts, aucune correspondance) : Ahn, Jang & Song (2020), 'Economic impacts of being close to subway networks: A case study of Korean metropolitan areas', Research in Transportation Economics 83:100900, doi:10.1016/j.retrec.2020.100900. Ce papier publie une VRAIE TABLE DE COEFFICIENTS (Table 3, 4 villes, colonnes OLS et lag spatial) -- formula_used ETENDU le 2026-09-23 (16 variables au lieu de 5) pour s'en rapprocher terme-a-terme : Area, Floor, Households, Parking.space, Heating, Subway.network.distance (corrige -- l'ancienne version utilisait Subway.distance, tres correlee mais differente ; Ahn et al. precisent explicitement utiliser la distance RESEAU dans leurs resultats publies), Bus.stops, CBD, Top.school, Green.space.distance, Waterfront.distance, Population.density, Higher.degree.ratio, Spring/Fall/Winter -- verifie une par une dans le .rds local (0% NA, pas de colinearite degeneree, Subway.distance vs Subway.network.distance correles a r=1 mais non identiques, ratio moyen 1.385 -- coherent avec un facteur de circuite reseau/vol d'oiseau plausible). SEULE RESERVE RESIDUELLE : 'construction year' (variable de proprietes du logement chez Ahn et al.) est absente de l'artefact local -- la colonne 'Year' disponible est l'ANNEE DE TRANSACTION (sert de dimension temporelle du panel, role different), pas l'annee de construction. formula_used reste donc une approximation tres proche mais pas exacte du modele publie. Le bloc yaml 'Formules candidates' (multivariate_constrained) n'a pas ete resynchronise avec cette extension (limitation technique du mecanisme de correction, contenu dans un bloc de code) -- a mettre a jour lors d'une prochaine regeneration complete de la fiche. package_include reste 'yes' (voir benchmark_readiness) : cette extension renforce la fidelite au modele publie, elle ne la degrade pas.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: Housing.price ~ Area + Floor + Households + Parking.space + Heating + Subway.network.distance + Bus.stops + CBD + Top.school + Green.space.distance + Waterfront.distance + Population.density + Higher.degree.ratio + Spring + Fall + Winter
- License evidence: DataCite API record for DOI 10.5281/zenodo.14715630 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Recommended validation: N lignes=178719; T declare=46; variable temporelle declaree=Year; repetitions de coordonnees controlees=173324. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Area, Floor, Households, Parking.space, Heating, Subway.network.distance, Bus.stops, CBD, Top.school, Green.space.distance, Waterfront.distance, Population.density, Higher.degree.ratio, Spring, Fall, Winter
- y_term_used: Housing.price
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  multivariate_constrained:
    formula: "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance"
    response: "Housing.price (prix du logement -- Condominium price, KRW)"
    predictors: ["Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station -- variable confirmee comme la plus importante par l'etude d'application liee)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City"
    response: "Housing.price"
    predictors: ["Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_korea_hedonic_housing`
- Dataset name: Aggregated hedonic datasets for Busan, Daegu, Daejeon, and Gwangju
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Hedonic dataset of the metropolitan housing market -- Cases in South Korea
- Paper DOI: 10.1016/j.dib.2021.106877
- Dataset DOI: 10.5281/zenodo.14715630
- Source URL: https://doi.org/10.5281/zenodo.14715630
- Year: 2021

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 -- article 'data descriptor' officiel de ce meme jeu de donnees (26 variables en 4 categories : housing properties, local demographics, local amenities, seasonal controls). Etude d'application liee trouvee : Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900, confirmant 'network distance to nearest subway station' comme la variable la plus importante pour expliquer le prix, avec les caracteristiques du logement]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "CONFIRMED (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : le papier 'data descriptor' officiel de ce jeu de donnees a ete retrouve -- Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 (texte consulte via PMC, article en libre acces). Structure officielle confirmee : 26 variables en 4 categories (housing properties : size/floor/parking/annee construction ; demographie locale : population/densite/education/age ; amenites locales : distance metro/bus/espaces verts/CBD ; controles saisonniers). Une etude d'application du meme jeu de donnees a egalement ete identifiee -- Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900 -- confirmant explicitement que la distance au metro et les caracteristiques du logement sont les determinants les plus importants du prix. formula_used (deja proposee par le curateur avant cette recherche) s'avere BIEN ALIGNEE avec la structure officiellement documentee (Area/Floor/Subway.distance/Population.density/Green.space.distance correspondent directement aux 4 categories du data descriptor, Subway.distance confirmee comme variable cle) -- aucune correction necessaire, seule la reference bibliographique est ajoutee. 4 fichiers xlsx (Busan.xlsx, Daegu.xlsx, Daejeon.xlsx, Gwangju.xlsx) telecharges directement depuis Zenodo (DOI 10.5281/zenodo.14715630, tres probablement une extension/mise a jour du dataset original de Song et al. par les memes auteurs ou un groupe associe) -- pas une reconstruction, N=178719 transactions immobilieres (Busan 53458, Daegu 56606, Daejeon 24350, Gwangju 44305). Coordonnees reelles (Longitude/Latitude) verifiees coherentes par ville, pas d'inversion. package_include laisse en manual_review : formule alignee avec la documentation officielle du dataset, mais pas verifiee terme-a-terme contre une regression publiee precise (le data descriptor ne publie pas lui-meme d'equation de regression, seulement la structure des variables)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: scientific_evidence
      source_ref: 'Revue en lot du 2026-09-09 -- voir Note ci-dessous.'
      notes: 'Song, Ahn, An & Jang (2021), Data in Brief, doi:10.1016/j.dib.2021.106877 -- article data-descriptor officiel documentant Area/Floor/Subway.distance/Population.density/Green.space.distance comme les variables hedoniques publiees pour ce jeu.'
    - estimator: gam_spatial
      basis: scientific_evidence
      source_ref: 'Revue en lot du 2026-09-09 -- voir Note ci-dessous.'
      notes: 'Meme source -- variante non-lineaire (GAM) des memes covariables publiees.'
    - estimator: random_forest
      basis: benchmark_use
      source_ref: 'Revue en lot du 2026-09-09 -- voir Note ci-dessous.'
      notes: 'Alternative ML generique pour comparaison, Y continu.'
    - estimator: xgboost
      basis: benchmark_use
      source_ref: 'Revue en lot du 2026-09-09 -- voir Note ci-dessous.'
      notes: 'Alternative ML generique pour comparaison, Y continu.'
  conditionally_eligible_estimators: ['sar_lag']
  ineligible_reason: 'Mis a jour le 2026-09-23 apres lecture INTEGRALE (PDF complet, pas seulement resume/TEI -- aucun TEI n existe pour ce papier, DOI/titre cherches en vain dans les 452 TEI et 422 PDF bruts du corpus) de Ahn, Jang & Song (2020), Research in Transportation Economics, doi:10.1016/j.retrec.2020.100900. Ce papier utilise EXPLICITEMENT un modele a lag spatial (eq. 2-3 du papier) en plus du modele hedonique OLS, avec une matrice de poids totalement specifiee : W_ij = 1/d_ij si d_ij < D (0 sinon), d_ij = distance euclidienne entre logements (longitude/latitude), forme row-standardisee -- un seuil de distance (Cas 1 de la methodologie de reconstruction W, README extensions_projet_2026-09/matrice_W_originale/). sar_lag place en conditionally_eligible (pas eligible_estimators) pour deux raisons : (1) la valeur numerique du seuil D n est donnee nulle part dans le texte integral (forme reconstructible, calibration non publiee) ; (2) l artefact local (4 fichiers xlsx Zenodo, N=178719, tres probablement une extension 2017+ du jeu original) a des effectifs differents par ville de ceux d Ahn et al. (Busan/Daegu/Daejeon/Gwangju n=62780/32672/21211/26024, donnees 2015) -- reconstruire leur W serait fidele a LEUR methode, pas une reproduction de LEURS resultats sur CES donnees. Fiche complete (equation, citation, mise en garde) : voir [[paper_korea_hedonic_housing]] > Bloc 1.'
  rule: 'Revue de la tache avant selection des routes; aucune promotion automatique.'
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 178719
- k variables: 35
- T periods: 46
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (178719) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 5395 ; panel NON EQUILIBRE (T par unite : min=1, mediane=15, max=908). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 5395 unites spatiales distinctes, pas sur les 178719 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 46 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [126.771905, 129.255899], y [35.048503, 36.453431]
- Time range: 1969 to 2019 (variable: Year)
- CRS analyse recommande: 32652 (UTM Zone 52N (EPSG:32652)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`korea_hedonic_housing` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `korea_hedonic_housing` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`korea_hedonic_housing` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Hedonic dataset of the metropolitan housing market -- Cases in South Korea

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=178719; T declare=46; variable temporelle declaree=Year; repetitions de coordonnees controlees=173324. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Les coupes annuelles sont des transactions de logements : un millesime unique ne rend pas les transactions au meme emplacement independantes; definir une cle immeuble/site, conserver le lien au parent. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
