# Se placer sur dev

git switch dev

# Mettre dev à jour depuis le dépôt distant

git fetch origin
git pull --rebase origin dev

# Créer une branche pour ta proposition

git switch -c feature/regression-article-bibliography

# FAIRE LES MODIFICATIONS LOCALES

# Vérifier les changements

git status
git diff

# Ajouter les fichiers modifiés

git add gg/regression_article.bib gg/regression_article_audit.md

# Créer un commit

git commit -m "Add regression article bibliography audit"

# Pousser la branche de proposition

git push -u origin feature/regression-article-bibliography

# Créer une Pull Request vers dev

gh pr create \
  --base dev \
  --head feature/regression-article-bibliography \
  --title "Add regression article bibliography audit" \
  --body "Propose l'ajout d'un audit bibliographique des articles de régression associés aux jeux de données du dépôt."