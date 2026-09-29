# Splits paper_shark_longline_catch into 4 per-species sub-datasets
# (blue_shark, porbeagle_shark, shortfin_mako_shark, sharks_nei), each
# keeping the SAME 300 distinct spatial sites present in the parent
# (site_id materialized 2026-09-23) and the same formula as the parent
# (catch ~ mean_sst + mean_chla + mean_ssh + sdm + target_effort +
# median_price_species -- none of these are species_commonname, so the
# formula is untouched by the split).
#
# Rationale (session 2026-09-23) : the parent's (site_id, year) pair is not
# unique -- 4 rows per (site, year), one per species -- found while
# functionally testing validate_spatial_panel_data(). The source paper
# (Burns et al. 2024, TEI confirmed) trains a SEPARATE model per species
# ("Our model was designed to be replicated for use with datasets of any
# spatiotemporal AND species resolution"), so splitting by species mirrors
# the authors' own approach, unlike paper_korea_hedonic_housing's split
# (project convenience, not an authors' design choice).
#
# species_commonname is dropped from X after the split (constant within
# each child, was never in formula_used anyway -- only in the
# ml_or_selected candidate formula).
#
# Usage: Rscript code/r_catalog/split_shark_longline_catch.R

REPO_ROOT <- "C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/llm-wiki-karpathy"
SF_DIR <- file.path(REPO_ROOT, "data", "final_datasets", "sf")

obj <- readRDS(file.path(SF_DIR, "paper_shark_longline_catch.rds"))
stopifnot("site_id" %in% names(obj))
crs <- sf::st_crs(obj)

species_labels <- c(
  "BLUE SHARK" = "blue_shark",
  "PORBEAGLE SHARK" = "porbeagle_shark",
  "SHORTFIN MAKO SHARK" = "shortfin_mako_shark",
  "SHARKS NEI" = "sharks_nei"
)
stopifnot(setequal(unique(obj$species_commonname), names(species_labels)))

plain_df <- as.data.frame(obj)
# meme garde que split_korea_hedonic_housing.R : verifier avant de subsetter
# si geom_origine degrade la subdivision sf, sinon le laisser (ici un seul
# sfc actif, geom_point, geom_origine deja verifiee identique lors du
# build de la W -- pas de retrait necessaire).

summary_rows <- list()
for (sp_name in names(species_labels)) {
  label <- species_labels[[sp_name]]
  idx <- which(plain_df$species_commonname == sp_name)
  sub_df <- plain_df[idx, ]
  sub_df$species_commonname <- NULL
  sub_df$species_sciname <- NULL
  sub_sf <- sf::st_as_sf(sub_df, crs = crs)
  n_total <- nrow(sub_sf)
  n_spatial <- length(unique(sub_sf$site_id))
  out_path <- file.path(SF_DIR, sprintf("paper_shark_longline_catch_%s.rds", label))
  saveRDS(sub_sf, out_path)
  summary_rows[[label]] <- data.frame(label = label, n_total = n_total, n_spatial = n_spatial)
  cat(sprintf("%-22s N=%5d  N_spatial=%4d  -> %s\n", label, n_total, n_spatial, basename(out_path)))
}

summary_df <- do.call(rbind, summary_rows)
cat("\nTotal rows across splits:", sum(summary_df$n_total), " (parent N=", nrow(plain_df), ")\n")
stopifnot(sum(summary_df$n_total) == nrow(plain_df))
cat("All splits together account for the full parent row count -- OK.\n")
