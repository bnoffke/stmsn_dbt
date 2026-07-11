# stmsn — build & publish
# run `just` (or `just --list`) to see recipes

default:
    @just --list

# pull catalog from stmsn-meta, dbt build --target prod (optionally --select), push catalog back
prod select="":
    STMSN_SELECT="{{select}}" uv run python scripts/entrypoint.py
