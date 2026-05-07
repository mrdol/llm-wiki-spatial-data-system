"""Prepare INSEE-linked literature query seeds."""

from __future__ import annotations

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import run_lit_cli


def main() -> None:
    """Entry point for the non-executed INSEE literature plan."""

    run_lit_cli(
        warehouse_id="insee",
        script_label="Prepare INSEE literature query plan.",
        extra_notes=(
            "INSEE-linked papers may cite series names rather than dataset pages, so title and keyword variants should both be kept.",
        ),
    )


if __name__ == "__main__":
    main()
