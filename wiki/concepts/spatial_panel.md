---
title: Spatial Panel
type: concept
created: 2026-04-29
updated: 2026-04-29
sources: []
tags: [concept, spatial, panel, spatiotemporal]
---

Dataset where spatial units are observed repeatedly over time.

## Definition

A spatial panel has units such as communes, regions, countries, parcels, stations, or grid cells observed across multiple periods.

Important properties:

- balanced or unbalanced panel
- number of spatial units `N`
- number of periods `T`
- spatial weights or neighborhood structure
- temporal frequency
- missing periods or changing boundaries

## Modeling Relevance

Spatial panels are strong candidates for spatial panel models, [[stvc]], [[svc]], [[mgwrsar]], [[inla]], and temporal baselines when the response variable typology is compatible.

## Related Pages

- [[spatiotemporal_data]]
- [[spatial_autocorrelation]]
- [[data_leakage]]
