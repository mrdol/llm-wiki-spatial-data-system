#!/usr/bin/env Rscript

# Build a small monitor-level benchmark prototype for PM2.5, NO2 and O3.
# This is not a full reproduction of Di/Requia et al.; it starts with public,
# lightweight sources that can be downloaded without Earthdata credentials.

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0 || is.na(x)) y else x
}

repo_root <- normalizePath(getwd(), mustWork = TRUE)
if (!dir.exists(file.path(repo_root, "data"))) {
  stop("Run this script from the llm-wiki-karpathy repository root.", call. = FALSE)
}

get_arg <- function(name, default = NULL) {
  args <- commandArgs(trailingOnly = TRUE)
  key <- paste0("--", name, "=")
  hit <- grep(paste0("^", key), args, value = TRUE)
  if (length(hit) == 0) return(default)
  sub(paste0("^", key), "", hit[[1]])
}

year <- as.integer(get_arg("year", "2016"))
state_code <- sprintf("%02d", as.integer(get_arg("state", "25"))) # 25 = Massachusetts
include_elevation <- tolower(get_arg("elevation", "true")) %in% c("true", "1", "yes")
include_power <- tolower(get_arg("power", "true")) %in% c("true", "1", "yes")
include_nlcd <- tolower(get_arg("nlcd", "true")) %in% c("true", "1", "yes")
include_roads <- tolower(get_arg("roads", "true")) %in% c("true", "1", "yes")

required <- c("sf", "jsonlite")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0) {
  stop("Missing R package(s): ", paste(missing, collapse = ", "), call. = FALSE)
}

dir_create <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE, showWarnings = FALSE)
}

raw_dir <- file.path(repo_root, "data", "raw", "covariates", "airdata")
roads_dir <- file.path(repo_root, "data", "raw", "covariates", "tiger_roads_2016")
power_cache_dir <- file.path(repo_root, "data", "raw", "covariates", "nasa_power_cache")
out_dir <- file.path(repo_root, "data", "interim", "air_quality_monitor_covariates")
final_dir <- file.path(repo_root, "data", "final_datasets", "sf")
dir_create(raw_dir)
dir_create(roads_dir)
dir_create(power_cache_dir)
dir_create(out_dir)
dir_create(final_dir)

pollutants <- list(
  pm25 = list(
    aqs_parameter = "88101",
    response = "pm25_mean_2016",
    local_grid = file.path(final_dir, "paper_pm25_grid.rds"),
    grid_value = "PM25_2016"
  ),
  no2 = list(
    aqs_parameter = "42602",
    response = "no2_mean_2016",
    local_grid = file.path(final_dir, "paper_no2_grid.rds"),
    grid_value = "NO2_2016"
  ),
  o3 = list(
    aqs_parameter = "44201",
    response = "o3_mean_2016",
    local_grid = file.path(final_dir, "paper_o3_grid.rds"),
    grid_value = "O3_2016"
  )
)

safe_names <- function(x) {
  gsub("[^A-Za-z0-9_]+", "_", x)
}

download_airdata <- function(parameter, year) {
  zip_name <- sprintf("daily_%s_%s.zip", parameter, year)
  dest <- file.path(raw_dir, zip_name)
  if (!file.exists(dest)) {
    url <- sprintf("https://aqs.epa.gov/aqsweb/airdata/%s", zip_name)
    message("[download] ", url)
    utils::download.file(url, dest, mode = "wb", quiet = FALSE)
  }
  dest
}

read_airdata_zip <- function(zip_path) {
  csv_name <- unzip(zip_path, list = TRUE)$Name[[1]]
  con <- unz(zip_path, csv_name)
  utils::read.csv(con, check.names = FALSE, stringsAsFactors = FALSE)
}

pick_response_col <- function(df) {
  candidates <- c(
    "Arithmetic Mean",
    "Daily Mean PM2.5 Concentration",
    "1st Max Value",
    "Sample Measurement"
  )
  hit <- candidates[candidates %in% names(df)]
  if (length(hit) == 0) {
    stop("No supported measurement column found. Columns: ", paste(names(df), collapse = ", "))
  }
  hit[[1]]
}

