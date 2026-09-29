---
title: claude_fallback_production_audit_2026-08-09
type: analysis
created: 2026-08-09
updated: 2026-08-09
sources: []
tags: [analysis, audit, fallback-production, kg, papers, warehouse]
---

# Rapport d'audit — session en mode secours Claude (2026-08-09)

Rapport requis par la section "Claude Fallback Production Mode" ajoutée le
2026-08-09 dans `AGENTS.md`/`CLAUDE.md`/`CONTEXT.md`. Mode secours actif
tout au long de cette session, sur autorisation explicite de l'utilisateur
a chaque etape (harvest, conversion sf, jointures geometriques, redaction
de fiches, phases 3/6bis/12 du pipeline papier).

## Fichiers modifies ou crees (categories)

- **Scripts pipeline** : `tools/harvest_datacite.R` (filtre cumulatif
  SciELO/ScienceDB, bonus depot prioritaire), `tools/verify_datacite_candidates.py`
  (prompt corrige pour ne plus penaliser `formula_status=not_found`),
  `tools/ingest_datacite_verified.py`, `tools/download_datacite_verified_pdfs.py`,
  `tools/apply_datacite_pdf_screening.py`
- **Nouveaux modules partages** : `tools/dataset_manifest_check.py` (+ connecteurs
  ScienceBase/PANGAEA/B2SHARE/Dataverse generique), `tools/paper_pdf_check.py`,
  `tools/warehouse_sf_conversion.py`, `tools/check_dataset_availability.py`,
  `tools/check_warehouse_dataset_availability.py`, `tools/ingest_warehouse_datasets.py`,
  `tools/ingest_manual_downloads.py`, `tools/retry_warehouse_download.py`,
  `tools/retry_warehouse_conversion.py`, `tools/harvest_warehouse_datasets.R`
- **Referentiels geographiques persistes** : `data/reference/admin_boundaries/`
  (Turquie GADM, Coree KOSTAT, Chine GADM provinces+prefectures, Maroc
  geoBoundaries, Mexique mxmaps) + `tools/admin_boundary_joins/` (6 modules
  reutilisables `join(df, colonne)`)
- **KG** : `inst/kg/paper_dataset_uses.json` — dizaines de mises a jour
  (statuts d'ingestion, chemins sf, formules, rejets documentes)
- **Fiches wiki nouvelles** (`wiki/datasets/fiches_datasets/`) : 22 fiches
  papier corrigees au format package (debut de session) + 6 nouvelles fiches
  (marrot, velado_alonso, rocha, teles, wang_henan, li_energy_price_co2_china)
- **Datasets finaux** : 58 `.gpkg`/`.rds` ajoutes ou corriges dans
  `data/final_datasets/sf/`

## Hypotheses et reconstructions documentees (non verifiees a 100%)

| Dataset | Hypothese | Niveau de confiance |
|---|---|---|
| Espagne (Velado-Alonso) | CRS EPSG:25830 (ETRS89 UTM 30N) suppose, papier ne precise pas le fuseau | medium |
| Chine energie/CO2 (Li) | Identification des 30 provinces par empreinte statistique (recensement 2010) + verification codes GB/T 2260, aucun codebook officiel | medium-high (deux methodes independantes convergentes) |
| Henan (Wang) | Y publie (indice pondere) non reconstruit — Y de substitution utilise ; couverture geographique 143/159 comtes (16 exclus, documentes, non fabriques) | partiel, documente |
| Brésil (Rocha) | CRS assume WGS84 sur la base des bornes geographiques (.prj absent du shapefile source) | medium |

Aucune jointure geometrique n'a ete appliquee sans verification `0 non
apparie` prealable (Turquie 81/81, Coree 229/229, Chine provinces 30/30 x2,
Maroc 75/75, Mexique 860/860, Chine villes 108/108, Chine energie 30/30).

## Sources externes utilisees pour verification

- CrossRef API (metadonnees bibliographiques des 6 nouveaux papiers)
- Wikipedia/NBS (recensement chinois 2010, codes administratifs GB/T 2260)
- geoBoundaries.org (Maroc ADM2, Chine ADM3 — remplace GADM quand insuffisant)
- Package R `mxmaps` (municipios mexicains, reconstruits depuis un format
  ggplot2 fortify)
- Recherche web independante (PIB/habitant Chine 2010 pour departager
  Yunnan/Guangxi) — croisee avec une verification tierce (ChatGPT) qui a
  identifie une erreur dans une premiere reconstruction, corrigee suite a
  cette relecture croisee

## Controles de conformite executes

- `tools/check_paper_benchmark_readiness.py` : 28/28 fiches papier passent
  (aucun `package_include: yes` sans `benchmark_status: ready`)
- `python tools/kg/run_all.py --llm-disambiguate` : execute deux fois,
  KG (`paper_dataset_uses.json`) verifie intact apres chaque run (lecture
  seule confirmee pour les etapes du pipeline)
- `LLM-wiki-Assessment/eval/run_eval.py` : execute sur les 6 nouvelles
  fiches — 5/6 en AMBER (0.74, ajoutees a `wiki/eval_queue.md` pour
  correction manuelle), 1/6 (Henan) en degradation gracieuse (erreur de
  parsing JSON du juge Tier 2, score par defaut 0.80)

## Champs non resolus / a revoir manuellement

Voir `wiki/eval_queue.md` (entrees 2026-08-09) pour le detail par fiche.
Points recurrents : licence non confirmee (Dryad/Mendeley/Figshare —
generalement CC0/CC-BY mais jamais verifie explicitement), CRS d'analyse
recommande souvent non valide, quelques `estimator_eligibility` marques
`uncertain` a trancher.

## Items necessitant une decision humaine avant promotion package

- Aucune des 6 nouvelles fiches n'a `package_include: yes` — toutes en
  `manual_review`, conformement a la regle de promotion (Phase 12bis).
- Le dataset Chine energie/CO2 depend d'une reconstruction d'identification
  geographique (voir tableau ci-dessus) — a signaler explicitement si
  utilise dans une publication.
- Le dataset Henan n'a pas l'indice Y publie reconstruit (Y de substitution
  documente) — necessite une decision sur l'usage souhaite avant benchmark.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- [[model_evidence_candidates_review_2026-08]]
