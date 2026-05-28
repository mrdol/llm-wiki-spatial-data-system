---
title: MCP Memory Layers
type: metadata
created: 2026-05-26
updated: 2026-05-26
tags: [mcp, codebase-memory, context-store, token-compression]
sources: []
---

# MCP Memory Layers

Cette page documente les premières couches locales ajoutées au système LLM Wiki pour réduire les lectures inutiles de fichiers et les grosses sorties terminal dans le contexte.

## Emplacement Des Éléments

| Élément | Chemin | Rôle |
|---|---|---|
| Mémoire locale | `.codex_memory/` | Dossier local de stockage des index et sorties longues. |
| Index du code | `.codex_memory/code_index.sqlite` | Base SQLite générée par `index_codebase()`. |
| Sorties terminal | `.codex_memory/outputs/` | Dossier où `store_output()` sauvegarde les logs complets. |
| Serveurs MCP | `mcp_servers/` | Dossier qui regroupe les serveurs MCP locaux du projet. |
| MCP catalogue dataset | `mcp_servers/dataset_search_server.py` | Serveur MCP métier pour chercher et auditer le catalogue dataset. |
| MCP mémoire code | `mcp_servers/codebase_memory_server.py` | Serveur MCP pour interroger la carte du code. |
| MCP sorties terminal | `mcp_servers/context_store_server.py` | Serveur MCP pour stocker, résumer et chercher dans les sorties longues. |
| Compression légère | `mcp_servers/token_slimming.py` | Module commun de résumé/compression des sorties terminal. |
| MCP RTK | `mcp_servers/rtk_server.py` | Serveur MCP pour compresser directement les petites et moyennes sorties terminal. |
| Headroom local | `mcp_servers/headroom.py` | Module de compression globale des blocs de contexte. |
| MCP Headroom | `mcp_servers/headroom_server.py` | Serveur MCP pour compresser un paquet global de prompt/contexte. |
| Proxy Headroom | `mcp_servers/headroom_proxy.py` | Proxy HTTP optionnel vers l'API OpenAI. |
| Configuration lint | `pyproject.toml` | Exclut `.codex_memory/` du lint Ruff. |

## Couche 1: Codebase Memory MCP

Le fichier `mcp_servers/codebase_memory_server.py` expose une mémoire structurelle du projet.

Son objectif est d'éviter qu'un agent lise tous les fichiers avec des recherches brutes quand une question porte sur la structure du code.

### `index_codebase()`

Scanne le dépôt et reconstruit `.codex_memory/code_index.sqlite`.

Il indexe:

- les fichiers Python, R et Markdown utiles;
- les fonctions Python;
- les classes Python;
- les fonctions R simples;
- les imports Python;
- les appels de fonctions Python détectés par AST.

À lancer après des changements importants dans le code.

### `find_symbol(name)`

Cherche où une fonction, une classe ou un symbole est défini.

Exemple d'usage:

```text
find_symbol("validate_dataset_record")
```

Réponse attendue: fichier, ligne, type de symbole, parent éventuel, docstring.

### `who_calls(symbol)`

Liste les endroits où une fonction semble appelée.

Exemple d'usage:

```text
who_calls("compute_metadata_richness")
```

Cette fonction est utile avant de modifier une fonction partagée.

### `architecture_summary()`

Retourne une vue d'ensemble de l'architecture indexée:

- nombre de fichiers;
- répartition par dossier;
- types de symboles;
- imports fréquents;
- points d'entrée probables.

## Couche 2: Context Store MCP

Le fichier `mcp_servers/context_store_server.py` expose un stockage local des sorties terminal.

Son objectif est d'éviter d'injecter de longues sorties dans le contexte. La sortie complète est sauvegardée dans `.codex_memory/outputs/`, puis seul un résumé compact est renvoyé.

### `store_output(label, content)`

Stocke une sortie complète dans `.codex_memory/outputs/`.

Retourne:

- un `output_id`;
- le nombre de lignes;
- un résumé;
- les lignes importantes détectées.

### `summarize_output(output_id)`

Recharge une sortie stockée et produit un résumé compact.

À utiliser quand l'agent a besoin de revoir un log sans tout remettre dans le contexte.

### `search_output(output_id, query)`

Cherche une expression dans une sortie stockée.

Exemple:

```text
search_output("out_...", "AssertionError")
```

Retourne uniquement les lignes qui correspondent.

