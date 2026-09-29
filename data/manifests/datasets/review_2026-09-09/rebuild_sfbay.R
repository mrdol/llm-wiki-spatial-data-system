source('code/r_catalog/build_sf_datasets_papers.R')
dir.create('data/interim/dataset_review_2026-09-09',recursive=TRUE,showWarnings=FALSE)
p <- 'data/final_datasets/sf/paper_sfbay_contaminated_sites.rds'
backup <- 'data/interim/dataset_review_2026-09-09/paper_sfbay_contaminated_sites_before.rds'
if(!file.exists(backup)) stopifnot(file.copy(p,backup))
a <- load_sfbay_contaminated_sites()
stopifnot(nrow(a$obj)==5297,sum(a$obj$is_open_case==0)==3817,sum(a$obj$is_open_case==1)==1480)
stopifnot(all(c('FID_WRCB_S','GLOBAL_ID','STATUS_SHO','source_file') %in% names(a$obj)))
result <- convert_paper_dataset('sfbay_contaminated_sites')
stopifnot(nrow(readRDS(p))==5297)
cat('source counts preserved; output columns',ncol(result$sf),'non-geometry',sum(!vapply(result$sf,inherits,logical(1),'sfc')),'\n')
