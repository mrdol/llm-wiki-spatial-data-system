# Snapshot chiffres pour le data paper software datasets.
# Usage depuis la racine du depot:
#   Rscript code/r_catalog/datapaper_inventory_snapshot.R

cat("ROOT", getwd(), "\n")

load("data/manifests/datasets/software_catalog_combined.RData")
cat("objects_combined", paste(ls(), collapse = ","), "\n")

if (exists("catalogue_combine_complet")) {
  d <- catalogue_combine_complet
  cat("combined_rows", nrow(d), "\n")
  cat("combined_cols", ncol(d), "\n")
  if ("source_language" %in% names(d)) print(table(d$source_language, useNA = "ifany"))
  if ("categorie" %in% names(d)) print(table(d$categorie, useNA = "ifany"))
  if ("classification" %in% names(d)) print(table(d$classification, useNA = "ifany"))
  if ("statut_selection" %in% names(d)) print(table(d$statut_selection, useNA = "ifany"))
  if ("final_category" %in% names(d)) {
    cat("final_category\n")
    print(table(d$final_category, useNA = "ifany"))
  }
  if ("role" %in% names(d)) {
    cat("role\n")
    print(table(d$role, useNA = "ifany"))
  }
  if ("has_geometry" %in% names(d)) {
    cat("has_geometry\n")
    print(table(d$has_geometry, useNA = "ifany"))
  }
  if ("has_coordinates" %in% names(d)) {
    cat("has_coordinates\n")
    print(table(d$has_coordinates, useNA = "ifany"))
  }
  if ("has_datetime" %in% names(d)) {
    cat("has_datetime\n")
    print(table(d$has_datetime, useNA = "ifany"))
  }
  if ("has_referenced_paper" %in% names(d)) {
    cat("has_referenced_paper\n")
    print(table(d$has_referenced_paper, useNA = "ifany"))
  }
  if ("package" %in% names(d)) cat("packages", length(unique(d$package)), "\n")
  if ("record_id" %in% names(d)) cat("record_id_unique", length(unique(d$record_id)), "\n")
  cat("columns", paste(names(d), collapse = "|"), "\n")
}

cat("\n--- sf index ---\n")
load("data/Final_datasets/sf/catalogue_sf_index.RData")
cat("sf_objects", paste(ls(), collapse = ","), "\n")

if (exists("index_sf")) {
  cat("index_rows", nrow(index_sf), "\n")
  if ("utilisable" %in% names(index_sf)) print(table(index_sf$utilisable, useNA = "ifany"))
  if ("source_language" %in% names(index_sf)) print(table(index_sf$source_language, useNA = "ifany"))
  if ("famille_geometrie" %in% names(index_sf)) print(table(index_sf$famille_geometrie, useNA = "ifany"))
  if ("a_reponse" %in% names(index_sf)) print(table(index_sf$a_reponse, useNA = "ifany"))
  if ("a_formule" %in% names(index_sf)) print(table(index_sf$a_formule, useNA = "ifany"))
  if ("has_formule" %in% names(index_sf)) {
    cat("has_formule\n")
    print(table(index_sf$has_formule, useNA = "ifany"))
  }
  if ("has_formule_modele" %in% names(index_sf)) {
    cat("has_formule_modele\n")
    print(table(index_sf$has_formule_modele, useNA = "ifany"))
  }
  if ("a_variable_T" %in% names(index_sf)) print(table(index_sf$a_variable_T, useNA = "ifany"))
  if ("type_reponse" %in% names(index_sf)) {
    cat("type_reponse\n")
    print(table(index_sf$type_reponse, useNA = "ifany"))
  }
  cat("columns", paste(names(index_sf), collapse = "|"), "\n")
}

cat("\n--- audit ---\n")
load("data/Final_datasets/sf/catalogue_sf_metadata_audit.RData")

if (exists("audit_crs")) {
  cat("audit_crs_rows", nrow(audit_crs), "\n")
  print(table(audit_crs$confiance, useNA = "ifany"))
  print(table(audit_crs$provenance, useNA = "ifany"))
}

if (exists("audit_time")) {
  cat("audit_time_rows", nrow(audit_time), "\n")
  print(table(audit_time$verdict_temporel, useNA = "ifany"))
}