site_id_from <- function(df) {
  paste(
    sprintf("%02d", as.integer(df[["State Code"]])),
    sprintf("%03d", as.integer(df[["County Code"]])),
    sprintf("%04d", as.integer(df[["Site Num"]])),
    sep = "-"
  )
}

summarise_monitors <- function(df, state_code, response_name) {
  df <- df[sprintf("%02d", as.integer(df[["State Code"]])) == state_code, , drop = FALSE]
  if (nrow(df) == 0) stop("No AQS rows for state code ", state_code)
  y_col <- pick_response_col(df)
  df$.site_id <- site_id_from(df)
  df$.y <- suppressWarnings(as.numeric(df[[y_col]]))
  df$.lat <- suppressWarnings(as.numeric(df[["Latitude"]]))
  df$.lon <- suppressWarnings(as.numeric(df[["Longitude"]]))
  if ("Date Local" %in% names(df)) {
    df$.date <- as.character(df[["Date Local"]])
  } else {
    df$.date <- seq_len(nrow(df))
  }
  keep <- stats::complete.cases(df[, c(".site_id", ".date", ".y", ".lat", ".lon")])
  df <- df[keep, , drop = FALSE]

  # AirData may contain several rows for a same site-day. Average first by day
  # so annual means are not biased by duplicate daily records.
  daily_y <- stats::aggregate(.y ~ .site_id + .date, df, mean, na.rm = TRUE)
  site_meta <- stats::aggregate(
    cbind(.lat, .lon) ~ .site_id,
    df,
    function(x) mean(x, na.rm = TRUE)
  )
  site_codes <- df[!duplicated(df$.site_id), c(".site_id", "State Code", "County Code", "Site Num"), drop = FALSE]
  split_df <- split(daily_y, daily_y$.site_id)
  rows <- lapply(split_df, function(x) {
    meta <- site_meta[site_meta$.site_id == x$.site_id[[1]], , drop = FALSE]
    codes <- site_codes[site_codes$.site_id == x$.site_id[[1]], , drop = FALSE]
    data.frame(
      site_id = x$.site_id[[1]],
      state_code = sprintf("%02d", as.integer(codes[["State Code"]][[1]])),
      county_code = sprintf("%03d", as.integer(codes[["County Code"]][[1]])),
      site_num = sprintf("%04d", as.integer(codes[["Site Num"]][[1]])),
      latitude = meta$.lat[[1]],
      longitude = meta$.lon[[1]],
      n_daily_observations = sum(!is.na(x$.y)),
      response_value = mean(x$.y, na.rm = TRUE),
      measurement_column = y_col,
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, rows)
  names(out)[names(out) == "response_value"] <- response_name
  out
}

join_nearest_grid_prediction <- function(monitors, grid_path, grid_value, pollutant_name) {
  if (!file.exists(grid_path)) {
    warning("Local grid RDS not found: ", grid_path)
    monitors[[paste0(pollutant_name, "_grid_prediction_2016")]] <- NA_real_
    return(monitors)
  }
  grid <- readRDS(grid_path)
  grid_df <- as.data.frame(grid)
  if (!all(c("lon", "lat", grid_value) %in% names(grid_df))) {
    warning("Grid lacks lon/lat/value columns: ", grid_path)
    monitors[[paste0(pollutant_name, "_grid_prediction_2016")]] <- NA_real_
    return(monitors)
  }
  grid_sf <- sf::st_as_sf(
    grid_df[, c("lon", "lat", grid_value)],
    coords = c("lon", "lat"),
    crs = 4326,
    remove = FALSE
  )
  mon_sf <- sf::st_as_sf(monitors, coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)
  idx <- sf::st_nearest_feature(mon_sf, grid_sf)
  monitors[[paste0(pollutant_name, "_grid_prediction_2016")]] <- grid_df[[grid_value]][idx]
  monitors[[paste0(pollutant_name, "_grid_distance_m")]] <- as.numeric(
    sf::st_distance(mon_sf, grid_sf[idx, ], by_element = TRUE)
  )
  monitors
}

fetch_elevation <- function(lon, lat) {
  url <- sprintf(
    "https://epqs.nationalmap.gov/v1/json?x=%.8f&y=%.8f&wkid=4326&units=Meters&includeDate=False",
    lon, lat
  )
  out <- tryCatch({
    txt <- paste(readLines(url, warn = FALSE), collapse = "")
    parsed <- jsonlite::fromJSON(txt)
    as.numeric(parsed$value)
  }, error = function(e) NA_real_)
  out
}

add_elevation <- function(monitors) {
  if (!include_elevation) {
    monitors$elevation_m_usgs_epqs <- NA_real_
    return(monitors)
  }
  message("[covariate] USGS elevation for ", nrow(monitors), " monitor(s)")
  monitors$elevation_m_usgs_epqs <- vapply(
    seq_len(nrow(monitors)),
    function(i) {
      Sys.sleep(0.05)
      fetch_elevation(monitors$longitude[[i]], monitors$latitude[[i]])
    },
    numeric(1)
  )
  monitors
}
fetch_power_annual <- function(lon, lat, year) {
  params <- "T2M,RH2M,WS10M,PRECTOTCORR,ALLSKY_SFC_SW_DWN,PS"
  key <- sprintf("power_%s_%0.4f_%0.4f.json", year, lon, lat)
  key <- gsub("[^A-Za-z0-9_.-]", "_", key)
  cache <- file.path(power_cache_dir, key)
  if (!file.exists(cache)) {
    url <- paste0(
      "https://power.larc.nasa.gov/api/temporal/daily/point?",
      "parameters=", params,
      "&community=AG&longitude=", sprintf("%.6f", lon),
      "&latitude=", sprintf("%.6f", lat),
      "&start=", year, "0101&end=", year, "1231",
      "&format=JSON&time-standard=UTC"
    )
    txt <- paste(readLines(url, warn = FALSE), collapse = "")
    writeLines(txt, cache, useBytes = TRUE)
    Sys.sleep(0.2)
  }
  parsed <- tryCatch(jsonlite::fromJSON(cache), error = function(e) NULL)
  if (is.null(parsed) || is.null(parsed$properties$parameter)) {
    return(setNames(rep(NA_real_, 6), c(
      "power_t2m_mean_c", "power_rh2m_mean_pct", "power_ws10m_mean_m_s",
      "power_prectotcorr_sum_mm", "power_swdwn_mean_mj_m2_day", "power_ps_mean_kpa"
    )))
  }
  p <- parsed$properties$parameter
  c(
    power_t2m_mean_c = mean(as.numeric(unlist(p$T2M)), na.rm = TRUE),
    power_rh2m_mean_pct = mean(as.numeric(unlist(p$RH2M)), na.rm = TRUE),
    power_ws10m_mean_m_s = mean(as.numeric(unlist(p$WS10M)), na.rm = TRUE),
    power_prectotcorr_sum_mm = sum(as.numeric(unlist(p$PRECTOTCORR)), na.rm = TRUE),
    power_swdwn_mean_mj_m2_day = mean(as.numeric(unlist(p$ALLSKY_SFC_SW_DWN)), na.rm = TRUE),
    power_ps_mean_kpa = mean(as.numeric(unlist(p$PS)), na.rm = TRUE)
  )
}

add_power_weather <- function(monitors) {
  if (!include_power) return(monitors)
  message("[covariate] NASA POWER weather for ", nrow(monitors), " monitor(s)")
  vals <- t(vapply(
    seq_len(nrow(monitors)),
    function(i) fetch_power_annual(monitors$longitude[[i]], monitors$latitude[[i]], year),
    numeric(6)
  ))
  cbind(monitors, as.data.frame(vals, check.names = FALSE))
}

nlcd_labels <- c(
  `11` = "Open Water", `12` = "Perennial Ice/Snow",
  `21` = "Developed, Open Space", `22` = "Developed, Low Intensity",
  `23` = "Developed, Medium Intensity", `24` = "Developed, High Intensity",
  `31` = "Barren Land", `41` = "Deciduous Forest", `42` = "Evergreen Forest",
  `43` = "Mixed Forest", `52` = "Shrub/Scrub", `71` = "Grassland/Herbaceous",
  `81` = "Pasture/Hay", `82` = "Cultivated Crops", `90` = "Woody Wetlands",
  `95` = "Emergent Herbaceous Wetlands"
)

fetch_nlcd <- function(lon, lat, year) {
  geom <- jsonlite::toJSON(list(x = lon, y = lat, spatialReference = list(wkid = 4326)), auto_unbox = TRUE)
  mosaic <- jsonlite::toJSON(list(where = sprintf("Year=%s", year)), auto_unbox = TRUE)
  url <- paste0(
    "https://di-nlcd.img.arcgis.com/arcgis/rest/services/USA_NLCD_Annual_LandCover/ImageServer/identify?",
    "f=json&geometry=", utils::URLencode(geom, reserved = TRUE),
    "&geometryType=esriGeometryPoint&returnGeometry=false&returnCatalogItems=false",
    "&mosaicRule=", utils::URLencode(mosaic, reserved = TRUE)
  )
  out <- tryCatch({
    parsed <- jsonlite::fromJSON(paste(readLines(url, warn = FALSE), collapse = ""))
    as.integer(parsed$value)
  }, error = function(e) NA_integer_)
  Sys.sleep(0.1)
  out
}

add_nlcd <- function(monitors) {
  if (!include_nlcd) return(monitors)
  message("[covariate] NLCD land cover for ", nrow(monitors), " monitor(s)")
  code <- vapply(seq_len(nrow(monitors)), function(i) fetch_nlcd(monitors$longitude[[i]], monitors$latitude[[i]], year), integer(1))
  label <- unname(nlcd_labels[as.character(code)])
  monitors$nlcd_land_cover_code <- code
  monitors$nlcd_land_cover_label <- ifelse(is.na(label), NA_character_, label)
  monitors$nlcd_developed <- as.integer(code %in% c(21L, 22L, 23L, 24L))
  monitors$nlcd_forest <- as.integer(code %in% c(41L, 42L, 43L))
  monitors$nlcd_agriculture <- as.integer(code %in% c(81L, 82L))
  monitors$nlcd_water <- as.integer(code == 11L)
  monitors
}

download_state_prisec_roads <- function(state_code) {
  zip_name <- sprintf("tl_2016_%s_prisecroads.zip", state_code)
  zip_path <- file.path(roads_dir, zip_name)
  if (!file.exists(zip_path)) {
    url <- sprintf("https://www2.census.gov/geo/tiger/TIGER2016/PRISECROADS/%s", zip_name)
    message("[download] ", url)
    utils::download.file(url, zip_path, mode = "wb", quiet = TRUE)
  }
  unzip_dir <- file.path(roads_dir, tools::file_path_sans_ext(zip_name))
  if (!dir.exists(unzip_dir)) unzip(zip_path, exdir = unzip_dir)
  shp <- list.files(unzip_dir, pattern = "\\.shp$", full.names = TRUE)
  shp[[1]]
}

read_roads_for_monitors <- function(monitors) {
  shp <- download_state_prisec_roads(state_code)
  suppressWarnings(sf::st_read(shp, quiet = TRUE))
}

road_density_for <- function(mon_sf, roads_sf, radius_m, mtfcc_keep = NULL) {
  roads_use <- roads_sf
  if (!is.null(mtfcc_keep) && "MTFCC" %in% names(roads_use)) {
    roads_use <- roads_use[roads_use$MTFCC %in% mtfcc_keep, , drop = FALSE]
  }
  if (nrow(roads_use) == 0) return(rep(NA_real_, nrow(mon_sf)))
  out <- numeric(nrow(mon_sf))
  area_km2 <- pi * radius_m^2 / 1e6
  for (i in seq_len(nrow(mon_sf))) {
    buf <- sf::st_buffer(mon_sf[i, ], radius_m)
    hit <- suppressWarnings(sf::st_intersection(roads_use, buf))
    out[[i]] <- if (nrow(hit) == 0) 0 else sum(as.numeric(sf::st_length(hit)), na.rm = TRUE) / area_km2
  }
  out
}

add_road_density <- function(monitors) {
  if (!include_roads) return(monitors)
  message("[covariate] Census TIGER road density for ", nrow(monitors), " monitor(s)")
  roads <- read_roads_for_monitors(monitors)
  mon_sf <- sf::st_as_sf(monitors, coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)
  mon_5070 <- sf::st_transform(mon_sf, 5070)
  roads_5070 <- sf::st_transform(roads, 5070)
  monitors$road_density_primary_secondary_1km_m_per_km2 <- road_density_for(mon_5070, roads_5070, 1000)
  monitors$road_density_primary_secondary_10km_m_per_km2 <- road_density_for(mon_5070, roads_5070, 10000)
  monitors
}

manifest <- list()

for (nm in names(pollutants)) {
  cfg <- pollutants[[nm]]
  message("\n== ", nm, " ==")
  zip_path <- download_airdata(cfg$aqs_parameter, year)
  aqs <- read_airdata_zip(zip_path)
  monitors <- summarise_monitors(aqs, state_code, cfg$response)
  response_units <- if (nm == "pm25") "micrograms_per_cubic_meter" else "ppb"
  if (nm == "o3" && max(monitors[[cfg$response]], na.rm = TRUE) < 1) {
    # EPA AirData ozone daily means are commonly expressed in ppm; the grid
    # product is in ppb. Convert the monitor response to ppb for consistency.
    monitors[[cfg$response]] <- monitors[[cfg$response]] * 1000
    response_units <- "ppb_converted_from_ppm"
  }
  monitors$response_units <- response_units
  monitors <- join_nearest_grid_prediction(monitors, cfg$local_grid, cfg$grid_value, nm)
  monitors <- add_elevation(monitors)
  monitors <- add_power_weather(monitors)
  monitors <- add_nlcd(monitors)
  monitors <- add_road_density(monitors)
  monitors$pollutant <- nm
  monitors$year <- year
  monitors$source_observations <- sprintf("EPA AirData daily_%s_%s.zip", cfg$aqs_parameter, year)
  monitors$source_grid_prediction <- basename(cfg$local_grid)

  csv_out <- file.path(out_dir, sprintf("aqs_%s_%s_state_%s_monitor_covariates.csv", nm, year, state_code))
  utils::write.csv(monitors, csv_out, row.names = FALSE, fileEncoding = "UTF-8")

  sf_out <- sf::st_as_sf(monitors, coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)
  rds_out <- file.path(final_dir, sprintf("paper_%s_aqs_state_%s_%s_monitor_covariates.rds", nm, state_code, year))
  saveRDS(sf_out, rds_out)

  manifest[[nm]] <- list(
    pollutant = nm,
    year = year,
    state_code = state_code,
    n_monitors = nrow(monitors),
    response = cfg$response,
    response_units = unique(monitors$response_units),
    predictors_current = c(
      paste0(nm, "_grid_prediction_2016"),
      paste0(nm, "_grid_distance_m"),
      "elevation_m_usgs_epqs",
      "power_t2m_mean_c", "power_rh2m_mean_pct", "power_ws10m_mean_m_s",
      "power_prectotcorr_sum_mm", "power_swdwn_mean_mj_m2_day",
      "nlcd_land_cover_code", "nlcd_developed", "nlcd_forest",
      "road_density_primary_secondary_1km_m_per_km2", "road_density_primary_secondary_10km_m_per_km2",
      "longitude",
      "latitude"
    ),
    aqs_zip = zip_path,
    csv = csv_out,
    rds = rds_out,
    limitation = "Prototype reconstruction: uses EPA AQS monitor observations, USGS elevation, NASA POWER weather/radiation, NLCD point land-cover class, Census TIGER road density, and nearest final prediction grid value. Satellite AOD and CTM covariates are not yet reconstructed."
  )
  message("[written] ", csv_out)
  message("[written] ", rds_out)
}

manifest_path <- file.path(out_dir, sprintf("air_quality_monitor_covariates_manifest_%s_state_%s.json", year, state_code))
jsonlite::write_json(manifest, manifest_path, auto_unbox = TRUE, pretty = TRUE)
message("\nManifest: ", manifest_path)

