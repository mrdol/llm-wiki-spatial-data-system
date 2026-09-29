"""HTTP client with an on-disk cache, per-host throttling and offline replay.

Every response (including 404s, which document dead links) is cached under
``<cache>/http/<host>/<key>.json`` + ``.body`` so a later run, or a run with
``offline=True``, reproduces the same analysis without network access.
Transient failures (network errors, 429, 5xx, API rate limits) are never
cached, so resuming after an interruption simply retries them.
"""

from __future__ import annotations

import datetime as dt
import hashlib
import io
import json
import os
import threading
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Callable
from urllib.parse import urlsplit

import requests

USER_AGENT = "llm-wiki-karpathy-datapaper-repo-audit/1.0 (static metadata audit, no crawling)"

# Minimum seconds between two requests to the same host.
HOST_INTERVALS = {
    "api.github.com": 0.8,
    "raw.githubusercontent.com": 0.2,
    "zenodo.org": 1.0,
    "api.figshare.com": 0.5,
    "api.datacite.org": 0.3,
    "pasta.lternet.edu": 0.5,
    "doi.org": 0.5,
    "api.osf.io": 0.5,
    "datadryad.org": 1.0,
    "www.openml.org": 0.5,
    "gitlab.com": 0.5,
}
DEFAULT_INTERVAL = 0.5
KEEP_HEADERS = (
    "content-type",
    "content-length",
    "content-range",
    "accept-ranges",
    "etag",
    "last-modified",
    "x-ratelimit-remaining",
    "x-ratelimit-reset",
    "link",
    "retry-after",
)
RETRY_STATUSES = {429, 500, 502, 503, 504}


class OfflineCacheMiss(Exception):
    """Raised in offline mode when a URL is not in the cache."""


class RateLimited(Exception):
    """Raised when a host signalled an exhausted API quota."""

    def __init__(self, host: str, reset: str | None = None):
        super().__init__(f"rate limited by {host} (reset={reset})")
        self.host = host
        self.reset = reset


def atomic_write(path: Path, data: bytes, attempts: int = 8) -> None:
    """Write via a temporary file; retry the rename while a sync client
    (e.g. Synology Drive) briefly locks the target."""
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_name(path.name + ".tmp")
    tmp.write_bytes(data)
    for attempt in range(attempts):
        try:
            tmp.replace(path)
            return
        except PermissionError:
            if attempt == attempts - 1:
                raise
            time.sleep(0.25 * (attempt + 1))


def now_iso() -> str:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat()


@dataclass
class Response:
    url: str
    status: int | None
    final_url: str
    headers: dict = field(default_factory=dict)
    content: bytes = b""
    truncated: bool = False
    from_cache: bool = False
    error: str | None = None
    fetched_at: str = ""

    @property
    def ok(self) -> bool:
        return self.status is not None and 200 <= self.status < 300

    def text(self) -> str:
        return self.content.decode("utf-8", errors="replace")

    def json(self):
        return json.loads(self.content.decode("utf-8"))


