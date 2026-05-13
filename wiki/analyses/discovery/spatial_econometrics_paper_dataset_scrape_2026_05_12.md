---
title: Spatial Econometrics Paper-Dataset Scrape - 2026-05-12
type: analysis
created: 2026-05-12
updated: 2026-05-12
sources:
  - data/manifests/papers/spatial_econometrics_paper_dataset_scrape_2026_05_12.json
tags: [analysis, discovery, papers, datasets, spatial, spatiotemporal, econometrics]
---

Scraping note for user-provided spatial econometrics papers. The goal was to identify papers that provide both modeling evidence and a traceable dataset or replication archive, without downloading datasets.

## Paper Priority Gate

New paper scraping should prioritize papers with at least 4 authors and a recognized publisher, journal, or scientific data venue. Papers with fewer than 4 authors normally remain in review, unless they have a strong exception package: recognized venue, resolvable paper DOI, resolvable dataset/archive DOI or repository package, and explicit spatial or spatio-temporal modeling evidence.

This scrape keeps several JAE papers with fewer than 4 authors because the ZBW replication archive provides unusually strong paper-to-dataset traceability.

## Confirmed Paper-Linked Dataset Routes

| paper | paper DOI | dataset/archive DOI | decision |
|---|---|---|---|
| Ertur & Koch 2007 | `10.1002/jae.963` | `10.15456/jae.2022319.0717374828` | create paper fiche with author-count exception |
| Parent & LeSage 2008 | `10.1002/jae.981` | `10.15456/jae.2022319.0719212236` | create paper fiche with author-count exception |
| Behrens, Ertur & Koch 2012 | `10.1002/jae.1231` | `10.15456/jae.2022320.0727751571` | create paper fiche with author-count exception |
| Millo 2015 | `10.1002/jae.2424` | `10.15456/jae.2022321.0721257195` | create paper fiche with author-count exception |
| Jin, Lee & Yang 2024 | `10.1002/jae.3046` | `10.15456/jae.2024045.0850271337` | create paper fiche with author-count exception |

## Review Candidates

| paper | reason kept in review |
|---|---|
| Holly, Pesaran & Yamagata 2010 | Strong spatio-temporal modeling paper, but dataset access is currently indirect through Millo 2015 replication package. |
| Dall'Erba & Le Gallo 2008 | Strong spatial regional-economics paper, but no dataset/archive DOI was confirmed during this scrape. |
| Baltagi & Li 2014 | Strong house-price extension, but no dataset/archive DOI was confirmed during this scrape. |
| Baltagi, Bresson & Etienne 2015 | Very relevant French housing pseudo-panel, but no dataset/archive DOI was confirmed during this scrape. |
| Basile et al. 2014 | Useful method/application paper using Lucas County house prices, but dataset access remains unconfirmed. |
| Geniaux & Martinetti 2018 | Useful MGWR-SAR method/application paper using Lucas County house prices, but dataset access remains unconfirmed. |
| Beck, Gleditsch & Beardsley 2006 | Spatial econometrics is present, but domain fit is weaker and dataset access remains unconfirmed. |

## Interpretation

The strongest ingestion route is through ZBW Journal Data Archive because it separates the published article DOI from a dataset/archive DOI and usually exposes replication files and code.

The house-price line should be handled carefully:

- Holly, Pesaran & Yamagata 2010 is the scientific root paper.
- Millo 2015 is the best operational ingestion route because it provides the R replication package and archive DOI.
- Baltagi & Li 2014 is useful for extension, but it should remain pending until its dataset package is found.

## Next Curation Targets

- Inspect the ZBW packages for file inventories and variable documentation.
- Create dataset fiches only after package-level metadata are checked.
- Link Holly 2010 as the root scientific paper for the Millo replication route.
- Continue searching for replication packages for the Paris housing and Baltagi-Li house-price papers.

## Related Pages

- [[zbw_journal_data_archive]]
- [[ertur_koch_2007_growth_spatial_externalities]]
- [[parent_lesage_2008_knowledge_spillovers]]
- [[behrens_ertur_koch_2012_dual_gravity]]
- [[millo_2015_house_prices_replication]]
- [[jin_lee_yang_2024_spatial_moments_employment]]
