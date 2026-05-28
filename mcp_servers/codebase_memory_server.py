"""MCP de mémoire structurelle du code pour éviter les lectures exhaustives."""

from __future__ import annotations

import ast
import sqlite3
import sys
import traceback
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from mcp.server.fastmcp import FastMCP

mcp = FastMCP("codebase-memory")

PROJECT_ROOT = Path(__file__).parent.parent
MEMORY_DIR = PROJECT_ROOT / ".codex_memory"
INDEX_PATH = MEMORY_DIR / "code_index.sqlite"
INDEXED_SUFFIXES = {".py", ".R", ".r", ".md"}
IGNORED_PARTS = {
    ".claude",
    ".git",
    ".venv",
    ".pytest_cache",
    ".ruff_cache",
    ".eval",
    ".codex_memory",
    "__pycache__",
    "raw",
}


def ensure_memory_dir() -> None:
    """Crée le répertoire de mémoire locale si nécessaire."""
    MEMORY_DIR.mkdir(parents=True, exist_ok=True)


def connect_index() -> sqlite3.Connection:
    """Ouvre la base SQLite qui contient la carte du code."""
    ensure_memory_dir()
    conn = sqlite3.connect(INDEX_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_schema(conn: sqlite3.Connection) -> None:
    """Initialise les tables de l'index codebase."""
    conn.executescript(
        """
        CREATE TABLE IF NOT EXISTS files (
            path TEXT PRIMARY KEY,
            suffix TEXT NOT NULL,
            line_count INTEGER NOT NULL,
            summary TEXT NOT NULL,
            indexed_at TEXT NOT NULL
        );
        CREATE TABLE IF NOT EXISTS symbols (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            kind TEXT NOT NULL,
            file_path TEXT NOT NULL,
            line INTEGER,
            end_line INTEGER,
            parent TEXT,
            docstring TEXT,
            UNIQUE(name, kind, file_path, line)
        );
        CREATE TABLE IF NOT EXISTS calls (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            caller TEXT NOT NULL,
            callee TEXT NOT NULL,
            file_path TEXT NOT NULL,
            line INTEGER
        );
        CREATE TABLE IF NOT EXISTS imports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_path TEXT NOT NULL,
            module TEXT NOT NULL,
            name TEXT
        );
        """
    )
    conn.commit()


def should_index(path: Path) -> bool:
    """Décide si un fichier doit entrer dans la carte du code."""
    if path.suffix not in INDEXED_SUFFIXES:
        return False
    return not any(part in IGNORED_PARTS for part in path.parts)


def relative_path(path: Path) -> str:
    """Retourne un chemin relatif stable depuis la racine du projet."""
    return path.relative_to(PROJECT_ROOT).as_posix()


def reset_index(conn: sqlite3.Connection) -> None:
    """Vide les tables avant une réindexation complète."""
    conn.executescript("DELETE FROM files; DELETE FROM symbols; DELETE FROM calls; DELETE FROM imports;")
    conn.commit()


def call_name(node: ast.AST) -> str | None:
    """Extrait le nom lisible d'un appel Python."""
    if isinstance(node, ast.Name):
        return node.id
    if isinstance(node, ast.Attribute):
        base = call_name(node.value)
        return f"{base}.{node.attr}" if base else node.attr
    return None


class PythonIndexer(ast.NodeVisitor):
    """Visiteur AST qui extrait fonctions, classes, imports et appels Python."""

    def __init__(self, file_path: str) -> None:
        self.file_path = file_path
        self.symbols: list[dict[str, Any]] = []
        self.calls: list[dict[str, Any]] = []
        self.imports: list[dict[str, Any]] = []
        self.scope: list[str] = []

    def visit_FunctionDef(self, node: ast.FunctionDef) -> None:
        self._add_function(node, "function")

    def visit_AsyncFunctionDef(self, node: ast.AsyncFunctionDef) -> None:
        self._add_function(node, "async_function")

    def visit_ClassDef(self, node: ast.ClassDef) -> None:
        parent = ".".join(self.scope) if self.scope else None
        self.symbols.append(
            {
                "name": node.name,
                "kind": "class",
                "file_path": self.file_path,
                "line": node.lineno,
                "end_line": getattr(node, "end_lineno", node.lineno),
                "parent": parent,
                "docstring": ast.get_docstring(node),
            }
        )
        self.scope.append(node.name)
        self.generic_visit(node)
        self.scope.pop()

    def visit_Call(self, node: ast.Call) -> None:
        callee = call_name(node.func)
        if callee:
            self.calls.append(
                {
                    "caller": ".".join(self.scope) if self.scope else "<module>",
                    "callee": callee,
                    "file_path": self.file_path,
                    "line": node.lineno,
                }
            )
        self.generic_visit(node)

    def visit_Import(self, node: ast.Import) -> None:
        for alias in node.names:
            self.imports.append({"file_path": self.file_path, "module": alias.name, "name": alias.asname})

    def visit_ImportFrom(self, node: ast.ImportFrom) -> None:
        module = node.module or ""
        for alias in node.names:
            self.imports.append({"file_path": self.file_path, "module": module, "name": alias.name})

    def _add_function(self, node: ast.FunctionDef | ast.AsyncFunctionDef, kind: str) -> None:
        parent = ".".join(self.scope) if self.scope else None
        self.symbols.append(
            {
                "name": node.name,
                "kind": kind,
                "file_path": self.file_path,
                "line": node.lineno,
                "end_line": getattr(node, "end_lineno", node.lineno),
                "parent": parent,
                "docstring": ast.get_docstring(node),
            }
        )
        self.scope.append(node.name)
        self.generic_visit(node)
        self.scope.pop()


def summarize_file(path: Path, text: str) -> str:
    """Produit un résumé court d'un fichier selon son type."""
    lines = text.splitlines()
    if path.suffix == ".py":
        try:
            tree = ast.parse(text)
        except SyntaxError:
            return f"Python non parseable, {len(lines)} ligne(s)."
        functions = sum(isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)) for node in ast.walk(tree))
        classes = sum(isinstance(node, ast.ClassDef) for node in ast.walk(tree))
        return f"Python: {len(lines)} ligne(s), {functions} fonction(s), {classes} classe(s)."
    if path.suffix.lower() == ".r":
        function_count = sum("<- function" in line or "= function" in line for line in lines)
        return f"R: {len(lines)} ligne(s), environ {function_count} fonction(s)."
    if path.suffix == ".md":
        headings = [line.strip("# ").strip() for line in lines if line.startswith("#")]
        topic = headings[0] if headings else path.stem
        return f"Markdown: {len(lines)} ligne(s), sujet principal: {topic}."
    return f"{path.suffix}: {len(lines)} ligne(s)."


