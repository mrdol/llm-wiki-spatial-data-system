---
title: Demandes de valeurs foncieres geolocalisees
type: dataset
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [dataset, data.gouv, DVF, geospatial, property, spatio-temporal, metadata]
---

Geolocated open property-transaction dataset with parcel-level identifiers, coordinates, mutation dates, and rich administrative metadata.

## Dataset Name

- Demandes de valeurs foncieres geolocalisees

## Source / Warehouse

- Warehouse: [[data_gouv]]
- Provider on platform: data.gouv.fr
- Upstream producer family: DGFiP / Ministeres economiques et financiers
- Official dataset page: [Demandes de valeurs foncieres geolocalisees](https://www.data.gouv.fr/datasets/demandes-de-valeurs-foncieres-geolocalisees/)

## Why It Is Useful for Metadata Enrichment

- It is a strong example of parcel-level spatial metadata combined with event dates and administrative geography.
- It exposes a rich schema with identifiers, address fields, cadastral keys, local-type codes, land-use codes, and WGS-84 coordinates.
- It is useful for testing metadata fields about geocoding provenance, administrative normalization, event-time structure, and file-level distribution by department or commune.

## Structured Metadata

### Variables

- `id_mutation`
- `date_mutation`
- `numero_disposition`
- `nature_mutation`
- `valeur_fonciere`
- `adresse_numero`
- `adresse_suffixe`
- `adresse_code_voie`
- `adresse_nom_voie`
- `code_postal`
- `code_commune`
- `nom_commune`
- `code_departement`
- `id_parcelle`
- `type_local`
- `surface_reelle_bati`
- `nombre_pieces_principales`
- `nature_culture`
- `nature_culture_speciale`
- `surface_terrain`
- `longitude`
- `latitude`

### Classifications

- Normalized INSEE commune codes
- FANTOIR road-code normalization
- Parcel identifiers compatible with cadastral files
- Local type codes
- Land-use and special land-use codes

### Spatial Units

- France excluding Alsace, Moselle, and Mayotte in the raw DVF dissemination described on data.gouv
- Department
- Commune
- Parcel
- WGS-84 coordinates

### Time Dimension

- `date_mutation` at transaction-event level
- Rolling open-data dissemination covering the last five years in the main DVF release

### Frequency

- Semiannual refresh on the platform in April and October

## Data Type

- Spatio-temporal transactional dataset

## Structure

- Event-level panel of property transactions indexed by mutation date and parcel-localization fields

## N (observations)

- Very large; raw files are explicitly described as volumineux

## T (time periods)

- Rolling five-year window in the main open-data publication

## N/T Profile

- N very large, T medium

## Spatial Resolution

- Parcel-level, commune-level, department-level, and coordinate-level support

## Temporal Resolution

- Transaction date

## Spatial Extent

- France with exclusions documented on the official page

## Time Range

- Since 2014 in the geolocated derivative description, with rolling dissemination over recent years

## Reproducibility

- Good reproducibility through versioned platform files, documented schema fields, and explicit refresh schedule.

## Access Conditions

- Public portal download on data.gouv.fr
- Department or commune delivery is documented on the geolocated page
- Main raw DVF publication distributes yearly `txt.zip` files and accompanying documentation

## Limitations

- Platform documentation warns about legal constraints around re-identification and indexing by external search engines.
- Geocoding coverage is incomplete for some parcels due to cadastral vector availability or parcel changes.
- The geolocated dataset is a derived dissemination layer and should be distinguished from the upstream raw DVF publication.

## Related Pages

- [[data_gouv]]
- [[overview]]
- [[dataset_catalog_schema_v2]]
