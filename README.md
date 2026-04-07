# LLM Wiki (Karpathy Pattern)

A personal knowledge base built and maintained by LLMs, based on [Andrej Karpathy's LLM Wiki pattern](https://github.com/karpathy/llm-wiki).

Instead of retrieving raw documents on every query (like traditional RAG), the LLM **incrementally builds a persistent, interlinked wiki** from your sources. Knowledge is compiled once and kept current — not re-derived every time you ask a question.

## How It Works

There are three layers:

- **Raw sources** (`raw/`) — your curated collection of source documents. The LLM reads from them but never modifies them.
- **The wiki** (`wiki/`) — LLM-generated markdown pages: summaries, glossaries, concept pages, and cross-references. The LLM owns this layer entirely.
- **The schema** (`CLAUDE.md`) — instructions that tell the LLM how the wiki is structured, what conventions to follow, and what workflows to use.

## Getting Started

1. Open this repo in [Cursor](https://cursor.sh/) (or any LLM-powered editor)
2. Open [Obsidian](https://obsidian.md/) pointed at the same directory to browse the wiki in real time
3. Drop a source document into `raw/`
4. Tell the LLM: *"ingest [filename]"*

The LLM will read the source, write wiki pages, update the index, and maintain cross-references automatically.

## Core Operations

| Operation | What happens |
|-----------|-------------|
| **Ingest** | Drop a file into `raw/`, tell the LLM to process it. It writes summaries, updates pages, and logs the action. |
| **Query** | Ask questions against the wiki. The LLM finds relevant pages and synthesizes answers. Good answers get filed back as new pages. |
| **Lint** | Ask the LLM to health-check the wiki — find contradictions, orphan pages, stale claims, and missing cross-references. |

## Wiki Structure

```
wiki/
├── index.md      # Master catalog of all pages (LLM reads this first)
├── overview.md    # High-level synthesis of the knowledge base
├── glossary.md    # Terminology and definitions
└── log.md         # Chronological record of ingests and queries
```

## Tips

- Use **Obsidian Web Clipper** to convert web articles to markdown for easy ingestion
- Use **Obsidian's graph view** to visualize how wiki pages connect
- The wiki is just a git repo of markdown files — you get version history for free

## Credits

- Pattern by [Andrej Karpathy](https://github.com/karpathy/llm-wiki)
- Article and implementation by Balu Kosuri
