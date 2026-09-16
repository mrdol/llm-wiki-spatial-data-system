---
title: Revue de fidélité de quatre fiches datasets aux publications
type: analysis
created: 2026-09-09
updated: 2026-09-09
sources:
  - wiki/datasets/fiches_datasets/paper_sfbay_contaminated_sites.md
  - wiki/datasets/fiches_datasets/paper_harbour_porpoise_response.md
  - wiki/datasets/fiches_datasets/paper_li_energy_price_co2_china.md
  - wiki/datasets/fiches_datasets/paper_no2_aqs_ma_2016_monitor_covariates.md
  - data/manifests/datasets/review_2026-09-09/final_data_counts.json
  - data/manifests/datasets/review_2026-09-09/harbour_replication.json
tags: [datasets, provenance, formulas, spatial-panel]
---

# Revue de fidélité aux publications

Les quatre fiches citées dans la demande ont été contrôlées contre les PDF, les données et le code disponible. La discussion fournie constitue une liste de questions, pas une source scientifique. Les blocs existants des fiches sont conservés ; les formules inventées ne sont pas remplacées par de nouvelles équations conjecturales.

## Résultats et décompte des variables

Ici, **k compte les attributs hors colonnes géométriques**, coordonnées et identifiants compris. Le nombre de covariables d'un modèle est indiqué séparément. Les interactions, effets aléatoires et coefficients ne sont pas des colonnes du RDS.

| Fiche | RDS avant → après | Colonnes après / géométries | k après | X du modèle publié |
|---|---:|---:|---:|---|
| [[paper_sfbay_contaminated_sites]] | 802 → 5 297 lignes | 81 / 2 | 79 | Sans objet : pas de régression sur le statut des sites |
| [[paper_harbour_porpoise_response]] | 700 → 722 lignes | 32 / 2 | 30 | 3, 3 et 4 variables selon le modèle, avant interaction |
| [[paper_li_energy_price_co2_china]] | 450 → 450 lignes | 18 / 1 | 17 | 9, toutes en logarithme |
| [[paper_no2_aqs_ma_2016_monitor_covariates]] | 10 → 10 lignes | 32 / 1 | 31 | Matrice d'apprentissage originale absente |

L'ancien RDS San Francisco avait déjà 17 colonnes dont deux géométries (k=15), et non k=13. Son nouveau k=79 provient de la conservation des 75 attributs source, plus quatre attributs de conversion/provenance. CO₂ : k=15 était également périmé ; les 17 attributs actuels comprennent neuf X, CO₂, cinq champs de panel/identification et deux coordonnées. Pour le marsouin et NO₂, les valeurs k=30 et k=31 étaient correctes comme nombres d'attributs, mais pas comme nombres de prédicteurs.

Les comptages et noms sont conservés dans [final_data_counts.json](../../data/manifests/datasets/review_2026-09-09/final_data_counts.json).

## San Francisco : erreur de loader et attribution de formule

Les couches Dryad contiennent 3 817 lignes fermées et 1 480 ouvertes. L'ancien loader supprimait les répétitions de `FID_DTSC_S`. Or ce champ vaut zéro pour 3 596 lignes fermées et 900 ouvertes : ce n'est pas un identifiant global de site. L'algorithme ramenait donc 4 496 lignes à une seule, donnant 802 lignes au total. Cela ne correspondait pas à une sélection scientifique du papier.

Le loader conserve désormais toutes les lignes, leurs attributs et leur géométrie ponctuelle native, convertie d'EPSG:3717 vers EPSG:4326. Les 5 297 géométries finales sont distinctes. Le RDS antérieur est sauvegardé dans `data/interim/dataset_review_2026-09-09/`, et les sources brutes n'ont pas été modifiées.

Le [papier de Hill et al.](https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2023EF003825) et le README décrivent une analyse SIG d'exposition et une association de Kendall avec la vulnérabilité sociale. Ils ne publient pas `is_open_case ~ gridcode`. La reclassification de la remontée de nappe au seuil de 0,1016 m est documentée ; elle ne justifie pas une régression sur le statut ouvert/fermé. Les couches portent sur des sites déjà exposés à la remontée de nappe ou à l'inondation : interpréter tout `gridcode=0` comme « non exposé » serait injustifié.

