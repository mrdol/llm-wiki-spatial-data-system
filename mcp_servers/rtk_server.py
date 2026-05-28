"""MCP Rust Token Killer local pour compresser les sorties terminal courtes ou moyennes."""

from __future__ import annotations

import sys
import traceback
from typing import Any

from mcp.server.fastmcp import FastMCP

try:
    from token_slimming import slim_output
except ImportError:
    from mcp_servers.token_slimming import slim_output

mcp = FastMCP("rtk-token-killer")


def build_command_text(command: str, stdout: str = "", stderr: str = "", returncode: int | None = None) -> str:
    """Construit une sortie terminal compacte mais traçable à partir des champs d'une commande."""
    parts = []
    if command:
        parts.append(f"$ {command}")
    if returncode is not None:
        parts.append(f"[exit_code] {returncode}")
    if stdout:
        parts.append("[stdout]")
        parts.append(stdout)
    if stderr:
        parts.append("[stderr]")
        parts.append(stderr)
    return "\n".join(parts)


@mcp.tool()
def slim_terminal_output(content: str, label: str = "terminal", max_lines: int = 80) -> dict[str, Any]:
    """
    Compresse une petite ou moyenne sortie terminal sans la stocker.
    À utiliser pour git status, npm install, tests rapides, ruff, logs courts, etc.
    """
    slimmed = slim_output(content, max_lines=max_lines)
    return {
        "label": label,
        "summary": slimmed.summary,
        "important_lines": slimmed.important_lines,
        "original_line_count": slimmed.original_line_count,
        "omitted_line_count": slimmed.omitted_line_count,
    }


@mcp.tool()
def slim_command_result(
    command: str,
    stdout: str = "",
    stderr: str = "",
    returncode: int | None = None,
    max_lines: int = 80,
) -> dict[str, Any]:
    """
    Compresse le résultat structuré d'une commande shell.
    Conserve le code retour, les erreurs importantes et un résumé lisible.
    """
    text = build_command_text(command=command, stdout=stdout, stderr=stderr, returncode=returncode)
    slimmed = slim_output(text, max_lines=max_lines)
    return {
        "command": command,
        "returncode": returncode,
        "summary": slimmed.summary,
        "important_lines": slimmed.important_lines,
        "original_line_count": slimmed.original_line_count,
        "omitted_line_count": slimmed.omitted_line_count,
        "has_error": returncode not in (None, 0) or bool(stderr.strip()),
    }


if __name__ == "__main__":
    try:
        mcp.run(transport="stdio")
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        raise
