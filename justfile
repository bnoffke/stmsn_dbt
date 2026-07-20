# stmsn — build & publish
# run `just` (or `just --list`) to see recipes

# loads GCS_KEY_ID / GCS_SECRET from .env (gitignored) for profiles/profiles.yml
set dotenv-load

default:
    @just --list

# pull catalog from stmsn-meta, dbt build --target prod (optionally --select), push catalog back
prod *args="":
    uv run python scripts/entrypoint.py {{args}}

# build and push stmsn-runner image to Artifact Registry (SHA tag + latest)
publish-image:
    #!/usr/bin/env bash
    set -euo pipefail
    PROJECT=$(gcloud config get-value project)
    IMAGE="us-central1-docker.pkg.dev/${PROJECT}/stmsn/stmsn-runner"
    SHA=$(git rev-parse --short HEAD)
    gcloud builds submit --tag "${IMAGE}:${SHA}"
    gcloud artifacts docker tags add "${IMAGE}:${SHA}" "${IMAGE}:latest"

# create local dev ducklake catalog (.ducklake/dev.ducklake, data in .ducklake/dev_data/)
bootstrap-dev:
    mkdir -p .ducklake
    uv run duckdb -f scripts/bootstrap_dev.sql

# dbt against the local dev catalog (bronze still reads from GCS via .env creds)
dev *args="":
    uv run dbt build --target dev --profiles-dir profiles {{args}}
