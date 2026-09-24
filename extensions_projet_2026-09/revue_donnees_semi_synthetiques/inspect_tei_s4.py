"""Print numbered TEI paragraphs for local S4 literature audit."""
from pathlib import Path
import sys
import xml.etree.ElementTree as ET
sys.stdout.reconfigure(encoding="utf-8", errors="replace")

BASE = Path(__file__).parent / "tei"
KEYS = (
    "simulation", "snr", "signal-to-noise", "spatial process", "covariance",
    "conditioning", "conditional", "range", "nugget", "variogram",
    "cross-validation", "monte carlo error", "data generating",
    "direct and indirect", "spatially autocorrelated", "spatially correlated",
)

for name in sys.argv[1:]:
    if ":" in name:
        name, wanted_text = name.split(":", 1)
        wanted = {int(x) for x in wanted_text.split(",")}
    else:
        wanted = None
    root = ET.parse(BASE / (name + ".tei.xml")).getroot()
    ps = [e for e in root.iter() if e.tag.endswith("}p")]
    print("\n###", name, "paragraphs", len(ps))
    for i, p in enumerate(ps, 1):
        s = " ".join(" ".join(p.itertext()).split())
        if (wanted is not None and i in wanted) or (
            wanted is None and any(k in s.lower() for k in KEYS)
        ):
            print(f"[{i}] {s if wanted is not None else s[:1000]}")
