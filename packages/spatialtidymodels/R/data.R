#' Registered spatial benchmark datasets
#'
#' Prepared spatial regression datasets bundled with `spatialtidymodels`.
#' Each object can be loaded with `data(<name>, package = "spatialtidymodels")`
#' and is also known by `benchmark_spatial_dataset()`.
#'
#' @format Data frames or `sf` objects with prepared coordinate columns.
#'
#' @section Available objects:
#' `georgia`, `columbus_crime`, `london_hp`, `boston_housing`, `dub_voter`,
#' `ewhp`, and `lasrosas`.
#'
#' @examples
#' data(columbus_crime, package = "spatialtidymodels")
#' head(columbus_crime)
#'
#' @name spatial_benchmark_datasets
NULL

#' @rdname spatial_benchmark_datasets
"georgia"

#' @rdname spatial_benchmark_datasets
"columbus_crime"

#' @rdname spatial_benchmark_datasets
"london_hp"

#' @rdname spatial_benchmark_datasets
"boston_housing"

#' @rdname spatial_benchmark_datasets
"dub_voter"

#' @rdname spatial_benchmark_datasets
"ewhp"

#' @rdname spatial_benchmark_datasets
"lasrosas"
