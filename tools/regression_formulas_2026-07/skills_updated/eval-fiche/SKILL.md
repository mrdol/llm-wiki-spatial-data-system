---
name: eval-fiche
description: >
  Évalue une ou plusieurs fiches wiki du projet llm-wiki-karpathy via le pipeline
  Tier1 (structurel, 0 token) → Tier2 (sémantique LLM-as-judge) → Tier3 (file amber).
  Utiliser dès qu'une fiche vient d'être injectée ou corrigée, avant tout commit,
  ou pour évaluer un batch complet. Produit un rapport structuré, met à jour
  wiki/eval_queue.md pour les AMBER, écrit les rapports JSON dans .eval/rejected/
  pour les REJECTED. Invoquer quand l'utilisateur dit : "évalue cette fiche",
  "lance l'éval", "check avant le commit", "valide le batch", "re-évalue la fiche corrigée".
---

# eval-fiche

Évalue les fiches wiki via le pipeline Tier1→Tier2→Tier3 et produit un rapport de validation.
Vocabulaire et seuils définis dans `CONTEXT.md`.

## Commandes

```bash
PYTHON="C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/.venv/Scripts/python.exe"
REPO="C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/llm-wiki-karpathy"

# Évaluer une fiche
"$PYTHON" "$REPO/LLM-wiki-Assessment/eval/run_eval.py" wiki/<type>/<warehouse>/<fiche>.md

# Évaluer tout le wiki
"$PYTHON" "$REPO/LLM-wiki-Assessment/eval/run_eval.py" --all
```

⚠️ Si `ANTHROPIC_API_KEY` absent du `.env` : Tier 2 passe en score par défaut (0.80).
Avertir l'utilisateur — l'évaluation sémantique est désactivée.

## Règles de décision

| Score      | Label    | Action immédiate                            |
|------------|----------|---------------------------------------------|
| ≥ 0.75     | PASS     | Fiche approuvée, commit autorisé            |
| 0.50–0.74  | AMBER    | Ajouter à `wiki/eval_queue.md`              |
| < 0.50     | REJECTED | Rapport JSON dans `.eval/rejected/`         |
| Tier 1 FAIL| BLOCKED  | Stopper, lister toutes les erreurs, alerter |

**Cap 0.74** — `sources: []` ou fichier raw absent → score plafonné à 0.74.
Toujours indiquer la raison du cap dans le rapport.

**Critère null** — Jamais interprété comme un pass. À signaler explicitement.

**Fiches exclues** — Ne jamais évaluer :
`index.md`, `log.md`, `overview.md`, `glossary.md`, `eval_queue.md`.

## Critères de validation — Statut régression canonique (mission 2026-07)

Quand une fiche dataset porte la section `### Statut regression canonique`
(champs `Statut` / `Niveau de preuve` / `Methode d'estimation` /
`Correspondance Python/R`), Tier 1 (`_check_regression_status_block` dans
`tier1_structural.py`) applique en plus :

| Règle | Sévérité |
|---|---|
| `Niveau de preuve: verbatim` mais `Reference publication` vide/pending | **ERROR** (bloque) |
| `Niveau de preuve: verbatim` sans URL ni DOI résolvable dans `Reference publication` (citation bibliographique simple type livre/revue) | WARNING (n'bloque pas) |
| `Statut` contient "analogie" **XOR** `Niveau de preuve` = `analogie` (incohérence) | **ERROR** (bloque) |
| `Statut: bon candidat` mais `formula_pub` vide/none/pending | **ERROR** (bloque) |
| `Statut` ou `Niveau de preuve` hors des valeurs reconnues | WARNING |

Si la section est absente de la fiche (fiches non issues de `generate_fiches.py`
ou fiches antérieures à cette mission), aucune de ces règles ne s'applique —
comportement inchangé.

À signaler explicitement dans le rapport de validation :
- Une fiche `bon candidat` sans URL/DOI (warning) → suggérer de rechercher une
  source plus traçable, mais ne pas bloquer si la citation bibliographique est
  complète (auteur, année, revue).
- Une incohérence Statut/Niveau de preuve sur l'analogie → BLOCKED, corriger
  les deux champs ensemble (jamais l'un sans l'autre).

## Format du rapport

```
## Validation Report — YYYY-MM-DD

### Résumé
Total : N  |  PASS : N  |  AMBER : N  |  REJECTED : N  |  BLOCKED : N

### Résultats

| Fiche | Type | T1 | Score T2 | Décision | Notes |
|---|---|---|---|---|---|
| [[nom]] | dataset | PASS | 0.74 (cap) | AMBER | sources: [] |
| [[nom]] | estimator | FAIL | — | BLOCKED | ## Failure Modes manquant |

### Fiches AMBER — champs à corriger
- [[nom]] : x_typology suspect — rôles X contiennent 'unknown'

### Fiches REJECTED — urgent
- [[nom]] : score 0.42 — y_typology invalide
```

## Actions après évaluation

- **BLOCKED** : stopper immédiatement, notifier l'utilisateur avant toute autre action.
- **AMBER** : mettre à jour `wiki/eval_queue.md` avec statut `[ ] à corriger`,
  score, type, champs suspects, raison.
- **REJECTED** : écrire `YYYY-MM-DD_<dataset_id>.json` dans `.eval/rejected/`.
- Toujours demander : "Voulez-vous archiver ce rapport dans `wiki/analyses/metadata/` ?"

## Re-évaluation après correction

1. Relancer `run_eval.py` sur la fiche corrigée uniquement.
2. Score ≥ 0.75 → retirer de `eval_queue.md`, confirmer PASS.
3. Encore AMBER → mettre à jour l'entrée (nouveau score + raison révisée).
4. Encore BLOCKED → lister les erreurs structurelles restantes précisément.
