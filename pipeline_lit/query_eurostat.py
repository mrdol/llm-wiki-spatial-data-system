"""Prepare Eurostat-linked literature query seeds."""

from __future__ import annotations

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import run_lit_cli


def main() -> None:
    """Entry point for the non-executed Eurostat literature plan."""

    run_lit_cli(
        warehouse_id="eurostat",
        script_label="Prepare Eurostat literature query plan.",
        extra_notes=(
            "Eurostat datasets are often cited by table code, so later ranking should boost exact code matches when they appear.",
        ),
    )


if __name__ == "__main__":
    main()
