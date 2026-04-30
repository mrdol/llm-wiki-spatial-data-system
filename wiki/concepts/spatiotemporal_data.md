---
title: Spatiotemporal Data
type: concept
created: 2026-04-29
updated: 2026-04-29
sources: []
tags: [concept, spatial, temporal, data]
---

Data where observations are indexed by both space and time.

## Definition

Spatiotemporal data combine a spatial support with a temporal support. The spatial support may be points, polygons, grids, networks, trajectories, or administrative units. The temporal support may be timestamps, periods, panels, events, or repeated snapshots.

## Modeling Relevance

Spatiotemporal structure can make estimators such as [[stvc]], [[svc]], [[mgwr]], [[mgwrsar]], [[inla]], [[rnn]], or engineered-feature [[svm]] plausible, depending on `Y` type, temporal depth, spatial resolution, and dependence structure.

## Related Pages

- [[spatial_panel]]
- [[spatial_autocorrelation]]
- [[variable_typology]]
