---
title: journal_first_ingestion_2026-08
type: metadata
created: 2026-08-15
updated: 2026-08-15
sources:
  - tools/ingest_journal_first_candidates.py
tags: [metadata, ingestion, journal-first]
---

# Ingestion des candidats journal-first verifies

Date : 2026-08-15

- Candidats verifies traites : **14**
- Derniere execution : **2** insertion(s), **12** mise(s) a jour dans `inst/kg/paper_dataset_uses.json`
- Repartition par statut : candidate_dataset_download_pending=14
- Dont formule incomplete (variable(s) manquante(s) detectee(s)) : **0**

Ces lignes ne signifient pas encore que les datasets sont prets pour `spatialtidymodels`.
Elles alimentent la meme file de curation reproductible que le harvest DataCite : KG -> tools/build_paper_dataset_curation_manifest.py -> loader sf -> fiche dataset -> metadata package.

| Dataset | Repo | Papier | Statut | Formule | Etape suivante |
|---|---|---|---|---|---|
| 10.5061/dryad.h44j0zpr2 | dryad | Building use-inspired species distribution models: Using multiple data types to  | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5281/zenodo.7971532 | zenodo | Building use-inspired species distribution models: Using multiple data types to  | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5281/zenodo.14982712 | zenodo | On the brink: mapping the last strongholds of the critically endangered flapper  | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5281/zenodo.3242134 | zenodo | Assessing public transport infrastructure: the role of employment matching in sp | candidate_dataset_download_pending | non_extraite | API confirmed real files but the download attempt failed (see verification_notes) -- retry via tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5281/zenodo.14178904 | zenodo | Visitation patterns across mobility groups: wandering, commuting, and exploring | candidate_dataset_download_pending | non_extraite | API confirmed real files but the download attempt failed (see verification_notes) -- retry via tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5281/zenodo.4446043 | zenodo | Determinants of Airbnb prices in European cities: A spatial econometrics approac | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.6084/m9.figshare.11375826 | figshare | Geographically neural network weighted regression for the accurate estimation of | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5281/zenodo.5644742 | zenodo | MetaComNet: A random forest-based framework for making spatial predictions of pl | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5281/zenodo.6907553 | zenodo | Balancing structural complexity with ecological insight in Spatio-temporal speci | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.6084/m9.figshare.7504448.v3 | figshare | Niche conservatism limits the distribution of Medicago in the tropics | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5061/dryad.kd1d4 | dryad | Integrated species distribution models to account for sampling biases and improv | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5061/dryad.t1n04 | dryad | Macaque Monkeys Perceive the Flash Lag Illusion | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5061/dryad.h44j0zpr2 | dryad | Building use-inspired species distribution models: using multiple data types to  | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5281/zenodo.3637689 | zenodo | A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonst | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
