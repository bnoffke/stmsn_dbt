from contextlib import contextmanager
from pathlib import Path

from google.cloud import storage

META_BUCKET = "stmsn-meta"
CATALOG_BLOB = "catalog/stmsn.ducklake"              # versioned catalog artifact
LOCAL_CATALOG_PATH = "./.ducklake/stmsn.ducklake"    # must match the DuckLake ATTACH in profiles.yml

# Sentinel: object does not yet exist. GCS treats if_generation_match=0
# as "only succeed if the object is absent" — the correct bootstrap guard.
_ABSENT = 0


def _blob():
    client = storage.Client()
    return client.bucket(META_BUCKET).blob(CATALOG_BLOB)


def pull_catalog() -> int:
    """
    Download the remote catalog to LOCAL_CATALOG_PATH.
    Returns the GCS generation observed at pull time, to be asserted on push.
    Returns _ABSENT (0) if the catalog does not yet exist (bootstrap run).
    """
    local = Path(LOCAL_CATALOG_PATH)
    local.parent.mkdir(parents=True, exist_ok=True)   # ./.ducklake/

    blob = _blob()
    if not blob.exists():
        # Bootstrap: no remote catalog yet. The in-memory dbt session will
        # create the metastore on first ATTACH. Clear any stale local remnants.
        local.unlink(missing_ok=True)
        Path(f"{LOCAL_CATALOG_PATH}.wal").unlink(missing_ok=True)
        return _ABSENT

    blob.reload()                       # populate blob.generation
    generation = blob.generation
    blob.download_to_filename(LOCAL_CATALOG_PATH)
    return generation


def push_catalog(if_generation_match: int) -> None:
    """
    Upload LOCAL_CATALOG_PATH back to stmsn-meta, asserting the remote object
    has not changed since pull. Raises google.api_core.exceptions.PreconditionFailed
    if the generation moved underneath us.
    """
    blob = _blob()
    blob.upload_from_filename(
        LOCAL_CATALOG_PATH,
        if_generation_match=if_generation_match,
    )


@contextmanager
def synced_catalog(push_on_failure: bool = False):
    """
    Bracket arbitrary dbt work with a single pull (on entry) and a single push
    (on exit). Optimistic concurrency via generation-match.

    push_on_failure:
        DuckLake's per-model ACID means a crashed build leaves a *consistent*
        but incomplete catalog. Default False (resume by re-running from a clean
        remote). Set True to persist partial progress.
    """
    generation = pull_catalog()
    ok = False
    try:
        yield
        ok = True
    finally:
        if ok or push_on_failure:
            push_catalog(if_generation_match=generation)
