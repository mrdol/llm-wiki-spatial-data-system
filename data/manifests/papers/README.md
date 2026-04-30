# Paper Manifests

This directory is reserved for machine-readable manifests that describe how a documented paper is stored, discovered, or linked to datasets.

The directory is intentionally empty until a paper has been explicitly documented.

Expected fields for future paper manifests:

- `paper_id`
- `title`
- `raw_path`
- `publication_doi`
- `source_url`
- `linked_datasets`
- `linked_warehouses`
- `has_published_data`
- `has_code_repository`
- `transformation`

Rules:

- Do not invent DOI values.
- Do not invent dataset links.
- Use `transformation: "none"` when only the raw paper path and traceability metadata are recorded.
