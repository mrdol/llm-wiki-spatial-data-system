"""Produire ou mettre a jour des pages wiki depuis le KG.

Ce script ne doit pas remplacer les syntheses humaines sans validation.
Il servira a proposer des pages ou sections a relire.
"""

from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
WIKI_DIR = ROOT / "wiki"


def main() -> None:
    print(f"Wiki directory: {WIKI_DIR}")


if __name__ == "__main__":
    main()

