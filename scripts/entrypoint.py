import argparse
import subprocess

from stmsn_catalog import synced_catalog

TARGET = "prod"   # fixed fact about this runner — not parameterized
PROFILES_DIR = "profiles"


def run_build(select: str) -> None:
    cmd = ["dbt", "build", "--target", TARGET, "--profiles-dir", PROFILES_DIR]
    if select:
        cmd += ["--select", select]
    subprocess.run(cmd, check=True)


def main() -> None:
    parser = argparse.ArgumentParser(description="Run dbt build with catalog sync.")
    parser.add_argument(
        "select",
        nargs="*",
        help="dbt node selector(s), e.g. tag:daily or source:routes+",
    )
    parser.add_argument("--push-on-failure", action="store_true")
    args = parser.parse_args()

    with synced_catalog(push_on_failure=args.push_on_failure):
        if not args.select:
            run_build("")
        else:
            for sel in args.select:
                run_build(sel)


if __name__ == "__main__":
    main()
