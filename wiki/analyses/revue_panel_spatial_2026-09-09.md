---
title: Revue ciblée du panel spatial à partir de Li, Fang et He
type: analysis
created: 2026-09-09
updated: 2026-09-09
sources:
  - wiki/datasets/fiches_datasets/paper_li_energy_price_co2_china.md
  - wiki/analyses/plan_implementation_panel_spatial_2026-09-09.md
tags: [spatial-panel, estimators, literature-review]
---

# Panel spatial : revue ciblée et préparation de l'implémentation

Cette revue part du papier associé à [[paper_li_energy_price_co2_china]], puis des travaux d'Elhorst et Baltagi et de l'implémentation `splm`. Elle prépare une implémentation ultérieure : aucune route de panel n'est ajoutée au package à ce stade. Les sources théoriques sont consultées au niveau accessible (notice, résumé ou documentation) ; cela ne prétend pas remplacer leur lecture intégrale pour l'implémentation.

## Ce que demande concrètement le papier CO₂

Li, Fang et He (2020), [DOI 10.1016/j.scitotenv.2019.135942](https://doi.org/10.1016/j.scitotenv.2019.135942), utilise neuf variables explicatives et une réponse en logarithme. Le modèle principal est spatial lag avec effets fixes provinciaux ; SEM/SAC et spécifications dynamiques servent aux comparaisons et robustesses. Les équations générales comportent aussi des effets temporels : le choix de l'effet doit rester un argument documenté, pas une conséquence implicite du nom SAR.

Dans les fichiers disponibles, le panel est équilibré : 30 provinces, 15 années, 450 lignes. Une W de 30 × 30 doit être indexée par province et utilisée avec une correspondance explicite aux observations de chaque année. Construire un voisinage sur 450 lignes avec géométries répétées ne reproduit pas cette structure. Empiler W ne suffit pas non plus à prendre en charge effets fixes, variance, dynamique et prédiction.

La W principale du papier est une contiguïté avec frontière commune, normalisée par ligne. Les robustesses utilisent aussi 3, 4, 5 et 6 plus proches voisins. Les choix pour les provinces sans voisin contigu, l'ordre des unités et le fond de carte exact sont à résoudre avant toute revendication de réplication.

## Sources à utiliser, et question traitée par chacune

| Source primaire | Apport vérifié / rôle dans la suite |
|---|---|
| Elhorst (2003), *Specification and Estimation of Spatial Panel Data Models*, [10.1177/0160017603253791](https://journals.sagepub.com/doi/10.1177/0160017603253791) | Cadre de spécification et estimation avec effets fixes/aléatoires et dépendance spatiale ; base pour distinguer le modèle de panel du SAR transversal. |
| Elhorst (2010), *Applied Spatial Econometrics: Raising the Bar*, [10.1080/17421770903541772](https://research.rug.nl/en/publications/applied-spatial-econometrics-raising-the-bar/) | Référence méthodologique évoquée par Li et al. ; à lire pour la stratégie de spécification et l'interprétation des effets. Notice et version éditeur identifiées. |
| Elhorst (2014), *Spatial Econometrics: From Cross-Sectional Data to Spatial Panels*, [10.1007/978-3-642-40340-8](https://link.springer.com/book/10.1007/978-3-642-40340-8) | Passage des coupes aux panels statiques puis dynamiques ; ouvrage cité dans la bibliographie de Li et al., avec code de réplication annoncé par l'éditeur. |
| Baltagi, Song et Koh (2003), *Testing panel data regression models with spatial error correlation*, [10.1016/S0304-4076(03)00120-9](https://www.sciencedirect.com/science/article/pii/S0304407603001209) | Tests LM distinguant effets régionaux aléatoires et corrélation spatiale des erreurs ; ne pas réutiliser sans justification des tests conçus pour une seule coupe. Résumé consulté, texte éditeur non récupéré. |
| Lee et Yu (2010), *Estimation of spatial autoregressive panel data models with fixed effects*, [notice éditeur](https://www.sciencedirect.com/science/article/pii/S030440760900178X) | Propriétés des estimateurs avec effets fixes et T fini ; utile pour examiner les corrections de biais et la variance. Résumé consulté, lecture intégrale à poursuivre. |
| Millo et Piras (2012), *splm: Spatial Panel Data Models in R*, [10.18637/jss.v047.i01](https://www.jstatsoft.org/article/view/v047i01) | Implémentations ML et moments, effets fixes/aléatoires ; exemple reproductible de productivité de 48 États sur 17 ans et code associé. Référence logicielle pour une première parité. |

## Première route à implémenter

Commencer par le **panel spatial lag statique à effets fixes individuels**, correspondant au modèle principal du papier. Le candidat R est `splm::spml`, dont la [documentation officielle](https://search.r-project.org/CRAN/refmans/splm/html/spml.html) expose explicitement les index, W, effets et présence du lag spatial :

```r
# Proposition de référence pour une future implémentation, non exécutée ici.
splm::spml(
  log(CO2) ~ log(POP) + log(PGDP) + log(INS) + log(URB) +
    log(RFDI) + log(TEC) + log(EDU) + log(ENS) + log(EP),
  data = panel_df,
  index = c("id_province", "year"),
  listw = W_provinces,
  model = "within", effect = "individual",
  lag = TRUE, spatial.error = "none"
)
```

Ce code indique une cible de comparaison, pas une preuve de réplication du papier. `panel_df` et `W_provinces` devront être préparés et vérifiés. La documentation de `spml` expose aussi les variantes d'erreur spatiale et doubles effets ; elle ne justifie pas de ranger toutes ces variantes sous le même moteur transversal.

Ensuite, ajouter SEM puis SAC en vérifiant séparément leur paramétrisation d'erreur. Le dynamique vient après : introduire une variable retardée dans une formule statique ne suffit pas à traiter son endogénéité ni les biais de panel court. Il faudra choisir et vérifier un estimateur approprié dans la littérature avant le raccordement logiciel.

## Contrat du futur harnais et vérification

1. **Entrée** : couple unité–temps explicite, unicité, calendrier, panel équilibré ou non et politique des valeurs manquantes. Conserver les données de panel complètes dans la banque.
2. **W** : taille N × N, noms et ordre des unités, normalisation, îlots, stabilité temporelle. Toute sous-sélection exige une règle documentée de réindexation.
3. **Modèle** : transformations, effet individuel/temporel/double, lag de Y, erreur spatiale, éventuel retard temporel ; ces éléments ne doivent pas être perdus dans une simple chaîne Y ~ X.
4. **Prédiction** : distinguer ajustement sur unités connues, prévision temporelle et transfert à une nouvelle unité. Les effets fixes et l'accès aux voisins observés ne sont pas disponibles dans les mêmes conditions. Définir d'abord la cible de prédiction.
5. **Validation** : comparaison numérique au package de référence sur un exemple publié, puis CO₂ si W et provenance sont suffisamment établies. Tester erreurs de réindexation et absence de fuite temporelle ; ne pas utiliser la réponse future pour calculer Wy.
6. **Résultats** : distinguer coefficients, effets directs/indirects/totaux et performances prédictives. Le coefficient d'une X dans un SAR ne se lit pas automatiquement comme son effet marginal total.

Un premier jalon défendable est la parité avec l'exemple Munnell de Millo–Piras, avant d'utiliser CO₂ comme cas de réplication. Pour CO₂, l'année 2001 annoncée dans une partie du PDF mais absente du fichier et la provenance géographique reconstruite empêchent encore de promettre une reproduction complète des tableaux.

## Statut dans la banque

`ready_in_data_bank` désigne un jeu de panel conservé et documenté dans la banque dont l'exécution par le harnais de benchmark n'est pas encore disponible. Il ne provoque ni `package_include: yes`, ni `benchmark_ready: true`. Le seul manque d'un moteur panel ne doit pas transformer un jeu documenté en `manual_review`.

Cette distinction est appliquée à CO₂. Elle ne convertit pas aveuglément tous les panels existants : un problème de provenance, de variable ou de contenu reste une question distincte, à établir jeu par jeu. Le recensement documentaire ci-dessous couvre désormais toutes les fiches ; il ne réaudite pas leurs artefacts RDS ni leur admissibilité au benchmark.


## Recensement de toutes les fiches datasets — 9 septembre 2026

**409 fiches parcourues. Une application de panel spatial économétrique est confirmée dans les fiches existantes : Li, Fang et He (CO₂). Un deuxième papier, Turchin (Seshat), teste effectivement une diffusion spatiale retardée dans une régression dynamique, mais cette composante n'est pas retenue dans ses résultats finaux.** Deux autres applications explicites sont déjà dans le corpus sans fiche dataset correspondante : Yun–Gramig et De Siano–Chiariello.

### Portée et preuve du recensement

Le criblage couvre tous les fichiers Markdown de `wiki/datasets/fiches_datasets`, y compris les sources R/Python et les entrepôts. Recherche initiale dans le KG, puis recherche textuelle dans les 409 fiches : panel, effets fixes/aléatoires, SAR/SEM/Durbin, noms de logiciels et références Elhorst/Baltagi. **180 fiches présentent au moins un de ces signaux très larges**, souvent une note générique sur les coordonnées répétées ou une fiche annuelle issue d'un même article. Ce nombre n'est donc ni un nombre de papiers ni un nombre de méthodes panel.

Les titres, formules et descriptions des sources servent au tri ; les PDF/TEI et le code original ont été consultés pour les principaux cas économétriques ambigus. L'[inventaire JSON des 409 fiches](../../data/manifests/datasets/review_2026-09-09/spatial_panel_inventory.json) conserve pour chacune son chemin, empreinte SHA-256, champs bibliographiques, formule publiée, signaux et conclusion avec son niveau de preuve. Les fiches sans preuve positive ne sont pas déclarées définitivement exemptes de méthode panel : **ce recensement exhaustif des fiches n'est pas une lecture intégrale de tous leurs articles**.

Le décompte ci-dessous porte sur les articles distincts. Une coupe annuelle et son parent ne constituent pas deux publications. Une structure longitudinale disponible ne prouve pas que l'article l'utilise comme panel spatial.

### Articles issus des fiches à retenir

| Article et fiche | Méthode effectivement appliquée | Preuves et conséquence pour la revue |
|---|---|---|
| Li, Fang et He (2020), *The Impact of Energy Price on CO₂ Emissions in China: A Spatial Econometric Analysis*. [DOI](https://doi.org/10.1016/j.scitotenv.2019.135942). [Fiche CO₂](../datasets/fiches_datasets/paper_li_energy_price_co2_china.md) | Panel spatial lag à effets fixes provinciaux ; comparaisons SEM/SAC et robustesse dynamique. | PDF local, sections 2.3/3.1, équations 4–7. **Cas principal pour préparer le harnais panel**. Les données locales sont 30 provinces × 15 années, 450 observations ; ces nombres ne remplacent pas la vérification de W et de l'échantillon exact du papier. |
| Turchin (2018), *Fitting Dynamic Regression Models to Seshat Data*. [DOI](https://doi.org/10.21237/c7clio9137696). [Fiche Seshat](../datasets/fiches_datasets/paper_seshat_social_complexity.md) | Régression dynamique avec retards propres, diffusion géographique retardée et terme phylogénétique ; essais d'effets fixes NGA. | PDF local, pages PDF 23–24 / imprimées 46–47 : équation (3), estimation `glm`, sélection AIC. La diffusion géographique est testée mais non significative et omise des résultats finaux ; effets fixes discutés page PDF 27. **Extension dynamique à documenter, pas réplication d'un SAR contemporain par `splm`.** |

Dans Seshat, la réponse de l'application étudiée est **Info** (sophistication des systèmes d'information), et non `PolityPopulation` comme le laisse croire la formule sommaire actuelle de la fiche. Le terme géographique utilise les valeurs des autres sociétés à la période précédente, pondérées par une décroissance exponentielle de la distance ; le pas est le siècle. Cette lecture justifie une future correction ciblée de la fiche après contrôle des colonnes réellement présentes : la fiche annonce 307 lignes et T = 1, alors que le texte discute notamment 902 observations interpolées. On ne peut donc pas annoncer que son RDS reproduit déjà l'application dynamique. Aucun changement de formule ou de statut de cette fiche n'est effectué par ce recensement.

### Cas qui gonfleraient artificiellement le nombre de panels

| Fiche / article | Conclusion du contrôle |
|---|---|
| [Regulatory Convergence](../datasets/fiches_datasets/paper_regulatory_convergence.md), DOI 10.1093/isq/sqz068 ; et sa [coupe 2008](../datasets/fiches_datasets/paper_regulatory_convergence_2008.md) | Le texte, section Research Design, annonce deux **coupes distinctes en 2008 et 2013**. Les 18 années du fichier parent ne transforment pas cette application en estimation panel. Les variantes spatiales ne suffisent pas à changer ce constat. |
| [Bias from Network Misspecification Under Spatial Dependence](../datasets/fiches_datasets/paper_network_misspecification_elections.md), DOI 10.1017/pan.2020.26 | Le code original `PAN-archive/code/examples.R` ajuste `lm(votelead ~ gr_an + coalsize + enep + pop + elecyr)` puis ajoute `gr_glob_tr_an`. C'est une application avec covariable spatiale de type SLX, pas une estimation SAR/SEM de panel dans cet exemple. Ne pas attribuer aux données électorales les modèles des simulations séparées. |
| [The Wald Test of Common Factors in Spatial Model Specification Search Strategies](../datasets/fiches_datasets/paper_wald_test.md), DOI 10.1017/pan.2020.23 | SDM et test de restrictions communes ; texte méthodologique orienté vers les dépendances transversales. Les répétitions pays/élections et la W politique ne suffisent pas à démontrer un estimateur panel à effets fixes/aléatoires. À garder pour les diagnostics de spécification, hors noyau panel confirmé. |
| [Regional distribution of photovoltaic deployment in the UK and its determinants](../datasets/fiches_datasets/paper_uk_photovoltaic.md) | Le texte après l'équation (4) indique explicitement une **coupe 2011**. « Solar panel » signifie aussi panneau solaire, faux positif lexical évident. |
| [Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors](../datasets/fiches_datasets/paper_midwest_crop_yield.md), DOI 10.1080/01621459.2022.2123333 | PDF pages 4 et 9 : coefficients spatialement variables et prédicteurs fonctionnels ; années traitées comme réplications conditionnellement indépendantes. Modèle spatial sur observations répétées, mais pas le panel SAR/SEM de Yun–Gramig. **Ce sont deux papiers différents.** |
| [GWQLasso MT](../datasets/fiches_datasets/paper_gwqlasso_mt.md), PR, RS et fiches annuelles ; [housing Corée](../datasets/fiches_datasets/paper_korea_hedonic_housing.md) et fiches annuelles | Une mention générique d'utilisation future du panel complet n'est pas une preuve de méthode publiée. Les fiches décrivent respectivement une régression quantile géographiquement pondérée et un descripteur de données hédoniques. Pas d'application panel SAR/SEM/SDM établie par ces fiches. |
| [Airbnb Europe](../datasets/fiches_datasets/paper_airbnb_europe_prices.md), [Portugal COVID](../datasets/fiches_datasets/paper_portugal_covid_municipal.md) | Les fiches décrivent des analyses séparées : weekday/weekend pour Airbnb ; modèles par quinzaine pour COVID. Ne pas les compter comme panel spatial sur la seule présence de plusieurs périodes. Niveau de preuve ici : fiche, sans nouvelle lecture intégrale des deux articles. |

### Modèles spatio-temporels connexes à conserver dans la revue élargie

Leur intérêt est réel pour de futurs estimateurs, mais leur classement précis demande une lecture complémentaire. Ces indications proviennent des fiches, sans nouvelle validation complète de chaque papier :

- [Gulf of Alaska / Exxon Valdez](../datasets/fiches_datasets/paper_goa_trawl_demersal.md) : GLMM à deux composantes et effets spatio-temporels AR(1).
- [Kodiak puffins](../datasets/fiches_datasets/paper_kodiak_puffin_density.md) : modèle VAST et champs spatio-temporels.
- [Groundfish CPUE](../datasets/fiches_datasets/paper_groundfish_cpue.md) : moyenne de modèles spatio-temporels.
- [STWR précipitations/isotopes](../datasets/fiches_datasets/paper_stwr_precip_isotope.md) : régression locale pondérée dans l'espace et le temps.
- [Chaleur Suisse](../datasets/fiches_datasets/paper_swiss_heat_exposure.md), [leptospirose Colombie](../datasets/fiches_datasets/paper_colombia_leptospirosis_risk.md) : modèles hiérarchiques bayésiens spatio-temporels signalés.
- [Crane](../datasets/fiches_datasets/paper_crane.md), [Houston LST](../datasets/fiches_datasets/paper_houston_lst_landcover.md), [song sparrow](../datasets/fiches_datasets/paper_song_sparrow_breeding_date.md), [mistletoe](../datasets/fiches_datasets/paper_mistletoe_bird_abundance.md) : autres structures spatiales/temporelles à préciser.

Ces dix fiches ne sont pas dix applications confirmées de panel spatial économétrique. Les sources R/Python et l'entrepôt TED ont également été criblés ; aucune preuve positive supplémentaire de cette méthode n'a été établie dans leurs fiches.

### Applications déjà présentes dans le corpus, sans fiche dataset correspondante

| Article | Vérification dans le texte local | Travail à prévoir |
|---|---|---|
| Yun et Gramig, *Spatial Panel Models of Crop Yield Response to Weather: Econometric Specification Strategies and Prediction Performance*, [DOI 10.1017/aae.2021.29](https://doi.org/10.1017/aae.2021.29), publication en volume 2022, mise en ligne 2021 | 14 spécifications de panel ; comparaison de modèles non spatiaux et spatiaux, effets fixes/aléatoires et erreur spatiale ; prédiction hors échantillon. Panel d'estimation de 1 042 comtés sur 1981–2012, prévision 2013–2018. [Fiche papier existante](../papers/yun_gramig_2021_spatial_panel_crop_yield.md) ; PDF et TEI disponibles. | **Priorité élevée pour le benchmark prédictif**. Examiner les données/code du dépôt signalé dans le papier, puis créer une fiche dataset fidèle après vérification. Ne pas réutiliser `paper_midwest_crop_yield` comme identité de ce jeu. |
| De Siano et Chiariello, *Women's political empowerment and welfare policy decisions: a spatial analysis of European countries*, [DOI 10.1080/17421772.2021.1905173](https://doi.org/10.1080/17421772.2021.1905173), PDF publié en ligne en 2021 | 17 pays européens, 1991–2015 ; modèle spatial de panel avec effets fixes pays, termes Wy et WX, maximum de vraisemblance et correction Lee–Yu. PDF pages 13–14, équation (3). Plusieurs définitions de proximité. PDF et TEI locaux. | **Bon complément SDM et choix de W**. Retrouver les suppléments et les données exactes avant de créer une fiche dataset. La présence du PDF ne prouve pas celle d'un artefact de données prêt. |

Ces deux articles sont comptés comme compléments du corpus, **pas comme deux fiches datasets déjà disponibles**. Les correspondances automatiques du KG restent des pistes : par exemple le rapprochement Yun–Gramig avec `Insurance` est déjà signalé comme bruit dans sa fiche papier.

### Articles empiriques externes proposés pour enrichir la banque

La liste proposée par l'utilisateur a été contrôlée sur les notices éditeur, les résumés bibliographiques et, lorsque disponible, le texte intégral. Tous les articles ci-dessous appliquent bien une méthode de panel spatial. Ils ne sont cependant pas tous également utiles pour la banque : l'existence du papier ne garantit ni des données ouvertes, ni la matrice `W`, ni le code de réplication.

| Priorité | Article vérifié | Structure et méthode | Apport au projet | Données / prochaine vérification |
|---|---|---|---|---|
| P1 | Baylis, Paulson et Piras (2011), *Spatial Approaches to Panel Data in Agricultural Economics: A Climate Change Application*, [DOI 10.1017/S1074070800004326](https://doi.org/10.1017/S1074070800004326) | Valeurs foncières agricoles ; modèles non spatiaux, spatial lag et spatial error, avec effets fixes et aléatoires. | Meilleur petit cas comparatif pour vérifier que le harnais distingue FE/RE, SAR/SEM et panel non spatial sur les mêmes données. | Texte intégral ouvert identifié. Rechercher le fichier de données, les unités, les années, `W` et le code avant création d'une fiche. |
| P1 | Yun et Gramig (2022), *Spatial Panel Models of Crop Yield Response to Weather*, [DOI 10.1017/aae.2021.29](https://doi.org/10.1017/aae.2021.29) | 1 042 comtés, panel équilibré d'estimation 1981–2012, prévisions 2013–2018 ; 14 spécifications, FE/RE et dépendance spatiale. | Cas central pour la prédiction, les découpages temporels et la comparaison de modèles. | PDF/TEI et fiche papier déjà présents ; dépôt de code signalé. Auditer maintenant les fichiers du dépôt et leur licence. |
| P1 | Pu, Zhao, Kong, Zhao et Chi (2019), *A spatial dynamic panel approach to modelling the space-time dynamics of interprovincial migration flows in China*, [DOI 10.4054/DemRes.2019.41.31](https://doi.org/10.4054/DemRes.2019.41.31) | Flux dyadiques interprovinciaux, 1985–2015 ; panel spatial dynamique, effets d'origine, de destination et de débordement, décomposés à court et long terme. | Ajoute une structure de **flux**, absente des cas CO₂ et rendements ; bon test pour des poids origine–destination et l'interprétation dynamique. | Texte intégral ouvert. Le matériel de réplication annoncé doit être testé : format des flux, identifiants, matrices et licence. |
| P1 | Parent et LeSage (2010), *A spatial dynamic panel model with random effects applied to commuting times*, [DOI 10.1016/j.trb.2010.01.004](https://doi.org/10.1016/j.trb.2010.01.004) | Filtre espace–temps, effets aléatoires ; application à la demande de transport induite et aux effets de capacité routière sur les temps de trajet présents et futurs. | Cas de référence pour `y_t`, `Wy_t`, `y_{t-1}` et les propagations futures ; utile après la route statique. | Article vérifié, mais accès aux données/code non établi. Chercher d'abord une version de travail et les compléments auteurs. |
| P1 | Bouayad-Agha et Védrine (2010), *Estimation Strategies for a Spatial Dynamic Panel using GMM: A New Approach to the Convergence Issue of European Regions*, [DOI 10.1080/17421771003730711](https://doi.org/10.1080/17421771003730711) | Croissance régionale européenne sur 25 ans ; deux stratégies GMM, extension d'Arellano–Bond à un panel spatial autorégressif et dépendance spatiale des erreurs. | Introduit une famille d'estimation GMM et les instruments, indispensable pour ne pas réduire le panel dynamique au maximum de vraisemblance. | Notice et résumé vérifiés ; texte éditeur restreint. Données, découpage régional, `W` et code restent à retrouver. |
| P1 | Baltagi et Bresson (2011), *Maximum Likelihood Estimation and Lagrange Multiplier Tests for Panel Seemingly Unrelated Regressions with Spatial Lag and Spatial Errors: An Application to Hedonic Housing Prices in Paris*, [DOI 10.1016/j.jue.2010.08.007](https://doi.org/10.1016/j.jue.2010.08.007) | 80 quartiers, 1990–2003 ; système de trois équations SUR pour trois types d'appartements, lag et erreurs spatiales, effets aléatoires et tests LM. | Excellent cas avancé pour modèles multivariés et diagnostics, mais trop complexe comme premier test du harnais. | Version de travail ouverte identifiée ; vérifier si les transactions agrégées, `W` et programmes d'estimation sont distribués. |
| P2 | Parent et LeSage (2012), *Spatial dynamic panel data models with random effects*, [DOI 10.1016/j.regsciurbeco.2012.04.008](https://doi.org/10.1016/j.regsciurbeco.2012.04.008) | Modèle de Solow, 48 États américains, 1973–1997 ; effets aléatoires avec `y_{t-1}`, `Wy_t` et `Wy_{t-1}` ; traitement explicite des observations initiales. | Très utile pour la dynamique et l'initialisation ; en partie redondant avec Parent–LeSage 2010 pour la couverture méthodologique. | Vérifier si le jeu de croissance et la matrice sont fournis avec l'article ou dans le code de LeSage. |
| P2 | Zhao, Burnett et Lacombe (2015), *Province-level convergence of China's carbon dioxide emissions*, [DOI 10.1016/j.apenergy.2015.04.015](https://doi.org/10.1016/j.apenergy.2015.04.015) | 30 provinces, 1990–2010 ; convergence au moyen d'un panel spatial dynamique. | Bon contrôle externe du cas CO₂ actuel, surtout pour comparer convergence et déterminants d'émissions. | Données reconstruites depuis les annuaires statistiques selon l'article ; disponibilité d'un fichier et de `W` non établie. |
| P2 | Antunes, Viegas, Varum et Pinho (2020), *The Impact of Structural Funds on Regional Growth: A Panel Data Spatial Analysis*, [DOI 10.1007/s10272-020-0921-1](https://doi.org/10.1007/s10272-020-0921-1) | 96 régions de l'UE, 1995–2009 ; modèle de Durbin sur panel avec effets régionaux et temporels, `Wy` et `WX`. | Cas SDM lisible, avec une formule publiée et des effets de voisinage ; complément naturel à De Siano–Chiariello. | Article intégral accessible sur le site de la revue. Vérifier la granularité régionale, les changements de nomenclature, les sources Eurostat et `W`. |
| P2 | Zhou et al. (2019), *A spatial panel analysis of carbon emissions, economic growth and high-technology industry in China*, [DOI 10.1016/j.strueco.2018.09.010](https://doi.org/10.1016/j.strueco.2018.09.010) | 30 provinces, 2004–2016 ; modèle STIRPAT–Durbin de panel, contiguïté de type Queen, effets directs et débordements. | Spécification SDM claire, mais forte proximité avec le cas CO₂ déjà présent. | À rechercher seulement après les domaines sous-représentés ; vérifier si les données et `W` sont redistribuables. |
| P2 | Chen, Shao, Fan, Tian et Yang (2022), *One man's loss is another's gain: Does clean energy development reduce CO₂ emissions in China? Evidence based on the spatial Durbin model*, [DOI 10.1016/j.eneco.2022.105852](https://doi.org/10.1016/j.eneco.2022.105852) | Application provinciale chinoise d'un SDM ; effets directs et indirects de l'énergie propre. | Utile pour l'interprétation des impacts, mais faible gain de diversité par rapport aux autres panels chinois de carbone. | Titre et DOI corrigés et vérifiés ; N, T, spécification des effets et disponibilité des données doivent encore être lus dans le papier. |
| P2 | Kang et al. (2016), *Environmental Kuznets curve for CO₂ emissions in China: A spatial panel data approach*, [DOI 10.1016/j.ecolind.2015.12.011](https://doi.org/10.1016/j.ecolind.2015.12.011) | Provinces chinoises, 1997–2012 ; comparaison panel non spatial / panel spatial et courbe de Kuznets. | Cas simple pour contrôler les transformations non linéaires et les effets de débordement. | Papier vérifié au niveau éditeur ; retrouver les données, les termes exacts de l'EKC et `W`. |
| P2 | Xu, Zhao, Li et Guo (2022), *Spatial Effect Analysis of Health Expenditure and Health Output in China From 2011 to 2018*, [DOI 10.3389/fpubh.2022.794177](https://doi.org/10.3389/fpubh.2022.794177) | 31 provinces, 2011–2018 ; SDM de panel pour les dépenses et résultats de santé. | Diversifie le domaine vers la santé ; texte intégral ouvert et structure relativement courte. | Vérifier les variables de résultat, les tables sources et la possibilité de reconstruire le panel avant téléchargement durable. |
| P2 | Egger, Pfaffermayr et Winner (2005), *An Unbalanced Spatial Panel Data Approach to US State Tax Competition*, [DOI 10.1016/j.econlet.2005.03.002](https://doi.org/10.1016/j.econlet.2005.03.002) | États américains, 1975–1999 ; panel spatial non équilibré sur la concurrence fiscale. | Cas important pour tester index incomplets, sous-panels et réindexation de `W`. | Référence bibliographique vérifiée ; vérifier dans le texte le modèle exact et l'accès aux données avant de l'ériger en cas de réplication. |
| P2 | Long, Shao et Chen (2016), *Spatial econometric analysis of China's province-level industrial carbon productivity and its influencing factors*, [DOI 10.1016/j.apenergy.2015.09.100](https://doi.org/10.1016/j.apenergy.2015.09.100) | 30 provinces, 2005–2012 ; modèles spatiaux de panel pour la productivité carbone industrielle. | Exemple valide, mais apporte peu de diversité après Li, Zhou, Zhao et Kang. | À conserver en réserve ; données/code et forme exacte du modèle restent à vérifier. |

#### Ce que cette proposition change dans les priorités

La priorité ne doit pas être fondée uniquement sur la sophistication économétrique. Pour une banque de benchmarks, un papier est prioritaire s'il combine : (1) données réellement accessibles, (2) identifiants unité–temps stables, (3) `W` fournie ou reconstruisible, (4) formule et transformations explicites, (5) code ou résultats numériques de référence, et (6) apport méthodologique distinct des jeux déjà admis.

Sur cette base, la sélection initiale de six papiers est resserrée ainsi :

1. **Yun–Gramig**, parce que PDF, TEI et piste de code sont déjà locaux et que l'article traite directement la prédiction.
2. **Baylis–Paulson–Piras**, comme cas statique comparatif FE/RE × SAR/SEM.
3. **Pu et al.**, pour les flux et la dynamique, sous réserve que le matériel de réplication soit effectivement complet.
4. **Parent–LeSage (2010)**, comme référence dynamique avec effets aléatoires, même si les données restent à localiser.
5. **Bouayad-Agha–Védrine**, pour GMM et l'instrumentation.
6. **Baltagi–Bresson**, comme cas avancé SUR spatial, à aborder après les modèles univariés.

Les nombreux articles « provinces chinoises × CO₂ × SDM » forment un **lot de comparaison**, pas six priorités indépendantes. Après le jeu CO₂ déjà présent, un seul cas supplémentaire devrait être intégré d'abord : Zhao–Burnett–Lacombe si la dynamique est prioritaire, ou Zhou et al. si le SDM et les effets directs/indirects sont prioritaires. Le papier de santé de Xu et al. est plus intéressant pour diversifier les réponses et les domaines.

### Ordre de travail issu de ce recensement

1. Lire ensemble les spécifications de **Li–Fang–He et Yun–Gramig** : le premier fixe le cas d'usage CO₂ ; le second fournit une comparaison prédictive de plusieurs modèles de panel.
2. Lire **Elhorst, Lee–Yu, Baltagi–Song–Koh et Millo–Piras** pour documenter les estimateurs et les tests nécessaires, selon la bibliographie ci-dessus.
3. Ajouter **De Siano–Chiariello** pour le SDM, la correction des effets fixes et la sensibilité à W.
4. Auditer **Seshat** comme cas dynamique distinct, en commençant par la réponse Info, les identifiants NGA–siècle, l'interpolation et les retards. Ne pas promettre une réplication sur le RDS actuel.
5. Étendre ensuite la lecture aux modèles spatio-temporels connexes si ces familles entrent dans le périmètre futur du harnais.

Le recensement ne modifie aucun statut dataset, aucune formule active et aucune admissibilité de benchmark. Il prépare les lectures et vérifications de provenance nécessaires à une implémentation ultérieure.

## Related Pages

- [[paper_li_energy_price_co2_china]]
- [[plan_implementation_panel_spatial_2026-09-09]]
- [[revue_fidelite_quatre_datasets_2026-09-09]]
