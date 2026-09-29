# Plan de mise au même niveau d’information

## P0 — Geler un état vérifiable

1. Exécuter `python tools/audit_datapaper_repo.py` avant chaque cycle de rédaction.
2. Conserver la date, les empreintes du registre et du KG dans `audit_etat_repo.json`.
3. Ne jamais transformer automatiquement `missing` en `no` ou en `manual_review`.

## P1 — Créer le manuscrit maître

1. Utiliser `PLAN_DATAPAPER_V2_2026-09-16.md` comme plan courant ; le plan d’août est historique.
2. Créer un seul manuscrit courant dans `extensions_projet_2026-09/redaction_datapaper/`.
3. Importer le positionnement de la synthèse introduction/discussion de septembre.
4. Remplacer tous les chiffres historiques par des valeurs issues du snapshot.
5. Marquer chaque tableau comme `catalogue`, `package registry`, `KG` ou `benchmark run`.

## P2 — Harmoniser les couches — identité et champs contrôlés terminés

1. **Terminé :** 392 identifiants communs ; 0 fiche absente du registre ; 0 entrée sans fiche.
2. **Terminé :** 0 désaccord de champ non vide dans le snapshot courant.
3. **À faire :** comparer les relations KG aux fiches pour les articles, formules, réponses, covariables et artifacts.
4. **À faire :** distinguer dans les tableaux les 260 décisions `yes`, les artifacts disponibles et les jeux effectivement exécutés.
5. **Règle :** documenter tout nouvel écart sans modifier automatiquement une fiche.

## P3 — Bibliographie maître

1. Fusionner les bibliographies benchmark et semi-synthétique dans un fichier de travail.
2. Dédupliquer les clés et DOI ; conserver les clés déjà utilisées dans les textes.
3. Vérifier titre, auteurs, année et DOI des références citées dans le manuscrit.
4. Séparer les références centrales du data paper des références d’extensions méthodologiques.

## P4 — Réécrire les parties périmées

Documents détectés par l’audit :

- `Mémoire/Data paper/plan_datapaper_v1.md` : comptes [51, 77, 91, 161, 286, 289], marqueurs ['91_fiches', '289_fiches']
- `wiki/analyses/datapapers/spatial_benchmark_databank_blocs_1_2_datapaper_draft_2026_08.md` : comptes [91], marqueurs ['91_fiches']

Le plan d’août peut être conservé comme squelette. Les brouillons de juillet–août doivent porter clairement la mention « historique » ou être remplacés par le manuscrit maître.

## P5 — Validation avant envoi ou soumission

1. Relancer l’audit et archiver son JSON avec la version du manuscrit.
2. Vérifier les liens locaux, les clés bibliographiques et les nombres des tableaux.
3. Vérifier les déclarations de licence, disponibilité et redistribution.
4. Distinguer catalogue, banque disponible, noyau benchmarkable et exécutions réalisées.
5. Faire relire les choix scientifiques : périmètre des panels, place de S1–S3, achèvement de S4 et revue cible.

## Critère de sortie

Le projet est au même niveau d’information lorsque le manuscrit maître ne contient aucun chiffre non traçable, que ses identifiants rejoignent fiches/registre/KG, que toutes ses citations existent dans la bibliographie maître et que les documents historiques ne sont plus utilisés comme source de l’état courant.
