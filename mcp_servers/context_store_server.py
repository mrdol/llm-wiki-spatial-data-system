"""MCP de stockage des sorties terminal longues ou bruyantes."""

from __future__ import annotations

import hashlib
import json
import sys
import traceback
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from mcp.server.fastmcp import FastMCP

try:
    from token_slimming import search_lines, slim_output
except ImportError:
    from mcp_servers.token_slimming import search_lines, slim_output

mcp = FastMCP("context-store")

PROJECT_ROOT = Path(__file__).parent.parent
MEMORY_DIR = PROJECT_ROOT / ".codex_memory"
OUTPUTS_DIR = MEMORY_DIR / "outputs"


def ensure_outputs_dir() -> None:
    """Crée le répertoire de stockage des sorties si nécessaire."""
    OUTPUTS_DIR.mkdir(parents=True, exist_ok=True)


def output_path(output_id: str) -> Path:
    """Construit le chemin du fichier JSON associé à une sortie stockée."""
    safe_id = "".join(char for char in output_id if char.isalnum() or char in {"_", "-"})
    return OUTPUTS_DIR / f"{safe_id}.json"


def load_output(output_id: str) -> dict[str, Any] | None:
    """Charge une sortie stockée à partir de son identifiant."""
    path = output_path(output_id)
    if not path.exists():
        return None
    return json.loads(path.read_text(encoding="utf-8"))


@mcp.tool()
def store_output(label: str, content: str) -> dict[str, Any]:
    """
    Stocke une sortie terminal complète hors contexte et retourne un résumé compact.
    Utilise cet outil quand une commande produit beaucoup de lignes.
    """
    ensure_outputs_dir()
    digest = hashlib.sha256(f"{label}\n{content}".encode("utf-8")).hexdigest()[:16]
    output_id = f"out_{digest}"
    slimmed = slim_output(content)
    payload = {
        "output_id": output_id,
        "label": label,
        "created_at": datetime.now(timezone.utc).isoformat(),
        "line_count": slimmed.original_line_count,
        "content": content,
        "summary": slimmed.summary,
    }
    output_path(output_id).write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    return {
        "output_id": output_id,
        "label": label,
        "stored": True,
        "line_count": slimmed.original_line_count,
        "summary": slimmed.summary,
        "important_lines": slimmed.important_lines,
    }


@mcp.tool()
def summarize_output(output_id: str, max_lines: int = 80) -> dict[str, Any]:
    """Résume une sortie déjà stockée sans renvoyer tout son contenu."""
    payload = load_output(output_id)
    if payload is None:
        return {"output_id": output_id, "found": False, "error": "output_not_found"}
    slimmed = slim_output(str(payload.get("content", "")), max_lines=max_lines)
    return {
        "output_id": output_id,
        "found": True,
        "label": payload.get("label"),
        "line_count": slimmed.original_line_count,
        "summary": slimmed.summary,
        "important_lines": slimmed.important_lines,
        "omitted_line_count": slimmed.omitted_line_count,
    }


@mcp.tool()
def search_output(output_id: str, query: str, limit: int = 20) -> dict[str, Any]:
    """Cherche une expression dans une sortie stockée et retourne seulement les lignes utiles."""
    payload = load_output(output_id)
    if payload is None:
        return {"output_id": output_id, "found": False, "error": "output_not_found", "matches": []}
    matches = search_lines(str(payload.get("content", "")), query=query, limit=limit)
    return {
        "output_id": output_id,
        "found": True,
        "query": query,
        "match_count": len(matches),
        "matches": matches,
    }


if __name__ == "__main__":
    try:
        ensure_outputs_dir()
        mcp.run(transport="stdio")
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        raise
