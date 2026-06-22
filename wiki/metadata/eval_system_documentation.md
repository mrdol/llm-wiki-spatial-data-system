---
title: Système d'évaluation des fiches wiki
type: metadata
created: 2026-05-06
updated: 2026-05-06
sources: []
tags: [eval, pipeline, tier1, tier2, tier3, documentation]
---

Documentation complète du pipeline d'évaluation automatique des fiches générées par Codex.

---

## Vue d'ensemble

Le pipeline vérifie toute fiche wiki avant qu'elle ne soit intégrée au dépôt.
Il se déclenche automatiquement à chaque `git commit` qui modifie un fichier `wiki/**/*.md`.

```
Codex génère une fiche
        ↓
  git commit (hook)
        ↓
    Tier 1 — structurel      (0 token, <1s)
     ├── ❌ FAIL → commit bloqué, message d'erreur précis
     └── ✅ PASS
              ↓
    Tier 2 — sémantique      (~1 appel Claude)
     ├── score < 0.50   → ❌ Rejeté  → .eval/rejected/
     ├── score 0.50-0.74 → 🟡 Amber  → wiki/eval_queue.md
     └── score ≥ 0.75   → ✅ Intégré
```

---

## Tier 1 — Contrôles structurels

**Fichier :** `eval/tier1_structural.py`
**Coût :** 0 token, <1s par fiche
**Déclenchement :** toujours, pour tous les types de fiches

### Ce qu'il vérifie

#### Contrôles universels (toutes les fiches)

| Contrôle | Règle |
|----------|-------|
| Frontmatter YAML | Le fichier commence par `---` et le YAML est valide |
| `title` | Non vide |
| `type` | Parmi : `dataset`, `source`, `concept`, `metadata`, `estimator`, `analysis` |
| `created` | Format `YYYY-MM-DD` |
| `updated` | Format `YYYY-MM-DD` |
| `tags` | Liste non vide (avertissement si vide) |
| Résumé en une ligne | Première ligne non vide après le frontmatter |
| `## Related Pages` | Section présente en bas de page |
| Backlinks wiki | Chaque lien wiki interne correspond à un fichier existant dans `wiki/` |

#### Sections requises par type

**`dataset`**

| Section requise |
|----------------|
| `## Dataset Name` |
| `## Source / Warehouse` |
| `## Structured Metadata` |
| `## Data Type` |
| `## Structure` |
| `## N (observations)` |
| `## T (time periods)` |
| `## N/T Profile` |
| `## Spatial Resolution` |
| `## Temporal Resolution` |
| `## Spatial Extent` |
| `## Time Range` |
| `## Reproducibility` |
| `## Related Pages` |

**`estimator`**

| Section requise |
|----------------|
| `## Estimator Family` |
| `## Model Equation` |
| `## Data Structures It May Fit` |
| `## Hyperparameters To Optimize` |
| `## Cross-validation Policy` |
| `## Diagnostics To Inspect` |
| `## Failure Modes` |
| `## Related Pages` |

**`analysis`, `source`, `concept`, `metadata`**

Seule `## Related Pages` est obligatoire. Ces types ont une structure plus libre.

#### Règles de cohérence interne (dataset uniquement)

| Condition | Règle |
|-----------|-------|
| `Data Type` contient "spatial" | `Spatial Resolution` et `Spatial Extent` doivent être non vides |
| `Structure` contient "panel" | `T (time periods)` doit être non vide |

### Ce que Tier 1 ne vérifie pas

Tier 1 vérifie **la forme**, pas le **fond**.
Si la section est présente et non vide, elle passe — même si le contenu est sémantiquement faux.
La vérification du contenu est le rôle de Tier 2.

### Comportement en cas d'échec

Tier 1 échoué bloque le `git commit` avec un message d'erreur précisant chaque champ manquant.
Le commit ne peut pas passer tant que les erreurs structurelles ne sont pas corrigées.

---

## Tier 2 — Vérification sémantique (LLM-as-judge)

**Fichier :** `eval/tier2_semantic.py`
**Coût :** ~1 appel Claude par fiche
**Modèle :** `claude-haiku-4-5-20251001` par défaut (configurable via `EVAL_MODEL`)
**Déclenchement :** uniquement si Tier 1 passe, et uniquement pour les types `dataset`, `estimator`, `analysis`

### Ce que le juge reçoit

Le juge reçoit trois éléments dans son prompt :

