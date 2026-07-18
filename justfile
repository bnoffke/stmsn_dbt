# stmsn — build & publish
# run `just` (or `just --list`) to see recipes

default:
    @just --list

# pull catalog from stmsn-meta, dbt build --target prod (optionally --select), push catalog back
prod select="":
    uv run python scripts/entrypoint.py {{select}}

# build and push stmsn-runner image to Artifact Registry (SHA tag + latest)
publish-image:
    #!/usr/bin/env bash
    set -euo pipefail
    PROJECT=$(gcloud config get-value project)
    IMAGE="us-central1-docker.pkg.dev/${PROJECT}/stmsn/stmsn-runner"
    SHA=$(git rev-parse --short HEAD)
    gcloud builds submit --tag "${IMAGE}:${SHA}"
    gcloud artifacts docker tags add "${IMAGE}:${SHA}" "${IMAGE}:latest"
