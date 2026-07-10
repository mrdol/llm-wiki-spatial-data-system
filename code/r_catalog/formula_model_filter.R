# =============================================================================
# Filtre partagé d'acceptation des formules
# -----------------------------------------------------------------------------
# Règle (commune à tout le pipeline) : une formule n'est retenue comme formule
# de MODÈLE que si elle apparaît :
#   * dans un appel de modèle  : lm(), glm(), gam(), gwr(), lagsarlm(),
#     errorsarlm(), lmer(), aov(), asreml(), spaMM/fitme(), inla(), ... ; OU
#   * assignée comme objet formule : f <- y ~ x, formula = y ~ x, as.formula(...)
# Les formules de GRAPHE (plot, xyplot, levelplot, boxplot, spplot, ggplot, ...)
# sont rejetées.
#
# Ce fichier centralise les motifs et deux helpers réutilisés par :
#   - create_r_software_catalog.R  (extract_formula_signals)
#   - build_sf_datasets.R          (calcul de has_formule_modele)
# Source-le avec :  source(file.path(<r_catalog>, "formula_model_filter.R"))
# =============================================================================

MODEL_FUNCTION_PATTERN <- paste0(
  "(lm|glm|gam|gamm|aov|lmer|glmer|gls|lme|nls|nlme|",
  "gwr|gwr\\.basic|ggwr|bw\\.gwr|lagsarlm|errorsarlm|sacsarlm|",
  "stsls|GMerrorsar|spautolm|spml|spgm|MCMCsamp|asreml|earth|randomForest|",
  "ranger|xgboost|train|spaMM|fitme|corrHLfit|inla|brm|stan_glm|",
  "moran\\.test|lmSLX)\\s*\\([^)]*$"
)

VISUAL_FUNCTION_PATTERN <- paste0(
  "(plot|points|lines|boxplot|hist|barplot|dotchart|xyplot|bwplot|",
  "levelplot|wireframe|contourplot|spplot|desplot|ggplot|qplot|coplot|",
  "stripplot|densityplot|histogram|interaction2wt|con_view|",
  "aggregate|reshape|acast|dcast)\\s*\\([^)]*$"
)

FORMULA_ASSIGNMENT_PATTERN <- "(^|[;<>{}\\s])([A-Za-z.][A-Za-z0-9_.]*)\\s*(<-|=)\\s*$"
EXPLICIT_FORMULA_PATTERN   <- "(formula\\s*=\\s*$|as\\.formula\\s*\\(\\s*$)"

# Mots de gauche non valides comme variable réponse (libellés d'axe, etc.).
FORMULA_LHS_STOPWORDS <- c("of", "a", "an", "the", "data", "format", "ratio", "plot")

# -----------------------------------------------------------------------------
# Renvoie TRUE si, vu son contexte précédent, une formule est en contexte modèle
# (appel de modèle, assignation, formula=/as.formula) et PAS en contexte graphe.
# -----------------------------------------------------------------------------
formula_in_model_context <- function(preceding_context) {
  is_model <- grepl(MODEL_FUNCTION_PATTERN, preceding_context, ignore.case = TRUE) |
    grepl(FORMULA_ASSIGNMENT_PATTERN, preceding_context, perl = TRUE) |
    grepl(EXPLICIT_FORMULA_PATTERN, preceding_context, ignore.case = TRUE)
  is_visual <- grepl(VISUAL_FUNCTION_PATTERN, preceding_context, ignore.case = TRUE)
  is_model & !is_visual
}

