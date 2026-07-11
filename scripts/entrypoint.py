import os
import subprocess

from catalog import synced_catalog

TARGET = "prod"   # fixed fact about this runner — not parameterized


def run_build(select: str) -> None:
    cmd = ["dbt", "build", "--target", TARGET]
    if select:
        cmd += ["--select", select]
    subprocess.run(cmd, check=True)


def main() -> None:
    selects = [s.strip() for s in os.environ.get("STMSN_SELECT", "").split(",") if s.strip()]
    push_on_failure = os.environ.get("STMSN_PUSH_ON_FAILURE") == "1"

    with synced_catalog(push_on_failure=push_on_failure):
        if not selects:
            run_build("")
        else:
            for sel in selects:
                run_build(sel)


if __name__ == "__main__":
    main()
