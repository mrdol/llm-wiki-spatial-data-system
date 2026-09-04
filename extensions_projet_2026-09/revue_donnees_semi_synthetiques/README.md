# Revue — données semi-synthétiques / DGP pour Monte Carlo

**Statut : premier passage exploratoire terminé (recherche web, une session).**

## Contenu

- [`revue_donnees_semi_synthetiques.html`](revue_donnees_semi_synthetiques.html) — le document complet (source de l'artefact publié).
- `revue_donnees_semi_synthetiques.bib` — à ajouter : généré via biblio from pdf à partir des PDF des papiers clés listés ci-dessous, une fois la lecture approfondie faite.

## Résumé

Cartographie de 6 familles de méthodes pour construire un DGP à partir d'un vrai (Y, X), du plus paramétrique au plus génératif :

1. Paramétrique classique (F̂ estimé + résidus imposés par une loi)
2. Bootstrap des résidus
3. **Empirical Monte Carlo Study (EMCS) / plasmode** — le nom que porte l'intuition de l'encadrant dans la littérature (Huber, Lechner & Wunsch 2013 ; Knaus, Lechner & Strittmatter ; critique méthodologique par Advani, Kitagawa & Słoczyński 2019)
4. Génératif (GAN / flows) — RealCause (Neal et al. 2020), pipeline générique IA-générative → Monte Carlo (2026, données multi-niveaux)
5. Morphing entre deux jeux réels (tsMorph) — piste peu coûteuse jamais mentionnée en discussion
6. F̂ non-linéaire à interactions contrôlées (Friedman #1, MARS)

**Constat clé côté spatial** : aucun papier trouvé ne combine explicitement plasmode/EMCS avec une dépendance spatiale (SAR/SEM) — le terrain semble réellement ouvert.

Recommandation esquissée pour le dashboard v2 : socle EMCS/plasmode + bootstrap des résidus en premier, GAN en extension, morphing comme piste originale et peu coûteuse.

## Prochaines étapes

- [ ] Lecture complète de Huber, Lechner & Wunsch (2013), Knaus/Lechner/Strittmatter, LeSage & Pace (2018), et du papier IA-générative-MC 2026 avant citation dans le data paper.
- [ ] Générer `revue_donnees_semi_synthetiques.bib` via biblio from pdf à partir des PDF récupérés pour les références listées dans l'artefact.
- [ ] Mail à « Flash » pour suggestions complémentaires (évoqué en discussion, pas encore envoyé).
- [ ] Recherche ciblée sur la géostatistique pure (krigeage + simulation conditionnelle), non creusée dans ce premier passage.
