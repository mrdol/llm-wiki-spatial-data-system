---
title: Lessani and Li 2024 - Similarity and Geographically Weighted Regression
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/SGWR  similarity and geographically weighted regression.pdf
  - corpus/papers/tei/SGWR  similarity and geographically weighted regression.tei.xml
  - doi:10.1080/13658816.2024.2342319
tags: [paper, sgwr, gwr, similarity, spatial, formula, benchmark, grobid]
---

# Lessani and Li 2024 - SGWR

This paper proposes similarity and geographically weighted regression (SGWR),
which combines geographical proximity and attribute similarity in the weighting
scheme of GWR.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: present in `corpus/papers/tei/`
- KG node: `paper:doi:10.1080/13658816.2024.2342319`
- Incremental extraction: parsed into `.kg/extracted/zz_incremental_tei_*`

## Extracted Method

- Main method: [[sgwr]]
- Parent method: [[gwr]]
- Related method signals: [[mgwr]], spatial heterogeneity, spatial regression
- Core idea: combine a geographic weight matrix and an attribute-similarity
  weight matrix.

## Extracted Formulas

The TEI detected formulas for:

- standard GWR;
- attribute distance;
- similarity weight matrix;
- combined geographic/similarity weight matrix;
- optimal mixing weight;
- evaluation metrics.

Curated SGWR weighting signal:

```math
W_{GS} = \alpha W_G + (1-\alpha)W_S
```

Optimization signal:

```math
\alpha^\star = \arg\min_{\alpha} AICc(\alpha)
```

## Extracted Datasets

The paper contains an `Experimental datasets` section and public data/code
availability signals. The repository should be checked to formalize exact
dataset names and variable roles.

Weak automatic KG matches:

- `AER::HousePrices`
- `AER::Mortgage`
- `geodatasets::home_sales`
- `libpysal::Home Sales`
- `MASS::Cars93`
- `splm::usaww`

These matches are plausible topic signals for housing examples but remain
automatic extractions until verified against the paper and repository.

## Hyperparameters And Metrics

Hyperparameters/signals:

- GWR bandwidth;
- similarity-distance construction;
- mixing coefficient `alpha` between geographic and attribute-similarity weights.

Metrics/comparisons:

- adjusted `R2`;
- MAPE;
- MAE;
- RMSE;
- RSS;
- AICc;
- computational time;
- comparison against enhanced GWR/MGWR-style baselines.

## Code Or Repository

Code/data repository extracted from TEI:

- `https://github.com/Lessani252/SGWR`

The repository is important because it documents the expected input structure:
coordinates, dependent variable and explanatory variables.

## Reuse For The Project

This paper is useful for:

- documenting non-distance-only extensions of GWR;
- adding similarity weights as a benchmark dimension;
- checking whether repository README files can provide cleaner variable roles
  than TEI extraction alone.

## Related Pages

- [[sgwr]]
- [[gwr]]
- [[mgwr]]
- [[spatial_heterogeneity]]
