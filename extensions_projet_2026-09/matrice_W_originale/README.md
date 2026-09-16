# Reconstruction de la matrice de voisinage W originale

**Statut : audit initial fait, méthodologie de reconstruction pas encore implémentée.** Chantier « rapide si c'est rapide » d'après l'encadrant — ne pas y passer plus qu'une session.

## Contexte

Remarque d'Emmanuel : le benchmark doit utiliser la « bonne » matrice W (celle du papier/package source) plutôt que de reconstruire systématiquement un kNN par défaut, quand c'est possible.

## Méthodologie dictée par l'encadrant

Trois cas selon comment W a été construite dans la source :

1. **W basée sur un k-NN ou un seuil de distance** — toujours reconstructible pour n'importe quel sous-échantillon (train/test), une fois qu'on connaît le k ou la distance utilisés par le papier source.

2. **W de contiguïté sur une grille régulière** — convertible en distance : seuil = `2·√D` (D = pas de la grille) → redevient un cas de distance, donc reconstructible comme le cas 1.

3. **W de contiguïté sur géométrie complexe (polygones, réseaux/routes) sans géométrie d'origine disponible** — pas reconstructible from scratch. Solution :
   - sous-sélection de la matrice existante : `W_train = W[train_idx, train_idx]`, puis renormalisation des lignes (somme = 1) ;
   - cas limite : si une ligne devient entièrement nulle après sous-sélection (plus aucun voisin dans le sous-échantillon), prendre `W²` (= `W %*% W`, les voisins-de-voisins) restreint aux colonnes du sous-échantillon, puis renormaliser ;
   - consigne explicite de l'encadrant : ne pas passer trois jours sur ce cas limite — si ce n'est pas rapide à faire, on élimine simplement les lignes concernées pour l'instant.

## Ce qui a déjà été fait (avant ce dossier)

[`build_original_spatial_weights.R`](build_original_spatial_weights.R) audite les 16 jeux de données actuellement embarqués dans le package : pour chacun, est-ce que le package/la source R ou Python d'origine documente/fournit déjà un objet W ?

Résultat ([`package_embedded_spatial_weights_audit.csv`](package_embedded_spatial_weights_audit.csv), détail dans [`package_embedded_spatial_weights_audit_2026-09.md`](package_embedded_spatial_weights_audit_2026-09.md)) : sur 16 jeux, **un seul** a une W source directement récupérable — `columbus_crime` (voisinage de contiguïté irrégulière lu depuis `spData::weights/columbus.gal`, sauvegardé dans `data/final_datasets/weights/` et exposé côté package sous `columbus_crime_listw.rda`). Les 15 autres n'ont pas de W documentée dans leur source directe.

Cet audit répond à « est-ce que la W existe quelque part », pas encore à « dans quel cas de la méthodologie ci-dessus tombe chaque dataset » — c'est l'étape suivante.

## Prochaines étapes

- [ ] Pour chacun des 15 jeux sans W source directe, déterminer si une W a été utilisée dans le papier/la doc d'origine et, si oui, comment elle a été construite (kNN, distance, contiguïté grille, contiguïté complexe) — ça détermine si elle est reconstructible ou non malgré l'absence de l'objet original.
- [ ] Implémenter la logique de sous-sélection + renormalisation + repli `W²` pour les cas de contiguïté complexe (déjà esquissée côté package dans `packages/spatialtidymodels/R/spatial-args.R` : `spatial_W_to_matrix()`, `normalize_spatial_W_for_data()`, `subset_spatial_W_rows()` — à compléter avec le repli `W²`, qui n'y est pas encore).
- [ ] Brancher `spatial_weights_status`/`spatial_weights_object` (déjà lu par `packages/spatialtidymodels/R/metadata-registry.R`) sur le harnais de benchmark pour que la W originale soit effectivement utilisée quand elle est disponible, au lieu du kNN par défaut.

## Remarque sur l'emplacement des fichiers

Le code déjà intégré au package (`R/spatial-args.R`, `R/metadata-registry.R`, `data-raw/prepare-benchmark-data.R`, `data/columbus_crime_listw.rda`) reste dans `packages/spatialtidymodels/` — ce sont des fichiers source du package, ils ne peuvent pas être déplacés ici sans casser sa structure. Seuls les fichiers de suivi/audit autonomes (script exploratoire + rapports) ont été rassemblés dans ce dossier.