# -----------------------------------------------------------------------------
# Extrait les formules de modèle acceptées d'un texte (doc Rd / exemples).
# Renvoie un vecteur de chaînes "y ~ x1 + x2".
# -----------------------------------------------------------------------------
extract_model_formulas <- function(doc_text) {
  if (is.null(doc_text) || length(doc_text) == 0 || is.na(doc_text) || !nzchar(doc_text)) {
    return(character(0))
  }
  text <- gsub("\\s+", " ", doc_text)
  m <- gregexpr("[A-Za-z.][A-Za-z0-9_.]*\\s*~\\s*[^,)]+", text, perl = TRUE)[[1]]
  if (length(m) == 1 && m[1] < 0) return(character(0))
  formulas <- trimws(regmatches(text, list(m))[[1]])
  locs <- as.integer(m); lens <- attr(m, "match.length")
  pre <- vapply(seq_along(locs), function(i)
    substr(text, max(1L, locs[i] - 80L), max(1L, locs[i] - 1L)), character(1))
  follow <- vapply(seq_along(locs), function(i) {
    s <- locs[i] + lens[i]; substr(text, s, min(nchar(text), s + 80L))
  }, character(1))
  keep <- formula_in_model_context(pre) &
    !grepl("#|windows|width|height|aspect.?ratio", formulas, ignore.case = TRUE) &
    !grepl("^[-+*/]", trimws(follow))
  formulas <- unique(formulas[keep])
  # Repare les parentheses tronquees (ex. "I(x^2" -> "I(x^2)") et rejette le
  # texte casse (assignation <-, accesseur $, separateur ;).
  formulas <- vapply(formulas, balance_parens, character(1))
  formulas <- formulas[!grepl("<-|[$;]", formulas)]
  lhs_ok <- vapply(formulas, function(f) {
    !(tolower(trimws(sub("~.*$", "", f))) %in% FORMULA_LHS_STOPWORDS)
  }, logical(1))
  formulas[lhs_ok]
}

# Equilibre les parentheses d'une formule tronquee par l'extraction.
balance_parens <- function(formula) {
  opened <- lengths(regmatches(formula, gregexpr("\\(", formula)))
  closed <- lengths(regmatches(formula, gregexpr("\\)", formula)))
  if (opened > closed) {
    formula <- paste0(formula, strrep(")", opened - closed))
  } else if (closed > opened) {
    excess <- closed - opened
    chars <- strsplit(formula, "", fixed = TRUE)[[1]]
    for (i in rev(seq_along(chars))) {
      if (excess == 0) break
      if (chars[i] == ")") { chars[i] <- ""; excess <- excess - 1 }
    }
    formula <- paste(chars, collapse = "")
  }
  trimws(formula)
}

# -----------------------------------------------------------------------------
# Vérifie qu'une formule ISOLÉE (sans contexte de code, ex. champ
# paper_formula_or_equation) est plausible comme formule de modèle :
# présence d'un ~, un membre gauche non trivial, au moins un prédicteur,
# pas un simple libellé d'axe. À utiliser quand le contexte d'appel est inconnu.
# -----------------------------------------------------------------------------
is_plausible_model_formula <- function(formula_text) {
  if (is.null(formula_text) || length(formula_text) == 0) return(FALSE)
  formula_text <- as.character(formula_text)[1]
  if (is.na(formula_text) || !nzchar(formula_text)) return(FALSE)
  if (toupper(trimws(formula_text)) == "NA") return(FALSE)
  if (!grepl("~", formula_text, fixed = TRUE)) return(FALSE)
  if (grepl("<-|[$;=]", formula_text)) return(FALSE)  # texte casse / non-formule
  parts <- strsplit(formula_text, "~", fixed = TRUE)[[1]]
  if (length(parts) < 2) return(FALSE)
  lhs <- trimws(parts[1]); rhs <- trimws(parts[2])
  if (!nzchar(lhs) || tolower(lhs) %in% FORMULA_LHS_STOPWORDS) return(FALSE)
  preds <- unlist(strsplit(rhs, "\\+|\\*|:|\\||-", perl = TRUE))
  preds <- trimws(gsub("[^A-Za-z0-9_.]", "", preds))
  preds <- preds[nzchar(preds) & !preds %in% c("0", "1")]
  length(preds) >= 1
}
