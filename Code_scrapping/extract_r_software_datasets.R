# Extract selected R package datasets from downloaded CRAN source archives.
#
# Usage from the repository root:
# Rscript scripts/extract_r_software_datasets.R
#
# The script reads downloaded package archives under:
# data/downloads/software/r_datasets/cran_packages/
# and writes extractable tabular objects under:
# data/downloads/software/r_datasets/extracted_csv/

repo_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
cran_dir <- file.path(repo_root, "data", "downloads", "software", "r_datasets", "cran_packages")
out_dir <- file.path(repo_root, "data", "downloads", "software", "r_datasets", "extracted_csv")
manifest_path <- file.path(repo_root, "data", "manifests", "software_r_extracted_datasets.jsonl")

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(manifest_path), recursive = TRUE, showWarnings = FALSE)

targets <- list(
  list(package = "spdep", dataset = "columbus", patterns = c("columbus")),
  list(package = "spdep", dataset = "nc.sids", patterns = c("nc.sids", "sids")),
  list(package = "GWmodel", dataset = "Georgia", patterns = c("Georgia")),
  list(package = "GWmodel", dataset = "LondonHP", patterns = c("LondonHP")),
  list(package = "GWmodel", dataset = "EWHP", patterns = c("EWHP")),
  list(package = "GWmodel", dataset = "DubVoter", patterns = c("DubVoter")),
  list(package = "gstat", dataset = "meuse", patterns = c("meuse")),
  list(package = "gstat", dataset = "jura", patterns = c("jura")),
  list(package = "spacetime", dataset = "air", patterns = c("air")),
  list(package = "surveillance", dataset = "measles", patterns = c("measles")),
  list(package = "surveillance", dataset = "rotavirus", patterns = c("rotavirus")),
  list(package = "surveillance", dataset = "imdepi", patterns = c("imdepi")),
  list(package = "SpatialEpi", dataset = "pennLC", patterns = c("pennLC")),
  list(package = "SpatialEpi", dataset = "scotland", patterns = c("scotland")),
  list(package = "SpatialEpi", dataset = "NYleukemia", patterns = c("NYleukemia")),
  list(package = "SpatialEpi", dataset = "germany", patterns = c("germany")),
  list(package = "vegan", dataset = "mite", patterns = c("mite")),
  list(package = "vegan", dataset = "dune", patterns = c("dune")),
  list(package = "vegan", dataset = "varespec_varechem", patterns = c("vare")),
  list(package = "ade4", dataset = "doubs", patterns = c("doubs")),
  list(package = "ade4", dataset = "mafragh", patterns = c("mafragh")),
  list(package = "ade4", dataset = "rpjdl", patterns = c("rpjdl")),
  list(package = "dismo", dataset = "bradypus", patterns = c("bradypus"))
)

json_escape <- function(x) {
  x <- ifelse(is.na(x), "", as.character(x))
  x <- gsub("\\\\", "\\\\\\\\", x)
  x <- gsub('"', '\\"', x)
  x <- gsub("\n", "\\\\n", x)
  x
}

write_jsonl <- function(con, record) {
  keys <- names(record)
  values <- vapply(keys, function(key) {
    value <- record[[key]]
    if (is.null(value) || length(value) == 0 || all(is.na(value))) {
      "null"
    } else if (is.logical(value) && length(value) == 1) {
      if (isTRUE(value)) "true" else "false"
    } else if (is.numeric(value) && length(value) == 1) {
      as.character(value)
    } else {
      paste0('"', json_escape(paste(value, collapse = "; ")), '"')
    }
  }, character(1))
  writeLines(paste0("{", paste(paste0('"', keys, '":', values), collapse = ","), "}"), con)
}

safe_filename <- function(x) {
  x <- gsub("[^A-Za-z0-9._-]+", "_", x)
  x <- gsub("^_+|_+$", "", x)
  if (!nzchar(x)) "object" else x
}

archive_for_package <- function(package) {
  hits <- list.files(cran_dir, pattern = paste0("^", package, "_.*[.]tar[.]gz$"), full.names = TRUE)
  if (length(hits) == 0) return(NA_character_)
  hits[[1]]
}

