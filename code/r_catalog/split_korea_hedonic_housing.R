# Splits paper_korea_hedonic_housing into per-year (1989-2019) + one pooled
# pre-1989 sub-dataset, each keeping the FULL set of distinct spatial units
# present for that period (preserves W-buildability) and the same Y/X formula
# as the parent (Housing.price ~ Area + Floor + Subway.distance +
# Population.density + Green.space.distance -- none of these are Year, so the
# formula is untouched by the split). Rationale: increase the number of
# already-benchmarkable datasets without inventing data or breaking spatial/
# formula validity (session 2026-08-17).
#
# NOTE: obj[idx, ] on this particular sf object silently degrades the sfc
# geometry columns to plain lists (reproduced bug: presence of a second sfc
# column "geom_origine" alongside the active "geom_point" breaks [.sf's row
# subsetting in this sf version). Workaround: subset the plain data.frame
# form instead, then reconstruct via st_as_sf(). geom_origine is dropped
# first -- verified numerically identical to geom_point for this point-family
# dataset (max coordinate distance 3.6e-14, floating point noise only), and
# generate_fiches_papers.R already discards geom_origine unconditionally
# before computing variables anyway.
#
# Usage: Rscript code/r_catalog/split_korea_hedonic_housing.R

REPO_ROOT <- "C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/llm-wiki-karpathy"
SF_DIR <- file.path(REPO_ROOT, "data", "final_datasets", "sf")

obj <- readRDS(file.path(SF_DIR, "paper_korea_hedonic_housing.rds"))
crs <- sf::st_crs(obj)

stopifnot(identical(as.data.frame(obj)$Year, as.data.frame(obj)$T))
p1 <- sf::st_coordinates(obj$geom_point)
p2 <- sf::st_coordinates(obj$geom_origine)
stopifnot(max(sqrt((p1[, 1] - p2[, 1])^2 + (p1[, 2] - p2[, 2])^2)) < 1e-9)

plain_df <- as.data.frame(obj)
plain_df$geom_origine <- NULL
plain_df$Year <- NULL

summary_rows <- list()

write_split <- function(label, idx) {
  sub_df <- plain_df[idx, ]
  sub_sf <- sf::st_as_sf(sub_df, crs = crs)
  stopifnot(identical(attr(sub_sf, "sf_column"), "geom_point"))
  n_total <- nrow(sub_sf)
  n_spatial <- length(unique(sf::st_as_text(sf::st_geometry(sub_sf))))
  out_path <- file.path(SF_DIR, sprintf("paper_korea_hedonic_housing_%s.rds", label))
  saveRDS(sub_sf, out_path)
  summary_rows[[label]] <<- data.frame(label = label, n_total = n_total, n_spatial = n_spatial)
  cat(sprintf("%-10s N=%6d  N_spatial=%5d  -> %s\n", label, n_total, n_spatial, basename(out_path)))
}

for (y in 1989:2019) {
  write_split(as.character(y), which(plain_df$T == y))
}
write_split("pre1989", which(plain_df$T < 1989))

summary_df <- do.call(rbind, summary_rows)
cat("\nTotal rows across splits:", sum(summary_df$n_total), " (parent N=", nrow(plain_df), ")\n")
stopifnot(sum(summary_df$n_total) == nrow(plain_df))
cat("All splits together account for the full parent row count -- OK.\n")
