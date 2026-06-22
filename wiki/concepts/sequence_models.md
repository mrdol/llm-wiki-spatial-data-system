---
title: Sequence Models
type: concept
created: 2026-06-04
updated: 2026-06-04
sources:
  - Elman 1990, doi:10.1207/s15516709cog1402_1
  - Hochreiter and Schmidhuber 1997, doi:10.1162/neco.1997.9.8.1735
tags: [concept, temporal, sequence, rnn]
---

Sequence models learn from ordered observations. RNNs, GRUs and LSTMs are
relevant only when a dataset supports meaningful temporal or event windows.

## Modeling Relevance

For spatial panels, sequence models require enough temporal depth and a
validation design that prevents future-to-past leakage.

## Related Pages

- [[rnn]]
- [[spatiotemporal_data]]
- [[data_leakage]]
