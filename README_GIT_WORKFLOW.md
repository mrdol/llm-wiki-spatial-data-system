# Workflow Git collaboratif

Ce document explique comment travailler a deux sur le depot
`mrdol/llm-wiki-spatial-data-system` sans perdre les modifications de l'autre.

## Roles des branches

Organisation actuelle conseillee :

| Branche | Role | Qui l'utilise |
|---|---|---|
| `main` | Version stable / definitive | Fusion finale seulement |
| `dev` | Branche commune de travail | Johnny + encadreur |
| `ma-modif` | Branche personnelle de l'encadreur | Encadreur, avant Pull Request |

Regle simple :

```text
ma-modif -> Pull Request -> dev -> tests/revue -> Pull Request -> main
```

`main` ne doit pas recevoir des modifications non relues. Le travail courant
se fait sur `dev`.

## Premiere installation du depot

Cloner le depot :

```powershell
git clone git@github.com:mrdol/llm-wiki-spatial-data-system.git
cd llm-wiki-spatial-data-system
```

Verifier les remotes :

```powershell
git remote -v
```

Resultat attendu :

```text
origin  git@github.com:mrdol/llm-wiki-spatial-data-system.git (fetch)
origin  git@github.com:mrdol/llm-wiki-spatial-data-system.git (push)
```

Si le clone a ete fait en HTTPS et que Git demande un mot de passe, passer en
SSH :

```powershell
git remote set-url origin git@github.com:mrdol/llm-wiki-spatial-data-system.git
```

Verifier l'authentification GitHub CLI :

```powershell
gh auth status
```

Si necessaire :

```powershell
gh auth login
```

Choisir :

- `GitHub.com`
- `SSH`
- `Login with a web browser`

## Recuperer le travail commun

Avant de commencer a modifier :

```powershell
git switch dev
git pull origin dev
```

Verifier que le dossier est propre :

```powershell
git status
```

Si Git repond `working tree clean`, on peut travailler.

## Faire ses modifications sur dev

Workflow normal :

```powershell
git switch dev
git pull origin dev

# modifier les fichiers

git status
git add <fichiers>
git commit -m "Message court et explicite"
git push origin dev
```

Exemple :

```powershell
git add tools/harvest_datacite.R wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md
git commit -m "Refine DataCite harvest filters"
git push origin dev
```

## Branche personnelle de l'encadreur

Si l'encadreur veut travailler sans modifier directement `dev` :

```powershell
git switch dev
git pull origin dev
git switch -c ma-modif
```

Puis :

```powershell
# modifier les fichiers
git status
git add <fichiers>
git commit -m "Message court"
git push -u origin ma-modif
```

Ensuite, ouvrir une Pull Request sur GitHub :

```text
base: dev
compare: ma-modif
```

Une fois la Pull Request acceptee, `dev` contient aussi les modifications de
`ma-modif`.

## Recuperer une branche de l'autre

Mettre a jour toutes les references distantes :

```powershell
git fetch origin
```

Voir les branches :

```powershell
git branch -a
```

Recuperer la branche `ma-modif` :

```powershell
git switch ma-modif
git pull origin ma-modif
```

Si la branche n'existe pas encore localement :

```powershell
git switch --track origin/ma-modif
```

## Ramener ma-modif dans dev localement

Si on veut fusionner sans passer par l'interface GitHub :

```powershell
git switch dev
git pull origin dev
git merge origin/ma-modif
git push origin dev
```

En cas de conflit, Git indique les fichiers a corriger. Apres correction :

```powershell
git add <fichiers_corriges>
git commit
git push origin dev
```

## Envoyer dev vers main

Quand `dev` est stable :

1. Ouvrir une Pull Request GitHub.
2. Choisir :
   - base: `main`
   - compare: `dev`
3. Verifier les fichiers modifies.
4. Fusionner seulement si le pipeline et les tests importants passent.

Equivalent local possible :

```powershell
git switch main
git pull origin main
git merge origin/dev
git push origin main
```

Mais la Pull Request est preferable, car elle garde une trace de revue.

## Verifier les ecarts entre branches

Commits presents dans `dev` mais pas dans `main` :

```powershell
git log --oneline main..dev
```

Commits presents dans `main` mais pas dans `dev` :

```powershell
git log --oneline dev..main
```

Nombre de commits d'ecart :

```powershell
git rev-list --count main..dev
git rev-list --count dev..main
```

Voir les derniers commits sous forme de graphe :

```powershell
git log --oneline --decorate --graph --all -n 30
```

## Regles de prudence

- Toujours faire `git pull origin dev` avant de commencer.
- Ne pas travailler directement sur `main`.
- Ne pas faire `git reset --hard` sauf decision explicite.
- Ne pas versionner les secrets : `.env`, `2.env`, cles API, profils navigateur.
- Ne pas versionner les caches lourds : `data/raw/`, `data/data_retrievals/`,
  `corpus/papers/tei/`, `.kg/`.
- Apres un gros pipeline, verifier avec :

```powershell
git status
git diff --stat
```

## Commandes utiles de secours

Voir ce qui a ete modifie :

```powershell
git status
git diff
```

Annuler un fichier non stage :

```powershell
git restore <fichier>
```

Retirer un fichier du staging sans supprimer son contenu :

```powershell
git restore --staged <fichier>
```

Sauvegarder temporairement des modifications non commitees :

```powershell
git stash push -m "travail temporaire"
```

Les recuperer :

```powershell
git stash pop
```

