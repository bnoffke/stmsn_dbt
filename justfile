# stmsn — build & publish
# run `just` (or `just --list`) to see recipes

catalog := "target/stmsn-prod.duckdb"   # must match `path:` of the prod target in profiles.yml
bucket  := "gs://stmsn-meta/catalog/stmsn.duckdb"

default:
    @just --list

# hermetic full prod build into a fresh catalog (no upload)
prod:
    rm -f {{catalog}} {{catalog}}.wal
    dbt build --target prod

# build fresh, then upload the catalog to GCS
publish: prod
    gcloud storage cp {{catalog}} {{bucket}}