# Architecture MCP Locale

```text
llm-wiki-karpathy/                         # Racine du projet LLM Wiki.
  mcp_servers/                             # Code des serveurs MCP locaux.
    dataset_search_server.py               # MCP métier: recherche, audit et validation du catalogue dataset.
    codebase_memory_server.py              # MCP mémoire code: indexe les fichiers, symboles, imports et appels.
    context_store_server.py                # MCP contexte: stocke les grosses sorties terminal et renvoie des résumés.
    token_slimming.py                      # Module interne: compresse les logs et extrait les lignes importantes.
    rtk_server.py                          # MCP RTK: compresse les petites et moyennes sorties terminal sans stockage.
    headroom.py                            # Module interne: compression globale de blocs de contexte.
    headroom_server.py                     # MCP Headroom: compresse un paquet global de prompt/contexte.
    headroom_proxy.py                      # Proxy HTTP optionnel vers l'API OpenAI.
    MCP_ARCHITECTURE.md                    # Documentation courte de cette architecture MCP.

  .codex_memory/                           # Stockage local généré par les MCP de mémoire.
    code_index.sqlite                      # Index SQLite créé par index_codebase().
    outputs/                               # Sorties terminal stockées par store_output().

  data/                                    # Catalogue dataset, manifestes et données structurées.
  wiki/                                    # Fiches Markdown du LLM Wiki.
  Code_scrapping/                          # Scripts Python/R de scraping, extraction et préparation.
```