La formule publiée est donc `not_applicable`, la formule système active est `pending`, et les estimateurs automatiques précédemment attribués au papier sont retirés. Les données restent dans la banque. La référence est corrigée en **Hirschfeld**, et l'année 2023 est renseignée.

## Marsouin : les trois modèles exacts du tableau 1

La page 7 du [PDF publié](../../corpus/papers/raw_pdf/Graham_2019_Harbour_porpoise_responses.pdf), récupéré depuis le [dépôt universitaire UEA](https://ueaeprints.uea.ac.uk/id/eprint/84311/1/rsos.190335.pdf), présente deux modèles à 24 h et un modèle à 12 h. Tous sont des GLMM binomiaux à lien probit avec intercept aléatoire pour le couple site–CPOD.

| Tableau / code auteur | Réponse et variables fixes | Lignes après filtres | AIC réexécuté |
|---|---|---:|---:|
| (a), m8_24 | réponse 24 h ; log(distance) × ordre + navires à 1 km | 654 | 619.3854 |
| (b), m14nz_24 | réponse 24 h ; exposition pondérée audiogramme × ordre + navires à 1 km | 654 | 620.9744 |
| (c), m7_12 | réponse 12 h ; log(distance) × ordre + ADD + navires à 500 m | 623 | 653.3871 |

Les AIC retrouvent exactement les arrondis du tableau : 619.4, 621.0 et 653.4. L'ancien texte confondait la troisième ligne du tableau avec un autre modèle acoustique à 24 h. Il attribuait aussi l'AIC 619.39 aux 700 lignes du jeu à 18 lieux ; le code auteur indique au contraire un autre AIC pour cette variante.

La table source contient 722 lignes. Le filtre global `is.finite(prop24)` supprimait des données nécessaires au modèle à 12 h : l'analyse à 12 h sur l'ancien RDS ne gardait que 616 lignes au lieu de 623. Ce filtre a été retiré du loader. Les filtres et standardisations sont désormais propres à chaque modèle, comme dans le code auteur. `ADD` est bien une covariable du modèle (c), et non un identifiant.

Preuve numérique : [harbour_replication.json](../../data/manifests/datasets/review_2026-09-09/harbour_replication.json), qui conserve formules, coefficients, N et AIC. La réplication utilise `lme4`, hors du harnais. Un SAR-probit ou SEM-probit n'est pas une approximation automatiquement justifiée de cet effet aléatoire ; aucune telle équivalence n'est conservée.

## CO₂ : logarithmes, panel et limites de réplication

Les équations (3)–(6) ont été contrôlées visuellement dans le [PDF local](../../corpus/papers/raw_pdf/The%20impact%20of%20energy%20price%20on%20CO2%20emissions%20in%20China%20-%20A%20spatial%20econometric%20analysis.pdf), pages 11 et 15–16. La composante de régression est :

```r
log(CO2) ~ log(POP) + log(PGDP) + log(INS) + log(URB) +
  log(RFDI) + log(TEC) + log(EDU) + log(ENS) + log(EP)
```

Les dix variables sont présentes, finies et strictement positives sur les 450 lignes. Cette formule remplace la version sans logarithmes ; elle ne dispense pas des effets fixes ni de la structure spatiale de l'estimateur. Le modèle principal retenu dans la section 3.1 est le spatial lag à effets fixes provinciaux ; SEM et SAC sont comparatifs, la dynamique est une robustesse. W principale est une contiguïté binaire normalisée par ligne ; les robustesses utilisent notamment k voisins avec k=3,4,5,6. Ce k de voisinage est distinct du nombre d'attributs dans la fiche.

Le troisième auteur est **Lerong He**, donc He, L. Le titre exact du [dépôt Mendeley](https://data.mendeley.com/datasets/hm29shxmfc/1) est restauré. Le fichier contient 30 provinces × 15 années 2002–2016. Le PDF local est une prépublication éditeur qui annonce aussi 2001–2016 et 480 observations en section 2.2 : cette incohérence reste explicitement signalée. Nous n'avons pas fabriqué les lignes 2001 ni confirmé une correspondance complète avec l'échantillon final.

Les noms de provinces et la géométrie proviennent d'une reconstruction du projet. La provenance géographique précise et l'identité de W avec celle des auteurs restent à vérifier avant une réplication. Le statut **ready_in_data_bank** signifie conservation dans la banque ; `package_include: no` et `benchmark_ready: false` empêchent une admission automatique comme benchmark de panel.

## NO₂ : origine exacte de la divergence et capacité du package

Le [PDF de Di et al.](../../corpus/papers/raw_pdf/Assessing%20NO2%20Concentration%20and%20Model%20Uncertainty%20with%20High%20spatiotemporal%20resolution%20accross%20the%20contiguous%20united%20states.pdf), sections 2.1 et 3.2–3.4, décrit des observations station–jour sur 2000–2016, 912 stations, et le maximum quotidien sur une heure. L'apprentissage transforme NO₂ en logarithme et standardise X. L'équation du GAM d'ensemble est présente page 1375 (page PDF 4), contrairement à l'ancienne mention « aucune formule trouvée ».

Le builder local `tools/build_air_quality_monitor_covariates.R` privilégie `Arithmetic Mean` avant `1st Max Value`, puis agrège par station avec une moyenne annuelle. Les dix lignes du RDS portent effectivement `measurement_column = Arithmetic Mean`. La divergence n'est donc pas seulement une question de choix de covariables : la réponse et l'unité d'observation changent.

Le dépôt Dataverse est un produit de prédiction sur grille, pas la matrice d'apprentissage. La table Massachusetts est une reconstruction locale partielle ; il n'est pas possible de transformer ses dix moyennes annuelles en les observations originales quotidiennes ni de retrouver les covariables manquantes par simple renommage. L'ancienne formule à cinq X est retirée des champs actifs, et le RDS reste conservé comme dérivé documenté.

| Composante | Code actuel du package | Conclusion |
|---|---|---|
| Random Forest | route `random_forest`, ranger/parsnip | disponible séparément |
| Gradient boosting | route `xgboost` | disponible séparément ; identité du moteur avec l'article non démontrée |
| GAM spatial | `mgcv::gam`, ajout de s(x,y) | disponible séparément ; différent du GAM d'ensemble |
| Réseau neuronal | aucune route native trouvée dans le registre | à intégrer si réplication demandée |
| Ensemble NN + RF + GB puis splines sur localisation et prédictions | aucune orchestration équivalente trouvée | à implémenter et valider |

RF, XGBoost et GAM spatial restent seulement conditionnels à une future tâche reconstruite et documentée. Sur la table actuelle de dix stations, ils ne sont pas déclarés benchmarkables par simple disponibilité logicielle. La reconstitution complète n'a pas été lancée dans cette revue.

## Reproductibilité et garde contre la régression des fiches

- Deux loaders corrigés ; seules les deux sorties RDS concernées ont été reconstruites.
- Quatre fiches corrigées avec leurs blocs existants ; les sections relues sont enregistrées dans `dataset_curation_overrides.json` et appliquées après les anciennes règles.
- L'export des métadonnées conserve la formule transformée mais distingue les noms de colonnes source : CO2 ne devient pas une fausse colonne nommée log(CO2).
- Les quatre notices sont synchronisées dans le registre du package ; les autres changements de travail existants sont préservés.
- Huit tests Python passent ; contrôles R des effectifs, logarithmes, géométries et trois réplications GLMM réalisés. Aucun benchmark comparatif général n'a été lancé.

La suite sur les panels est détaillée dans [[revue_panel_spatial_2026-09-09]].

## Related Pages

- [[paper_sfbay_contaminated_sites]]
- [[paper_harbour_porpoise_response]]
- [[paper_li_energy_price_co2_china]]
- [[paper_no2_aqs_ma_2016_monitor_covariates]]
- [[revue_panel_spatial_2026-09-09]]
