"""Prepare World Bank-linked literature query seeds."""

from __future__ import annotations

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import run_lit_cli


def main() -> None:
    """Entry point for the non-executed World Bank literature plan."""

    run_lit_cli(
        warehouse_id="world_bank",
        script_label="Prepare World Bank literature query plan.",
        extra_notes=(
            "World Bank datasets are often cited by both title and indicator family names, so keyword-augmented queries are intentionally retained.",
        ),
    )


if __name__ == "__main__":
    main()
