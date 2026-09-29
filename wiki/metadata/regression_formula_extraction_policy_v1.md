Politique d'extraction de formules de régression depuis les papiers scientifiques
(prose + tableaux de résultats) — llm-wiki-spatial-data-system

## Contexte

Ce travail alimente les blocs de métadonnées formule des fiches datasets du projet
(Bloc 1 — Formule et variables, Bloc 3 — Typologie des modèles), tels que définis dans
AGENTS.md et wiki/metadata/catalog_registry_schema_v3.md. Il s'applique en particulier
au Bloc 2 du projet (datasets liés à des publications scientifiques), où la formule doit
être vérifiée dans le papier (texte ou tableau de résultats), pas seulement citée.

Règle générale déjà en vigueur dans AGENTS.md : "Do not invent a regression formula.
Formula links must come from one of: package documentation, web/book documentation,
TEI section evidence, code examples, manually audited paper-dataset metadata." Ce prompt
précise comment appliquer cette règle à deux formats de preuve fréquents dans les papiers :
la description en prose et le tableau de régressions multi-modèles.

## Cas 1 — Description en prose ("Y est régressé sur X1, X2, X3", "we estimate Y = f(X)")

1. Repérer la phrase dans le texte (TEI GROBID ou lecture directe du PDF/HTML).
2. Copier le texte source verbatim dans `modeling_evidence.equation_text` — ne jamais
   reformuler ou compléter.
3. Normaliser en formule R uniquement dans `formula_candidates.multivariate_constrained.formula`
   (ex: "Y ~ X1 + X2 + X3"), jamais en écrasant `equation_text`.
4. `modeling_evidence.source_type`: `full_paper` si trouvé dans le corps du texte,
   `paper_abstract` si seulement dans le résumé.
5. `modeling_evidence.confidence`:
   - `high` si toutes les variables sont nommées explicitement ;
   - `medium` si certaines sont implicites (ex: "and standard controls", "plus fixed effects") ;
   - ne jamais monter à `high` si une partie de la spécification reste vague.
6. Préserver dans `x_terms_pub` toute transformation mentionnée (log, différence, décalage
   temporel, ratio per capita, interaction) telle qu'écrite dans le papier — ne jamais la
   simplifier vers la variable brute du dataset sans le signaler explicitement.
7. Vérifier que chaque nom de variable cité correspond à une colonne réelle du dataset
   (sf/RDS). Si le nom diffère (autre libellé, variable dérivée), documenter la
   correspondance explicitement dans une note ; ne jamais la présumer silencieusement.

## Cas 2 — Tableau de régressions (estimateurs en colonnes ou en lignes, variables en lignes ou en colonnes)

Étape préalable obligatoire : déterminer l'orientation réelle du tableau (variables en
lignes / modèles en colonnes est le format le plus courant, mais l'inverse existe).
Ne jamais supposer l'orientation par défaut.

Ensuite, distinguer deux situations :

### 2a. Toutes les colonnes partagent la même liste de variables (spécification commune)

C'est le cas idéal pour le benchmark : une formule unique testée par plusieurs estimateurs.

- `y_term_pub` : cherché dans le titre ou la note du tableau (rarement dans le tableau
  lui-même), jamais deviné.
- `x_terms_pub` : toutes les lignes de variables, à l'exclusion stricte des lignes de
  diagnostics (R², AIC, log-vraisemblance, N, rho/lambda estimé, Moran's I des résidus,
  constante) — ces lignes ne sont jamais des covariables.
- Chaque colonne devient une entrée `estimator_eligibility` avec `basis: scientific_evidence`
  et `source_ref` précis (ex: "Table 3, papier X, colonne SAR").
- Cette spécification devient un candidat `formula_candidates.multivariate_constrained`
  avec `status: confirmed`, `source_type: published_or_manual_formula`, et peut alimenter
  directement `formula_used` du benchmark.

### 2b. Les colonnes ont des spécifications différentes (construction pas à pas, ou un
     estimateur différent avec un jeu de variables différent par colonne)

- Ne jamais fusionner les colonnes en une seule formule.
- Créer une entrée distincte par colonne, chacune référençant explicitement la colonne
  du tableau dont elle vient (`source_ref: "Table 3, col. 2"`).
- Choisir une seule colonne comme `formula_used` du benchmark — en priorité celle que le
  papier désigne lui-même comme spécification préférée (souvent discutée dans le texte
  principal, ou la dernière colonne d'une construction emboîtée) — et documenter
  explicitement ce choix et sa justification dans `modeling_evidence`.
- Les autres colonnes peuvent nourrir `ml_or_selected` comme union élargie de variables,
  uniquement si cette union reste strictement dérivée du tableau lui-même ; toute variable
  ajoutée au-delà de ce qui est documenté doit être classée `generated_system_formula`,
  jamais `published_or_manual_formula`.

### Règles communes au cas 2 (colonnes comme lignes)

- Les étoiles de significativité (*, **, ***) ne servent qu'à confirmer qu'une variable a
  été estimée dans ce modèle précis — elles ne doivent jamais servir à décider si une
  variable "compte" dans la formule ou non.
- Si une note de bas de tableau indique des variables omises ("controls not shown",
  "additional covariates omitted for brevity") : ne pas les inventer. Marquer
  `formula_status: partial`, `modeling_evidence.confidence: low`, et écrire une note
  explicite indiquant que la spécification complète n'est pas récupérable du tableau seul.
- Toute extraction faite via GROBID/TEI sur un tableau à en-têtes fusionnés ou multi-lignes
  doit rester plafonnée à `confidence: medium` tant qu'elle n'a pas été revérifiée
  manuellement contre le PDF source (TEI est une extraction, pas une vérité — cf. AGENTS.md).

## Tableau récapitulatif à respecter strictement

| Situation source | source_type | confidence max | Destination |
|---|---|---|---|
| Phrase explicite listant Y et tous les X | published_or_manual_formula | high | multivariate_constrained + formula_used |
| Tableau, spécification commune à tous les estimateurs | published_or_manual_formula | high | multivariate_constrained + formula_used |
| Tableau, spécifications différentes par colonne | published_or_manual_formula (par colonne) | medium | plusieurs candidats distincts, un seul élu formula_used avec justification écrite |
| Tableau avec variables omises ("controls not shown") | published_or_manual_formula | low | formula_status: partial, ne pas compléter |
| Extraction GROBID/TEI non revérifiée manuellement | full_paper | medium max | à revalider avant de passer à confirmed |
| Aucune formule trouvée | none_found | — | unavailable, ne jamais forcer une formule |

## Contraintes transversales (non négociables)

- Ne jamais inventer une formule, une variable, ou une transformation qui n'apparaît pas
  explicitement dans la source.
- Toujours distinguer, dans les champs du fiche, une formule confirmée par publication
  (`Niveau de preuve: publication`) d'une formule générée par le système
  (`Niveau de preuve: system_generated`) — ne jamais présenter la seconde comme la première.
- `sources:` dans le frontmatter doit citer le fichier/DOI/page exacts consultés, pas une
  référence générique.
- Ne jamais marquer `quality_pedigree.review_status: reviewed` ou équivalent — la validation
  finale reste humaine (règle Delta1 du projet). Le statut proposé reste `pending`.
- En cas de doute entre deux interprétations possibles d'un tableau, choisir la lecture la
  plus conservative (celle qui affirme le moins) et l'écrire explicitement dans une note
  de vérification plutôt que de trancher silencieusement.