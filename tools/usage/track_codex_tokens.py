"""Affiche l'usage de tokens des requêtes Codex Desktop.

Le script lit la base de journaux locale de Codex en lecture seule. Il agrège
les différents appels au modèle appartenant à une même demande utilisateur.
"""

from __future__ import annotations

import argparse
import json
import re
import sqlite3
import time
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path


DEFAULT_DATABASE = Path.home() / ".codex" / "logs_2.sqlite"
TURN_RE = re.compile(r"(?:turn\.id=|turn_id=)([0-9a-f-]{36})")
RESPONSE_RE = re.compile(r'"response":\{"id":"([^"]+)"')


@dataclass
class Usage:
    turn_id: str
    timestamp: int = 0
    completed: bool = False
    calls: int = 0
    input_tokens: int = 0
    cached_tokens: int = 0
    output_tokens: int = 0
    reasoning_tokens: int = 0
    total_tokens: int = 0

    @property
    def uncached_input_tokens(self) -> int:
        return self.input_tokens - self.cached_tokens


def open_database(path: Path) -> sqlite3.Connection:
    """Ouvre le journal Codex en lecture seule."""
    if not path.exists():
        raise FileNotFoundError(f"Journal Codex introuvable : {path}")
    return sqlite3.connect(f"{path.resolve().as_uri()}?mode=ro", uri=True)


def decode_usage(body: str) -> dict[str, object] | None:
    """Extrait l'objet JSON usage d'un événement response.completed."""
    marker = '"usage":'
    start = body.rfind(marker)
    if start < 0:
        return None
    try:
        value, _ = json.JSONDecoder().raw_decode(body[start + len(marker) :])
    except json.JSONDecodeError:
        return None
    return value if isinstance(value, dict) else None


def load_usages(path: Path) -> list[Usage]:
    """Agrège les appels au modèle par identifiant de tour Codex."""
    connection = open_database(path)
    try:
        rows = connection.execute(
            """
            SELECT ts, feedback_log_body
            FROM logs
            WHERE target = 'codex_api::endpoint::responses_websocket'
              AND feedback_log_body LIKE '%response.completed%'
              AND feedback_log_body LIKE '%"usage"%'
            ORDER BY id
            """
        ).fetchall()
        status_rows = connection.execute(
            """
            SELECT feedback_log_body
            FROM logs
            WHERE target = 'codex_core::session::turn'
              AND feedback_log_body LIKE '%post sampling token usage%'
            ORDER BY id
            """
        ).fetchall()
    finally:
        connection.close()

    turns: dict[str, Usage] = {}
    seen_responses: set[str] = set()

    for timestamp, body in rows:
        if not body:
            continue
        turn_match = TURN_RE.search(body)
        response_match = RESPONSE_RE.search(body)
        usage_data = decode_usage(body)
        if not turn_match or not usage_data:
            continue

        response_id = response_match.group(1) if response_match else None
        if response_id and response_id in seen_responses:
            continue
        if response_id:
            seen_responses.add(response_id)

        turn_id = turn_match.group(1)
        usage = turns.setdefault(turn_id, Usage(turn_id=turn_id))
        usage.timestamp = max(usage.timestamp, int(timestamp))
        usage.calls += 1
        usage.input_tokens += int(usage_data.get("input_tokens", 0))
        input_details = usage_data.get("input_tokens_details") or {}
        if isinstance(input_details, dict):
            usage.cached_tokens += int(input_details.get("cached_tokens", 0))
        usage.output_tokens += int(usage_data.get("output_tokens", 0))
        output_details = usage_data.get("output_tokens_details") or {}
        if isinstance(output_details, dict):
            usage.reasoning_tokens += int(
                output_details.get("reasoning_tokens", 0)
            )
        usage.total_tokens += int(usage_data.get("total_tokens", 0))

    for (body,) in status_rows:
        if not body:
            continue
        turn_match = TURN_RE.search(body)
        if not turn_match or turn_match.group(1) not in turns:
            continue
        if (
            "model_needs_follow_up=false" in body
            and "has_pending_input=false" in body
        ):
            turns[turn_match.group(1)].completed = True

    return sorted(turns.values(), key=lambda item: item.timestamp, reverse=True)


