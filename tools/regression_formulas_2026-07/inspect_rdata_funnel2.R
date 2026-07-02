#!/usr/bin/env Rscript
# Second pass: extract the exact funnel numbers needed for the Tache 5 dashboard.
args <- commandArgs(trailingOnly = FALSE)
script_path <- sub("^--file=", "", args[grep("^--file=", args)])
root <- normalizePath(file.path(dirname(script_path), "..", ".."))
manifests <- file.path(root, "data", "manifests", "datasets")

e <- new.env()
load(file.path(manifests, "software_catalog_curated_final.RData"), envir = e)

cat("=== Synthese ===\n")
print(e$Synthese)

cat("\n=== Bons_candidats_spatial : keep x has_datetime ===\n")
print(table(e$Bons_candidats_spatial$keep, e$Bons_candidats_spatial$has_datetime, useNA = "ifany"))

cat("\n=== Bons_candidats_spatial (keep=='yes') : has_datetime ===\n")
bcs_kept <- e$Bons_candidats_spatial[!is.na(e$Bons_candidats_spatial$keep) & e$Bons_candidats_spatial$keep == "yes", ]
cat("n rows kept:", nrow(bcs_kept), "\n")
print(table(bcs_kept$has_datetime, useNA = "ifany"))
print(table(bcs_kept$has_geometry, useNA = "ifany"))
print(table(bcs_kept$geometry_type, useNA = "ifany"))

cat("\n=== Bons_candidats_spatial (keep=='yes') : source_language ===\n")
print(table(bcs_kept$source_language, useNA = "ifany"))

cat("\n=== Bons_candidats_spatial (keep=='yes') : N size summary ===\n")
print(summary(as.numeric(bcs_kept$n)))

cat("\n=== Bons_candidats_spatial (keep=='yes') : K size summary ===\n")
print(summary(as.numeric(bcs_kept$k)))

cat("\n=== Totals across all sheets in curated_final ===\n")
sheets <- c("Bons_candidats_spatial", "Declasser_auxiliaire_Python", "Declasser_auxiliaire_R",
            "ML_non_spatial", "Spatial_simple")
for (s in sheets) {
  df <- get(s, envir = e)
  cat(sprintf("%s: %d rows, keep=yes: %d\n", s, nrow(df),
              sum(!is.na(df$keep) & grepl("^yes", df$keep))))
}
total_rows <- sum(sapply(sheets, function(s) nrow(get(s, envir = e))))
total_keep <- sum(sapply(sheets, function(s) {
  df <- get(s, envir = e)
  sum(!is.na(df$keep) & grepl("^yes", df$keep))
}))
cat(sprintf("\nTOTAL rows across sheets: %d\n", total_rows))
cat(sprintf("TOTAL keep=yes(*) across sheets: %d\n", total_keep))

cat("\n=== rdata_manifest ===\n")
print(e$rdata_manifest)

# Cross-check against the combined catalog (before final curation split)
e2 <- new.env()
load(file.path(manifests, "software_catalog_combined.RData"), envir = e2)
cat("\n=== software_catalog_combined :: catalogue_combine_complet total ===\n")
cat("nrow:", nrow(e2$catalogue_combine_complet), "\n")
print(table(e2$catalogue_combine_complet$final_category, e2$catalogue_combine_complet$source_language, useNA = "ifany"))
