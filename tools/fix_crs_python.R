#!/usr/bin/env Rscript
# fix_crs_python.R
#
# OBSOLETE depuis l'integration de CRS_OVERRIDES dans build_sf_datasets.R.
# La normalisation CRS (Cat A st_transform + Cat B CRS_OVERRIDES) est
# desormais appliquee directement dans build_sf_datasets.R avant le saveRDS.
# Ce script est conserve a titre de reference diagnostique uniquement.
#
# Correction des problemes de CRS sur les datasets Python convertis en sf.
#
# Categorie A (4 datasets) : CRS projete correctement declare -> st_transform(4326)
# Categorie B (6 datasets) : CRS 4326 declare mais bbox incoherente -> diagnostic
#
# Usage : source() dans RStudio

library(sf)

REPO <- "C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/llm-wiki-karpathy"
SF_DIR <- file.path(REPO, "data/Final_datasets/sf")

cat("=======================================================\n")
cat("  CATEGORIE A — CRS projete -> st_transform(4326)\n")
cat("=======================================================\n\n")

# Datasets avec CRS projete correctement declare, a transformer en WGS84
cat_a <- list(
  list(file = "Python_geodatasets_geoda.guerry.rds",
       crs_actuel = 27572, label = "Guerry (Lambert II France)"),
  list(file = "Python_geodatasets_geoda.nyc.rds",
       crs_actuel = 2263, label = "NYC (NY State Plane ft)"),
  list(file = "Python_geodatasets_geoda.nyc_education.rds",
       crs_actuel = 2263, label = "NYC Education (NY State Plane ft)"),
  list(file = "Python_libpysal_chicagoSDOH.rds",
       crs_actuel = 3435, label = "ChicagoSDOH (Illinois State Plane)")
)

for (ds in cat_a) {
  path <- file.path(SF_DIR, ds$file)
  cat(sprintf("--- %s ---\n", ds$label))

  if (!file.exists(path)) {
    cat("  WARN: fichier absent, ignore\n\n"); next
  }

  obj <- readRDS(path)
  cat(sprintf("  CRS actuel : EPSG %d\n", st_crs(obj)$epsg))
  cat(sprintf("  bbox avant : xmin=%.3f xmax=%.3f ymin=%.3f ymax=%.3f\n",
    st_bbox(obj)["xmin"], st_bbox(obj)["xmax"],
    st_bbox(obj)["ymin"], st_bbox(obj)["ymax"]))

  obj_wgs84 <- st_transform(obj, 4326)

  cat(sprintf("  bbox apres : xmin=%.4f xmax=%.4f ymin=%.4f ymax=%.4f\n",
    st_bbox(obj_wgs84)["xmin"], st_bbox(obj_wgs84)["xmax"],
    st_bbox(obj_wgs84)["ymin"], st_bbox(obj_wgs84)["ymax"]))

  saveRDS(obj_wgs84, path)
  cat("  -> Sauvegarde OK\n\n")
}

cat("=======================================================\n")
cat("  CATEGORIE B — CRS 4326 declare, bbox incoherente\n")
cat("  Diagnostic uniquement — aucune modification auto\n")
cat("=======================================================\n\n")

cat_b <- list(
  list(file = "Python_libpysal_Baltimore.rds",
       label = "Baltimore", expected = "x~[-77,-76] y~[39,40]"),
  list(file = "Python_geodatasets_spdata.eire.rds",
       label = "Eire (Irlande)", expected = "x~[-10,-6] y~[51,55]"),
  list(file = "Python_geodatasets_spdata.nydata.rds",
       label = "NYdata (NYC)", expected = "x~[-74.3,-73.7] y~[40.5,40.9]"),
  list(file = "Python_libpysal_georgia.rds",
       label = "Georgia (etat US ou pays)", expected = "x~[-85,-81] y~[30,35] (US) ou x~[39,47] y~[41,44] (pays)"),
  list(file = "Python_libpysal_Ohiolung.rds",
       label = "Ohiolung (Ohio)", expected = "x~[-84,-80] y~[38,42]"),
  list(file = "Python_geodatasets_geoda.cincinnati.rds",
       label = "Cincinnati", expected = "x~[-84.7,-84.3] y~[39.0,39.3]")
)

for (ds in cat_b) {
  path <- file.path(SF_DIR, ds$file)
  cat(sprintf("--- %s ---\n", ds$label))
  cat(sprintf("  Attendu : %s\n", ds$expected))

  if (!file.exists(path)) {
    cat("  WARN: fichier absent, ignore\n\n"); next
  }

  obj <- readRDS(path)
  bb <- st_bbox(obj)
  crs_epsg <- st_crs(obj)$epsg
  coords_sample <- head(st_coordinates(obj), 3)

  cat(sprintf("  CRS declare : EPSG %s\n", ifelse(is.na(crs_epsg), "NA", crs_epsg)))
  cat(sprintf("  bbox actuelle : xmin=%.3f xmax=%.3f ymin=%.3f ymax=%.3f\n",
    bb["xmin"], bb["xmax"], bb["ymin"], bb["ymax"]))
  cat("  Echantillon coords (3 premiers points) :\n")
  print(coords_sample)

  # Heuristique : les coords ressemblent a un systeme local (petits entiers)?
  x_range <- bb["xmax"] - bb["xmin"]
  y_range <- bb["ymax"] - bb["ymin"]
  if (x_range < 200 && y_range < 200 &&
      all(abs(coords_sample[,1]) < 200) &&
      all(abs(coords_sample[,2]) < 200)) {
    cat("  DIAGNOSTIC : coordonnees semblent en systeme local (petites valeurs)\n")
    cat("  ACTION : identifier le vrai CRS dans la source Python originale\n")
    cat("  COMMANDE Python : gdf.crs  # dans le package source\n")
  } else {
    cat("  DIAGNOSTIC : coordonnees en grands nombres (systeme projete?)\n")
    cat("  ACTION : essayer st_transform depuis le CRS d'origine\n")
  }
  cat("\n")
}

cat("=======================================================\n")
cat("  APRES CORRECTIONS : relancer export_sf_metadata.R\n")
cat("  puis regenerer les fiches avec generate_fiches.py\n")
cat("=======================================================\n")
