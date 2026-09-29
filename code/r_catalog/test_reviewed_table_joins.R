# Focused regression checks; no benchmark run and no artifact mutation.
source("code/r_catalog/build_sf_datasets.R")
for (name in c("doubs", "mafragh")) {
  e <- new.env(parent=baseenv())
  utils::data(list=name, package="ade4", envir=e)
  native <- get(name, envir=e)
  first <- if (name == "doubs") "fish" else "flo"
  original <- native[[first]]
  native[[first]] <- original[rev(seq_len(nrow(original))), , drop=FALSE]
  joined <- coerce_to_sf(native, list(package="ade4", dataset_name=name))
  stopifnot(!is_fail(joined))
  for (column in names(original)) stopifnot(identical(joined[[paste(first,column,sep="__")]], original[[column]]))
  native[[first]] <- original[-1, , drop=FALSE]
  stopifnot(is_fail(coerce_to_sf(native, list(package="ade4", dataset_name=name))))
}
suppressPackageStartupMessages(library(sf))
parent <- readRDS("data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds")
for (year in c(1999L, 2001L)) {
  task <- readRDS(sprintf("data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn_%d.rds",year))
  rows <- which(parent$year == year)
  stopifnot(inherits(st_geometry(task),"sfc"),nrow(task)==length(rows))
  for (column in names(parent)) stopifnot(isTRUE(all.equal(task[[column]],parent[[column]][rows])))
}
cat("PASS: 2 keyed site joins (permuted/missing keys), 2 Las Rosas subsets (all columns and geometry).\n")
