"""Proxy HTTP minimal Headroom pour compresser les requêtes OpenAI.

Usage:
    python mcp_servers/headroom_proxy.py --port 8787

Le proxy reçoit des requêtes compatibles avec /v1/responses ou
/v1/chat/completions, compresse les champs textuels du JSON, puis relaie la
requête vers l'API OpenAI.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any

try:
    from headroom import compress_prompt_bundle
except ImportError:
    from mcp_servers.headroom import compress_prompt_bundle

OPENAI_API_BASE = os.environ.get("OPENAI_API_BASE", "https://api.openai.com")
OPENAI_ENDPOINTS = {
    "/responses": "/v1/responses",
    "/v1/responses": "/v1/responses",
    "/chat/completions": "/v1/chat/completions",
    "/v1/chat/completions": "/v1/chat/completions",
}
FORWARDED_HEADERS = {
    "authorization",
    "content-type",
    "openai-beta",
    "openai-organization",
    "openai-project",
}


class HeadroomProxyHandler(BaseHTTPRequestHandler):
    """Handler HTTP qui compresse puis relaie les appels OpenAI."""

    server_version = "HeadroomProxy/0.1"

    def do_GET(self) -> None:
        """Expose un endpoint santé minimal."""
        if self.path == "/health":
            self._send_json(200, {"ok": True, "service": "headroom-proxy"})
            return
        self._send_json(404, {"error": "not_found"})

    def do_POST(self) -> None:
        """Compresse et transmet une requête OpenAI."""
        endpoint = OPENAI_ENDPOINTS.get(self.path)
        if endpoint is None:
            self._send_json(404, {"error": "unsupported_path", "path": self.path})
            return

        length = int(self.headers.get("content-length", "0"))
        raw_body = self.rfile.read(length)
        try:
            payload = json.loads(raw_body.decode("utf-8"))
        except json.JSONDecodeError as exc:
            self._send_json(400, {"error": "invalid_json", "detail": str(exc)})
            return

        compressed = compress_prompt_bundle(payload)["compressed"]
        body = json.dumps(compressed, ensure_ascii=False).encode("utf-8")
        headers = self._forward_headers()
        headers["content-type"] = "application/json"

        request = urllib.request.Request(
            f"{OPENAI_API_BASE}{endpoint}",
            data=body,
            headers=headers,
            method="POST",
        )
        try:
            with urllib.request.urlopen(request, timeout=300) as response:
                response_body = response.read()
                self.send_response(response.status)
                self.send_header("content-type", response.headers.get("content-type", "application/json"))
                self.send_header("x-headroom-compressed", "true")
                self.end_headers()
                self.wfile.write(response_body)
        except urllib.error.HTTPError as exc:
            self.send_response(exc.code)
            self.send_header("content-type", exc.headers.get("content-type", "application/json"))
            self.end_headers()
            self.wfile.write(exc.read())
        except Exception as exc:
            self._send_json(502, {"error": "proxy_error", "detail": str(exc)})

    def log_message(self, format: str, *args: Any) -> None:
        """Journalise côté stderr sans injecter les logs dans stdout MCP."""
        print(f"{self.address_string()} - {format % args}", file=sys.stderr)

    def _forward_headers(self) -> dict[str, str]:
        return {
            key: value
            for key, value in self.headers.items()
            if key.lower() in FORWARDED_HEADERS
        }

    def _send_json(self, status: int, payload: dict[str, Any]) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("content-type", "application/json")
        self.send_header("content-length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


def main() -> None:
    parser = argparse.ArgumentParser(description="Run the local Headroom OpenAI proxy.")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8787)
    args = parser.parse_args()

    server = ThreadingHTTPServer((args.host, args.port), HeadroomProxyHandler)
    print(f"Headroom proxy listening on http://{args.host}:{args.port}", file=sys.stderr)
    server.serve_forever()


if __name__ == "__main__":
    main()
