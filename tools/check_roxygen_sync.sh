#!/usr/bin/env bash
# tools/check_roxygen_sync.sh
#
# Verifie que packages/spatialtidymodels/NAMESPACE et man/ sont synchronises
# avec les tags roxygen du code INDEXE (ce qui va etre committe).
#
# Principe : on extrait l'index (git checkout-index) dans un dossier temporaire,
# on y lance roxygen2::roxygenise(), puis on compare NAMESPACE et man/ avec
# leur version indexee. L'arbre de travail n'est jamais modifie.
#
# Appele par le hook pre-commit (LLM-wiki-Assessment/eval/hooks/pre-commit),
# seulement quand le commit touche R/*.R, DESCRIPTION, NAMESPACE ou man/*.Rd.
#
# Usage manuel :
#   bash tools/check_roxygen_sync.sh --force    # verifie l'index meme sans fichier du package indexe
# Contournement ponctuel (a eviter) :
#   SKIP_ROXYGEN_CHECK=1 git commit ...
# Pour corriger un echec :
#   Rscript -e "roxygen2::roxygenise('packages/spatialtidymodels')"
#   git add packages/spatialtidymodels/NAMESPACE packages/spatialtidymodels/man

set -euo pipefail

PKG="packages/spatialtidymodels"
FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

if [ "${SKIP_ROXYGEN_CHECK:-0}" = "1" ]; then
  echo "roxygen : verification ignoree (SKIP_ROXYGEN_CHECK=1)."
  exit 0
fi

cd "$(git rev-parse --show-toplevel)"

if [ "$FORCE" -eq 0 ]; then
  TOUCHED=$(git diff --cached --name-only --diff-filter=ACMDR \
    | grep -E "^${PKG}/(R/.*\.R|DESCRIPTION|NAMESPACE|man/.*\.Rd)$" || true)
  if [ -z "$TOUCHED" ]; then
    exit 0
  fi
fi

find_rscript() {
  if [ -n "${RSCRIPT:-}" ] && [ -x "$RSCRIPT" ]; then echo "$RSCRIPT"; return; fi
  if command -v Rscript >/dev/null 2>&1; then command -v Rscript; return; fi
  local base=""
  if command -v cygpath >/dev/null 2>&1 && [ -n "${LOCALAPPDATA:-}" ]; then
    base="$(cygpath -u "$LOCALAPPDATA")/Programs/R"
  fi
  local found
  found=$(ls -d "$base"/R-*/bin/Rscript.exe "/c/Program Files/R"/R-*/bin/Rscript.exe 2>/dev/null | sort -V | tail -1 || true)
  [ -n "$found" ] && echo "$found"
  return 0
}

RSCRIPT_BIN="$(find_rscript)"
if [ -z "$RSCRIPT_BIN" ]; then
  echo "roxygen : Rscript introuvable -- verification NON effectuee."
  echo "  Definir RSCRIPT=/chemin/vers/Rscript, ou lancer roxygen a la main avant de committer."
  exit 0
fi

echo ""
echo "roxygen -- verification de NAMESPACE et man/ (index, ~1 min)..."

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Extrait de l'index uniquement ce dont roxygen a besoin pour charger le package.
git ls-files -z -- "$PKG/DESCRIPTION" "$PKG/NAMESPACE" "$PKG/R" "$PKG/man" "$PKG/data" "$PKG/inst" \
  | xargs -0 git checkout-index --prefix="$TMP/" --

W="$TMP/$PKG"
mkdir -p "$TMP/before/man" "$W/man"
[ -f "$W/NAMESPACE" ] && cp "$W/NAMESPACE" "$TMP/before/NAMESPACE"
cp -r "$W/man/." "$TMP/before/man/" 2>/dev/null || true

if ! (cd "$W" && "$RSCRIPT_BIN" -e "roxygen2::roxygenise('.')" >"$TMP/roxygen.log" 2>&1); then
  echo "ECHEC -- roxygen2::roxygenise() a plante sur l'index (le package se charge-t-il ?)."
  tail -n 25 "$TMP/roxygen.log"
  echo "  (contournement ponctuel : SKIP_ROXYGEN_CHECK=1 git commit ...)"
  exit 1
fi

DIFFS=""
if [ -f "$TMP/before/NAMESPACE" ]; then
  diff -q --strip-trailing-cr "$TMP/before/NAMESPACE" "$W/NAMESPACE" >/dev/null 2>&1 \
    || DIFFS="$DIFFS  NAMESPACE"$'\n'
else
  DIFFS="$DIFFS  NAMESPACE (absent de l'index)"$'\n'
fi
MAN_DIFF="$(diff -rq --strip-trailing-cr "$TMP/before/man" "$W/man" 2>&1 || true)"
if [ -n "$MAN_DIFF" ]; then
  DIFFS="$DIFFS$(echo "$MAN_DIFF" | sed \
    -e "s#^Only in $W/man: \(.*\)#  man/\1 (a creer)#" \
    -e "s#^Only in $TMP/before/man: \(.*\)#  man/\1 (a supprimer)#" \
    -e "s#^Files $TMP/before/man/\(.*\) and .* differ#  man/\1 (a mettre a jour)#")"$'\n'
fi

if [ -n "$DIFFS" ]; then
  echo "BLOQUE -- NAMESPACE / man/ ne sont pas a jour par rapport aux tags roxygen indexes :"
  printf '%s' "$DIFFS" | head -n 30
  echo ""
  echo "  Corriger :"
  echo "    Rscript -e \"roxygen2::roxygenise('$PKG')\""
  echo "    git add $PKG/NAMESPACE $PKG/man"
  echo "  (contournement ponctuel : SKIP_ROXYGEN_CHECK=1 git commit ...)"
  exit 1
fi

echo "OK -- NAMESPACE et man/ synchronises avec roxygen."
exit 0
