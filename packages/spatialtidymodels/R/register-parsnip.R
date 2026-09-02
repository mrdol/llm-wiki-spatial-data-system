# Enregistrement parsnip au chargement du package.
#
# Les appels parsnip::set_*() modifient un registre vivant dans le namespace de
# parsnip. Les executer seulement au niveau haut des fichiers R n'est pas assez
# fiable dans un package installe, car la compilation lazy-load peut faire ces
# effets de bord dans une session differente de la session utilisateur. .onLoad()
# garantit que le registre est rempli quand library(spatialtidymodels) est appele.

.onLoad <- function(libname, pkgname) {
  register_spatialreg_reg()
  register_spboost_reg()
  register_mgwrsar_reg()
  register_spmoran_reg()
}

register_spatialreg_reg <- function() {
  if ("spatialreg_reg" %in% parsnip::get_model_env()$models) return(invisible(TRUE))

  parsnip::set_new_model("spatialreg_reg")
  parsnip::set_model_mode(model = "spatialreg_reg", mode = "regression")
  parsnip::set_model_engine("spatialreg_reg", mode = "regression", eng = "spatialreg")
  parsnip::set_dependency("spatialreg_reg", eng = "spatialreg", pkg = "spatialreg")

  for (arg in c("coords", "W", "model_type", "k_neighbors", "style", "zero_policy")) {
    parsnip::set_model_arg(
      model = "spatialreg_reg",
      eng = "spatialreg",
      parsnip = arg,
      original = arg,
      func = switch(arg,
        k_neighbors = list(pkg = "spatialtidymodels", fun = "k_neighbors"),
        list(pkg = "dials", fun = "unknown")
      ),
      has_submodel = FALSE
    )
  }

  parsnip::set_fit(
    model = "spatialreg_reg",
    eng = "spatialreg",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data"),
      func = c(pkg = "spatialtidymodels", fun = "spatialreg_fit_impl"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "spatialreg_reg",
    eng = "spatialreg",
    mode = "regression",
    options = list(
      predictor_indicators = "traditional",
      # spatialreg construit deja l'intercept depuis la formule. Si workflows
      # ajoute aussi une colonne `(Intercept)`, SDM la lagge et produit un
      # alias `(Intercept)` / `lag.(Intercept)`.
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "spatialreg_reg",
    eng = "spatialreg",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = function(results, object) as.numeric(results),
      func = c(pkg = "spatialtidymodels", fun = "spatialreg_pred_impl"),
      args = list(
        object = quote(object),
        new_data = quote(new_data)
      )
    )
  )

  invisible(TRUE)
}

register_spboost_reg <- function() {
  if ("spboost_reg" %in% parsnip::get_model_env()$models) return(invisible(TRUE))

  parsnip::set_new_model("spboost_reg")
  parsnip::set_model_mode(model = "spboost_reg", mode = "regression")
  parsnip::set_model_engine("spboost_reg", mode = "regression", eng = "spboost")
  parsnip::set_dependency("spboost_reg", eng = "spboost", pkg = "spboost")

  for (arg in c("coords", "DGP", "method", "mstop", "nu", "k_neighbors")) {
    parsnip::set_model_arg(
      model = "spboost_reg",
      eng = "spboost",
      parsnip = arg,
      original = arg,
      func = switch(arg,
        mstop = list(pkg = "spatialtidymodels", fun = "mstop"),
        k_neighbors = list(pkg = "spatialtidymodels", fun = "k_neighbors"),
        list(pkg = "dials", fun = "unknown")
      ),
      has_submodel = FALSE
    )
  }

  parsnip::set_fit(
    model = "spboost_reg",
    eng = "spboost",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data"),
      func = c(pkg = "spatialtidymodels", fun = "spboost_fit_impl"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "spboost_reg",
    eng = "spboost",
    mode = "regression",
    options = list(
      # "none" (retabli 2026-08, apres essai infructueux de "traditional").
      # "traditional" est applique par le blueprint hardhat de
      # workflows::add_formula() AVANT que spboost_fit_impl() ne recoive
      # formula/data -- topo y arrive deja developpee en indicatrices, avec
      # une formule reecrite (colonnes type nitro:topoW). spb_build_boosting_
      # formula() cherche pourtant les variables brutes par leur nom d'origine
      # (data[["nitro"]], etc.) pour router bols()/bbs() : avec la formule
      # deja reecrite, ce nom n'existe plus -- confirme empiriquement sur
      # lasrosas ("objet 'nitro' introuvable"), sur une session R fraichement
      # redemarree. "traditional" ne corrige donc rien ici, il deplace
      # seulement l'echec. Le vrai correctif pour un jeu avec covariable
      # categorielle doit developper topo en amont, dans les donnees du jeu
      # lui-meme, pas via ce reglage global.
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "spboost_reg",
    eng = "spboost",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = function(results, object) as.numeric(results),
      func = c(pkg = "spatialtidymodels", fun = "spboost_pred_impl"),
      args = list(
        object = quote(object),
        new_data = quote(new_data)
      )
    )
  )

  invisible(TRUE)
}

register_mgwrsar_reg <- function() {
  if ("mgwrsar_reg" %in% parsnip::get_model_env()$models) return(invisible(TRUE))

  parsnip::set_new_model("mgwrsar_reg")
  parsnip::set_model_mode(model = "mgwrsar_reg", mode = "regression")
  parsnip::set_model_engine("mgwrsar_reg", mode = "regression", eng = "mgwrsar")
  parsnip::set_dependency("mgwrsar_reg", eng = "mgwrsar", pkg = "mgwrsar")

  for (arg in c("coords", "model_type", "kernel", "bandwidth", "fixed_vars")) {
    parsnip::set_model_arg(
      model = "mgwrsar_reg",
      eng = "mgwrsar",
      parsnip = arg,
      original = switch(arg,
        coords = "coords", model_type = "Model", kernel = "kernels",
        bandwidth = "H", fixed_vars = "fixed_vars"
      ),
      func = switch(arg,
        bandwidth = list(pkg = "spatialtidymodels", fun = "bandwidth"),
        kernel = list(pkg = "spatialtidymodels", fun = "spatial_kernel"),
        list(pkg = "dials", fun = "unknown")
      ),
      has_submodel = FALSE
    )
  }

  parsnip::set_fit(
    model = "mgwrsar_reg",
    eng = "mgwrsar",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data"),
      func = c(pkg = "spatialtidymodels", fun = "mgwrsar_fit_impl"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "mgwrsar_reg",
    eng = "mgwrsar",
    mode = "regression",
    options = list(
      # "none" (retabli 2026-08, meme raison que spboost_reg ci-dessus) :
      # "traditional" fait developper topo en indicatrices par le blueprint
      # hardhat de workflows AVANT mgwrsar_fit_impl(), qui passe pourtant
      # formula/data tels quels a mgwrsar::MGWRSAR() -- confirme empiriquement
      # sur lasrosas ("colonnes non definies selectionnees"), sur une session
      # R fraichement redemarree. Le correctif pour une covariable
      # categorielle doit se faire en amont, dans les donnees du jeu.
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "mgwrsar_reg",
    eng = "mgwrsar",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = function(results, object) as.numeric(results),
      func = c(pkg = "spatialtidymodels", fun = "mgwrsar_pred_impl"),
      args = list(
        object = quote(object),
        new_data = quote(new_data),
        coords = quote(object$spec$args$coords)
      )
    )
  )

  invisible(TRUE)
}

register_spmoran_reg <- function() {
  if ("spmoran_reg" %in% parsnip::get_model_env()$models) return(invisible(TRUE))

  parsnip::set_new_model("spmoran_reg")
  parsnip::set_model_mode(model = "spmoran_reg", mode = "regression")
  parsnip::set_model_engine("spmoran_reg", mode = "regression", eng = "spmoran")
  parsnip::set_dependency("spmoran_reg", eng = "spmoran", pkg = "spmoran")

  for (arg in c("coords", "model_type", "vif", "enum")) {
    parsnip::set_model_arg(
      model = "spmoran_reg",
      eng = "spmoran",
      parsnip = arg,
      original = arg,
      func = switch(arg,
        enum = list(pkg = "spatialtidymodels", fun = "spmoran_enum"),
        vif = list(pkg = "spatialtidymodels", fun = "spmoran_vif"),
        list(pkg = "dials", fun = "unknown")
      ),
      has_submodel = FALSE
    )
  }

  parsnip::set_fit(
    model = "spmoran_reg",
    eng = "spmoran",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data"),
      func = c(pkg = "spatialtidymodels", fun = "spmoran_fit_impl"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "spmoran_reg",
    eng = "spmoran",
    mode = "regression",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "spmoran_reg",
    eng = "spmoran",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = function(results, object) as.numeric(results),
      func = c(pkg = "spatialtidymodels", fun = "spmoran_pred_impl"),
      args = list(
        object = quote(object),
        new_data = quote(new_data)
      )
    )
  )

  invisible(TRUE)
}
