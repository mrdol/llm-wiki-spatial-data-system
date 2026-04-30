---
title: Two-Way International Trade (Pagoulatos and Sorensen, 1975)
type: source
created: 2026-04-21
updated: 2026-04-21
sources: [pagoulatos1975.pdf]
tags: [international-trade, intra-industry-trade, econometrics, methodology]
---

Empirical article testing determinants of intra-industry (two-way) trade in U.S. manufacturing and clarifying how measurement choices shape interpretation.

## Citation Context

- Authors: Emilio Pagoulatos and Robert Sorensen
- Year: 1975
- Topic: two-way (intra-industry) trade in differentiated manufactures
- Empirical scope: U.S. manufacturing, 102 SITC 3-digit industries, 1963-1967

## Research Question

- Is simultaneous export and import of the same commodity mainly a statistical artifact from aggregation, or a real trade phenomenon explained by market structure and policy variables?

## Conceptual Frame

- Builds on Gray's model of differentiated products under imperfect competition.
- Introduces the condition of reciprocal export price ranges (EPRs) to explain two-way trade.
- Proposes that similarities between countries (income, costs, barriers) can increase two-way trade.

## Methodology and Variables

- Baseline indicator: Grubel-Lloyd-type intra-industry trade index per industry (`Bi`), bounded in [0, 100].
- Main model: multivariate double-log regression for `Bi`.
- Explanatory dimensions:
  - aggregation intensity (`SITCi`)
  - similarity in income (`ISi`, OECD trade share proxy)
  - tariff and non-tariff barrier levels (`HTBi`, `HNTBi`)
  - tariff and non-tariff similarity (`TDi`, `NTBDi`)
  - transport-cost proxy (`MDSi`, mean distance shipped)
  - product differentiation proxy (`PDDi`, dummy based on unit-value dispersion)
- Extension: multinational activity proxy (`MNi`) added to test substitution of FDI for exports.

## Main Findings

- Two-way trade is quantitatively important and increasing over time in the sample period.
- Strong support for roles of income similarity, tariff structure, transport-cost conditions, and some aggregation effects.
- Product differentiation proxy has expected sign but weak significance; potential measurement limitations are discussed.
- Additional regression suggests multinational activity may reduce observed two-way trade (FDI-export substitution channel).

## Implications for Dataset Construction and Metadata

- Distinguish clearly between phenomenon and measurement artifact:
  - keep a variable for industry aggregation depth (3-digit vs 4-digit decomposition),
  - track classification versions (e.g., SITC revision).
- Represent transformed indices explicitly:
  - formula field,
  - valid range and interpretation rules (0 to 100),
  - edge-case behavior (`X=0` or `M=0`).
- Document proxy variables with provenance and assumptions:
  - each proxy requires a "theory link", source, and known weaknesses.
- Preserve comparability metadata:
  - partner-country set,
  - period coverage,
  - tariff/non-tariff source heterogeneity,
  - cross-sectional versus panel design choices.
- Add a flag for potential construct contamination:
  - e.g., aggregation-induced inflation of intra-industry trade.

## Limitations Highlighted by the Source

- Imperfect observability of key constructs (especially product differentiation and non-tariff barriers).
- Proxy choices can alter significance and interpretation.
- Cross-sectional design reduces leverage on dynamic mechanisms.

## Related Pages

- [[grubel_lloyd_index]]
- [[pagoulatos1975_methodology_to_metadata]]

