# Audit formules de régression canoniques — juillet 2026

Scripts et données utilisés pour la mission "mise à jour des fiches datasets
avec les formules de régression canoniques identifiées" (Tâches 1-6, sessions
du 2026-07-01 et 2026-07-02). Sauvegardés ici pour pouvoir rejouer/auditer les
modifications appliquées à `wiki/datasets/packages/*.md` et aux scripts/skills
du pipeline.

## Contenu — Tâches 1-4 (fiches)

- `regression_findings.py` — table de référence `FINDINGS` : pour chacune
  des 98 fiches de `wiki/datasets/packages/`, statut régression (bon
  candidat / à vérifier / mauvais candidat / mis de côté / candidat par
  analogie), formule, méthode, source exacte, niveau de preuve
  (verbatim/code/article/analogie), correspondance Python/R le cas échéant.
  C'est la source de vérité de la mission — modifier ce fichier puis
  relancer `apply_findings.py` pour propager un changement.
- `apply_findings.py` — applique `FINDINGS` aux fiches : remplit
  `### Formule — niveau publication`, ajoute une sous-section
  `### Statut regression canonique` et un bloc `modeling_evidence:` en
  Bloc 3. Idempotent (peut être relancé sans dupliquer les blocs).
- `check_files.py` — vérifie que chaque clé de `FINDINGS` correspond à un
  fichier existant dans `wiki/datasets/packages/` (et inversement).
- `extract_doc_crosscheck.py` — pour chaque fiche, retrouve le fichier de
  documentation correspondant sous `wiki/datasets/r_package_docs/<package>/
  topics/` et extrait les sections Format/Source/License pour comparaison
  manuelle. Produit `doc_crosscheck_report.txt` (déjà généré, inclus ici).
- `fix_nt_metadata.py` — corrige les 8 fiches où une variable continue
  (timestamp GPS, date de vente, indicateur de santé...) avait été prise à
  tort pour un axe temporel répété (bug de profilage N/T), confirmé par
  croisement avec `r_package_docs` ou par inspection directe des colonnes.
- `license_crosscheck.py` — compare systématiquement la licence déclarée en
  Bloc 6 de chaque fiche à la licence du package source (`License:` dans
  `<package>.md`) ; a permis de détecter l'erreur systématique sur les 5
  fiches `agridat` (GPL-2 déclaré à tort au lieu de `MIT + file LICENSE`).
- `packages_backup_pre_2026-07-01/` — snapshot des 98 fiches **avant**
  application de cette mission (les fiches de `wiki/datasets/packages/`
  n'étaient pas encore suivies par git à ce moment, donc pas de diff git
  possible autrement).

## Contenu — Tâche 4, 2e passe (2026-07-02)

- `task4_full_pass.py` — revue systématique des 59 fiches classées `mauvais_candidat` (48)
  ou `a_verifier` (11) après la 1ère passe, pour juger au cas par cas si une formule
  candidate par analogie est défendable (25 upgrades) ou si aucune analogie pertinente
  n'existe (30 fiches, statut inchangé mais note explicite ajoutée ; 4 fiches déjà
  résolues laissées inchangées). Patche `FINDINGS` en mémoire au-dessus de
  `regression_findings.py` (ne le modifie pas sur disque) puis réutilise
  `apply_findings.process()` pour réécrire les fiches. À relancer après tout changement
  dans `UPGRADES`/`NO_ANALOGY_REVIEWED` : `python task4_full_pass.py`.
  **Important** : `build_dashboard_stats.py` importe et applique automatiquement ce patch
  avant de calculer les statistiques — les deux fichiers doivent rester cohérents.

## Contenu — Tâche 5 (dashboard)

- `inspect_rdata_funnel2.R` — script Rscript qui recalcule l'entonnoir amont
  de curation (jeux catalogués → non spatiaux/ML / spatiaux simples / bons
  candidats spatiaux → retenus pour fiche wiki) directement depuis
  `data/manifests/datasets/software_catalog_combined.RData` et
  `software_catalog_curated_final.RData`. Nécessite Rscript (chemin local :
  `C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe`).
  Sortie sauvegardée dans `rdata_funnel_report.txt`.
- `build_dashboard_stats.py` — calcule les statistiques de la mission (statut
  régression, niveau de preuve, méthodes, homologues résolus, corrections
  N/T et licence) à partir de `regression_findings.py` et écrit
  `data/manifests/datasets/banque_regression_dashboard_2026-07.{json,csv}`.
- Rapport final (Markdown, wiki) :
  `wiki/analyses/metadata/banque_regression_formulas_dashboard_2026-07.md`.

## Contenu — Tâche 6 (scripts et skills)

- `Code_scrapping/r_catalog/generate_fiches.py` (dans le repo, pas ici) a été
  modifié pour générer nativement les nouveaux champs : table
  `PYTHON_R_HOMOLOGS` (correspondance Python/R, à enrichir au fil des
  découvertes), fonction `find_homolog_formula()` qui propage automatiquement
  la formule d'un homologue déjà résolu, section `### Statut regression
  canonique` et bloc `modeling_evidence:` dans le gabarit de fiche.
- `LLM-wiki-Assessment/eval/tier1_structural.py` (dans le repo, pas ici) a
  reçu une nouvelle fonction `_check_regression_status_block()` : vérifie la
  cohérence Statut/Niveau de preuve, qu'un "bon candidat" a une formule non
  vide, et avertit (sans bloquer) qu'un niveau de preuve "verbatim" sans
  URL/DOI résolvable est une simple citation bibliographique. Voir le detail
  des règles dans le skill `eval-fiche` mis à jour (copie dans
  `skills_updated/`).
- `skills_updated/enrich-metadata/SKILL.md` et `skills_updated/eval-fiche/SKILL.md`
  — copies de sauvegarde des skills mis à jour. **Attention** : les skills
  installés vivent dans un répertoire de session éphémère
  (`AppData/Roaming/Claude/local-agent-mode-sessions/skills-plugin/.../skills/`)
  qui peut ne pas persister d'une session à l'autre ; ces copies dans le repo
  sont la référence durable — les recopier vers l'emplacement des skills
  installés si les modifications n'apparaissent plus dans une session future.

## Rejouer l'audit

```bash
# Depuis la racine du repo, avec le venv du projet :
python tools/regression_formulas_2026-07/check_files.py
python tools/regression_formulas_2026-07/apply_findings.py
python tools/regression_formulas_2026-07/license_crosscheck.py
python tools/regression_formulas_2026-07/build_dashboard_stats.py

# Entonnoir amont (necessite Rscript) :
Rscript tools/regression_formulas_2026-07/inspect_rdata_funnel2.R
```

## Constat clé (bug récurrent Tâche 2)

Plusieurs fiches affichaient `Structure: panel` avec un `T periods` élevé
généré à partir d'une variable qui n'est PAS un axe temporel répété mais un
attribut continu par observation (timestamp GPS, date de vente individuelle,
indicateur de santé...). Signature typique : `T periods` proche ou égal à
`N observations`. Détecté et corrigé sur : `pol_pres15` (cas confirmé par la
mission), `gartner.corn`, `house`, `chicagoSDOH`, `charleston2`, `hickory2`,
`lansing2`, `home_sales`. Ce bug vient probablement du profilage R en amont
(`export_sf_metadata.R` / `build_sf_datasets.R`) — non corrigé à la source
ici (hors scope de cette mission), seulement dans les fiches déjà générées.
