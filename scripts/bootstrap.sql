-- bootstrap.sql, run once
INSTALL ducklake;
LOAD ducklake;

-- reuse the same GCS credentials / httpfs config the project already uses

ATTACH 'ducklake:.ducklake/stmsn.ducklake' AS stmsn (DATA_PATH 'gs://stmsn-lake/');

-- tier schemas; default paths land at gs://stmsn-lake/silver/ and .../gold/
CREATE SCHEMA IF NOT EXISTS stmsn.silver;
CREATE SCHEMA IF NOT EXISTS stmsn.gold;

DETACH stmsn;  -- clean detach so the file is self-contained (no dangling .wal)