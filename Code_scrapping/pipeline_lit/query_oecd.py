"""Prepare OECD-linked literature query seeds."""

from __future__ import annotations

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import run_lit_cli


def main() -> None:
    """Entry point for the non-executed OECD literature plan."""

    run_lit_cli(
        warehouse_id="oecd",
        script_label="Prepare OECD literature query plan.",
        extra_notes=(
            "OECD papers and publications may reference discontinued series titles without current API identifiers, so exact title retention matters.",
        ),
    )


if __name__ == "__main__":
    main()
