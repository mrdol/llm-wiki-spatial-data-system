---
title: datacite_verified_ingestion_2026-08
type: metadata
created: 2026-08-15
updated: 2026-08-15
sources:
  - tools/ingest_datacite_verified.py
tags: [metadata, ingestion, datacite]
---

# Ingestion des candidats DataCite valides

Date : 2026-08-15

- Candidats `verified_candidate` traites : **3**
- Entrees DataCite presentes dans `PaperDatasetUse` : **3**
- Derniere execution : **0** insertion(s), **3** mise(s) a jour

Ces lignes ne signifient pas encore que les datasets sont prets pour `spatialtidymodels`.
Elles creent une file d'ingestion reproductible: PDF/data -> GROBID -> KG -> fiche dataset -> metadata package.

| Dataset DOI | Publication DOI | Article | Dataset | Estimateurs detectes | Statut suivant |
|---|---|---|---|---|---|
| 10.5061/dryad.0cfxpnw7w | 10.1111/1365-2664.14526 | Numerical top-down effects on red deer ( Cervus elaphus ) are mainly shaped by humans rather than large carnivores across Europe | Data from: Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe | pending_tei | candidate_dataset_download_pending |
| 10.25384/sage.18902846.v1 | 10.1177/23998083211063885 | Uncovering spatial heterogeneity in real estate prices via combined hierarchical linear model and geographically weighted regression | sj-csv-2-epb-10.1177_23998083211063885 - Supplemental Material for Uncovering spatial heterogeneity in real estate prices via combined hierarchical linear model and geographically weighted regression | GWR | candidate_dataset_download_pending |
| 10.5066/p9pgal0d | 10.3133/sir20215015 | Methods for estimating regional skewness of annual peak flows in parts of eastern New York and Pennsylvania, based on data through water year 2013 | Regional flood skew for parts of the mid-Atlantic region (hydrologic unit 02) in eastern New York and Pennsylvania | pending_tei | candidate_dataset_download_pending |

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