class HttpClient:
    def __init__(
        self,
        cache_dir: Path,
        *,
        offline: bool = False,
        refresh: bool = False,
        session_factory: Callable[[], requests.Session] | None = None,
        sleep: Callable[[float], None] = time.sleep,
        max_retries: int = 3,
    ):
        self.cache_dir = Path(cache_dir) / "http"
        self.log_path = Path(cache_dir) / "access_log.jsonl"
        self.offline = offline
        self.refresh = refresh
        self.sleep = sleep
        self.max_retries = max_retries
        self._session_factory = session_factory or self._default_session
        self._local = threading.local()
        self._lock = threading.Lock()
        self._host_locks: dict[str, threading.Lock] = {}
        self._last_call: dict[str, float] = {}
        self._refreshed: set[str] = set()
        self.blocked_hosts: dict[str, str | None] = {}
        self.network_calls = 0
        token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
        self._auth = {"api.github.com": {"Authorization": f"Bearer {token}"}} if token else {}

    @staticmethod
    def _default_session() -> requests.Session:
        session = requests.Session()
        session.headers["User-Agent"] = USER_AGENT
        return session

    @property
    def session(self) -> requests.Session:
        if not hasattr(self._local, "session"):
            self._local.session = self._session_factory()
        return self._local.session

    # -- cache -----------------------------------------------------------------
    def _key(self, url: str, headers: dict | None) -> str:
        blob = url + "\n" + json.dumps(sorted((headers or {}).items()))
        return hashlib.sha256(blob.encode("utf-8")).hexdigest()[:32]

    def _paths(self, url: str, key: str) -> tuple[Path, Path]:
        host = (urlsplit(url).netloc.lower() or "nohost").replace(":", "_")
        folder = self.cache_dir / host
        return folder / f"{key}.json", folder / f"{key}.body"

    def _load(self, meta_path: Path, body_path: Path) -> Response | None:
        try:
            meta = json.loads(meta_path.read_text(encoding="utf-8"))
            content = body_path.read_bytes() if body_path.exists() else b""
        except (OSError, ValueError):
            return None
        # The byte limit used at fetch time travels in a private header so that
        # ``get`` can decide whether a truncated cached body is enough.
        return Response(
            url=meta["url"],
            status=meta.get("status"),
            final_url=meta.get("final_url") or meta["url"],
            headers={**meta.get("headers", {}), "x-audit-max-bytes": meta.get("max_bytes")},
            content=content,
            truncated=meta.get("truncated", False),
            from_cache=True,
            fetched_at=meta.get("fetched_at", ""),
        )

    def _save(self, meta_path: Path, body_path: Path, resp: Response, max_bytes: int | None) -> None:
        atomic_write(body_path, resp.content)
        meta = {
            "url": resp.url,
            "final_url": resp.final_url,
            "status": resp.status,
            "headers": resp.headers,
            "truncated": resp.truncated,
            "max_bytes": max_bytes,
            "fetched_at": resp.fetched_at,
        }
        atomic_write(meta_path, json.dumps(meta, indent=1).encode("utf-8"))

    def _log(self, resp: Response) -> None:
        entry = {
            "at": resp.fetched_at,
            "url": resp.url,
            "status": resp.status,
            "final_url": resp.final_url if resp.final_url != resp.url else None,
            "bytes": len(resp.content),
            "truncated": resp.truncated,
            "error": resp.error,
        }
        with self._lock:
            self.log_path.parent.mkdir(parents=True, exist_ok=True)
            with self.log_path.open("a", encoding="utf-8") as stream:
                stream.write(json.dumps(entry) + "\n")

    # -- network ---------------------------------------------------------------
    def _throttle(self, host: str) -> None:
        with self._lock:
            lock = self._host_locks.setdefault(host, threading.Lock())
        with lock:
            interval = HOST_INTERVALS.get(host, DEFAULT_INTERVAL)
            wait = self._last_call.get(host, 0.0) + interval - time.monotonic()
            if wait > 0:
                self.sleep(wait)
            self._last_call[host] = time.monotonic()

    def _fetch_once(self, url: str, headers: dict, max_bytes: int | None) -> Response:
        host = urlsplit(url).netloc.lower()
        self._throttle(host)
        all_headers = {**headers, **self._auth.get(host, {})}
        with self._lock:
            self.network_calls += 1
        raw = self.session.get(url, headers=all_headers, stream=True, timeout=(15, 90), allow_redirects=True)
        try:
            chunks = io.BytesIO()
            truncated = False
            for chunk in raw.iter_content(64 * 1024):
                if not chunk:
                    continue
                chunks.write(chunk)
                if max_bytes is not None and chunks.tell() > max_bytes:
                    truncated = True
                    break
            content = chunks.getvalue()
            if truncated:
                content = content[:max_bytes]
            kept = {k: raw.headers[k] for k in raw.headers if k.lower() in KEEP_HEADERS}
            kept = {k.lower(): v for k, v in kept.items()}
            return Response(
                url=url,
                status=raw.status_code,
                final_url=str(raw.url),
                headers=kept,
                content=content,
                truncated=truncated,
                fetched_at=now_iso(),
            )
        finally:
            raw.close()

    def get(self, url: str, *, headers: dict | None = None, max_bytes: int | None = None, cache: bool = True) -> Response:
        headers = dict(headers or {})
        key = self._key(url, headers)
        meta_path, body_path = self._paths(url, key)
        use_cache = cache and not (self.refresh and key not in self._refreshed)
        if use_cache and meta_path.exists():
            cached = self._load(meta_path, body_path)
            if cached is not None:
                limit = cached.headers.pop("x-audit-max-bytes", None)
                wants_more = cached.truncated and (max_bytes is None or (limit is not None and max_bytes > limit))
                if not wants_more:
                    return cached
        if self.offline:
            raise OfflineCacheMiss(url)
        host = urlsplit(url).netloc.lower()
        if host in self.blocked_hosts:
            raise RateLimited(host, self.blocked_hosts[host])

        resp: Response | None = None
        for attempt in range(self.max_retries + 1):
            try:
                resp = self._fetch_once(url, headers, max_bytes)
            except requests.RequestException as exc:
                resp = Response(url=url, status=None, final_url=url, error=f"{type(exc).__name__}: {exc}"[:300], fetched_at=now_iso())
            if resp.status in (403, 429) and resp.headers.get("x-ratelimit-remaining") == "0":
                self._log(resp)
                self.blocked_hosts[host] = resp.headers.get("x-ratelimit-reset")
                raise RateLimited(host, self.blocked_hosts[host])
            transient = resp.error is not None or resp.status in RETRY_STATUSES
            if not transient or attempt == self.max_retries:
                break
            retry_after = resp.headers.get("retry-after")
            delay = min(2 ** attempt * 2, 30)
            if retry_after and retry_after.isdigit() and int(retry_after) <= 60:
                delay = int(retry_after)
            self._log(resp)
            self.sleep(delay)

        assert resp is not None
        self._log(resp)
        transient = resp.error is not None or resp.status in RETRY_STATUSES
        if cache and not transient:
            self._save(meta_path, body_path, resp, max_bytes)
            self._refreshed.add(key)
        return resp


