"""Compression globale de contexte avant envoi à un modèle."""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from typing import Any

try:
    from token_slimming import slim_output
except ImportError:
    from mcp_servers.token_slimming import slim_output


@dataclass
class CompressedBlock:
    """Bloc compressé avec métriques simples."""

    name: str
    content: str
    original_chars: int
    compressed_chars: int
    estimated_original_tokens: int
    estimated_compressed_tokens: int


def estimate_tokens(text: str) -> int:
    """Approximation conservatrice: environ quatre caractères par token."""
    if not text:
        return 0
    return max(1, len(text) // 4)


def normalize_blank_lines(text: str) -> str:
    """Réduit les longues zones vides sans modifier le sens du texte."""
    return re.sub(r"\n{3,}", "\n\n", text.strip())


def is_terminal_like(text: str) -> bool:
    """Détecte les blocs qui ressemblent à des sorties terminal."""
    lowered = text.lower()
    markers = (
        "traceback",
        "error:",
        "warning:",
        "failed",
        "passed",
        "pytest",
        "ruff",
        "npm ",
        "git status",
        "[stdout]",
        "[stderr]",
    )
    return any(marker in lowered for marker in markers)


def compress_markdown_or_text(text: str, max_lines: int) -> str:
    """Compresse un texte général en gardant titres, début et fin."""
    lines = normalize_blank_lines(text).splitlines()
    if len(lines) <= max_lines:
        return "\n".join(lines)

    heading_lines = [line for line in lines if line.lstrip().startswith("#")]
    head_count = min(24, max_lines // 3)
    tail_count = min(24, max_lines // 3)
    remaining = max(0, max_lines - head_count - tail_count - len(heading_lines[:16]) - 1)
    middle = lines[head_count : head_count + remaining]

    chunks = [
        *heading_lines[:16],
        *lines[:head_count],
        *middle,
        f"[... {len(lines) - head_count - tail_count - len(middle)} ligne(s) compressée(s) par Headroom ...]",
        *lines[-tail_count:],
    ]
    return "\n".join(dict.fromkeys(chunks))


def compress_text_block(name: str, text: str, max_lines: int = 120) -> CompressedBlock:
    """Compresse un bloc selon sa nature: terminal ou texte général."""
    original = text or ""
    if not original.strip():
        compact = ""
    elif is_terminal_like(original):
        slimmed = slim_output(original, max_lines=max_lines)
        compact = "\n".join([slimmed.summary, *slimmed.important_lines])
    else:
        compact = compress_markdown_or_text(original, max_lines=max_lines)

    return CompressedBlock(
        name=name,
        content=compact,
        original_chars=len(original),
        compressed_chars=len(compact),
        estimated_original_tokens=estimate_tokens(original),
        estimated_compressed_tokens=estimate_tokens(compact),
    )


def stringify_content(content: Any) -> str:
    """Convertit un contenu de message en texte compressible."""
    if isinstance(content, str):
        return content
    return json.dumps(content, ensure_ascii=False, indent=2)


def compress_prompt_bundle(bundle: dict[str, Any], max_lines_per_block: int = 120) -> dict[str, Any]:
    """Compresse les champs usuels d'un paquet de contexte."""
    compressed: dict[str, Any] = {}
    blocks: list[CompressedBlock] = []

    for key, value in bundle.items():
        if isinstance(value, str):
            block = compress_text_block(key, value, max_lines=max_lines_per_block)
            compressed[key] = block.content
            blocks.append(block)
        elif isinstance(value, list) and key in {"messages", "input"}:
            new_messages = []
            for index, message in enumerate(value):
                if not isinstance(message, dict):
                    new_messages.append(message)
                    continue
                content = stringify_content(message.get("content", ""))
                block = compress_text_block(f"{key}[{index}].content", content, max_lines=max_lines_per_block)
                new_message = dict(message)
                new_message["content"] = block.content
                new_messages.append(new_message)
                blocks.append(block)
            compressed[key] = new_messages
        else:
            compressed[key] = value

    original_tokens = sum(block.estimated_original_tokens for block in blocks)
    compressed_tokens = sum(block.estimated_compressed_tokens for block in blocks)
    return {
        "compressed": compressed,
        "metrics": {
            "block_count": len(blocks),
            "estimated_original_tokens": original_tokens,
            "estimated_compressed_tokens": compressed_tokens,
            "estimated_saved_tokens": max(0, original_tokens - compressed_tokens),
            "compression_ratio": round(compressed_tokens / original_tokens, 3) if original_tokens else 1.0,
            "blocks": [block.__dict__ for block in blocks],
        },
    }
