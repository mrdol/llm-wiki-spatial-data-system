---
title: Tier 2.5 — Vérification de formules PDF par vision LLM
type: metadata
created: 2026-05-13
updated: 2026-05-13
sources: []
tags: [metadata, eval, formulas, vision, pdf, estimator, tier2_5]
---

Documentation du module de vérification de formules mathématiques par extraction PDF via l'API vision Claude.

## Pourquoi ce tier existe

Les fiches estimateur déclarent une section `## Model Equation` qui résume les formules mathématiques du papier source. Jusque-là, cette section n'était jamais vérifiée contre le PDF original — un modèle pouvait écrire une équation légèrement fausse ou omettre des termes clés sans que le pipeline le détecte.

Le Tier 2.5 ferme ce vide : il ouvre le PDF source, rend chaque page en image, demande à Claude d'extraire toutes les formules en LaTeX (vision), et compare le résultat avec ce que la fiche déclare.

---

## Architecture — les 6 compartiments

```
raw/paper/GAMboosting.pdf
      │
      ▼  [Compartiment 1]
_find_pdf_source()          ← lit sources: [GAMboosting.pdf] dans le frontmatter
      │                        cherche dans raw/paper/, raw/estimators/, raw/
      ▼  [Compartiment 2]
extract_pages_as_images()   ← PyMuPDF (fitz) : 29 pages → 29 PNG bytes en mémoire
      │                        résolution 150 DPI
      ▼  [Compartiment 3]
extract_formulas_from_page()← API Claude vision, page par page
      │                        prompt : "Extrais toutes les formules en LaTeX"
      │                        retour JSON : {"formulas": ["\\hat{f}...", ...]}
      ▼  [Compartiment 4]
run_formula_extraction()    ← sauvegarde dans le manifeste JSON (cache disque)
      │                        data/manifests/papers/GAMboosting_formulas_extracted.json
      ▼  [Compartiment 5]
compare_formulas_with_fiche()← lit ## Model Equation de la fiche
      │                         envoie section + 50 formules PDF à Claude
      │                         retour : assessment, score, matched, missing, divergences
      ▼  [Compartiment 6]
run(fiche_path, frontmatter)← point d'entrée appelé depuis run_eval.py
                               retourne FormulaResult (score, assessment, rapport)
```

---

## Fichiers créés par le module

| Fichier | Rôle |
|---|---|
| `LLM-wiki-Assessment/eval/tier2_5_formula.py` | Module principal — les 6 compartiments |
| `data/manifests/papers/<stem>_formulas_extracted.json` | Manifeste de cache des formules extraites |

Le manifeste est créé automatiquement lors de la première extraction et réutilisé lors des runs suivants.

---

## Format du manifeste JSON

```json
{
  "pdf_path": "raw/paper/GAMboosting.pdf",
  "extracted_at": "2026-05-13T14:24:14+00:00",
  "model": "claude-haiku-4-5-20251001",
  "dpi": 150,
  "page_count": 29,
  "total_formulas": 222,
  "pages": [
    {
      "page": 2,
      "formulas": [
        "\\hat{f}_A(\\cdot) = \\sum_{m=1}^{M} \\alpha_m \\hat{g}^{[m]}(\\cdot)",
        "(X_1, Y_1), \\ldots, (X_n, Y_n)"
      ]
    },
    {
      "page": 4,
      "formulas": [
        "f^*(\\cdot) = \\arg\\min_f \\mathbb{E}[\\rho(Y, f(X))]",
        "U_i = -\\frac{\\partial}{\\partial f}\\rho(Y_i, f)|_{f=\\hat{f}^{[m-1]}(X_i)}",
        "\\hat{f}^{[m]}(\\cdot) = \\hat{f}^{[m-1]}(\\cdot) + \\nu \\cdot \\hat{g}^{[m]}(\\cdot)"
      ]
    }
  ],
  "all_formulas": ["...", "..."]
}
```

---

## Format du résultat de comparaison

