# stmsn — build & publish
# run `just` (or `just --list`) to see recipes

default:
    @just --list

# pull catalog from stmsn-meta, dbt build --target prod (optionally --select), push catalog back
prod select="":
    uv run python scripts/entrypoint.py {{select}}

# build and push stmsn-runner image to Artifact Registry
publish-image:
    gcloud builds submit --tag us-central1-docker.pkg.dev/$(gcloud config get-value project)/stmsn/stmsn-runner:$(git rev-parse --short HEAD)
