# Revue — données semi-synthétiques / DGP pour Monte Carlo

Mise à jour bibliographique du 14 septembre 2026 : [lecture approfondie, processus d'observation et complément géostatistique](lecture_approfondie_et_geostatistique_2026-09-14.md). Le [HTML principal](revue_donnees_semi_synthetiques.html) intègre désormais les neuf articles complémentaires et les résultats consolidés du pilote Georgia/Meuse.

Étape suivante préparée : [spécification des scénarios d'observation et de simulation géostatistique](specification_scenarios_observation_geostatistique_2026-09-14.md).

**Statut : revue consolidée le 14 septembre après intégration des neuf articles complémentaires, lecture intégrale de RealCause, approfondissement de Gelfand–Schliep, Gotway–Young et Tiedeman–Green, et complément géostatistique.**


## Programme actif — décision du 8 septembre 2026

**Plasmode exclusivement.** La cartographie du 7 septembre ci-dessous reste
un historique bibliographique. EMCS placebo, GAN et morphing ne sont plus
des branches de développement actives.

- [Protocole](../../wiki/analyses/protocole_plasmode_spatial_2026-09-08.md).
- [Pilote R](plasmode_pilot.R) et [tests](test_plasmode_pilot.R).
- [Rapport du pilote](pilot_output_2026-09-08/rapport_pilote.html).
- Sorties natives RDS, miroir JSON, vérités, W, folds, graines et sessionInfo.

Le pilote exécuté compare sept scénarios sur Georgia et Meuse. Il est autonome :
ni intégration au dashboard, ni modification des admissions, ni étude complète
D0–D9. La synthèse originale de l'encadrant reste intacte.

## Contenu

- [`revue_donnees_semi_synthetiques.html`](revue_donnees_semi_synthetiques.html) — le document complet (source de l'artefact publié), avec une section « Convergence » (comparaison SpaCE/synthèse encadrant) et une section « Lecture complète » (corrections après lecture intégrale).
- [`synthese_encadrant_2026-09.md`](synthese_encadrant_2026-09.md) — copie de la synthèse transmise par l'encadrant, taxonomie F1–F7 + protocole de benchmark spatial D0–D9.
- [`ICLR-2024-space-the-spatial-confounding-environment.pdf`](ICLR-2024-space-the-spatial-confounding-environment.pdf) — *SpaCE* (Tec et al., ICLR 2024).
- [`papiers_lus/`](papiers_lus/) — les 5 papiers phares lus intégralement le 7 sept. : Huber, Lechner & Wunsch (2013), Schreck et al. (2024), Advani, Kitagawa & Słoczyński (2019), Knaus, Lechner & Strittmatter (2018), Neal et al. — RealCause (2020, résumé approfondi, pas encore lu ligne à ligne).
- `revue_donnees_semi_synthetiques.bib` — à ajouter : généré via biblio from pdf à partir des PDF ci-dessus.

## Résumé

Cartographie de 8 familles de méthodes pour construire un DGP à partir d'un vrai (Y, X), du plus paramétrique au plus génératif.

## Correction importante du 7 sept. (après lecture intégrale)

Le 1ᵉʳ passage traitait **EMCS et plasmode comme un seul mécanisme** (« famille C »). Ce n'est pas exact — ce sont deux mécanismes distincts :

- **Plasmode** (Schreck et al. 2024 ; Franklin et al. 2014) : X rééchantillonné du réel, **Y régénéré** par un modèle générateur (OGM) ajusté sur les vraies données (ex. LASSO fitté sur le vrai Y, dont les prédictions deviennent la nouvelle vérité). Le terme lui-même vient de Cattell & Jaspers (1967), pas de Franklin et al. qui l'a seulement popularisé pour la pharmaco-épidémiologie.
- **EMCS « placebo »** (Huber, Lechner & Wunsch 2013) : X **et** Y restent 100&nbsp;% réels, rééchantillonnés tels quels — seule l'étiquette de traitement est fabriquée via une équation de sélection réaliste. L'effet vrai est zéro par construction, sans qu'aucun modèle n'ait dû être ajusté pour générer Y.
- **EMCS « placebo », version hétérogène** (Knaus, Lechner & Strittmatter 2018) : même principe, mais un effet **fixé à la main** (une fonction sinus de la probabilité de traitement, pas ajustée par ML) est ajouté au-dessus du vrai Y⁰.
- **EMCS « structuré »** (Busso et al. 2014, décrit dans Advani et al. 2019) : troisième variante, absente du 1ᵉʳ passage — X et Y tirés de lois paramétriques dont les paramètres sont calés sur le réel (ex. revenu ~ log-normale estimée), plus synthétique qu'un plasmode mais plus réaliste qu'un DGP purement inventé.

**La critique d'Advani et al. (2019) est plus sévère qu'on ne l'avait rapporté** : testée sur de vraies données (NSW) où la performance des estimateurs est connue, elle montre que les deux designs EMCS choisissent le meilleur estimateur **moins souvent qu'un tirage au hasard** sur le critère du biais absolu, et jamais mieux qu'un simple bootstrap sur le MSE.

**Autres apports de la lecture complète** : la distinction plasmode biologique (vrai labo) vs statistique (rééchantillonnage + OGM) ; le protocole en 9 étapes de Schreck et al. basé sur les critères ADEMP ; et surtout que le nombre de réplications N et la taille de rééchantillonnage m ne doivent pas être choisis arbitrairement — Schreck et al. recommandent de vérifier la convergence des mesures de performance en N et d'utiliser l'algorithme de Bickel & Sakov pour choisir m.

## Recommandations historiques du 7 septembre (remplacées ci-dessus)

- Socle v2 : grille D0–D9 de l'encadrant + calibration SNR/part spatiale/portée.
- Résidus : bootstrap empirique ou GMRF façon SpaCE en premier ; `engression`/`drf`/Forest-Flow en extension ; GAN en dernier recours.
- Validation : comparaison d'histogrammes/densités (Schreck et al.) au minimum, classifier two-sample test/pMSE + Moran's I/variogramme en plus complet.
- N et m : ne jamais les fixer arbitrairement — vérifier la convergence des mesures de performance en N, choisir m via un algorithme adaptatif.
- Garde-fou explicite dans le dashboard : le mode Monte Carlo est un outil de test relatif entre estimateurs sur un DGP donné, jamais une preuve de supériorité générale — les EMCS publiés font pire que le hasard sur ce point précis.

## Pistes bibliographiques historiques à reprioriser

- [ ] Lecture complète de LeSage & Pace (2018) — non trouvé en accès libre, à obtenir via bibliothèque universitaire.
- [ ] Lecture ligne à ligne de RealCause (Neal et al. 2020) — pour l'instant seulement un résumé approfondi.
- [ ] Générer `revue_donnees_semi_synthetiques.bib` via biblio from pdf à partir des PDF dans `papiers_lus/` et `ICLR-2024-space-the-spatial-confounding-environment.pdf`.
- [ ] Mail à « Flash » pour suggestions complémentaires (toujours pas envoyé).
- [ ] Recherche ciblée sur la géostatistique pure (krigeage + simulation conditionnelle), non creusée.
- [ ] Discussion avec l'encadrant : trancher sur le socle technique v2 et sur la portée exacte du data paper vis-à-vis de SpaCE, en tenant compte de la distinction EMCS/plasmode maintenant clarifiée.


## Collecte complémentaire du 9 septembre 2026

- [Articles retenus, PDF disponibles et téléchargements manuels](articles_complementaires_2026-09-09/README.md).
- 6 nouveaux PDF disponibles sur 9 articles sélectionnés. Les lectures approfondies et la génération du `.bib` avec `Biblio_from_pdf` sont à venir.

## Bibliographie vérifiée — 9 septembre 2026

[revue_donnees_semi_synthetiques.bib](revue_donnees_semi_synthetiques.bib) : **20 références**, produites avec Biblio_from_pdf après contrôle des premières pages et correction des métadonnées. Les liens BibDesk pointent vers les PDF conservés dans cette revue. Les prépublications sont signalées dans les notices. Compilation LaTeX/BibTeX et liens PDF validés.
# Extension des scénarios d'observation (2026-09-14)

- [Fiche de suivi actualisée après chaque intervention](SUIVI_ETAPES.md)
- [Point simple pour l'encadrant](POINT_SIMPLE_ENCADRANT_2026-09-15.md)
- [Script S4, champs spatiaux calibrés](scenario_s4_calibrated_fields.R) · [tests S4](test_scenario_s4_calibrated_fields.R) · [contrôles et interprétation Georgia/Meuse/Banff](resultats_s4_faisabilite_2026-09-15.md) · [RDS Georgia/Meuse non conditionnel](scenario_s4_40_2026-09-15/results.rds) · [RDS Georgia/Meuse conditionnel](scenario_s4_40_conditional_2026-09-15/results.rds) · [RDS Banff, deux modes](scenario_s4_banff_40_2026-09-15/results.rds)
- [Relecture des TEI et corrections S4](audit_tei_s4_2026-09-15.md) · [contrôles des champs sur les deux sources](check_s4_sources.R)
- [Contrôles S4 à 3 000 tirages et tampon](scenario_s4_source_checks_validation_2026-09-15/field_checks.csv) · [variogrammes](scenario_s4_source_checks_validation_2026-09-15/variogram_checks.csv) · [pilote tamponné](scenario_s4_buffered_smoke_2026-09-15/results.json)
- [Spécification S1–S4](specification_scenarios_observation_geostatistique_2026-09-14.md)
- [Script du scénario S2](scenario_s2_aggregation.R)
- [Tests du scénario S2](test_scenario_s2_aggregation.R)
- [Résultats et interprétation de S2](resultats_s2_aggregation_2026-09-14.md)
- Sorties complètes de S2 : `scenario_s2_output_2026-09-14/`
- [Script du scénario S1](scenario_s1_overlapping_supports.R)
- [Tests du scénario S1](test_scenario_s1_overlapping_supports.R)
- [Résultats et interprétation de S1](resultats_s1_supports_recouvrants_2026-09-14.md)
- Sorties complètes de S1 : `scenario_s1_output_2026-09-14/`
- [Choix des covariables et réseaux pour S3](choix_s3_covariables_reseaux_2026-09-14.md)
- [Script S3](scenario_s3_interpolated_covariate.R) · [tests S3](test_scenario_s3_interpolated_covariate.R) · [résultats pilotes S3](resultats_s3_pilote_2026-09-15.md)
- [Contrastes appariés S3](report_s3_paired.R) · sorties `scenario_s3_central_paired_2026-09-15/`
- [Contrastes densité, bruit et transfert S3](report_s3_factor_contrasts.R) · [sortie CSV](scenario_s3_network_noise_2026-09-15/factor_contrasts.csv)
- [Répétition sur 20 réseaux S3](report_s3_network_repeats.R) · [synthèse CSV](scenario_s3_network_repeat_2026-09-15/summary.csv)
- [Point simple pour l'encadrant](POINT_SIMPLE_ENCADRANT_2026-09-15.md)
- [Propagation conditionnelle aux estimateurs ordinaires](report_s3_conditional_estimators.R)
