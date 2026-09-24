# Benchmark spatial des variantes INLA (+ comparateurs) : UN jeu x UNE graine de
# decoupage en folds. Meme protocole que celui lance en arriere-plan le
# 2026-09-22 (CV spatial en 5 blocs par k-means sur les sites uniques, echantillon
# de sites FIXE, metriques hors echantillon poolees, aucun tuning).
#
# Depuis la console R (racine du depot comme repertoire de travail) :
#   BENCH_DATASET <- "crane"; BENCH_SEED <- 11L
#   source("tools/bench_inla_multiseed.R", local = new.env())
# ou en ligne de commande :
#   Rscript tools/bench_inla_multiseed.R crane 11
#
# Jeux disponibles : banff, georgia, baltimore, flapper, crane, mistletoe, goa.
# Sortie (par defaut) : data/manifests/runs/inla_multiseed_2026-09-22/
#   <jeu>_s<graine>_folds.csv  (temps, mlik et portee INLA par fold, erreurs)
#   <jeu>_s<graine>_preds.csv  (verite, prediction, moyenne d'entrainement)
#   <jeu>_s<graine>_log.txt    (avancement, ligne par ligne)
# Les CSV sont ecrits au fil de l'eau : une interruption garde ce qui est fait.
#
# La graine varie le DECOUPAGE en folds : les sites sont regroupes en 20 blocs spatiaux
# (k-means), affectes aleatoirement aux 5 folds (voir make_folds ci-dessous). L'echantillon
# de sites reste le meme, donc c'est le meme jeu d'une graine a l'autre. NB : ce n'est plus
# le decoupage "5 gros clusters k-means" des benchmarks precedents, qui donnait le meme
# decoupage pour toutes les graines ; les chiffres ne sont pas directement comparables.
# Les estimateurs INLA sont retentes jusqu'a 3 fois en cas d'echec numerique.

.args <- commandArgs(trailingOnly = TRUE)
nm <- if (length(.args) >= 1L) .args[1] else get0("BENCH_DATASET", ifnotfound = NULL)
SEED <- if (length(.args) >= 2L) as.integer(.args[2]) else get0("BENCH_SEED", ifnotfound = NULL)
OUT <- if (length(.args) >= 3L) .args[3] else get0("BENCH_OUT", ifnotfound = "data/manifests/runs/inla_multiseed_2026-09-22")
if (is.null(nm) || is.null(SEED) || is.na(SEED)) {
  stop("Definir BENCH_DATASET et BENCH_SEED (ou passer <jeu> <graine> a Rscript).", call. = FALSE)
}

# Un seul thread par calcul externe : les fits INLA tournent deja en 1:1 par defaut
# (options spatialtidymodels.inla_reproducible), on evite de sur-souscrire le CPU.
Sys.setenv(OMP_NUM_THREADS = "1", OPENBLAS_NUM_THREADS = "1", MKL_NUM_THREADS = "1")
options(ranger.num.threads = 1L)
suppressMessages(devtools::load_all("packages/spatialtidymodels", quiet = TRUE))

dir.create(OUT, showWarnings = FALSE, recursive = TRUE)
tag <- sprintf("%s_s%d", nm, SEED)
LOG <- file.path(OUT, paste0(tag, "_log.txt"))
log_msg <- function(...) {
  line <- paste(format(Sys.time(), "%H:%M:%S"), sprintf(...))
  cat(line, "\n", file = LOG, append = TRUE); message(line)
}
K <- 5L

cfgs <- list(
  banff = list(id = "paper_banff_stream_temperature", coords = c("Easting", "Northing"),
    formula = WaterTemp ~ Elev + RSlope + LE, typ = "continuous", group = "HUC10", time = NULL, sample_loc = NULL),
  georgia = list(id = "Python_libpysal_georgia", coords = c("X", "Y"),
    formula = PctBach ~ PctRural + PctEld + PctFB + PctPov, typ = "continuous", group = NULL, time = NULL, sample_loc = NULL),
  baltimore = list(id = "Python_libpysal_Baltimore", coords = c("X", "Y"),
    formula = PRICE ~ NROOM + NBATH + PATIO + FIREPL + AC + GAR + AGE + LOTSZ + SQFT, typ = "continuous", group = NULL, time = NULL, sample_loc = NULL),
  flapper = list(id = "paper_flapper_skate_presence", coords = c("lon", "lat"),
    formula = present_01 ~ bath + dcoast + current + pp_mean + fishing_hours, typ = "binary", group = "survey", time = NULL, sample_loc = 700L),
  crane = list(id = "paper_crane", coords = c("x", "y"),
    formula = mark ~ Urb_Den_cov + PA_Ratio_cov + Area_cov, typ = "binary", group = NULL, time = "ti", sample_loc = 130L),
  mistletoe = list(id = "paper_mistletoe_bird_abundance", coords = c("Long", "Lat"),
    formula = Total_abundance ~ total_live_mistletoe + total_dead_mistletoe + canopy_cover + shrub_cover + large_old_tree_total + Season,
    typ = "count", group = "Region", time = "Season", sample_loc = 130L),
  goa = list(id = "paper_goa_trawl_demersal", coords = c("Lon", "Lat"),
    formula = Atheresthesstomias ~ log.BottomDepth + log.BottomDepth2, typ = "continuous", group = "Stratum", time = "Year", sample_loc = 500L)
)
cfg <- cfgs[[nm]]
if (is.null(cfg)) stop("jeu inconnu: ", nm, " (attendus: ", paste(names(cfgs), collapse = ", "), ")", call. = FALSE)

