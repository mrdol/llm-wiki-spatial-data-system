"""MCP Headroom pour compresser le contexte global avant un appel modèle."""

from __future__ import annotations

import sys
import traceback
from typing import Any

from mcp.server.fastmcp import FastMCP

try:
    from headroom import compress_prompt_bundle, compress_text_block, estimate_tokens
except ImportError:
    from mcp_servers.headroom import compress_prompt_bundle, compress_text_block, estimate_tokens

mcp = FastMCP("headroom")


@mcp.tool()
def estimate_context_tokens(text: str) -> dict[str, Any]:
    """Estime grossièrement le nombre de tokens d'un bloc de contexte."""
    return {"characters": len(text), "estimated_tokens": estimate_tokens(text)}


@mcp.tool()
def compress_context_block(name: str, content: str, max_lines: int = 120) -> dict[str, Any]:
    """Compresse un bloc de contexte: historique, sortie d'outil, configuration ou fichier."""
    block = compress_text_block(name=name, text=content, max_lines=max_lines)
    return {
        "name": block.name,
        "content": block.content,
        "original_chars": block.original_chars,
        "compressed_chars": block.compressed_chars,
        "estimated_original_tokens": block.estimated_original_tokens,
        "estimated_compressed_tokens": block.estimated_compressed_tokens,
    }


@mcp.tool()
def compress_prompt(
    bundle: dict[str, Any],
    max_lines_per_block: int = 120,
) -> dict[str, Any]:
    """
    Compresse un paquet global de prompt avant envoi au modèle.
    Le paquet peut contenir system, messages, tool_outputs, files, config, etc.
    """
    return compress_prompt_bundle(bundle=bundle, max_lines_per_block=max_lines_per_block)


if __name__ == "__main__":
    try:
        mcp.run(transport="stdio")
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        raise
