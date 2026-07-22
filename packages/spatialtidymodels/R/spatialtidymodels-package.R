#' spatialtidymodels
#'
#' Tidymodels extension for spatial regression benchmarks.
#'
#' `spatialtidymodels` connects the `llm-wiki-karpathy` metadata workflow to
#' executable spatial regression benchmarks. The package is not only a
#' collection of wrappers: it is designed to consume curated metadata extracted
#' from dataset fiches and estimator fiches, then use that metadata to choose
#' formulas, coordinates, resampling schemes, estimator routes, and diagnostics.
#'
#' ## Metadata-driven workflow
#'
#' The project keeps the human-readable knowledge base in Markdown:
#'
#' * dataset fiches in `wiki/datasets/fiches_datasets/`;
#' * estimator fiches in `wiki/estimators/`;
#' * methodological schemas in `wiki/metadata/`.
#'
#' The intended package workflow is:
#'
#' 1. validate and enrich the Markdown fiches;
#' 2. export machine-readable dataset and estimator registries;
#' 3. load those registries from the package;
#' 4. run benchmarks through stable R functions.
#'
#' This keeps the scientific decisions visible in the wiki while giving R users
#' a compact API.
#'
#' ## Dataset metadata
#'
#' Dataset fiches provide the information used by
#' [available_benchmark_datasets()] and [benchmark_spatial_dataset()]:
#'
#' * dataset identifier and source package;
#' * response variable and candidate predictors;
#' * published formula when available;
#' * generated formula candidates when no published formula was found;
#' * coordinate columns, CRS, geometry type, and spatial support;
#' * missing-value and duplicate checks;
#' * recommended benchmark eligibility.
#'
#' ## Estimator metadata
#'
#' Estimator fiches document which estimators are allowed by the project policy,
#' what each backend needs, and how it can enter the benchmark:
#'
#' * `parsnip` specification and engine;
#' * required spatial arguments such as `coords`, `W`, and `k_neighbors`;
#' * tunable hyperparameters such as `mstop` or `bandwidth`;
#' * diagnostics to inspect, including residual Moran's I when applicable;
#' * known failure modes and dataset compatibility constraints.
#'
#' ## Main user entry points
#'
#' Use [available_benchmark_datasets()] to list registered datasets and
#' [available_benchmark_estimators()] to list registered estimators. Use
#' [benchmark_spatial_dataset()] when a dataset is already registered, or
#' [benchmark_spatial()] when you provide a formula, data frame, and coordinate
#' columns manually.
#'
#' For quick model-level work, [fit_sar()], [fit_sem()], and [fit_sdm()] provide
#' a compact interface similar to `glm(formula, data)`. For full tidymodels
#' usage, use [sar_reg()], [sem_reg()], [sdm_reg()], [spboost_reg()],
#' [mgwrsar_reg()], and [spmoran_reg()] inside `workflows::workflow()`.
#'
#' ## Current scope
#'
#' The package currently focuses on regression benchmarks for spatial datasets.
#' Classification tasks, temporal forecasting tasks, and a fully automatic
#' export from all wiki fiches to package registries are planned follow-up
#' steps.
#'
#' @keywords internal
"_PACKAGE"

#' spatialtidymodels package overview
#'
#' Opens the package overview for `spatialtidymodels`.
#'
#' This help topic summarizes how the package connects the
#' `llm-wiki-karpathy` metadata workflow to executable spatial regression
#' benchmarks. It is intentionally exported so that `help(spatialtidymodels)`
#' and `?spatialtidymodels` resolve to a visible documentation page.
#'
#' @return Invisibly returns the package help object.
#' @export
spatialtidymodels <- function() {
  utils::help("spatialtidymodels-package", package = "spatialtidymodels")
}
