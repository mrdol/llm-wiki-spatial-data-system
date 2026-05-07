"""Prepare data.gouv.fr-linked literature query seeds."""

from __future__ import annotations

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import run_lit_cli


def main() -> None:
    """Entry point for the non-executed data.gouv.fr literature plan."""

    run_lit_cli(
        warehouse_id="data_gouv",
        script_label="Prepare data.gouv.fr literature query plan.",
        extra_notes=(
            "Because data.gouv is a dissemination layer, later phases should separate producer mentions from portal mentions in scoring.",
        ),
    )


if __name__ == "__main__":
    main()
