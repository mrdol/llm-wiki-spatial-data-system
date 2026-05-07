# Test Framework

The tests are split into two families.

## Fast deterministic tests

These tests do not use the network:

```powershell
pytest tests/unit tests/validation
```

They check JSON structure, required metadata fields, DOI format, manifest URL format, wiki links, licenses, and estimator-policy consistency.
They also check the `quality_pedigree` control matrix: every active catalog record must have bounded scores, textual evidence for each score, a valid Delta1 risk, and a human-review gate.
When citation metrics are present, tests check that citation counts are non-negative, dated when recorded, sourced, and interpreted as a decision signal rather than an automatic quality verdict.

## External validation tests

These tests use the network and are disabled by default:

```powershell
$env:RUN_EXTERNAL_VALIDATION="1"
$env:EXTERNAL_VALIDATION_LIMIT="25"
pytest tests/validation/test_external_catalog_integrity.py
```

They check that:

- DOI values resolve through `doi.org`;
- DOI metadata roughly match local paper or dataset titles when available;
- DOI type is compatible with the local field name when possible;
- catalog and manifest HTTP/HTTPS URLs respond online;
- explicit license metadata is coherent;
- license URLs respond online when they are documented;
- known open or restrictive license names match the stored openness flag.

External tests can fail because of network issues, rate limits, server outages, redirects, or metadata differences. They are reliability checks, not a replacement for human scientific review.

## Human quality review

The LLM can propose `quality_pedigree` scores, but it must leave `review_status` as `pending` until the user or supervisor validates the evaluation.

Use:

```text
tests/evaluation/quality_pedigree_review_grid.md
```

to manually review a proposed score set before changing a record to `reviewed`.