class RangeBudgetExceeded(Exception):
    pass


class NoRangeSupport(Exception):
    pass


class HttpRangeFile(io.RawIOBase):
    """Seekable read-only view of a remote file backed by cached Range requests.

    Lets ``zipfile`` list an archive's central directory (and read one small
    member) without downloading the archive.
    """

    BLOCK = 256 * 1024

    def __init__(self, http: HttpClient, url: str, size: int, budget_bytes: int):
        super().__init__()
        self.http = http
        self.url = url
        self.size = size
        self.budget = budget_bytes
        self.fetched = 0
        self.pos = 0
        self._blocks: dict[int, bytes] = {}

    def readable(self) -> bool:
        return True

    def seekable(self) -> bool:
        return True

    def tell(self) -> int:
        return self.pos

    def seek(self, offset: int, whence: int = io.SEEK_SET) -> int:
        if whence == io.SEEK_SET:
            self.pos = offset
        elif whence == io.SEEK_CUR:
            self.pos += offset
        else:
            self.pos = self.size + offset
        return self.pos

    def _block(self, index: int) -> bytes:
        if index not in self._blocks:
            start = index * self.BLOCK
            end = min(start + self.BLOCK, self.size) - 1
            if self.fetched + (end - start + 1) > self.budget:
                raise RangeBudgetExceeded(self.url)
            resp = self.http.get(self.url, headers={"Range": f"bytes={start}-{end}"}, max_bytes=self.BLOCK)
            if resp.status != 206:
                raise NoRangeSupport(f"{self.url} answered {resp.status} to a Range request")
            self.fetched += len(resp.content)
            self._blocks[index] = resp.content
        return self._blocks[index]

    def read(self, n: int = -1) -> bytes:
        if n is None or n < 0:
            n = self.size - self.pos
        n = max(0, min(n, self.size - self.pos))
        out = bytearray()
        while n > 0:
            index, offset = divmod(self.pos, self.BLOCK)
            block = self._block(index)
            piece = block[offset : offset + n]
            if not piece:
                break
            out += piece
            self.pos += len(piece)
            n -= len(piece)
        return bytes(out)

    def readinto(self, buffer) -> int:
        data = self.read(len(buffer))
        buffer[: len(data)] = data
        return len(data)
