---
title: Ingestion des candidats dataset-first verified_pending_download (Dryad + Zenodo)
type: analysis
created: 2026-09-04
updated: 2026-09-04
sources:
  - inst/kg/paper_dataset_uses.json
tags: [datasets, dataset-first, dryad, zenodo, ingestion]
---

# Ingestion des candidats dataset-first verifies (Dryad + Zenodo)

Date : 2026-09-04

- Candidats verifies traites : **9**
- Derniere execution : **0** insertion(s), **9** mise(s) a jour dans `inst/kg/paper_dataset_uses.json`
- Repartition par statut : candidate_dataset_download_pending=3, raw_data_downloaded_pending_loader=6
- Sans publication liee resolue (paper_doi absent ou non trouve via OpenAlex) : **2**
- Dont formule incomplete (variable(s) manquante(s) detectee(s)) : **0**

Ces lignes ne signifient pas encore que les datasets sont prets pour `spatialtidymodels`.
Elles alimentent la meme file de curation reproductible que journal-first/DataCite : KG -> tools/build_paper_dataset_curation_manifest.py -> loader sf -> fiche dataset -> metadata package.

| Dataset | Repo | Publication | Statut | Formule | Etape suivante |
|---|---|---|---|---|---|
| 10.25349/d9x893 | dryad | Spatial uncertainty in herbarium data: simulated displacement but not error dist | raw_data_downloaded_pending_loader | non_extraite | write sf loader in build_sf_datasets_papers.R using the downloaded files and formula_completeness evidence, then generate the fiche |
| 10.5061/dryad.236j7 | dryad | Comparative analysis of 2D and 3D distance measurements to study spatial genome  | raw_data_downloaded_pending_loader | non_extraite | write sf loader in build_sf_datasets_papers.R using the downloaded files and formula_completeness evidence, then generate the fiche |
| 10.5061/dryad.3n5tb2rqt | dryad | Season of death, pathogen persistence and wildlife behaviour alter number of ant | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5061/dryad.69p8cz94j | dryad | Detecting and reducing heterogeneity of error in acoustic classification: Data | raw_data_downloaded_pending_loader | non_extraite | write sf loader in build_sf_datasets_papers.R using the downloaded files and formula_completeness evidence, then generate the fiche |
| 10.5061/dryad.cb8gd26 | dryad | Rates of niche and phenotype evolution lag behind diversification in a temperate | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5061/dryad.k0p2ngfcc | dryad | T cell-mediated curation and restructuring of tumor tissue coordinates an effect | candidate_dataset_download_pending | non_extraite | real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually |
| 10.5061/dryad.nzs7h44s4 | dryad | Anipose: a toolkit for robust markerless 3D pose estimation | raw_data_downloaded_pending_loader | non_extraite | write sf loader in build_sf_datasets_papers.R using the downloaded files and formula_completeness evidence, then generate the fiche |
| 10.5281/zenodo.14965669 | zenodo | [dataset-first, publication non resolue] The global fish and invertebrate abunda | raw_data_downloaded_pending_loader | non_extraite | write sf loader in build_sf_datasets_papers.R using the downloaded files and formula_completeness evidence, then generate the fiche |
| 10.5281/zenodo.4090917 | zenodo | [dataset-first, publication non resolue] iSDAsoil: soil extractable Aluminium fo | raw_data_downloaded_pending_loader | non_extraite | write sf loader in build_sf_datasets_papers.R using the downloaded files and formula_completeness evidence, then generate the fiche |

## Sans publication liee resolue

- **10.5281/zenodo.14965669** : 4 fichier(s) au format donnee reelle detecte(s) | aucune publication liee dans les metadonnees du depot (relatedWorks/related_identifiers vide)
- **10.5281/zenodo.4090917** : 5 fichier(s) au format donnee reelle detecte(s) | aucune publication liee dans les metadonnees du depot (relatedWorks/related_identifiers vide)


## Related Pages

Aucune fiche wiki associee a ce rapport ; se referer aux sources listees en frontmatter.
