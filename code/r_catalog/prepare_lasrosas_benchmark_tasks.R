# Prepare the two cross-sectional benchmark tasks contained in
# agridat::lasrosas.corn. The source object remains unchanged: it is a
# two-harvest archive, whereas the current benchmark operates on one spatial
# cross-section at a time.

repo_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
source_path <- file.path(
  repo_root,
  "data", "final_datasets", "sf",
  "R_agridat_lasrosas.corn_lasrosas.corn.rds"
)
out_dir <- dirname(source_path)

if (!file.exists(source_path)) {
  stop(sprintf("Source Las Rosas introuvable: %s", source_path), call. = FALSE)
}

lasrosas_source <- readRDS(source_path)
if (!"year" %in% names(lasrosas_source)) {
  stop("La colonne `year` est absente de la source Las Rosas.", call. = FALSE)
}

for (campaign in c(1999L, 2001L)) {
  task <- lasrosas_source[lasrosas_source$year == campaign, , drop = FALSE]
  if (nrow(task) == 0L) {
    stop(sprintf("Aucune observation Las Rosas pour %d.", campaign), call. = FALSE)
  }
  output_path <- file.path(
    out_dir,
    sprintf("R_agridat_lasrosas.corn_lasrosas.corn_%d.rds", campaign)
  )
  saveRDS(task, output_path, compress = "xz")
  message(sprintf("Ecrit %s (%d observations).", output_path, nrow(task)))
}
