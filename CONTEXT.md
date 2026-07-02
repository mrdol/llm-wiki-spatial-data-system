# CONTEXT.md — Vocabulaire partagé du projet

Lire ce fichier en premier à chaque session. Il définit les termes utilisés
partout dans le projet (wiki, CLAUDE.md, AGENTS.md, scripts, fiches).

---

## Projet en une phrase

Constitution d'une banque de datasets spatiaux (objets sf R) pour benchmarker
des estimateurs de spatial ML sous tidymodels.

---

## Termes fondamentaux

**Fiche** = **page wiki** — synonymes. Fichier `.md` dans `wiki/`.
Types : `dataset`, `estimator`, `analysis`, `source`, `concept`, `metadata`.

**sf** — Simple Features (package R). Format canonique final de tous les
datasets, y compris ceux d'origine Python.

**N** — Nombre d'unités spatiales (logements, communes, points, polygones…).
**T** — Nombre de périodes temporelles. T=1 → dataset cross-sectionnel.
**Profil N/T** — Caractérisation de la structure spatio-temporelle d'un dataset.

**Y** — Variable cible (réponse), notation majuscule.
**X** — Variables explicatives / covariables, notation majuscule.
**x, y** — Coordonnées spatiales (longitude, latitude), notation minuscule.
Convention : toutes les coordonnées spatiales doivent être unifiées en `x` (longitude)
et `y` (latitude) dans l'objet sf final.
**Application stricte** : les colonnes `x`/`y` (coordonnées) et les colonnes
identifiant (`id`, `fid`, `gid`, `code`, `key`, `index`…) ne sont **jamais** des
covariables X candidates. Elles sont exclues du tableau `Candidate X variables`
des fiches et reportées séparément (`Coordinates`, `Identifier columns`).
Appliqué dans `export_sf_metadata.R` (`classify_x` → buckets `coordinate_columns`
/ `identifier_columns`, distincts de `x_candidates`) et `generate_fiches.py`.
**Typologie Y** : `continuous` · `count` · `binary` · `rate` · `compositional` · `ordinal` · `unknown`.
**Typologie X** : `spatial` · `temporal` · `socio-economic` · `environmental` ·
`categorical` · `identifier` · `continuous` · `lagged` · `imputed` · `unknown`.

**Bandwidth** — Paramètre de fenêtre spatiale. Sens principal : GWR/MGWR
(pondération géographique locale). Sens élargi : tout kernel spatial selon
l'estimateur.

**Entrepôt / warehouse** — Dépôt de recherche généraliste ou curé : Zenodo, Dryad, Figshare, Dataverse…
**Package** — Dataset distribué via un package R ou Python (ex : `spdep`, `geodaData`, `geodatasets`).
**Portail institutionnel** — Portail thématique ou public : INSEE, Copernicus, GBIF, NOAA, Eurostat…

---

## Trois familles de sources

1. **Packages R/Python** (priorité actuelle)
2. **Datasets liés à des papers scientifiques**
3. **Entrepôts et portails institutionnels** (Zenodo, Dryad, GBIF, Copernicus…)

---

## Pipeline

```
raw/  →  KG (.kg/graph.sqlite)  →  wiki/  →  eval  →  data/final_datasets/
```

**KG** — Knowledge graph SQLite. Première couche d'accès structuré.
Toujours consulter le KG avant de lire le wiki complet.

**raw/** — Sources brutes, immuables, lecture seule pour tous les agents.

---

## Évaluation des fiches (pipeline Tier 1 → 2 → 3)

| Score      | Label    | Action automatique                     |
|------------|----------|----------------------------------------|
| ≥ 0.75     | PASS     | Fiche approuvée                        |
| 0.50–0.74  | AMBER    | Ajoutée à `wiki/eval_queue.md`         |
| < 0.50     | REJECTED | Rapport dans `.eval/rejected/`         |
| Tier 1 FAIL| BLOCKED  | Commit bloqué, erreurs à corriger      |

**Tier 1** — Contrôle structurel automatique (0 token, < 1 s).
**Tier 2** — Contrôle sémantique LLM-as-judge (~1 appel Claude Haiku).
**Tier 3** — Gestionnaire de file amber.
**Cap 0.74** — Si `sources: []` ou fichier raw absent → score plafonné à 0.74
quel que soit la qualité interne du contenu.
**Critère null** — Un critère `null` n'est jamais un pass implicite.

---

## Estimateurs du projet

GAM · GAMBoost · INLA · LightGBM · MARS · MGWR · MGWRSAR ·
RandomForest · RNN · SPBoost · STVC · SVC · SVM · XGBoost

---

## Agents

**Quality gate** (Claude / Cowork) — évalue les fiches, maintient
`wiki/eval_queue.md`. Manuel complet : `CLAUDE.md`.

**Injecting agent** (Codex) — crée et injecte les fiches dans `wiki/`.
Manuel complet : `AGENTS.md`.

Règle inter-agents : le quality gate ne modifie jamais une fiche.
L'injecting agent ne valide jamais sa propre évaluation.