with_group <- function(formula, g) stats::as.formula(paste(deparse(formula), "+ (1 |", g, ")"), env = environment(formula))
inla_diag <- function(fit) {
  # workflow / model_fit -> moteur bru ; objet bru brut (route groupe) -> lui-meme
  eng <- tryCatch(parsnip::extract_fit_engine(fit), error = function(e) fit)
  if (is.null(eng) || is.null(eng$summary.hyperpar)) return(c(mlik = NA_real_, range = NA_real_))
  h <- eng$summary.hyperpar; r <- h$mean[grep("^Range", rownames(h))[1]]
  c(mlik = as.numeric(eng$mlik[1]), range = as.numeric(r))
}
fit_predict <- function(est, train, test) {
  typ <- cfg$typ; yname <- all.vars(cfg$formula)[1]
  if (est == "baseline_mean") return(list(pred = rep(mean(train[[yname]]), nrow(test)), diag = c(mlik = NA_real_, range = NA_real_)))
  if (est == "inla_spde_st_group") {
    fml <- with_group(cfg$formula, cfg$group)
    fam <- switch(typ, count = "poisson", binary = "binomial", "gaussian")
    tr <- train; if (typ == "binary") tr[[yname]] <- as.integer(tr[[yname]])
    fit <- inlaspde_fit_impl(fml, tr, cfg$coords, family = fam, time = "time_idx")
    class(fit) <- c("inla_spde_group_fit", class(fit))
    return(list(pred = inlaspde_pred_impl(fit, test), diag = inla_diag(fit)))
  }
  fml <- if (est == "inla_spde_group") with_group(cfg$formula, cfg$group) else cfg$formula
  a <- list(est, fml, train, coords = cfg$coords, response_typology = typ)
  if (est == "inla_spde_st") a$inla_time <- "time_idx"
  fit <- do.call(fit_one_benchmark_estimator, a)
  list(pred = predict_vector_for_benchmark(fit, test, response_typology = typ),
       diag = if (grepl("^inla", est)) inla_diag(fit) else c(mlik = NA_real_, range = NA_real_))
}

d <- sf::st_drop_geometry(readRDS(file.path("data/final_datasets/sf", paste0(cfg$id, ".rds"))))
used <- unique(c(all.vars(cfg$formula), cfg$coords, cfg$group, cfg$time))
d <- d[stats::complete.cases(d[, used]), ]
set.seed(42)                                   # echantillon de sites FIXE (meme jeu pour toutes les graines)
key <- do.call(paste, c(d[, cfg$coords, drop = FALSE], sep = "_"))
ukeys <- unique(key)
if (!is.null(cfg$sample_loc) && length(ukeys) > cfg$sample_loc) {
  keep <- sample(ukeys, cfg$sample_loc); d <- d[key %in% keep, ]; key <- key[key %in% keep]; ukeys <- unique(key)
}
if (!is.null(cfg$time)) d$time_idx <- as.integer(factor(d[[cfg$time]]))
loc <- d[!duplicated(key), cfg$coords, drop = FALSE]
# BEGIN make_folds
# Decoupage spatial en blocs, different selon la graine : les sites sont regroupes en
# K * blocks_per_fold blocs spatiaux (k-means sur les coordonnees centrees-reduites), puis les
# blocs sont affectes aleatoirement aux K folds (dans un ordre aleatoire, chaque bloc va au fold
# le moins rempli, egalites tirees au hasard). Tous les sites d'un meme bloc, donc toutes les
# lignes d'un meme site, sont dans le meme fold. Un decoupage est refuse si un fold contient
# moins de min_frac des sites. (Un simple k-means en K clusters redonnait le MEME decoupage
# pour toutes les graines sur goa : indice de Rand ajuste = 1.)
make_folds <- function(loc, K, SEED, blocks_per_fold = 4L, min_frac = 0.10) {
  n <- nrow(loc); nb <- min(K * blocks_per_fold, n - 1L); z <- scale(loc)
  for (try_i in seq_len(200L)) {
    set.seed(SEED * 1000L + try_i)
    km <- tryCatch(suppressWarnings(stats::kmeans(z, centers = nb, nstart = 1, iter.max = 50)), error = function(e) NULL)
    if (is.null(km)) next
    blocks <- km$cluster; bsz <- tabulate(blocks, nbins = max(blocks))
    fold_of_block <- integer(length(bsz)); load <- integer(K)
    for (b in sample(seq_along(bsz))) {
      cand <- which(load == min(load))
      f <- if (length(cand) > 1L) sample(cand, 1L) else cand
      fold_of_block[b] <- f; load[f] <- load[f] + bsz[b]
    }
    if (min(load) >= min_frac * n) return(fold_of_block[blocks])
  }
  NULL
}
# END make_folds
fold_sites <- make_folds(loc, K, SEED)
if (is.null(fold_sites)) stop("aucun decoupage valide apres 200 essais")
fold_of_key <- stats::setNames(fold_sites, key[!duplicated(key)])
d$.fold <- unname(fold_of_key[key])
typ <- cfg$typ
ests <- c("baseline_mean", "ols", "gam_spatial")
if (typ != "count") ests <- c(ests, "random_forest")
ests <- c(ests, "xgboost")
if (typ == "continuous") ests <- c(ests, "sar_lag", "sem_error")
if (typ == "binary") ests <- c(ests, "sar_probit", "sem_probit")
ests <- c(ests, "inla_spde")
if (!is.null(cfg$group)) ests <- c(ests, "inla_spde_group")
if (!is.null(cfg$time)) ests <- c(ests, "inla_spde_st")
if (nm == "mistletoe") ests <- c(ests, "inla_spde_st_group")
# Restriction facultative des estimateurs (test rapide ou relance partielle) :
#   BENCH_ESTIMATORS <- c("baseline_mean", "inla_spde")   ou variable d'environnement
#   BENCH_ESTIMATORS="baseline_mean,inla_spde"
.only <- get0("BENCH_ESTIMATORS", ifnotfound = NULL)
if (is.null(.only) && nzchar(Sys.getenv("BENCH_ESTIMATORS"))) .only <- strsplit(Sys.getenv("BENCH_ESTIMATORS"), ",")[[1]]
if (!is.null(.only)) ests <- intersect(ests, .only)
log_msg("=== %s graine %d : N=%d, sites=%d, folds(lignes)=%s | estimateurs: %s", nm, SEED, nrow(d), length(ukeys),
        paste(table(d$.fold), collapse = "/"), paste(ests, collapse = ","))