def index_python_file(conn: sqlite3.Connection, path: Path, rel_path: str, text: str) -> None:
    """Indexe les symboles, imports et appels d'un fichier Python."""
    try:
        tree = ast.parse(text)
    except SyntaxError:
        return
    indexer = PythonIndexer(rel_path)
    indexer.visit(tree)
    conn.executemany(
        """
        INSERT OR IGNORE INTO symbols (name, kind, file_path, line, end_line, parent, docstring)
        VALUES (:name, :kind, :file_path, :line, :end_line, :parent, :docstring)
        """,
        indexer.symbols,
    )
    conn.executemany(
        "INSERT INTO calls (caller, callee, file_path, line) VALUES (:caller, :callee, :file_path, :line)",
        indexer.calls,
    )
    conn.executemany(
        "INSERT INTO imports (file_path, module, name) VALUES (:file_path, :module, :name)",
        indexer.imports,
    )


def index_r_file(conn: sqlite3.Connection, rel_path: str, text: str) -> None:
    """Indexe les définitions de fonctions R avec une extraction simple."""
    symbols = []
    for line_number, line in enumerate(text.splitlines(), start=1):
        stripped = line.strip()
        for marker in ("<- function", "= function"):
            if marker in stripped:
                name = stripped.split(marker, 1)[0].strip()
                if name:
                    symbols.append(
                        {
                            "name": name,
                            "kind": "r_function",
                            "file_path": rel_path,
                            "line": line_number,
                            "end_line": line_number,
                            "parent": None,
                            "docstring": None,
                        }
                    )
    conn.executemany(
        """
        INSERT OR IGNORE INTO symbols (name, kind, file_path, line, end_line, parent, docstring)
        VALUES (:name, :kind, :file_path, :line, :end_line, :parent, :docstring)
        """,
        symbols,
    )


