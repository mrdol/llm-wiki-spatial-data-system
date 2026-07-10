# Exemple manuel pour comprendre et tester SpBoost dans R.
# Ce fichier ne lance pas d'installation automatiquement: les lignes
# d'installation restent commentees pour eviter de modifier ton environnement
# sans decision explicite.

# Depuis la racine du projet:
# setwd("C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/llm-wiki-karpathy")

# 1. Installer le package local si ce n'est pas deja fait.
# Sur Windows, l'installation depuis les sources peut demander Rtools.
# install.packages("remotes")
# remotes::install_local("raw/estimators/spboost_0.6.3/spboost", upgrade = "never")

# 2. Charger les packages.
library(spboost)
library(mboost)

# 3. Simuler un jeu de donnees SAR non lineaire fourni par le package.
# Y est la variable a expliquer.
# X1, X2, X3, ... sont des variables explicatives candidates.
# W est la matrice de voisinage spatial, normalisee par ligne.
set.seed(123)
sim <- spboost::dgp(
  n = 500,
  rho = 0.6,
  betas = c(0, 0.5, 1, -1),
  sigma2 = 1,
  model = "SAR",
  nonlin = TRUE,
  X_het = FALSE,
  X_sp = FALSE,
  f_sp = FALSE,
  X_cor = FALSE
)

df <- sim$data
W <- sim$W

# 4. Definir la formule.
# Pour les methodes BSPA, on utilise la syntaxe mboost:
# - bbs(X) pour un effet spline non lineaire;
# - bols(X) pour un effet lineaire simple.
# Eviter bspatial(u, v) au debut: il peut absorber le signal spatial
# que rho ou lambda doivent justement mesurer.
formula_spboost <- Y ~ bbs(X1) + bbs(X2) + bbs(X3)

# 5. Definir les controles de boosting.
# mstop = nombre d'iterations de boosting.
# nu = learning rate, ou vitesse d'apprentissage.
# mstop_criterion = "spatial" demande une selection adaptee au modele SAR.
control_spboost <- list(
  control_gamboost = mboost::boost_control(mstop = 300, nu = 0.1),
  mstop_criterion = "spatial",
  mstop_init = 300,
  nfold = 5,
  ncore = 1
)

# 6. Estimer un modele SAR non lineaire avec CFE.
# CFE = closed-form estimator: estimation rapide de rho sans recalculer
# de log-determinant spatial a chaque iteration.
fit_sar_cfe <- spboost::spbgam(
  formula = formula_spboost,
  data = df,
  W = W,
  DGP = "SAR",
  method = "BSPA_SAR_CFE",
  control = control_spboost
)

# 7. Lire les sorties principales.
print(fit_sar_cfe)
print(fit_sar_cfe$rho)
print(fit_sar_cfe$rmse)

# 8. Comparer avec la version ML, souvent plus couteuse mais utile
# comme benchmark lorsque n reste raisonnable.
fit_sar_ml <- spboost::spbgam(
  formula = formula_spboost,
  data = df,
  W = W,
  DGP = "SAR",
  method = "BSPA_SAR_ML",
  control = control_spboost
)

print(fit_sar_ml$rho)
print(fit_sar_ml$rmse)

# 9. Exemple avec le wrapper du systeme.
# Le wrapper garde la meme logique, mais renvoie un objet standardise
# avec model + metadata.
source("R/estimators/load_estimators.R")

wrapped_fit <- fit_spboost(
  data = df,
  y = "Y",
  x = c("X1", "X2", "X3"),
  config = list(
    W = W,
    formula = formula_spboost,
    DGP = "SAR",
    method = "BSPA_SAR_CFE",
    control = control_spboost
  )
)

print(wrapped_fit$metadata)
print(wrapped_fit$model$rho)

# 10. Squelette pour une vraie donnee.
# - Construire df avec Y, X_candidate et coordonnees.
# - Construire W avec une methode documentee.
# - Garder X_candidate et X_selected dans les metadonnees.
#
# Exemple indicatif:
# coords <- as.matrix(df[, c("longitude", "latitude")])
# W_candidates <- spboost::build_Wk(coords)
# W <- W_candidates[[1]]
# real_formula <- y_var ~ bbs(x1) + bbs(x2) + bols(x3)
# real_fit <- spboost::spbgam(
#   formula = real_formula,
#   data = df,
#   W = W,
#   DGP = "SAR",
#   method = "BSPA_SAR_CFE",
#   control = control_spboost
# )

# 11. Prediction.
# predict_spboost demande une matrice W compatible avec l'ensemble
# apprentissage + prediction. Ne pas reutiliser une W d'apprentissage
# si newdata ajoute de nouvelles observations sans reconstruire W.
#
# pred <- spboost::predict_spboost(
#   model = fit_sar_cfe,
#   newdata = df_test,
#   data = df_train,
#   W = W_full,
#   type = "BPN"
# )
