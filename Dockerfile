FROM python:3.13-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# git required to install stmsn-catalog from GitHub
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev

COPY . .

RUN uv run dbt deps --profiles-dir .github/ci-profiles

ENTRYPOINT ["uv", "run", "python", "scripts/entrypoint.py"]
