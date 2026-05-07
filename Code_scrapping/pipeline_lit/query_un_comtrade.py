"""Prepare UN Comtrade-linked literature query seeds."""

from __future__ import annotations

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import run_lit_cli


def main() -> None:
    """Entry point for the non-executed UN Comtrade literature plan."""

    run_lit_cli(
        warehouse_id="un_comtrade",
        script_label="Prepare UN Comtrade literature query plan.",
        extra_notes=(
            "UN Comtrade is frequently cited together with classification systems such as HS or SITC, so later phases may want to expand keyword blocks using those taxonomies.",
        ),
    )


if __name__ == "__main__":
    main()