@mcp.tool()
def index_codebase() -> dict[str, Any]:
    """
    Scanne le projet et reconstruit la carte SQLite du code.
    À lancer après des changements importants dans les fichiers.
    """
    conn = connect_index()
    init_schema(conn)
    reset_index(conn)
    indexed_at = datetime.now(timezone.utc).isoformat()
    counts = Counter()

    for path in PROJECT_ROOT.rglob("*"):
        if not path.is_file() or not should_index(path):
            continue
        rel_path = relative_path(path)
        text = path.read_text(encoding="utf-8", errors="replace")
        summary = summarize_file(path, text)
        conn.execute(
            "INSERT OR REPLACE INTO files (path, suffix, line_count, summary, indexed_at) VALUES (?, ?, ?, ?, ?)",
            (rel_path, path.suffix, len(text.splitlines()), summary, indexed_at),
        )
        if path.suffix == ".py":
            index_python_file(conn, path, rel_path, text)
        elif path.suffix.lower() == ".r":
            index_r_file(conn, rel_path, text)
        counts[path.suffix] += 1

    conn.commit()
    symbol_count = conn.execute("SELECT COUNT(*) FROM symbols").fetchone()[0]
    call_count = conn.execute("SELECT COUNT(*) FROM calls").fetchone()[0]
    file_count = conn.execute("SELECT COUNT(*) FROM files").fetchone()[0]
    conn.close()
    return {
        "indexed": True,
        "index_path": str(INDEX_PATH),
        "indexed_at": indexed_at,
        "file_count": file_count,
        "symbol_count": symbol_count,
        "call_count": call_count,
        "files_by_suffix": dict(sorted(counts.items())),
    }


@mcp.tool()
def find_symbol(name: str, limit: int = 20) -> list[dict[str, Any]]:
    """Trouve où une fonction, une classe ou un symbole est défini."""
    conn = connect_index()
    init_schema(conn)
    rows = conn.execute(
        """
        SELECT name, kind, file_path, line, end_line, parent, docstring
        FROM symbols
        WHERE name = ? OR name LIKE ?
        ORDER BY CASE WHEN name = ? THEN 0 ELSE 1 END, file_path, line
        LIMIT ?
        """,
        (name, f"%{name}%", name, limit),
    ).fetchall()
    conn.close()
    return [dict(row) for row in rows]


@mcp.tool()
def who_calls(symbol: str, limit: int = 50) -> list[dict[str, Any]]:
    """Liste les endroits où un symbole semble appelé dans le code Python indexé."""
    conn = connect_index()
    init_schema(conn)
    rows = conn.execute(
        """
        SELECT caller, callee, file_path, line
        FROM calls
        WHERE callee = ? OR callee LIKE ?
        ORDER BY file_path, line
        LIMIT ?
        """,
        (symbol, f"%.{symbol}", limit),
    ).fetchall()
    conn.close()
    return [dict(row) for row in rows]


@mcp.tool()
def architecture_summary() -> dict[str, Any]:
    """Résume l'architecture indexée du projet sans relire tous les fichiers."""
    conn = connect_index()
    init_schema(conn)
    files = conn.execute("SELECT path, suffix, line_count, summary FROM files ORDER BY path").fetchall()
    symbols_by_kind = conn.execute("SELECT kind, COUNT(*) AS count FROM symbols GROUP BY kind ORDER BY kind").fetchall()
    imports = conn.execute("SELECT module, COUNT(*) AS count FROM imports GROUP BY module ORDER BY count DESC LIMIT 12").fetchall()
    conn.close()

    top_dirs = Counter(Path(row["path"]).parts[0] for row in files if Path(row["path"]).parts)
    entrypoints = [
        row["path"]
        for row in files
        if row["path"].startswith("mcp_servers/")
        or row["path"].endswith("run_eval.py")
        or row["path"].endswith("run_portal_plan.py")
    ]
    return {
        "index_path": str(INDEX_PATH),
        "file_count": len(files),
        "files_by_top_directory": dict(top_dirs.most_common()),
        "symbols_by_kind": {row["kind"]: row["count"] for row in symbols_by_kind},
        "common_imports": [dict(row) for row in imports],
        "entrypoints": entrypoints,
        "notable_areas": [
            "mcp_servers/: serveurs MCP locaux du projet",
            "Code_scrapping/: scripts Python/R de scraping et d'inventaire",
            "LLM-wiki-Assessment/: évaluations et tests",
            "wiki/: fiches Markdown du système LLM Wiki",
            "data/: catalogue et manifestes",
        ],
    }


if __name__ == "__main__":
    try:
        ensure_memory_dir()
        mcp.run(transport="stdio")
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        raise
