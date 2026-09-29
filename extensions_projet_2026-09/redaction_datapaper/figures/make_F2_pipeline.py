"""Readable A4-width diagram of the project's chronological curation routes.

Source chronology: internship report and the 24 September datapaper draft.
Source workflow: wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md.
The warehouse pilot (one sheet) is omitted from the diagram.
"""
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch


HERE = Path(__file__).resolve().parent
fig, ax = plt.subplots(figsize=(7.4, 8.4))
ax.set_xlim(0, 12)
ax.set_ylim(0, 10)
ax.axis("off")

SOFTWARE = "#65876a"
EVIDENCE = "#356f96"
PAPER = "#8192a3"
CHECK = "#bb4c43"
DECISION = "#32784f"


def box(x, y, width, height, label, colour, fontsize=9.2):
    patch = FancyBboxPatch(
        (x - width / 2, y - height / 2), width, height,
        boxstyle="round,pad=0.025,rounding_size=0.12",
        linewidth=0, facecolor=colour,
    )
    ax.add_patch(patch)
    ax.text(x, y, label, ha="center", va="center",
            color="white", fontsize=fontsize, linespacing=1.18)
    return x, y, width, height


def arrow(start, end):
    ax.add_patch(FancyArrowPatch(
        start, end, arrowstyle="-|>", mutation_scale=11,
        linewidth=1.15, color="#263746",
    ))


box(2, 9.25, 3.45, 0.86, "1. Software\nR/Python package data", SOFTWARE, 9.2)
box(6, 9.25, 3.45, 0.86, "2. Dataset first\nRepository search", PAPER, 9.2)
box(10, 9.25, 3.45, 0.86, "3. Article first\nTargeted paper search", PAPER, 9.2)

box(2, 7.9, 3.45, 0.73, "Package help and\nobject metadata", SOFTWARE, 8.9)
box(8, 7.9, 6.7, 0.73, "Repository metadata + paper TEI/KG evidence", EVIDENCE, 8.7)
arrow((2, 8.82), (2, 8.29))
arrow((6, 8.82), (7.2, 8.29))
arrow((10, 8.82), (8.8, 8.29))

box(6, 6.55, 6.8, 0.82, "Re-executable loader  ->  spatial artefact", EVIDENCE, 9.3)
arrow((2, 7.5), (4.6, 6.98))
arrow((8, 7.5), (7.3, 6.98))

box(6, 5.23, 6.8, 0.78, "Six-block sheet + registry metadata", EVIDENCE, 9.4)
arrow((6, 6.12), (6, 5.64))

box(3.1, 3.84, 5.2, 0.98,
    "Source verification\nY/X, sample, formula and time", CHECK, 9.0)
box(8.9, 3.84, 5.2, 0.98,
    "Deterministic consistency\nroles, sample size and readiness", CHECK, 8.8)
arrow((5.25, 4.82), (3.1, 4.36))
arrow((6.75, 4.82), (8.9, 4.36))

box(6, 2.42, 6.8, 0.75, "Human-controlled promotion gate", DECISION, 9.6)
arrow((3.1, 3.31), (5.1, 2.82))
arrow((8.9, 3.31), (6.9, 2.82))

box(3.1, 1.06, 5.2, 0.77,
    "package_include:\nyes / manual_review / no", DECISION, 8.9)
box(8.9, 1.06, 5.2, 0.77,
    "storage:\nbundled / repo_only", DECISION, 8.9)
arrow((5.15, 2.02), (3.1, 1.46))
arrow((6.85, 2.02), (8.9, 1.46))

ax.text(6, 0.24,
        "Routes are chronological. Article first complements repository search.",
        ha="center", va="center", fontsize=8, color="#374c5b")
fig.suptitle("Data collection, provenance and curation", fontsize=12.3, y=0.985)
fig.tight_layout(rect=(0.01, 0.015, 0.99, 0.97))
out = HERE / "F2_pipeline_curation.png"
fig.savefig(out, dpi=220, bbox_inches="tight")
print(f"wrote {out.name}")
