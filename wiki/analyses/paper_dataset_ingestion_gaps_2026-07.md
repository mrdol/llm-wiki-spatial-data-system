# Papiers du corpus avec datasets spatiaux non encore ingérés

Date : 2026-07-27

Cette liste est issue des usages papier-dataset curés dans `inst/kg/paper_dataset_uses.json`.
Elle ne reprend pas les simples cooccurrences TEI non validées.

## Top-down scale approaches for multiscale GWR with locally adaptive bandwidths

- DOI papier : `10.1007/s10109-025-00481-4`
- BibTeX key : `Geniaux2026TopDownScale`

| Dataset | Statut | Thème | n | Covariables | Source | Pourquoi il reste à faire |
|---|---|---|---:|---:|---|---|
| Clearwater | `catalog_only_needs_reconciliation` | Landslide | 239 | 6 | PySAL example datasets; Geniaux (2026), Table 5 | Geniaux (2026), Table 5 lists Clearwater as a real dataset with theme Landslide, size 239 and 6 covariates. The current KG catalog has a Clearwater record but reports a different local n, so it must be reconciled before package ingestion. |
| Tokyo | `catalog_only_needs_reconciliation` | Mortality | 262 | 5 | PySAL example datasets; Geniaux (2026), Table 5 | Geniaux (2026), Table 5 lists Tokyo as a real dataset with theme Mortality, size 262 and 5 covariates. The current KG catalog has a Tokyo record but fewer variables, so it must be reconciled before package ingestion. |
| Berlin | `catalog_only_source_not_extracted` | Airbnb rental price | 2203 | 3 | PySAL example datasets; Geniaux (2026), Table 5 | Geniaux (2026), Table 5 lists Berlin as a real dataset with theme Airbnb rental price, size 2203 and 3 covariates. The current KG catalog has a Berlin record but the vector file was not found during extraction. |
| VaucluseHousePrice | `not_ingested_source_known` | House price | 3215 | 12 | DVF / data.gouv.fr; Geniaux (2026), Table 5 and text around p. 29 | Geniaux (2026), p. 29 states that VaucluseHousePrice comes from the French DVF real estate transaction database and contains house sales in small municipalities in Vaucluse; Table 5 gives size 3215 and 12 covariates. |
| KingHousePrices | `not_ingested_source_known` | House price | 18788 | 8 | Kaggle House Sales Prediction; Geniaux (2026), Table 5 | Geniaux (2026), Table 5 lists KingHousePrices as a real dataset with theme House price, size 18788 and 8 covariates; p. 29 points to Kaggle and the reproduction GitHub repository. |
| NYCAirBnb | `not_ingested_source_known` | Airbnb rental price | 38782 | 7 | Kaggle New York City Airbnb Open Data; Geniaux (2026), Table 5 | Geniaux (2026), Table 5 lists NYCAirBnb as a real dataset with theme Airbnb rental price, size 38782 and 7 covariates; p. 29 points to Kaggle and the reproduction GitHub repository. |