1. **Les règles de `AGENTS.md`** — en cache prompt (même contenu à chaque appel, ne coûte qu'une fois)
2. **Le contenu complet de la fiche** — varie à chaque appel
3. **L'extrait de la source `raw/`** — si le champ `sources:` du frontmatter est non vide et que le fichier existe dans `raw/`

### Ce qu'il évalue — par type

#### `dataset`

| Critère | Question posée au juge |
|---------|----------------------|
| `y_typology_ok` | Les variables Y ont-elles une typologie cohérente avec leur description (continuous, binary, count, rate, proportion, presence_absence, categorical, ordinal, duration) ? |
| `x_typology_ok` | Les variables X sont-elles bien classées selon leur rôle (predictor, spatial, temporal, lagged, imputed, identifier, geometry) ? |
| `nt_profile_consistent` | Le profil N/T déclaré est-il cohérent avec les valeurs N et T décrites individuellement ? |
| `formula_faithful` | Si une source raw est disponible, les informations clés correspondent-elles à la source ? `null` si pas de source. |
| `quality_gate_ok` | La quality_pedigree proposée par le LLM reste-elle bien en `pending` avec `human_review_required: true` ? |
| `metadata_completeness_ok` | DOI, licence, URL source, reproducibility, feature_selection, modeling_evidence et quality_pedigree sont-ils tous explicitement renseignés ? |
| `paper_linkage_ok` | Si un papier scientifique est lié au dataset, son DOI/titre/evidence sont-ils cohérents ? Si aucun papier n'est lié, la fiche le dit-elle explicitement (none/unknown) ? |

#### `estimator`

| Critère | Question posée au juge |
|---------|----------------------|
| `equation_coherent` | La formule mathématique est-elle cohérente avec la famille d'estimateur déclarée ? |
| `hyperparameters_coherent` | Les hyperparamètres listés sont-ils cohérents avec cet estimateur ? |
| `source_faithful` | Si une source raw est disponible, la fiche lui est-elle fidèle ? `null` si pas de source. |

#### `analysis`

| Critère | Question posée au juge |
|---------|----------------------|
| `claims_faithful` | Si une source raw est disponible, les affirmations de l'analyse correspondent-elles à la source ? `null` si pas de source. |
| `internally_consistent` | L'analyse est-elle cohérente en elle-même (pas de contradiction interne) ? |

#### `source`, `concept`, `metadata`

Tier 2 ne s'exécute pas pour ces types. Ils reçoivent un **score par défaut de 0.80** si Tier 1 passe.
Le risque sémantique est trop faible pour justifier un appel API.

### La règle du plafond à 0.74

Si le champ `sources:` du frontmatter est vide ou si les fichiers référencés n'existent pas dans `raw/`,
le score est **plafonné à 0.74**, quelle que soit la qualité interne de la fiche.

**Pourquoi :** sans source vérifiable, le juge ne peut pas confirmer la fidélité du contenu.
Un score ≥ 0.75 (auto-validation) requiert une source raw disponible.

**Conséquence pratique :** toutes les fiches dataset actuelles ont `sources: []`
et passeront en AMBER jusqu'à ce qu'un fichier source soit ajouté dans `raw/`.

### Dégradation gracieuse

Si l'API est indisponible (clé absente, erreur réseau, réponse non parseable),
Tier 2 retourne un score par défaut de 0.80 avec un avertissement.
Le commit n'est pas bloqué.

---

## Tier 3 — File de vérification manuelle

**Fichier :** `eval/tier3_queue.py`
**Déclenchement :** automatique si score Tier 2 entre 0.50 et 0.74
**Sortie :** `wiki/eval_queue.md`

### Ce qu'il fait

Tier 3 maintient `wiki/eval_queue.md`, un tableau markdown listant toutes les fiches
amber avec leur score, les champs suspects, et la raison du flag.

```markdown
| Date | Fiche | Score | Type | Champs suspects | Raison | Statut |
|------|-------|-------|------|-----------------|--------|--------|
| 2026-05-06 | [[dataset_example]] | 0.68 | dataset | x_typology | ... | [ ] à corriger |
```

### Workflow de correction manuelle

1. Ouvrir `wiki/eval_queue.md`
2. Lire les champs suspects et la raison
3. Corriger la fiche directement dans `wiki/`
4. Relancer l'évaluation sur la fiche corrigée :
   ```bash
   python LLM-wiki-Assessment/eval/run_eval.py wiki/datasets/<warehouse>/ma_fiche.md
   ```
5. Si Tier 1 passe, commiter — le hook relancera l'évaluation complète

### Fiches rejetées (score < 0.50)

Les fiches avec un score inférieur à 0.50 sont loguées dans `.eval/rejected/`
sous forme de JSON avec la date, le score, et les détails du juge.
Le commit est autorisé (seul Tier 1 bloque), mais la fiche est marquée.

---

## Seuils de score

| Seuil | Label | Action |
|-------|-------|--------|
| ≥ 0.75 | ✅ OK | Fiche intégrée au wiki |
| 0.50 – 0.74 | 🟡 AMBER | Ajoutée à `wiki/eval_queue.md` pour révision manuelle |
| < 0.50 | ❌ REJETÉ | Rapport dans `.eval/rejected/`, révision urgente |

---

## Fichiers exclus de l'évaluation

| Fichier | Raison |
|---------|--------|
| `wiki/index.md` | Méta-fichier du wiki |
| `wiki/log.md` | Journal d'activité |
| `wiki/overview.md` | Synthèse générale |
| `wiki/glossary.md` | Terminologie |
| `wiki/eval_queue.md` | File de révision (généré par le système) |

---

## Configuration

| Variable d'environnement | Rôle | Défaut |
|--------------------------|------|--------|
| `ANTHROPIC_API_KEY` | Clé API pour Tier 2 | requis |
| `EVAL_MODEL` | Modèle Claude utilisé comme juge | `claude-haiku-4-5-20251001` |

---

## Installation du hook git

```bash
python eval/install_hook.py
```

Le script détecte automatiquement si tu travailles dans un worktree git et installe
le hook dans le bon répertoire `.git/hooks/`.

Pour désinstaller : supprimer `.git/hooks/pre-commit`.

---

## Utilisation manuelle

```bash
# Une fiche spécifique
python eval/run_eval.py wiki/datasets/ma_fiche.md

# Toutes les fiches du wiki
python eval/run_eval.py --all
```

---

## Dépendances Python

| Package | Usage | Installation |
|---------|-------|-------------|
| `pyyaml` | Parsing du frontmatter YAML (Tier 1) | `pip install pyyaml` |
| `anthropic` | Appel Claude pour Tier 2 | `pip install anthropic` |
| `pdfminer.six` | Extraction texte depuis PDF (optionnel) | `pip install pdfminer.six` |

---

## Related Pages

- [[catalog_registry_schema_v3]]
- [[restricted_estimator_policy_v1]]
- [[dataset_catalog_schema_v2]]
