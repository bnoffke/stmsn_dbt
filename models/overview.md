{% docs __overview__ %}

# Strong Towns Madison — Data Warehouse

This dbt project powers **[Strong Towns Madison](https://www.strongtownsmadison.org/)
advocacy with data**. Its goal is to turn the City of Madison's open geospatial
and assessment data into clear, defensible evidence for a more financially
resilient, productive, and people-oriented city — measuring how land is used,
what it's worth, what it pays in taxes, and how much of it we've paved.

Every model here is built to answer the kinds of questions Strong Towns asks:
*Which places produce the most value per acre? Who's subsidizing whom? How much
of a district is dedicated to moving and storing cars versus serving people?*

## What's inside

The project follows a **bronze → staging → silver → gold** medallion layout,
built on [DuckDB](https://duckdb.org/) with the `spatial` extension and
materialized into a [DuckLake](https://ducklake.select/) lakehouse: the catalog
lives in `gs://stmsn-meta` (synced around each build with optimistic
concurrency), and silver/gold tables land as Parquet under `gs://stmsn-lake/`.
Geometries are stored in Madison's local projection
(`EPSG:8193`) for accurate area/length math and reprojected to `EPSG:4326` for
web mapping.

- **Bronze** (`sources`) — raw City of Madison data landed as Parquet on Google
  Cloud Storage: ArcGIS parcels, streets, impervious surfaces, alder-district /
  area-plan / TOD overlays; the published tax roll; assessor MLS extracts; plus
  backfill and legacy lakes-and-rivers reference data.
- **Staging** (`stg_*`, views) — cleans and conforms each source: renaming
  columns, fixing lot sizes, unioning historically broken lots, resolving
  changing tax-roll schemas, cleaning addresses, and spatially joining features
  to their alder district and area plan.
- **Silver** (`fact_parcels`, `fact_streets`, `fact_tax_roll`,
  `fact_route_traffic`) — conformed, parcel- and segment-grain fact tables
  combining geometry, assessment, tax, and traffic attributes, written to the
  `silver` schema in DuckLake.
- **Gold** — analysis-ready rollups with the metrics advocacy runs on:
  - `fact_sites` — parcels grouped into real-world *sites*, with value-per-acre,
    land-share, tax-rate, and land-value-alignment metrics.
  - `fact_alder_districts` — one row per Common Council district per year,
    rolling up parcels, streets, and impervious surfaces.
  - `fact_area_plans` — the same rollups by neighborhood/area plan.

## How to use this site

Use the **lineage graph** (bottom-right) to trace any metric back from gold to
its raw source, and browse a model to see its column-level descriptions. Column
definitions are shared across models via dbt `docs` blocks, so a term means the
same thing everywhere it appears.

---

**Project:** [github.com/bnoffke/stmsn-dbt](https://github.com/bnoffke/stmsn-dbt)
&nbsp;·&nbsp; **Maintainer:** Ben Noffke ([bnoffke3790@gmail.com](mailto:bnoffke3790@gmail.com))
&nbsp;·&nbsp; **Strong Towns Madison:** [strongtownsmadison.org](https://www.strongtownsmadison.org/)

{% enddocs %}