yname <- all.vars(cfg$formula)[1]
preds <- list(); frows <- list()
for (est in ests) for (f in seq_len(K)) {
  train <- d[d$.fold != f, ]; test <- d[d$.fold == f, ]
  # INLA echoue parfois numeriquement ("Matrix is not (numerical) positive definite") et son
  # optimiseur garde un aleatoire residuel : jusqu'a 3 tentatives pour les estimateurs INLA
  # (une seule pour les autres), le nombre de tentatives est enregistre.
  max_att <- if (grepl("^inla", est)) 3L else 1L
  t0 <- proc.time()[["elapsed"]]
  for (att in seq_len(max_att)) {
    set.seed(1000L * SEED + f + 100000L * (att - 1L))
    r <- tryCatch(fit_predict(est, train, test), error = function(e) e)
    p <- if (inherits(r, "error")) r else r$pred
    if (!(inherits(p, "error") || length(p) != nrow(test) || any(!is.finite(p)))) break
    if (att < max_att) log_msg("%s | fold %d tentative %d/%d echouee, nouvel essai", est, f, att, max_att)
  }
  el <- proc.time()[["elapsed"]] - t0
  if (inherits(p, "error") || length(p) != nrow(test) || any(!is.finite(p))) {
    msg <- if (inherits(p, "error")) conditionMessage(p) else "prediction non finie ou de mauvaise longueur"
    log_msg("%s | fold %d ECHEC (%.1fs): %s", est, f, el, substr(msg, 1, 160))
    frows[[length(frows) + 1]] <- data.frame(dataset = nm, seed = SEED, estimator = est, fold = f, ok = FALSE, elapsed = el,
                                             attempts = max_att, mlik = NA_real_, range = NA_real_, error = substr(msg, 1, 200))
    next
  }
  log_msg("%s | fold %d ok (%.1fs%s)", est, f, el, if (att > 1L) sprintf(", tentative %d", att) else "")
  frows[[length(frows) + 1]] <- data.frame(dataset = nm, seed = SEED, estimator = est, fold = f, ok = TRUE, elapsed = el,
                                           attempts = att, mlik = r$diag[["mlik"]], range = r$diag[["range"]], error = NA_character_)
  preds[[length(preds) + 1]] <- data.frame(dataset = nm, seed = SEED, estimator = est, fold = f, typ = typ,
                                           truth = as.numeric(test[[yname]]), pred = as.numeric(p), ytrain_mean = mean(train[[yname]]))
  utils::write.csv(do.call(rbind, frows), file.path(OUT, paste0(tag, "_folds.csv")), row.names = FALSE)
  utils::write.csv(do.call(rbind, preds), file.path(OUT, paste0(tag, "_preds.csv")), row.names = FALSE)
}
utils::write.csv(do.call(rbind, frows), file.path(OUT, paste0(tag, "_folds.csv")), row.names = FALSE)
if (length(preds)) utils::write.csv(do.call(rbind, preds), file.path(OUT, paste0(tag, "_preds.csv")), row.names = FALSE)
log_msg("=== %s graine %d TERMINE", nm, SEED)
