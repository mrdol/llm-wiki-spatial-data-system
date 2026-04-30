# R bridge for the existing Python scraping scripts.
#
# Use this file from the repository root:
# source("R/scraping/python_scraper_bridge.R")
#
# The bridge intentionally calls Python scripts as CLI commands with system2().
# This is more stable than importing them with reticulate because the current
# Python scrapers are argparse entry points.

find_project_python <- function(repo_root = getwd()) {
  # The project may be run from llm-wiki-karpathy while the virtualenv sits in
  # the parent workspace. Check both locations before falling back to PATH.
  parent_root <- dirname(normalizePath(repo_root, winslash = "/", mustWork = TRUE))
  candidates <- c(
    file.path(repo_root, ".venv", "Scripts", "python.exe"),
    file.path(repo_root, ".venv", "bin", "python"),
    file.path(parent_root, ".venv", "Scripts", "python.exe"),
    file.path(parent_root, ".venv", "bin", "python"),
    Sys.which("python")
  )
  candidates <- candidates[nzchar(candidates)]
  hits <- candidates[file.exists(candidates)]
  if (length(hits) == 0) {
    stop("No Python interpreter found. Expected .venv/Scripts/python.exe, .venv/bin/python, or python on PATH.", call. = FALSE)
  }
  normalizePath(hits[[1]], winslash = "/", mustWork = TRUE)
}

as_cli_args <- function(args) {
  # Convert a named R list into argparse-style flags.
  # TRUE becomes --flag, FALSE/NULL is skipped, other values become --flag value.
  if (is.null(args) || length(args) == 0) {
    return(character())
  }
  if (is.character(args) && is.null(names(args))) {
    return(args)
  }

  output <- character()
  for (name in names(args)) {
    value <- args[[name]]
    flag <- paste0("--", gsub("_", "-", name))

    if (is.null(value) || length(value) == 0 || isFALSE(value)) {
      next
    }
    if (isTRUE(value)) {
      output <- c(output, flag)
      next
    }
    output <- c(output, flag, as.character(value))
  }
  output
}

run_python_script <- function(script, args = list(), python = NULL, repo_root = getwd(), echo = TRUE) {
  if (is.null(python)) {
    python <- find_project_python(repo_root)
  }
  script_path <- file.path(repo_root, script)
  if (!file.exists(script_path)) {
    stop("Python script not found: ", script_path, call. = FALSE)
  }

  cli_args <- c(normalizePath(script_path, winslash = "/", mustWork = TRUE), as_cli_args(args))

  # Windows paths in this workspace contain spaces and an apostrophe, so every
  # argument is quoted before passing it to system2().
  quoted_args <- if (.Platform$OS.type == "windows") {
    shQuote(cli_args, type = "cmd")
  } else {
    shQuote(cli_args)
  }

  if (isTRUE(echo)) {
    message("Running: ", shQuote(python), " ", paste(quoted_args, collapse = " "))
  }

  output <- system2(python, args = quoted_args, stdout = TRUE, stderr = TRUE)
  status <- attr(output, "status")
  if (is.null(status)) {
    status <- 0L
  }

  result <- list(
    status = status,
    python = python,
    script = script,
    args = cli_args[-1],
    output = output
  )
  class(result) <- c("python_scraper_result", class(result))

  if (!identical(status, 0L)) {
    warning("Python scraper exited with status ", status, call. = FALSE)
  }
  result
}

print.python_scraper_result <- function(x, ...) {
  cat("Python scraper result\n")
  cat("  script:", x$script, "\n")
  cat("  status:", x$status, "\n")
  if (length(x$output) > 0) {
    cat(paste(x$output, collapse = "\n"), "\n")
  }
  invisible(x)
}

