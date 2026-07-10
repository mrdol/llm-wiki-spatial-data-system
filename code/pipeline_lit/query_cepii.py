"""Prepare CEPII-linked literature query seeds."""

from __future__ import annotations

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import run_lit_cli


def main() -> None:
    """Entry point for the non-executed CEPII literature plan."""

    run_lit_cli(
        warehouse_id="cepii",
        script_label="Prepare CEPII literature query plan.",
        extra_notes=(
            "CEPII datasets are often cited by dataset family name plus version tag, so later phases should preserve version-sensitive matching.",
        ),
    )


if __name__ == "__main__":
    main()