```json
{
  "assessment": "partial",
  "score": 0.45,
  "matched_formulas": [
    "\\hat{f}^{[m]} = \\hat{f}^{[m-1]} + \\nu \\cdot \\hat{g}^{[m]}",
    "U_i = -\\frac{\\partial}{\\partial f}\\rho(Y_i, f)|_{f=\\hat{f}^{[m-1]}(X_i)}"
  ],
  "missing_from_fiche": [
    "f^*(\\cdot) = \\arg\\min_f \\mathbb{E}[\\rho(Y, f(X))]",
    "C(f) = n^{-1}\\sum_{i=1}^n \\rho(Y_i, f(X_i))"
  ],
  "divergences": [
    "La fiche omet les fonctions de perte \\rho (quadratique, log-likelihood, SVM)",
    "Notation h_j(x_ij) dans la fiche vs \\hat{g}^{[m]}(X_i) dans le PDF"
  ],
  "reasoning": "La fiche capture la structure itérative mais reste schématique..."
}
```

Valeurs d'`assessment` :

| Valeur | Signification | Score typique |
|---|---|---|
| `faithful` | Formules de la fiche concordent avec le PDF | ≥ 0.85 |
| `partial` | Formule principale présente, détails manquants | 0.50–0.84 |
| `divergent` | Au moins une formule clé incorrecte | < 0.50 |
| `not_verifiable` | PDF ou fiche sans formules suffisantes | 0.70 (neutre) |

---

## Résultat sur GAMBoost (test réel — 2026-05-13)

PDF analysé : `raw/paper/GAMboosting.pdf` — 29 pages, **222 formules extraites**

| Critère | Résultat |
|---|---|
| Tier 1 | ✅ PASS |
| Tier 2 | 🟡 AMBER 0.65 — `source_faithful` = `-` (template, normal) |
| **Tier 2.5** | **`partial` — score 0.45** |

**Formules identifiées dans les deux sources :**
- `\hat{f}^{[m]} = \hat{f}^{[m-1]} + \nu \cdot \hat{g}^{[m]}` — mise à jour itérative ✓
- `U_i = -\partial_f \rho(Y_i, f)|_{f=\hat{f}^{[m-1]}}` — pseudo-résidus ✓

**Formules importantes absentes de la fiche :**
- `f^*(\cdot) = \arg\min_f \mathbb{E}[\rho(Y, f(X))]` — prédicteur de Bayes
- `C(f) = n^{-1}\sum \rho(Y_i, f(X_i))` — risque empirique
- `\hat{f}^{[0]}(\cdot) \equiv \arg\min_c n^{-1}\sum \rho(Y_i, c)` — initialisation
- Formules AdaBoost (err, α, poids) — présentes dans le PDF
- Fonctions de perte `\rho` pour régression, log-vraisemblance, SVM

**Divergences détectées :**
- La fiche utilise `h_j(x_{ij})` pour les base learners ; le PDF utilise `\hat{g}^{[m]}(X_i)` — notations différentes mais équivalentes
- `g(E[y_i]) = \eta_i` dans la fiche n'apparaît pas dans le PDF — notation GAM importée d'ailleurs
- Fonctions de perte entièrement absentes de la fiche

---

## Installation requise

```bash
# PyMuPDF — rendu des pages PDF en images
pip install pymupdf

# Vérification
python -c "import fitz; print('PyMuPDF', fitz.__version__)"
```

La clé `ANTHROPIC_API_KEY` doit être présente dans `.env` à la racine du projet (même condition que Tier 2).

---

## Commandes VS Code — terminal intégré PowerShell

Ouvrez le terminal intégré dans VS Code (`Ctrl+ù` ou menu **Terminal → New Terminal**).  
Vérifiez que le répertoire courant est bien la racine du projet :

```powershell
# Vérifier qu'on est au bon endroit (doit afficher llm-wiki-karpathy)
Get-Location
# Si besoin, se placer dans le bon répertoire :
Set-Location "C:\Users\jdoliveira\SynologyDrive\johnny D'OLIVEIRA\Travaux stages\llm-wiki-karpathy"
```

> **Note PowerShell** : la syntaxe bash `VAR=valeur commande` n'existe pas sous PowerShell.  
> Il faut utiliser `$env:NOM = "valeur"` sur une ligne séparée, **puis** lancer la commande.  
> Puisque le venv est déjà activé (`(.venv)` visible dans le prompt), `python` suffit — pas besoin du chemin complet vers l'exécutable.

---

### 1. Vérification complète avec formules (cache si déjà extrait)

```powershell
$env:PYTHONIOENCODING = "utf-8"
python LLM-wiki-Assessment/eval/run_eval.py wiki/estimators/gamboost.md --formulas
```