def format_integer(value: int) -> str:
    """Formate un entier avec des espaces comme séparateurs de milliers."""
    return f"{value:,}".replace(",", " ")


def format_time(timestamp: int) -> str:
    """Convertit l'horodatage Unix local en texte lisible."""
    return datetime.fromtimestamp(timestamp).strftime("%Y-%m-%d %H:%M:%S")


def print_usage(usage: Usage) -> None:
    """Affiche le bilan détaillé d'une demande."""
    cache_rate = (
        100 * usage.cached_tokens / usage.input_tokens
        if usage.input_tokens
        else 0
    )
    print(f"Tour Codex          : {usage.turn_id}")
    print(f"État                : {'terminé' if usage.completed else 'actif/incomplet'}")
    print(f"Dernier appel vers  : {format_time(usage.timestamp)}")
    print(f"Appels au modèle    : {usage.calls}")
    print(f"Entrée totale       : {format_integer(usage.input_tokens)}")
    print(f"  dont cache        : {format_integer(usage.cached_tokens)}")
    print(f"  hors cache        : {format_integer(usage.uncached_input_tokens)}")
    print(f"Sortie totale       : {format_integer(usage.output_tokens)}")
    print(f"  dont raisonnement : {format_integer(usage.reasoning_tokens)}")
    print(f"Total API           : {format_integer(usage.total_tokens)}")
    print(f"Taux de cache       : {cache_rate:.1f} %")


def print_table(usages: list[Usage], limit: int) -> None:
    """Affiche plusieurs demandes sous forme de tableau compact."""
    print(
        "Date                Etat       Appels       Entree       Cache"
        "   Hors cache      Sortie       Total"
    )
    for usage in usages[:limit]:
        print(
            f"{format_time(usage.timestamp):19} "
            f"{('termine' if usage.completed else 'actif'):10}"
            f"{usage.calls:7}"
            f"{usage.input_tokens:13}"
            f"{usage.cached_tokens:12}"
            f"{usage.uncached_input_tokens:13}"
            f"{usage.output_tokens:12}"
            f"{usage.total_tokens:12}"
        )


def watch(path: Path, interval: float) -> None:
    """Attend l'apparition d'un nouveau tour dans le journal Codex."""
    current = load_usages(path)
    known_completed = {usage.turn_id for usage in current if usage.completed}
    print("Surveillance active. Envoyez une nouvelle demande à Codex.")
    try:
        while True:
            time.sleep(interval)
            usages = load_usages(path)
            for usage in usages:
                if usage.completed and usage.turn_id not in known_completed:
                    print()
                    print_usage(usage)
                    return
    except KeyboardInterrupt:
        print("\nSurveillance arrêtée.")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Mesure l'usage de tokens enregistré par Codex Desktop."
    )
    parser.add_argument(
        "--database",
        type=Path,
        default=DEFAULT_DATABASE,
        help="Chemin de logs_2.sqlite.",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("latest", help="Affiche la dernière demande connue.")

    list_parser = subparsers.add_parser(
        "list", help="Compare les dernières demandes."
    )
    list_parser.add_argument("--limit", type=int, default=10)

    watch_parser = subparsers.add_parser(
        "watch", help="Attend puis affiche la prochaine demande."
    )
    watch_parser.add_argument("--interval", type=float, default=2.0)
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    if args.command == "watch":
        watch(args.database, args.interval)
        return

    usages = load_usages(args.database)
    if not usages:
        raise SystemExit("Aucune information d'usage trouvée.")

    if args.command == "latest":
        completed = [usage for usage in usages if usage.completed]
        if completed:
            print_usage(completed[0])
        else:
            print(
                "Aucun tour terminé n'est encore présent dans le journal. "
                "Affichage du tour actif.\n"
            )
            print_usage(usages[0])
    elif args.command == "list":
        print_table(usages, max(args.limit, 1))


if __name__ == "__main__":
    main()