portal_scraper_scripts <- c(
  # Names exposed to R users on the left, Python entry points on the right.
  zenodo = "pipeline_portals/python/scrape_zenodo.py",
  figshare = "pipeline_portals/python/scrape_figshare.py",
  dataverse = "pipeline_portals/python/scrape_dataverse.py",
  dryad = "pipeline_portals/python/scrape_dryad.py",
  world_bank = "pipeline_portals/python/scrape_world_bank.py",
  eurostat = "pipeline_portals/python/scrape_eurostat.py",
  oecd = "pipeline_portals/python/scrape_oecd.py",
  un_comtrade = "pipeline_portals/python/scrape_un_comtrade.py",
  data_gouv = "pipeline_portals/python/scrape_data_gouv.py",
  insee = "pipeline_portals/python/scrape_insee.py",
  cepii = "pipeline_portals/python/scrape_cepii.py"
)

run_portal_scraper <- function(source,
                               query = NULL,
                               limit = 5,
                               max_pages = NULL,
                               page_size = NULL,
                               view = "summary",
                               pretty = TRUE,
                               write = FALSE,
                               download = FALSE,
                               plan = FALSE,
                               enrich_paper = FALSE,
                               mailto = NULL,
                               heavy_threshold_mb = NULL,
                               yes_heavy = FALSE,
                               extra_args = list(),
                               python = NULL,
                               repo_root = getwd(),
                               echo = TRUE) {
  # High-level R wrapper for all one-source portal scrapers.
  source <- match.arg(source, names(portal_scraper_scripts))
  args <- c(
    list(
      query = query,
      limit = limit,
      max_pages = max_pages,
      page_size = page_size,
      view = view,
      pretty = pretty,
      write = write,
      download = download,
      plan = plan,
      enrich_paper = enrich_paper,
      mailto = mailto,
      heavy_threshold_mb = heavy_threshold_mb,
      yes_heavy = yes_heavy
    ),
    extra_args
  )
  run_python_script(
    script = unname(portal_scraper_scripts[[source]]),
    args = args,
    python = python,
    repo_root = repo_root,
    echo = echo
  )
}

run_portal_plan <- function(warehouse_id = NULL,
                            dataset_id = NULL,
                            plan = NULL,
                            include_nonpreferred = FALSE,
                            enrich_paper = FALSE,
                            mailto = NULL,
                            write = NULL,
                            pretty = TRUE,
                            python = NULL,
                            repo_root = getwd(),
                            echo = TRUE) {
  # Build a dry-run job plan from local catalog metadata.
  run_python_script(
    script = "pipeline_portals/python/run_portal_plan.py",
    args = list(
      warehouse_id = warehouse_id,
      dataset_id = dataset_id,
      plan = plan,
      include_nonpreferred = include_nonpreferred,
      enrich_paper = enrich_paper,
      mailto = mailto,
      write = write,
      pretty = pretty
    ),
    python = python,
    repo_root = repo_root,
    echo = echo
  )
}

run_portal_jobs <- function(warehouse_id = NULL,
                            dataset_id = NULL,
                            plan = NULL,
                            include_nonpreferred = FALSE,
                            enrich_paper = FALSE,
                            mailto = NULL,
                            limit = NULL,
                            use_playwright = NULL,
                            python = NULL,
                            repo_root = getwd(),
                            echo = TRUE) {
  # Execute controlled portal jobs. This can perform HTTP requests.
  run_python_script(
    script = "pipeline_portals/python/execute_portal_jobs.py",
    args = list(
      warehouse_id = warehouse_id,
      dataset_id = dataset_id,
      plan = plan,
      include_nonpreferred = include_nonpreferred,
      enrich_paper = enrich_paper,
      mailto = mailto,
      limit = limit,
      use_playwright = use_playwright
    ),
    python = python,
    repo_root = repo_root,
    echo = echo
  )
}

run_literature_plan <- function(warehouse_id = NULL,
                                dataset_id = NULL,
                                plan = NULL,
                                mailto = NULL,
                                write = NULL,
                                pretty = TRUE,
                                python = NULL,
                                repo_root = getwd(),
                                echo = TRUE) {
  # Build OpenAlex/Crossref request plans without executing the literature APIs.
  run_python_script(
    script = "pipeline_lit/run_literature_plan.py",
    args = list(
      warehouse_id = warehouse_id,
      dataset_id = dataset_id,
      plan = plan,
      mailto = mailto,
      write = write,
      pretty = pretty
    ),
    python = python,
    repo_root = repo_root,
    echo = echo
  )
}
