# Genere F1_distribution_jeux_reels_66_articles.png en ANGLAIS (le fichier
# precedent etait en francais, incoherent avec le reste du manuscrit -- pas
# de script source retrouve pour la version francaise, recree ici a
# l'identique sur les donnees, seule la langue et la taille changent).
# Chiffres reprisde BROUILLON_DATAPAPER_V1 Sect. "Monte Carlo breadth and
# empirical breadth" (deja verifies contre meta_analyse_codage_66_articles) :
# 14/39/11/1/1 articles pour 0/1/2/3-5/>5 jeux reels, 73 usages bruts, median=1.
import matplotlib.pyplot as plt

categories = ["0", "1", "2", "3-5", ">5"]
counts = [14, 39, 11, 1, 1]
pct = [21.2, 59.1, 16.7, 1.5, 1.5]
colors = ["#8c9bab", "#2e6f95", "#55a868", "#ccb974", "#c44e52"]

fig, ax = plt.subplots(figsize=(7.2, 3.3))
bars = ax.bar(categories, counts, color=colors)
for b, c, p in zip(bars, counts, pct):
    ax.annotate(f"{c} ({p:.1f}%)", (b.get_x() + b.get_width() / 2, b.get_height()),
                ha="center", va="bottom", fontsize=8.5)

ax.set_title("Empirical diversity in the 66 methodological spatial articles", fontsize=11.5)
ax.set_xlabel("Number of real datasets per article", fontsize=9.5)
ax.set_ylabel("Number of articles", fontsize=9.5)
ax.set_ylim(0, 44)
ax.tick_params(labelsize=8.8)
ax.spines[["top", "right"]].set_visible(False)

fig.text(0.5, -0.02,
         "Reading note: 73 raw empirical uses in total, median = 1; purposive, reasoned corpus, "
         "not representative of the whole literature.",
         ha="center", fontsize=7.4, style="italic", color="#444444")

fig.tight_layout()
fig.savefig("extensions_projet_2026-09/redaction_datapaper/figures/F1_distribution_jeux_reels_66_articles.png",
            dpi=200, bbox_inches="tight")
print("wrote F1_distribution_jeux_reels_66_articles.png (English)")
