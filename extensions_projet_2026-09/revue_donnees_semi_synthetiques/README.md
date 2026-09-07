# Revue — données semi-synthétiques / DGP pour Monte Carlo

**Statut : premier passage exploratoire (4 sept.), recoupé et enrichi le 7 sept. avec deux documents de l'encadrant.**

## Contenu

- [`revue_donnees_semi_synthetiques.html`](revue_donnees_semi_synthetiques.html) — le document complet (source de l'artefact publié), incluant depuis le 7 sept. une section « Convergence » comparant notre revue, la synthèse de l'encadrant et le papier SpaCE.
- [`synthese_encadrant_2026-09.md`](synthese_encadrant_2026-09.md) — copie de la synthèse transmise par l'encadrant (7 sept.), taxonomie F1–F7 + protocole de benchmark spatial D0–D9.
- [`ICLR-2024-space-the-spatial-confounding-environment.pdf`](ICLR-2024-space-the-spatial-confounding-environment.pdf) — *SpaCE: The Spatial Confounding Environment* (Tec et al., ICLR 2024), papier source de la comparaison ci-dessus.
- `revue_donnees_semi_synthetiques.bib` — à ajouter : généré via biblio from pdf à partir des PDF des papiers clés listés ci-dessous, une fois la lecture approfondie faite.

## Résumé

Cartographie de 8 familles de méthodes pour construire un DGP à partir d'un vrai (Y, X), du plus paramétrique au plus génératif — 6 familles du premier passage (A–F) + 2 ajoutées le 7 sept. depuis la synthèse de l'encadrant (G, H) :

1. Paramétrique classique (F̂ estimé + résidus imposés par une loi)
2. Bootstrap des résidus
3. **Empirical Monte Carlo Study (EMCS) / plasmode** — le nom que porte l'intuition de l'encadrant dans la littérature (Huber, Lechner & Wunsch 2013 ; Knaus, Lechner & Strittmatter ; critique méthodologique par Advani, Kitagawa & Słoczyński 2019). **Confirmé le 7 sept. par une implémentation spatiale concrète : le papier SpaCE.**
4. Génératif (GAN / flows) — RealCause (Neal et al. 2020) ; alternatives sans discriminateur recommandées par l'encadrant (`engression`, `drf`, Forest-Flow)
5. Morphing entre deux jeux réels (tsMorph) — piste peu coûteuse jamais mentionnée en discussion
6. F̂ non-linéaire à interactions contrôlées (Friedman #1, MARS)
7. Injection de signal connu / spike-in (knockoffs) — ajout du 7 sept.
8. Synthèse pour confidentialité (`synthpop`) — ajout du 7 sept., objectif différent (partage de données, pas benchmark)

**Constat clé côté spatial, révisé le 7 sept.** : le premier passage n'avait trouvé aucun papier combinant plasmode/EMCS et dépendance spatiale. Ce n'est plus tout à fait exact — **SpaCE** (ICLR 2024) le fait, mais dans un but plus étroit (correction du *spatial confounding* en inférence causale), pas la comparaison générale d'estimateurs spatiaux (SAR/SEM/GWR/boosting) que vise notre benchmark. Ce terrain plus large reste ouvert, et c'est exactement ce que couvre le protocole D0–D9 de la synthèse de l'encadrant.

Recommandation mise à jour pour le dashboard v2 : socle EMCS/plasmode structuré par la grille D0–D9 + calibration SNR/part spatiale/portée (synthèse encadrant), résidus par bootstrap ou GMRF façon SpaCE en premier, `engression`/`drf`/Forest-Flow en extension avant tout GAN, validation par classifier two-sample test + Moran's I/variogramme.

## Prochaines étapes

- [ ] Lecture complète de Huber, Lechner & Wunsch (2013), Knaus/Lechner/Strittmatter, LeSage & Pace (2018), Schreck et al. (2024), et de la section 3 complète de la synthèse de l'encadrant (protocole D0–D9) avant la discussion de lundi.
- [ ] Générer `revue_donnees_semi_synthetiques.bib` via biblio from pdf à partir des PDF récupérés pour les références listées dans l'artefact (bibliographie étendue à ~37 entrées au 7 sept.).
- [ ] Mail à « Flash » pour suggestions complémentaires (évoqué en discussion, pas encore envoyé).
- [ ] Recherche ciblée sur la géostatistique pure (krigeage + simulation conditionnelle), non creusée dans ce premier passage.
- [ ] Discussion de lundi avec l'encadrant : trancher sur le socle technique v2 (grille D0–D9 + GMRF vs `engression`/`drf`) et sur la portée exacte du data paper vis-à-vis de SpaCE.