## Couche 3: RTK / Rust Token Killer

La couche RTK repose sur deux fichiers:

- `mcp_servers/token_slimming.py`: moteur interne de compression légère;
- `mcp_servers/rtk_server.py`: serveur MCP appelable directement par l'agent.

Elle sert aux sorties petites et moyennes qui ne justifient pas un stockage complet dans `context-store`.

Le moteur contient notamment:

- `slim_output()`: résume une sortie courte ou moyenne;
- `search_lines()`: cherche dans une sortie;
- des résumés spécialisés pour `git status`, `pytest` et `ruff`;
- une suppression simple des lignes répétitives.

Le serveur MCP expose:

### `slim_terminal_output(content, label, max_lines)`

Compresse une sortie terminal brute sans la stocker.

### `slim_command_result(command, stdout, stderr, returncode, max_lines)`

Compresse un résultat de commande structuré et conserve:

- la commande;
- le code retour;
- les lignes importantes;
- un indicateur `has_error`.

Cette couche est volontairement plus légère que `context-store`: elle ne persiste rien.

## Couche 4: Headroom

La couche Headroom compresse ce qui reste juste avant l'appel modèle: historique, sorties d'outils, fichiers lus, instructions ou blocs de configuration.

Elle repose sur trois fichiers:

- `mcp_servers/headroom.py`: fonctions de compression globale;
- `mcp_servers/headroom_server.py`: serveur MCP pour compresser un paquet de contexte;
- `mcp_servers/headroom_proxy.py`: proxy HTTP optionnel pour relayer `/v1/responses` ou `/v1/chat/completions` vers OpenAI après compression.

### `estimate_context_tokens(text)`

Retourne une estimation simple du nombre de tokens d'un bloc.

### `compress_context_block(name, content, max_lines)`

Compresse un seul bloc de contexte. Les sorties terminal sont détectées et envoyées vers `token_slimming`; les textes généraux gardent les titres, le début et la fin.

### `compress_prompt(bundle, max_lines_per_block)`

Compresse un paquet global comme:

```json
{
  "system": "...",
  "messages": [{"role": "user", "content": "..."}],
  "tool_outputs": "...",
  "files": "...",
  "config": "..."
}
```

La réponse contient:

- `compressed`: le paquet prêt à envoyer;
- `metrics`: estimation des tokens avant/après, ratio de compression et détail par bloc.

### Proxy HTTP optionnel

Le proxy se lance avec:

```powershell
..\.venv\Scripts\python.exe mcp_servers\headroom_proxy.py --port 8787
```

Il accepte `POST /v1/responses` et `POST /v1/chat/completions`, compresse le JSON de requête, puis relaie vers `https://api.openai.com`.

Ce proxy n'est pas activé automatiquement par Claude Code ou Codex. Il devient effectif seulement si le client est configuré pour utiliser `http://127.0.0.1:8787/v1/responses` ou `http://127.0.0.1:8787/v1/chat/completions` comme point de passage.

## Notes D'Activation MCP

Les fichiers serveurs sont présents dans le dépôt, mais ils doivent être déclarés dans la configuration MCP du client pour apparaître comme outils appelables.

Commandes serveur attendues:

```powershell
..\.venv\Scripts\python.exe mcp_servers\dataset_search_server.py
..\.venv\Scripts\python.exe mcp_servers\codebase_memory_server.py
..\.venv\Scripts\python.exe mcp_servers\context_store_server.py
..\.venv\Scripts\python.exe mcp_servers\rtk_server.py
..\.venv\Scripts\python.exe mcp_servers\headroom_server.py
```

Après modification de la configuration MCP, il faut généralement redémarrer ou recharger la session pour que les nouveaux outils apparaissent.

## Politique De Stockage

Tout ce qui est généré automatiquement est stocké dans `.codex_memory/`.

Ce dossier contient de l'état local:

- l'index SQLite peut être reconstruit avec `index_codebase()`;
- les sorties stockées sont des artefacts de session;
- le dossier ne doit pas être utilisé comme source canonique de vérité.

Les sources canoniques restent:

- le code Python/R;
- `data/catalogue_datasets.json`;
- les fiches `wiki/`;
- les manifestes `data/manifests/`.

## Related Pages

- [[catalog_registry_schema_v3]]
- [[dataset_catalog_schema_v2]]
- [[eval_system_documentation]]
