# Garde-fou timeout fiable pour un cas (dataset x estimateur x fold), via un
# process worker callr separe -- pas base R setTimeLimit().
#
# setTimeLimit() a ete teste empiriquement contre le vrai calcul pathologique
# qui a motive ce garde-fou (stats::AIC() sur un objet mboost, cf.
# extract_information_criteria() dans 12-diagnose-spatial.R, deja corrige a la
# racine pour ce cas precis) et ne l'a JAMAIS interrompu: toujours actif apres
# 40s+ contre un budget de 3s, avec elapsed= comme avec cpu=. R ne verifie les
# interruptions qu'entre deux instructions de l'evaluateur -- jamais au milieu
# d'un seul appel compile/matriciel prolonge, exactement le cas ici. La seule
# maniere fiable de couper un tel calcul est de le faire tourner dans un
# process separe et de le tuer au niveau OS si besoin: c'est ce que fait ce
# fichier via callr::r_session.
#
# Cout: le process worker est PERSISTANT (un par appel a
# evaluate_benchmark_resamples(), reutilise pour tous les folds/estimateurs de
# ce dataset x cv_scheme) pour eviter de recharger le package a chaque fold.
# Il n'est jamais cree si fold_timeout_sec est NA (defaut) -- zero overhead
# pour les appels existants.

new_fold_timeout_worker <- function() {
  require_package("callr", "fold_timeout_sec (garde-fou timeout par fold)")

  pkg_dev <- isTRUE(tryCatch(pkgload::is_dev_package("spatialtidymodels"), error = function(e) FALSE))
  pkg_path <- tryCatch(getNamespaceInfo(asNamespace("spatialtidymodels"), "path"), error = function(e) NULL)
  custom <- custom_estimator_registry_snapshot()

  rs <- callr::r_session$new(wait = TRUE)
  rs$run(
    function(pkg_dev, pkg_path, custom) {
      if (isTRUE(pkg_dev) && !is.null(pkg_path)) {
        if (!requireNamespace("pkgload", quietly = TRUE)) {
          stop("pkgload n'est pas disponible dans le worker fold_timeout_sec pour charger spatialtidymodels en mode dev.", call. = FALSE)
        }
        pkgload::load_all(pkg_path, quiet = TRUE)
      } else if (requireNamespace("spatialtidymodels", quietly = TRUE)) {
        library(spatialtidymodels)
      } else {
        stop("Le worker fold_timeout_sec n'a pas pu charger spatialtidymodels (ni installe, ni source dev localisable).", call. = FALSE)
      }
      # Replique les estimateurs enregistres via register_spatial_estimator()
      # dans ce process: custom_estimator_registry_env demarre vide ici.
      for (entry in custom) {
        spatialtidymodels:::restore_custom_estimator_entry(entry)
      }
      invisible(TRUE)
    },
    args = list(pkg_dev = pkg_dev, pkg_path = pkg_path, custom = custom)
  )
  rs
}

get_fold_timeout_worker <- function(session_box) {
  session <- session_box$session
  alive <- !is.null(session) && isTRUE(tryCatch(session$is_alive(), error = function(e) FALSE))
  if (!alive) {
    session <- new_fold_timeout_worker()
    session_box$session <- session
  }
  session
}

close_fold_timeout_worker <- function(session_box) {
  if (!is.null(session_box$session)) {
    tryCatch(session_box$session$close(), error = function(e) NULL)
    session_box$session <- NULL
  }
}

#' @keywords internal
#' @noRd
run_with_fold_timeout <- function(session_box, timeout_sec, func, args = list()) {
  # Runs func(args) in the persistent worker held by session_box, aborting
  # (and killing/dropping the worker so a fresh one is spawned next call) if
  # it exceeds timeout_sec of wall-clock time. Returns a list:
  #   list(ok = TRUE, value = <func's return value>)
  #   list(ok = FALSE, timeout = TRUE,  error_message = "TIMEOUT: ...")
  #   list(ok = FALSE, timeout = FALSE, error_message = <the worker-side error>)
  session <- get_fold_timeout_worker(session_box)
  session$call(func, args = args)
  state <- session$poll_process(as.integer(round(timeout_sec * 1000)))
  if (identical(state, "timeout")) {
    close_fold_timeout_worker(session_box)
    return(list(
      ok = FALSE, timeout = TRUE,
      error_message = sprintf("TIMEOUT: le cas a depasse fold_timeout_sec (%.0fs).", timeout_sec)
    ))
  }
  out <- session$read()
  if (!is.null(out$error)) {
    return(list(ok = FALSE, timeout = FALSE, error_message = conditionMessage(out$error)))
  }
  list(ok = TRUE, timeout = FALSE, value = out$result)
}