is_candidate_member <- function(member, patterns) {
  lower <- tolower(member)
  grepl("/data/.*[.](rda|RData)$", member, ignore.case = TRUE) &&
    any(vapply(patterns, function(pattern) grepl(tolower(pattern), lower, fixed = TRUE), logical(1)))
}

as_tabular <- function(object) {
  if (inherits(object, "data.frame")) {
    return(as.data.frame(object))
  }
  if (is.matrix(object) || is.table(object)) {
    return(as.data.frame(object))
  }
  if (is.vector(object) && !is.list(object)) {
    return(data.frame(value = object))
  }
  if (is.list(object) && length(object) > 0) {
    simple_lengths <- vapply(object, function(item) {
      if (is.atomic(item) && length(dim(item)) == 0) length(item) else -1L
    }, integer(1))
    if (all(simple_lengths > 0) && length(unique(simple_lengths)) == 1) {
      return(as.data.frame(object, stringsAsFactors = FALSE))
    }
    frames <- object[vapply(object, inherits, logical(1), what = "data.frame")]
    if (length(frames) > 0) {
      frames <- Map(function(name, frame) {
        frame <- as.data.frame(frame)
        frame$component <- name
        frame
      }, names(frames), frames)
      return(do.call(rbind, frames))
    }
  }
  NULL
}

manifest_con <- file(manifest_path, open = "w", encoding = "UTF-8")
on.exit(close(manifest_con), add = TRUE)

for (target in targets) {
  archive <- archive_for_package(target$package)
  target_dir <- file.path(out_dir, target$package, target$dataset)
  dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)

  if (is.na(archive)) {
    write_jsonl(manifest_con, list(
      package = target$package,
      dataset = target$dataset,
      status = "archive_not_found",
      archive = NA_character_,
      member = NA_character_,
      object = NA_character_,
      output = NA_character_,
      rows = NA_real_,
      columns = NA_real_
    ))
    next
  }

  members <- utils::untar(archive, list = TRUE)
  candidates <- members[vapply(members, is_candidate_member, logical(1), patterns = target$patterns)]
  if (length(candidates) == 0) {
    write_jsonl(manifest_con, list(
      package = target$package,
      dataset = target$dataset,
      status = "data_file_not_found",
      archive = archive,
      member = NA_character_,
      object = NA_character_,
      output = NA_character_,
      rows = NA_real_,
      columns = NA_real_
    ))
    next
  }

  temp_dir <- tempfile("rdata_extract_")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE, force = TRUE), add = TRUE)
  utils::untar(archive, files = candidates, exdir = temp_dir)

  for (member in candidates) {
    data_path <- file.path(temp_dir, member)
    env <- new.env(parent = emptyenv())
    loaded <- try(load(data_path, envir = env), silent = TRUE)
    if (inherits(loaded, "try-error")) {
      write_jsonl(manifest_con, list(
        package = target$package,
        dataset = target$dataset,
        status = "load_failed",
        archive = archive,
        member = member,
        object = NA_character_,
        output = NA_character_,
        rows = NA_real_,
        columns = NA_real_
      ))
      next
    }

    for (object_name in loaded) {
      object <- get(object_name, envir = env)
      table <- try(as_tabular(object), silent = TRUE)
      if (inherits(table, "try-error") || is.null(table)) {
        write_jsonl(manifest_con, list(
          package = target$package,
          dataset = target$dataset,
          status = "not_tabular",
          archive = archive,
          member = member,
          object = object_name,
          output = NA_character_,
          rows = NA_real_,
          columns = NA_real_
        ))
        next
      }

      output <- file.path(target_dir, paste0(safe_filename(object_name), ".csv"))
      utils::write.csv(table, output, row.names = FALSE, fileEncoding = "UTF-8")
      write_jsonl(manifest_con, list(
        package = target$package,
        dataset = target$dataset,
        status = "extracted_csv",
        archive = archive,
        member = member,
        object = object_name,
        output = output,
        rows = nrow(table),
        columns = ncol(table)
      ))
    }
  }
}

cat("Extraction manifest:", manifest_path, "\n")
