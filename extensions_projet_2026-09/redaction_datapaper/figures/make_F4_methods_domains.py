"""Plot simulation-design breadth in the current quantitative corpus.

The former method-by-domain graphic depended on a classification available
only for the obsolete 66-article corpus. The current TSV supports a fully
reproducible comparison of basic design factors and misspecification axes.
"""

import csv
from collections import Counter
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "codage_corpus_complet_2026-09-29.tsv"
with SOURCE.open(encoding="utf-8-sig", newline="") as stream:
    rows = [row for row in csv.DictReader(stream, delimiter="\t")
            if row["decision"] == "include_quantitative"]
assert len(rows) == 101

labels = {
    "taille": "Sample size", "intensite_spatiale": "Spatial dependence",
    "loi_erreurs": "Error distribution", "W_config": "Weights configuration",
    "bruit_snr": "Noise / SNR", "heterogeneite": "Spatial heterogeneity",
    "correlation_X": "Covariate correlation",
    "modele_spatial_errone": "Model misspecification",
    "variables_omises": "Omitted variables",
    "heteroscedasticite": "Heteroskedasticity", "nonlinearite": "Non-linearity",
    "W_incorrecte": "Incorrect weights", "W_endogene": "Endogenous weights",
    "erreur_mesure": "Measurement error", "interactions": "Interactions",
    "support_echelle": "Support / scale", "donnees_manquantes": "Missing data",
}
factor_counts = Counter(v for row in rows for v in row["facteurs_minimaux"].split(";") if v)
misspec_counts = Counter(v for row in rows for v in row["misspec"].split(";") if v)
items = [(key, count, "basic") for key, count in factor_counts.items()]
items += [(key, count, "misspec") for key, count in misspec_counts.items()]
items.sort(key=lambda item: item[1])

font_path = Path("C:/Windows/Fonts/arial.ttf")
bold_path = Path("C:/Windows/Fonts/arialbd.ttf")
font = lambda size, bold=False: ImageFont.truetype(str(bold_path if bold else font_path), size)
image = Image.new("RGB", (1640, 1260), "white")
draw = ImageDraw.Draw(image)
draw.text((820, 34), "Simulation-design dimensions in 101 spatial-method articles",
          anchor="ma", font=font(34, True), fill="#17324a")
left, top, right, bottom = 430, 105, 1560, 1120
max_value = 60
row_height = (bottom - top) / len(items)
for tick in range(0, max_value + 1, 10):
    x = left + tick / max_value * (right - left)
    draw.line((x, top, x, bottom), fill="#dddddd", width=1)
    draw.text((x, bottom + 12), str(tick), anchor="ma", font=font(19), fill="#333333")
for index, (key, count, group) in enumerate(items):
    y = top + index * row_height + row_height * 0.16
    height = row_height * 0.68
    draw.text((left - 18, y + height / 2), labels[key], anchor="rm",
              font=font(19), fill="#222222")
    width = count / max_value * (right - left)
    color = "#2e6f95" if group == "basic" else "#c46b3c"
    draw.rectangle((left, y, left + width, y + height), fill=color)
    draw.text((left + width + 10, y + height / 2), str(count), anchor="lm",
              font=font(19, True), fill="#222222")
draw.line((left, top, left, bottom), fill="#333333", width=3)
draw.line((left, bottom, right, bottom), fill="#333333", width=3)
draw.text(((left + right) / 2, 1175), "Articles varying or examining the axis",
          anchor="ma", font=font(23), fill="#222222")
draw.rectangle((520, 1220, 550, 1245), fill="#2e6f95")
draw.text((560, 1232), "Basic design factor", anchor="lm", font=font(18), fill="#333333")
draw.rectangle((840, 1220, 870, 1245), fill="#c46b3c")
draw.text((880, 1232), "Qualitative misspecification axis", anchor="lm", font=font(18), fill="#333333")
out = HERE / "F4_simulation_dimensions_101_articles.png"
image.save(out, dpi=(200, 200))
print(f"{out.name}: factors={dict(factor_counts)}, misspec={dict(misspec_counts)}")