Comportement :
- Charge le manifeste `GAMboosting_formulas_extracted.json` depuis le cache (pas de ré-extraction)
- Lance uniquement la comparaison (1 appel Claude)
- Affiche le résultat Tier 2.5 à la suite de Tier 1 et Tier 2

---

### 2. Forcer la réextraction depuis le PDF

```powershell
$env:PYTHONIOENCODING = "utf-8"
python LLM-wiki-Assessment/eval/run_eval.py wiki/estimators/gamboost.md --formulas --force-formulas
```

Comportement :
- Ignore le manifeste existant
- Relit toutes les pages du PDF (29 pages → 29 appels API vision)
- Écrase le manifeste avec les nouvelles formules
- Lance ensuite la comparaison

---

### 3. Évaluation standard sans formules

```powershell
$env:PYTHONIOENCODING = "utf-8"
python LLM-wiki-Assessment/eval/run_eval.py wiki/estimators/gamboost.md
```

Sans `--formulas`, le Tier 2.5 est ignoré silencieusement.

---

### 4. Évaluation avec réseau + formules

```powershell
$env:PYTHONIOENCODING = "utf-8"
python LLM-wiki-Assessment/eval/run_eval.py wiki/estimators/gamboost.md --external --formulas
```

Lance dans l'ordre : Tier 1 → vérification réseau (DOI/URL) → Tier 2 → Tier 2.5.

---

### 5. Tester sur un autre estimateur

```powershell
$env:PYTHONIOENCODING = "utf-8"
python LLM-wiki-Assessment/eval/run_eval.py wiki/estimators/spboost.md --formulas
```

Le module cherche automatiquement le PDF dans `sources:` du frontmatter de la fiche.  
Si aucun PDF n'est trouvé dans `raw/paper/`, `raw/estimators/` ou `raw/`, le Tier 2.5 est ignoré avec un message explicite.

---

### 6. Utiliser un modèle plus puissant (si disponible sur votre compte)

```powershell
$env:PYTHONIOENCODING = "utf-8"
$env:FORMULA_MODEL = "claude-3-5-sonnet-20241022"
python LLM-wiki-Assessment/eval/run_eval.py wiki/estimators/gamboost.md --formulas --force-formulas
```

Le modèle par défaut est `claude-haiku-4-5-20251001` (même que Tier 2). Un modèle Sonnet ou Opus produit de meilleures extractions sur les formules complexes ou les notations peu standard.

Réinitialisez la variable après si vous ne voulez pas qu'elle persiste dans la session :

```powershell
Remove-Item Env:FORMULA_MODEL
```

---

## Variables d'environnement disponibles

| Variable | Rôle | Défaut |
|---|---|---|
| `FORMULA_MODEL` | Modèle Claude utilisé pour vision et comparaison | `claude-haiku-4-5-20251001` |
| `FORMULA_PDF_DPI` | Résolution de rendu des pages PDF | `150` |
| `ANTHROPIC_API_KEY` | Clé API (lue depuis `.env`) | — |

---

## Comportement selon le type de fiche

Le Tier 2.5 ne s'exécute que pour les fiches de type `estimator`.  
Pour les fiches `dataset`, `paper`, `analysis` — il est ignoré silencieusement même si `--formulas` est passé.

| Type de fiche | Comportement avec `--formulas` |
|---|---|
| `estimator` | Tier 2.5 actif si un PDF est trouvé dans `sources:` |
| `dataset` | Ignoré — `"Tier 2.5 ignoré — type 'dataset'"` |
| `paper` | Ignoré |
| `analysis` | Ignoré |

---

## Limites connues

- **Formules dans des images scannées** : si le PDF est un scan de mauvaise qualité, l'extraction sera partielle. À 150 DPI, les PDFs natifs (latex compilé) sont parfaitement lisibles.
- **Nombre de formules** : la comparaison utilise les 50 premières formules extraites. Pour un PDF de 222 formules, des formules en fin de document peuvent être manquées dans la comparaison (mais pas dans le manifeste).
- **JSON avec LaTeX** : les réponses de Claude contenant des formules LaTeX avec `\` sont réparées automatiquement si le JSON est invalide. Dans de rares cas, le parsing peut échouer — le module retourne alors `not_verifiable`.
- **Cache du manifeste** : si vous mettez à jour le PDF source, relancez avec `--force-formulas` pour régénérer le manifeste.

---

## Related Pages

- [[eval_system_documentation]]
- [[estimator_fiche_schema_v1]]
- [[restricted_estimator_policy_v1]]
