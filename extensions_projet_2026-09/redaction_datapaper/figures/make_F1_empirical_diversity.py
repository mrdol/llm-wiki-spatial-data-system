"""Plot empirical dataset counts from the current quantitative corpus."""

import csv
import statistics
from collections import Counter
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "codage_corpus_complet_2026-09-29.tsv"
with SOURCE.open(encoding="utf-8-sig", newline="") as stream:
    rows = [row for row in csv.DictReader(stream, delimiter="\t")
            if row["decision"] == "include_quantitative"]

values = [int(row["n_jeux_reels"]) for row in rows]
assert len(rows) == 101 and len({row["id"] for row in rows}) == 101
distribution = Counter(values)
categories = ["0", "1", "2", "3--5", ">5"]
counts = [distribution[0], distribution[1], distribution[2],
          sum(n for v, n in distribution.items() if 3 <= v <= 5),
          sum(n for v, n in distribution.items() if v > 5)]
assert counts == [27, 62, 9, 2, 1]
median = statistics.median(values)
colors = ["#8c9bab", "#2e6f95", "#55a868", "#ccb974", "#c44e52"]
font_path = Path("C:/Windows/Fonts/arial.ttf")
bold_path = Path("C:/Windows/Fonts/arialbd.ttf")
font = lambda size, bold=False: ImageFont.truetype(str(bold_path if bold else font_path), size)
image = Image.new("RGB", (1440, 700), "white")
draw = ImageDraw.Draw(image)
draw.text((720, 34), f"Empirical diversity in {len(rows)} spatial-method articles",
          anchor="ma", font=font(36, True), fill="#17324a")
left, top, right, bottom = 150, 110, 1370, 570
draw.line((left, top, left, bottom), fill="#333333", width=3)
draw.line((left, bottom, right, bottom), fill="#333333", width=3)
for tick in range(0, 61, 10):
    y = bottom - tick / 65 * (bottom - top)
    draw.line((left - 8, y, right, y), fill="#d9d9d9", width=1)
    draw.text((left - 18, y), str(tick), anchor="rm", font=font(22), fill="#333333")
bar_width, gap = 150, 75
start = left + 95
for index, (category, count, color) in enumerate(zip(categories, counts, colors)):
    x0 = start + index * (bar_width + gap)
    y0 = bottom - count / 65 * (bottom - top)
    draw.rectangle((x0, y0, x0 + bar_width, bottom), fill=color)
    draw.text((x0 + bar_width / 2, y0 - 12),
              f"{count} ({100 * count / len(rows):.1f}%)",
              anchor="ms", font=font(20, True), fill="#222222")
    draw.text((x0 + bar_width / 2, bottom + 16), category,
              anchor="ma", font=font(24), fill="#222222")
draw.text((760, 625), "Number of real datasets per article",
          anchor="ma", font=font(25), fill="#222222")
draw.text((38, 340), "Articles", anchor="mm", font=font(24), fill="#222222")
note = (f"{sum(values)} article-level empirical uses; median = {median:g}. "
        "Purposive corpus; not representative of the entire literature.")
draw.text((720, 670), note, anchor="ms", font=font(18), fill="#555555")
out = HERE / "F1_distribution_jeux_reels_101_articles.png"
image.save(out, dpi=(200, 200))
print(f"{out.name}: n={len(rows)}, distribution={dict(sorted(distribution.items()))}, "
      f"uses={sum(values)}, median={median:g}")
