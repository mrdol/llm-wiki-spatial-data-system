# Restore documented site attributes without choosing a response or a formula.
source("code/r_catalog/build_sf_datasets.R")
library(jsonlite)
results <- list()
for (dataset_name in c("doubs", "mafragh")) {
  env <- new.env(parent = baseenv())
  utils::data(list=dataset_name, package="ade4", envir=env)
  source_obj <- get(dataset_name, envir=env)
  restored <- coerce_to_sf(source_obj, list(package="ade4", dataset_name=dataset_name))
  if (is_fail(restored)) stop(reason_of(restored))
  id <- paste0("R_ade4_",dataset_name,"_",dataset_name)
  path <- file.path("data/final_datasets/sf",paste0(id,".rds"))
  old <- readRDS(path)
  # The existing geometry and row order must agree exactly with native xy.
  xy_old <- sf::st_coordinates(sf::st_geometry(old))[,1:2,drop=FALSE]
  xy_new <- sf::st_coordinates(restored)[,1:2,drop=FALSE]
  stopifnot(nrow(old)==nrow(restored),isTRUE(all.equal(unname(xy_old),unname(xy_new),tolerance=1e-9)))
  attrs <- sf::st_drop_geometry(restored)
  cols <- grep("^(env|fish|flo)__", names(attrs), value=TRUE)
  for (name in cols) old[[name]] <- attrs[[name]]
  attr(old,"site_table_provenance") <- list(package="ade4",version=as.character(packageVersion("ade4")),join="native xy rownames; exact key set and coordinate alignment verified",response="not_selected",formula="pending")
  saveRDS(old,path)
  results[[id]] <- list(n=nrow(old),k_attributes=sum(!vapply(old,inherits,logical(1),"sfc")),added_columns=cols,join="keys and geometry verified",formula="pending",package_include="manual_review")
}
jsonlite::write_json(results,"data/manifests/datasets/ade4_reviewed_table_joins_2026-09-07.json",pretty=TRUE,auto_unbox=TRUE)
cat("Restored:",paste(names(results),collapse=", "),"; no Y/formula selected\n")
