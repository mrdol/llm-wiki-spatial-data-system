"""Installe le hook git pre-commit pour l'évaluation des fiches wiki.
Usage : python eval/install_hook.py
"""

import shutil
import stat
import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent
HOOK_SRC = PROJECT_ROOT / "eval" / "hooks" / "pre-commit"


def main() -> None:
    try:
        git_common_dir = subprocess.check_output(
            ["git", "rev-parse", "--git-common-dir"],
            cwd=PROJECT_ROOT,
            text=True,
        ).strip()
    except subprocess.CalledProcessError:
        print("❌ Ce répertoire n'est pas un dépôt git.", file=sys.stderr)
        sys.exit(1)

    hooks_dir = Path(git_common_dir) / "hooks"
    hooks_dir.mkdir(parents=True, exist_ok=True)

    dst = hooks_dir / "pre-commit"

    if dst.exists():
        backup = dst.with_suffix(".bak")
        shutil.copy(dst, backup)
        print(f"⚠  Hook existant sauvegardé dans {backup}")

    shutil.copy(HOOK_SRC, dst)
    dst.chmod(dst.stat().st_mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH)

    print(f"✅ Hook installé : {dst}")
    print("   Chaque commit qui modifie wiki/**/*.md déclenchera l'évaluation.")


if __name__ == "__main__":
    main()
