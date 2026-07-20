-- bootstrap_dev.sql — create a local dev DuckLake catalog for testing.
-- Run once (or after deleting .ducklake/dev*):
--   uv run duckdb -f scripts/bootstrap_dev.sql
-- Data lands in .ducklake/dev_data/ instead of gs://stmsn-lake/, so dbt builds
-- against the dev target never touch prod tables.
INSTALL ducklake;
LOAD ducklake;

ATTACH 'ducklake:.ducklake/dev.ducklake' AS stmsn (DATA_PATH '.ducklake/dev_data/');

CREATE SCHEMA IF NOT EXISTS stmsn.silver;
CREATE SCHEMA IF NOT EXISTS stmsn.gold;

DETACH stmsn;  -- clean detach so the file is self-contained (no dangling .wal)
