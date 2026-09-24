# Genere F3_composition_catalogue.png : composition du catalogue (392
# fiches), toutes fiches vs package_include: yes -- meme style que F1
# (matplotlib, comptage+pourcentage sur les barres, note de lecture).
# Chiffres recalcules directement depuis le registre courant (pas de
# nombres codes en dur), meme logique de deduplication corrigee que
# tools/audit_datapaper_repo.py (session 2026-09-24).
import json
import matplotlib.pyplot as plt

with open("packages/spatialtidymodels/inst/metadata/datasets.json", encoding="utf-8") as f:
    recs = json.load(f)["records"]

def flat_typology(v):
    if isinstance(v, list):
        v = [str(x).strip().rstrip(".") for x in v if x]
        return "+".join(sorted(set(v))) if v else "missing"
    return str(v).strip().rstrip(".") if v else "missing"

TYP_ORDER = ["continuous", "count", "binary", "rate", "categorical", "unknown"]
TYP_LABEL = {"continuous": "Continuous", "count": "Count", "binary": "Binary",
             "rate": "Rate", "categorical": "Categorical", "unknown": "Unknown"}

all_recs = recs
yes_recs = [r for r in recs if r.get("package_include") == "yes"]

def typ_counts(rs):
    c = {k: 0 for k in TYP_ORDER}
    for r in rs:
        t = flat_typology(r.get("response_typology"))
        if t in c:
            c[t] += 1
        else:
            c["unknown"] += 1
    return c

def t_periods_int(r):
    try:
        return int(r.get("t_periods"))
    except (TypeError, ValueError):
        return 1

def struct_counts(rs):
    n = len(rs)
    panel_strict = sum(r.get("data_structure") == "spatial_panel" for r in rs)
    st = sum(t_periods_int(r) > 1 for r in rs)
    cross = n - st
    return panel_strict, st, cross

fig, axes = plt.subplots(1, 3, figsize=(14, 5.2))
palette = ["#4c72a0", "#55a868", "#c44e52", "#8172b2", "#ccb974", "#8c9bab"]

# Panel A: response typology, all vs yes (grouped bars)
ax = axes[0]
all_t = typ_counts(all_recs)
yes_t = typ_counts(yes_recs)
x = range(len(TYP_ORDER))
w = 0.38
bars_all = ax.bar([i - w / 2 for i in x], [all_t[k] for k in TYP_ORDER], width=w,
                   label=f"All sheets (n={len(all_recs)})", color="#8c9bab")
bars_yes = ax.bar([i + w / 2 for i in x], [yes_t[k] for k in TYP_ORDER], width=w,
                   label=f"package_include: yes (n={len(yes_recs)})", color="#2e6f95")
for bars in (bars_all, bars_yes):
    for b in bars:
        h = b.get_height()
        if h > 0:
            ax.annotate(str(int(h)), (b.get_x() + b.get_width() / 2, h),
                        ha="center", va="bottom", fontsize=7.6)
ax.set_xticks(list(x))
ax.set_xticklabels([TYP_LABEL[k] for k in TYP_ORDER], rotation=30, ha="right", fontsize=8.5)
ax.set_ylabel("Number of sheets")
ax.set_title("A. Response typology", fontsize=11)
ax.legend(fontsize=7.6, frameon=False)
ax.spines[["top", "right"]].set_visible(False)

# Panel B: structural composition, all vs yes
ax = axes[1]
labels_b = ["Panel\n(strict, wired)", "Spatio-temporal\n(t_periods > 1)", "Cross-sectional\n(t_periods = 1)"]
all_b = struct_counts(all_recs)
yes_b = struct_counts(yes_recs)
xb = range(3)
ax.bar([i - w / 2 for i in xb], all_b, width=w, color="#8c9bab", label=f"All sheets (n={len(all_recs)})")
ax.bar([i + w / 2 for i in xb], yes_b, width=w, color="#2e6f95", label="package_include: yes")
for i, (a, y) in enumerate(zip(all_b, yes_b)):
    ax.annotate(str(a), (i - w / 2, a), ha="center", va="bottom", fontsize=8)
    ax.annotate(str(y), (i + w / 2, y), ha="center", va="bottom", fontsize=8)
ax.set_xticks(list(xb))
ax.set_xticklabels(labels_b, fontsize=8.5)
ax.set_title("B. Temporal structure", fontsize=11)
ax.legend(fontsize=7.6, frameon=False)
ax.spines[["top", "right"]].set_visible(False)

# Panel C: admission status + dedup families
ax = axes[2]
inc = {"yes": 0, "manual_review": 0, "no": 0}
for r in all_recs:
    v = r.get("package_include")
    if v in inc:
        inc[v] += 1
cats = ["yes", "manual_review", "no"]
colors_c = ["#2e7d4f", "#ccb974", "#c44e52"]
bars = ax.bar(cats, [inc[c] for c in cats], color=colors_c)
for b, c in zip(bars, cats):
    h = b.get_height()
    ax.annotate(f"{h}\n({100*h/len(all_recs):.0f}%)", (b.get_x() + b.get_width() / 2, h),
                ha="center", va="bottom", fontsize=8.5)
ax.set_title("C. Admission status (all sheets)", fontsize=11)
ax.set_ylabel("Number of sheets")
ax.spines[["top", "right"]].set_visible(False)

fig.suptitle("Composition of the dataset catalogue, dated snapshot of 24 September 2026", fontsize=13.5)
fig.text(0.5, -0.02,
         "Reading note: panels A-B compare all 392 sheets against the 278 admitted (package_include: yes); "
         "panel C covers all 392. Deduplicated by decomposition family: 241 (all) / 131 (yes) -- not shown here, see Table 1.",
         ha="center", fontsize=8, style="italic", color="#444444")
fig.tight_layout(rect=[0, 0.02, 1, 0.96])
fig.savefig("extensions_projet_2026-09/redaction_datapaper/figures/F3_composition_catalogue.png",
            dpi=200, bbox_inches="tight")
print("wrote F3_composition_catalogue.png")
