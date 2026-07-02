---
title: Audit qualité des nœuds Formula du KG
type: analysis
created: 2026-06-25
sources:
  - .kg/extracted/*_nodes.jsonl
  - .kg/extracted/*_edges.jsonl
tags: [kg, qualite, formules, nettoyage]
---

# Audit qualité — nœuds Formula du KG

## Chiffres (1727 nœuds Formula : 228 doc package, 150 papiers TEI, le reste audit/incrémental)

| Problème | Nombre | Part |
|---|---:|---:|
| Texte vraiment cassé (`<-`, `$`, `;`, `scannf`, `= FALSE`) | 173 | 10 % |
| Formule tronquée (parenthèses déséquilibrées, ex. `I(income^2` coupé) | 586 | 33 % |
| Attribution papier→jeu vérifiable | 130 | — |
|  · dont overlap de variables OK | 130 | 100 % |
|  · dont aucun overlap (mauvaise attribution) | 0 | 0 % |
| Attribution NON vérifiable (jeu sans variables connues) — zone aveugle | 20 | — |
| Formules « pulvérisées » sur ≥ 3 jeux différents | 8 | — |

## Le problème central : la « pulvérisation » (spray)

Une même formule est attribuée à plusieurs jeux sans rapport, parce que
l'extraction la relie à *tous* les jeux nommés dans le document, pas au jeu
auquel elle appartient. Exemples :

- `houseValue ~ age + nBedrooms m1 <-lm` → **10 jeux** (AER::CigarettesSW,
  AER::Fertility, AER::GSOEP9402, …) — formule du livre Hijmans, cassée + mal collée.
- `yield ~ pmin(year` → 8 jeux agridat.
- `yield ~ -1 + gen` → 4 jeux agridat.

Point rassurant : **là où on peut vérifier** (jeu dont les variables sont
connues du KG), l'attribution est correcte à 100 %. Le mal est concentré dans
(a) les formules au texte cassé et (b) la zone aveugle des jeux seulement cités.

## Causes racines (dans l'extraction, pas dans les données)

1. **Capture du texte trop large** : le motif happe les tokens suivants
   (`m1 <-lm`, `pmin(year`) → texte cassé.
2. **Troncature aux parenthèses** : on coupe au premier `)` → `I(x^2` non fermé.
3. **Attribution par simple co-citation** : une formule est liée à chaque jeu
   nommé dans la section/le papier, sans vérifier qu'elle lui correspond.

## Plan de nettoyage proposé (corriger les règles puis reconstruire — pas d'édition manuelle de `.kg/`)

- **A. Resserrer la capture du texte** (`03_parse_tei.py`, `extract_formula_signals`) :
  s'arrêter au premier token non-formule, rejeter `<-`, `$`, `;`, `scannf`.
- **B. Parenthèses équilibrées** : capturer des formules à parenthèses fermées
  (réparer/rejeter les `I(...` tronqués).
- **C. Garde-fou d'attribution (le plus important)** : ne lier une formule à un
  jeu **que si ≥ 1 variable de la formule appartient aux variables connues du
  jeu**. L'audit montre que cette règle est fiable (130/130) et qu'elle
  éliminerait la pulvérisation (`houseValue~age` ne recouvre pas les variables
  de CigarettesSW).

Effet attendu : suppression des 8 sprays, des 173 textes cassés, et fiabilisation
de la couche Formula avant tout usage pour le catalogue.
