# Revue — données semi-synthétiques / DGP pour Monte Carlo

**Statut : premier passage exploratoire (4 sept.), recoupé avec l'encadrant (7 sept.), puis corrigé après lecture intégrale de 5 papiers phares (7 sept.).**

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

## Recommandations pour le package (mises à jour)

- Socle v2 : grille D0–D9 de l'encadrant + calibration SNR/part spatiale/portée.
- Résidus : bootstrap empirique ou GMRF façon SpaCE en premier ; `engression`/`drf`/Forest-Flow en extension ; GAN en dernier recours.
- Validation : comparaison d'histogrammes/densités (Schreck et al.) au minimum, classifier two-sample test/pMSE + Moran's I/variogramme en plus complet.
- N et m : ne jamais les fixer arbitrairement — vérifier la convergence des mesures de performance en N, choisir m via un algorithme adaptatif.
- Garde-fou explicite dans le dashboard : le mode Monte Carlo est un outil de test relatif entre estimateurs sur un DGP donné, jamais une preuve de supériorité générale — les EMCS publiés font pire que le hasard sur ce point précis.

## Prochaines étapes

- [ ] Lecture complète de LeSage & Pace (2018) — non trouvé en accès libre, à obtenir via bibliothèque universitaire.
- [ ] Lecture ligne à ligne de RealCause (Neal et al. 2020) — pour l'instant seulement un résumé approfondi.
- [ ] Générer `revue_donnees_semi_synthetiques.bib` via biblio from pdf à partir des PDF dans `papiers_lus/` et `ICLR-2024-space-the-spatial-confounding-environment.pdf`.
- [ ] Mail à « Flash » pour suggestions complémentaires (toujours pas envoyé).
- [ ] Recherche ciblée sur la géostatistique pure (krigeage + simulation conditionnelle), non creusée.
- [ ] Discussion avec l'encadrant : trancher sur le socle technique v2 et sur la portée exacte du data paper vis-à-vis de SpaCE, en tenant compte de la distinction EMCS/plasmode maintenant clarifiée.
