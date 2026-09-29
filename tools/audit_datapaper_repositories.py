#!/usr/bin/env python3
"""Static audit of the code/data repositories attached to the 20 reviewed data papers.

Determines, with located evidence (repository URL, commit or version, file,
lines), how each resource was assembled, documented, transformed, checked,
versioned and published. It does NOT rerun benchmarks and never executes
third-party code.

    python tools/audit_datapaper_repositories.py inventory --paper DP17
    python tools/audit_datapaper_repositories.py inspect   --paper DP17
    python tools/audit_datapaper_repositories.py report
    python tools/audit_datapaper_repositories.py run --paper DP17,DP19,DP15

Outputs go to extensions_projet_2026-09/revue_jeux_donnees_benchmark/repo_audit/
(manifest.tsv, evidence.jsonl, comparaison_methodes_collecte.tsv, rapport.md,
cache/). Re-running a command resumes an interrupted run. Set GITHUB_TOKEN to
lift the 60 requests/hour anonymous GitHub API limit; without it the tool falls
back to blobless partial clones.
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from datapaper_repo_audit.cli import main  # noqa: E402

if __name__ == "__main__":
    raise SystemExit(main())
