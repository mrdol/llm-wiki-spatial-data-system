"""Read the structure of a remote ZIP (incl. ZIP64) with a few HTTP Range requests.

1. the tail (end-of-central-directory, EOCD/ZIP64 records) gives the declared
   number of members and the size/offset of the central directory;
2. the central directory is parsed in full when it fits the byte budget,
   otherwise only its first ``sample_bytes`` (flagged ``sampled``);
3. selected small members are read through their local header and inflated.
"""

from __future__ import annotations

import struct
import zlib

from .netcache import HttpRangeFile

EOCD = b"PK\x05\x06"
ZIP64_LOCATOR = b"PK\x06\x07"
ZIP64_EOCD = b"PK\x06\x06"
CENTRAL = b"PK\x01\x02"
LOCAL = b"PK\x03\x04"


class ZipStructureError(Exception):
    pass


def read_tail(reader: HttpRangeFile) -> dict:
    tail_len = min(reader.size, 128 * 1024)
    reader.seek(reader.size - tail_len)
    tail = reader.read(tail_len)
    i = tail.rfind(EOCD)
    if i < 0 or i + 22 > len(tail):
        raise ZipStructureError("end-of-central-directory record not found")
    _d, _cd, _nd, n_total, cd_size, cd_offset, _cl = struct.unpack("<HHHHIIH", tail[i + 4 : i + 22])
    info = {"n_members_declared": n_total, "central_directory_bytes": cd_size, "cd_offset": cd_offset, "zip64": False}
    loc = tail.rfind(ZIP64_LOCATOR, 0, i)
    if loc >= 0 and loc + 20 <= len(tail):
        _disk, eocd64_offset, _ndisks = struct.unpack("<IQI", tail[loc + 4 : loc + 20])
        reader.seek(eocd64_offset)
        rec = reader.read(56)
        if rec[:4] == ZIP64_EOCD:
            n_total, cd_size, cd_offset = struct.unpack("<QQQ", rec[32:56])
            info.update(n_members_declared=n_total, central_directory_bytes=cd_size, cd_offset=cd_offset, zip64=True)
    return info


def _zip64_extra(extra: bytes, usize: int, csize: int, offset: int) -> tuple[int, int, int]:
    pos = 0
    while pos + 4 <= len(extra):
        hid, hlen = struct.unpack("<HH", extra[pos : pos + 4])
        body = extra[pos + 4 : pos + 4 + hlen]
        if hid == 0x0001:
            j = 0
            if usize == 0xFFFFFFFF and j + 8 <= len(body):
                usize = struct.unpack("<Q", body[j : j + 8])[0]
                j += 8
            if csize == 0xFFFFFFFF and j + 8 <= len(body):
                csize = struct.unpack("<Q", body[j : j + 8])[0]
                j += 8
            if offset == 0xFFFFFFFF and j + 8 <= len(body):
                offset = struct.unpack("<Q", body[j : j + 8])[0]
            break
        pos += 4 + hlen
    return usize, csize, offset


def parse_central_directory(data: bytes) -> list[dict]:
    out, pos = [], 0
    while pos + 46 <= len(data) and data[pos : pos + 4] == CENTRAL:
        method = struct.unpack("<H", data[pos + 10 : pos + 12])[0]
        csize, usize = struct.unpack("<II", data[pos + 20 : pos + 28])
        nlen, xlen, clen = struct.unpack("<HHH", data[pos + 28 : pos + 34])
        offset = struct.unpack("<I", data[pos + 42 : pos + 46])[0]
        end = pos + 46 + nlen + xlen + clen
        if end > len(data):
            break
        name = data[pos + 46 : pos + 46 + nlen].decode("utf-8", "replace")
        extra = data[pos + 46 + nlen : pos + 46 + nlen + xlen]
        usize, csize, offset = _zip64_extra(extra, usize, csize, offset)
        if not name.endswith("/"):
            out.append({"path": name, "size": usize, "compressed": csize, "method": method, "offset": offset})
        pos = end
    return out


def list_members(reader: HttpRangeFile, budget_bytes: int, sample_bytes: int = 2 * 1024 * 1024) -> dict:
    info = read_tail(reader)
    cd = info["central_directory_bytes"]
    to_read = cd if cd <= budget_bytes else min(cd, sample_bytes)
    reader.seek(info["cd_offset"])
    members = parse_central_directory(reader.read(to_read))
    info["sampled"] = to_read < cd
    info["members"] = members
    return info


def list_tar_prefix(prefix: bytes, compressed: bool = True) -> tuple[list[dict], bool]:
    """Members whose 512-byte header lies in the first bytes of a (gzipped) tar.

    A gzip stream cannot be read at random offsets, so only a prefix is
    fetched; returns (members, complete) where ``complete`` is True only if
    the end-of-archive marker was reached.
    """
    data = zlib.decompressobj(16 + zlib.MAX_WBITS).decompress(prefix) if compressed else prefix
    out, pos = [], 0
    while pos + 512 <= len(data):
        header = data[pos : pos + 512]
        if header == b"\0" * 512:
            return out, True
        name = header[0:100].split(b"\0", 1)[0].decode("utf-8", "replace")
        prefix_field = header[345:500].split(b"\0", 1)[0].decode("utf-8", "replace")
        size_field = header[124:136].split(b"\0", 1)[0].strip()
        try:
            size = int(size_field or b"0", 8)
        except ValueError:
            break  # not a tar header: stop rather than guess
        kind = header[156:157]
        full = f"{prefix_field}/{name}" if prefix_field else name
        if kind in (b"0", b"\0", b"7"):
            out.append({"path": full, "size": size})
        pos += 512 + ((size + 511) // 512) * 512
    return out, False


def read_member(reader: HttpRangeFile, member: dict) -> bytes:
    reader.seek(member["offset"])
    head = reader.read(30)
    if head[:4] != LOCAL:
        raise ZipStructureError("bad local header")
    nlen, xlen = struct.unpack("<HH", head[26:30])
    reader.seek(member["offset"] + 30 + nlen + xlen)
    raw = reader.read(member["compressed"])
    if member["method"] == 0:
        return raw
    if member["method"] == 8:
        return zlib.decompress(raw, -15)
    raise ZipStructureError(f"unsupported compression method {member['method']}")
