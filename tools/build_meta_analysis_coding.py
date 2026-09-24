#!/usr/bin/env python3
"""Pre-fill the spatial-methods meta-analysis grid from GROBID TEI files.

The output is deliberately conservative: textual evidence is extracted, while
counts that cannot be established without scientific reading remain ``unclear``.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import xml.etree.ElementTree as ET
from collections import Counter
from pathlib import Path


NS = {"tei": "http://www.tei-c.org/ns/1.0"}
SIM_RE = re.compile(r"\b(simulat\w*|monte[ -]?carlo|synthetic data|data generat\w* process|dgp)\b", re.I)
REAL_RE = re.compile(
    r"\b(empirical|application|case stud\w*|real[- ](?:world|life|data)|illustrat\w*|data set|dataset)\b",
    re.I,
)
REAL_HEAD_RE = re.compile(
    r"\b(empirical|application|real[- ](?:life|data)|case stud|data (?:example|analysis)|"
    r"analysis of .+ data|illustration|limiting long-term illness|housing price model|"
    r"dual gravity model|climate data application|precipitation over europe|"
    r"switzerland rainfall data|sea surface conductivity|gulf of mexico|"
    r"educational attainment in georgia|data examples simulations)\b",
    re.I,
)
PERF_RE = re.compile(r"\b(cross[- ]validation|hold[- ]out|out[- ]of[- ]sample|predict\w*|rmse|mae|mse)\b", re.I)
SIM_HEAD_RE = re.compile(r"monte|simulat|finite sample|small sample|data generat|experiment", re.I)
REPLICATION_RE = re.compile(
    r"(?:based on|using|use|with|generate(?:d)?|repeat(?:ed)?)?\s*(\d[\d, ]*)\s+"
    r"(?:monte[ -]?carlo\s+)?(?:replications?|repetitions?|samples?|datasets?)",
    re.I,
)
METRIC_RE = re.compile(
    r"\b(RMSE|MSE|MAE|bias|standard deviation|standard error|coverage(?: probability)?|"
    r"size|power|type I error|prediction error|MSPE|RASE|AIC|BIC|log[- ]likelihood|"
    r"comput(?:ation|ing) time)\b",
    re.I,
)

AXES = {
    "axis_sample_size": re.compile(r"\b(sample size|n\s*=|grid size|number of (?:sites|locations|observations))\b", re.I),
    "axis_spatial_dependence": re.compile(r"\b(spatial (?:dependence|correlation)|autoregressive parameter|rho|λ|lambda)\b", re.I),
    "axis_weights_geometry": re.compile(r"\b(weight(?:s| matrix)|\bW\b|contiguit\w*|neighbou?r|distance matrix|grid)\b", re.I),
    "axis_noise_snr": re.compile(r"\b(signal[- ]to[- ]noise|SNR|noise (?:level|variance)|error variance)\b", re.I),
    "axis_error_distribution": re.compile(r"\b(normal|gaussian|t[- ]distribution|error distribution|nonnormal|non-normal)\b", re.I),
    "axis_heteroskedasticity": re.compile(r"\bheteroskedastic\w*|heteroscedastic\w*\b", re.I),
    "axis_nonlinearity": re.compile(r"\bnonlinear\w*|non-linear\w*\b", re.I),
    "axis_x_correlation": re.compile(r"\b(correlat\w* (?:covariate|regressor|explanatory)|multicollinearity)\b", re.I),
    "axis_spatial_scale": re.compile(r"\b(spatial scale|bandwidth|range parameter|multi[- ]?scale)\b", re.I),
    "axis_measurement_error": re.compile(r"\bmeasurement error|error-prone|mis-?measured\b", re.I),
    "axis_missing_data": re.compile(r"\bmissing (?:data|value|observation)|incomplete data\b", re.I),
}

# Full-text decisions for the empirical-data variable.  These are deliberately
# separate from the automatic evidence finder so regeneration does not erase
# human reading.  A zero means that the paper itself contains no empirical
# dataset; references to applications in the literature do not count.
REAL_DATA_CODING = {
    "E01": (0, "", "none"), "E02": (0, "", "none"),
    "E03": (1, "US county teenage-pregnancy rates", "empirical illustration"),
    "E04": (0, "", "none"), "E05": (0, "", "none"), "E06": (0, "", "none"),
    "E07": (0, "", "none"),
    "E08": (1, "bilateral trade-flow gravity data", "empirical illustration"),
    "E09": (2, "Boston housing; dual gravity/trade data", "two illustrative applications"),
    "E10": (0, "", "none"), "E11": (0, "", "none"), "E12": (0, "", "none"),
    "E13": (0, "", "none"),
    "E14": (1, "Urbansimul parcel data, Provence", "empirical performance illustration"),
    "G01": (1, "Tyne and Wear car-ownership wards", "case study"),
    "G02": (1, "limiting long-term illness data", "worked empirical example"),
    "G03": (0, "", "none"),
    "G04": (1, "Irish Famine electoral divisions", "empirical illustration"),
    "G05": (1, "Dublin voter-turnout data", "empirical illustration"),
    "G06": (1, "PM2.5 and meteorological data", "empirical analysis"),
    "G07": (1, "Georgia educational-attainment data", "worked empirical example"),
    "G08": (1, "Boston housing", "empirical illustration"),
    "G09": (1, "New York City COVID-19 ZCTA counts", "empirical illustration"),
    "G10": (2, "Dublin voter turnout; England and Wales house prices", "prediction with test sets"),
    "G11": (0, "", "none"),
    "S01": (1, "Colorado climatological stations", "kriging case study"),
    "S02": (1, "US April 1948 precipitation stations", "kriging application"),
    "S03": (1, "NCDC US precipitation anomalies", "data example"),
    "S04": (1, "USDA Forest Inventory and Analysis biomass", "spatial regression application"),
    "S05": (0, "", "none"),
    "S06": (1, "NCDC US precipitation anomalies", "real-data analysis"),
    "S07": (1, "USDA Forest Inventory and Analysis biomass", "empirical analysis"),
    "S08": (1, "MIRS satellite total precipitable water", "real-data comparison"),
    "S09": (1, "CESM Large Ensemble climate fields", "climate-data application"),
    "S10": (1, "European weekly maximum precipitation", "empirical application"),
    "T01": (0, "", "none"), "T02": (0, "", "none"),
    "T03": (1, "US state HECM mortgage originations", "empirical application"),
    "T04": (1, "US state cigarette demand", "empirical illustration"),
    "T05": (1, "US state HECM mortgage originations", "empirical application"),
    "T06": (1, "sovereign bond spreads for 51 countries", "empirical application"),
    "T07": (1, "political competition across Chinese cities", "empirical application"),
    "T08": (1, "Pittsburgh monthly crime counts by census tract", "real-data analysis"),
    "T09": (1, "US state cigarette demand", "empirical illustration"),
    "T10": (1, "USGS streamflow, Northern Illinois and Wisconsin", "empirical application"),
    "C01": (2, "Pacific Ocean wind; Irish wind data", "two real-data illustrations"),
    "C02": (1, "Massachusetts birth registry and PM2.5 exposure study", "empirical analysis"),
    "C03": (1, "Carolina wren presence-absence and PRISM climate data", "empirical application"),
    "C04": (2, "Switzerland rainfall; Gulf of Mexico sea-surface conductivity", "two empirical applications"),
    "C05": (1, "Boston housing", "empirical illustration"),
}

SCREENING_OVERRIDES = {
    "E02": (
        "exclude_no_monte_carlo",
        "Full TEI contains theory only: no simulation experiment or empirical application was found.",
        "no",
    ),
    "G01": (
        "retain_influential_contextual_stratum",
        "Highly cited foundational paper retained in the influential contextual stratum; randomization test only, so excluded from the parametric-DGP quantitative denominator.",
        "randomization_test_not_eligible",
    ),
    "G02": (
        "retain_influential_contextual_stratum",
        "Highly cited foundational paper retained in the influential contextual stratum; randomization test only, so excluded from the parametric-DGP quantitative denominator.",
        "randomization_test_not_eligible",
    ),
}

# Values checked directly against simulation sections/tables.  Counts remain
# per experiment when designs differ, so repetitions are never multiplied by
# cells or by internal bootstrap draws.
SIMULATION_MANUAL_CODING = {
    "E01": {"n_simulation_experiments": "2", "n_dgp_structures": "1", "n_cells_by_experiment": "45; 63", "n_dgp_cells_main_text": "108", "cell_count_status": "exact", "n_replications_by_experiment": "500; 500", "method_proposed": "generalized moments estimator", "comparators": "GMM; QML; NLS; OLS", "metrics": "bias; RMSE; interquantile dispersion"},
    "E03": {"n_simulation_experiments": "2", "n_dgp_structures": "2 variance structures", "n_cells_by_experiment": "8 main estimation cells; test design reported separately", "n_dgp_cells_main_text": "lower_bound_8", "cell_count_status": "lower_bound", "n_replications_by_experiment": "1000; 1000", "method_proposed": "heteroskedasticity-robust GMM", "comparators": "MLE; GMME; robust GMME; 2SLS/B2SLS; Hausman and LM tests", "metrics": "mean; bias; SD; RMSE; empirical size; power"},
    "E04": {"n_simulation_experiments": "1", "n_dgp_structures": "homoskedastic; heteroskedastic", "n_cells_by_experiment": "unclear", "n_dgp_cells_main_text": "unclear", "cell_count_status": "not_reconstructible_from_reported_main_text", "n_replications_by_experiment": "unclear", "method_proposed": "GS2SLS/GM for SARAR", "comparators": "GS2SLS/GM; ML", "metrics": "bias; rejection rate"},
    "E05": {"n_simulation_experiments": "1", "n_dgp_structures": "homoskedastic; heteroskedastic", "n_cells_by_experiment": "multiple W/sample/parameter cells across Tables 2-14", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "2000", "method_proposed": "heteroskedasticity-robust GS2SLS/GM", "comparators": "GS2SLS/GM; ML", "metrics": "bias; SD; RMSE; rejection rate"},
    "E06": {"n_simulation_experiments": "1", "n_dgp_structures": "multiple error distributions", "n_cells_by_experiment": "unclear", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "1000", "method_proposed": "adaptive semiparametric SAR estimator", "comparators": "adaptive estimator; OLS; benchmark likelihood-based estimators", "metrics": "bias; MSE"},
    "E07": {"n_simulation_experiments": "1", "n_dgp_structures": "1 SARAR with endogenous regressor", "n_cells_by_experiment": "four lattice/sample configurations × parameter settings", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "2500", "method_proposed": "two-step estimator for SARAR with endogenous regressors", "comparators": "proposed estimator and associated tests", "metrics": "bias; SD; estimated SD; rejection rate; R2"},
    "E08": {"n_simulation_experiments": "1", "n_dgp_structures": "2", "n_cells_by_experiment": "SARMA(1,1); SARMA(0,1), each with parameter settings", "n_dgp_cells_main_text": "lower_bound_2", "cell_count_status": "lower_bound", "n_replications_by_experiment": "1000", "method_proposed": "best GMM estimator (BGMME)", "comparators": "BGMME; MLE; QMLE; GS2SLSE", "metrics": "bias; RMSE; precision/efficiency"},
    "E09": {"n_simulation_experiments": "1", "n_dgp_structures": "heteroskedastic SAR", "n_cells_by_experiment": "4 spatial-layout combinations × parameter settings", "n_dgp_cells_main_text": "lower_bound_4", "cell_count_status": "lower_bound", "n_replications_by_experiment": "1000", "internal_bootstrap_counts": "none", "method_proposed": "robust GMM and Bayesian MCMC estimators", "comparators": "MLE; RGMME; Bayesian BE1; Bayesian BE2", "metrics": "bias; SD; RMSE; direct/indirect/total effects"},
    "E10": {"n_simulation_experiments": "1", "n_dgp_structures": "1 endogenous-W SAR", "n_cells_by_experiment": "3 endogeneity levels × 2 spatial-dependence levels = 6, before other settings", "n_dgp_cells_main_text": "lower_bound_6", "cell_count_status": "lower_bound", "n_replications_by_experiment": "1000", "method_proposed": "IV/QML/GMM estimators for endogenous W", "comparators": "two-stage IV; QMLE; GMM; conventional SAR with alternative W", "metrics": "mean; bias; empirical SD; estimated SE"},
    "E11": {"n_simulation_experiments": "2", "n_dgp_structures": "3 error DGPs plus SARAR extension", "n_cells_by_experiment": "main SAR factorial; smaller SARAR comparison", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "1000; 1000", "method_proposed": "modified QMLE", "comparators": "QMLE; MQMLE; GMME; RGMME; ORGMME; 2SLSE; root estimator; three-step SARAR estimator", "metrics": "mean; bias; RMSE; SD; robust estimated SE"},
    "E12": {"n_simulation_experiments": "2", "n_dgp_structures": "nonlinear transformations and misspecification/test alternatives", "n_cells_by_experiment": "estimation designs; functional-form test pairs", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "1000; 1000", "internal_bootstrap_counts": "500", "method_proposed": "MLE; IV/2SLS and simulated optimal IV for nonlinear SAR", "comparators": "MLE; IV; 2SLS; simulated optimal IV", "metrics": "bias; SD; RMSE; prediction; empirical size; power"},
    "E13": {"n_simulation_experiments": "1", "n_dgp_structures": "1 binary SAR", "n_cells_by_experiment": "2 sample sizes × 4 rho levels = 8", "n_dgp_cells_main_text": "8", "cell_count_status": "exact", "n_replications_by_experiment": "1000", "method_proposed": "comparative study of binary SAR estimators", "comparators": "EM; Gibbs; RIS; GMM; linearized GMM", "metrics": "mean bias; SD; computation/feasibility"},
    "E14": {"n_simulation_experiments": "3", "n_dgp_structures": "2 (SAR probit; SEM probit)", "n_cells_by_experiment": "2; 8; 84", "n_dgp_cells_main_text": "94", "cell_count_status": "exact", "n_replications_by_experiment": "1000; 1000; 1000", "method_proposed": "approximate full/conditional likelihood for spatial probit", "comparators": "RIS; CLUC reorderings; full likelihood; conditional likelihood; standard probit", "metrics": "bias; SD; RMSE; log-likelihood; computation time"},
    "G03": {"n_simulation_experiments": "2", "n_dgp_structures": "2 (stationary coefficients; spatially varying coefficients)", "n_cells_by_experiment": "Georgia n=159 and Toronto n=1003 × correlation settings", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "unclear", "method_proposed": "GWR reliability assessment", "comparators": "global regression; standard GWR; locally linear GWR", "metrics": "coefficient accuracy; coefficient correlation; prediction error; false-positive behavior"},
    "G04": {"n_simulation_experiments": "2", "n_dgp_structures": "2 (unequal spatial heterogeneity; equal spatial heterogeneity)", "n_cells_by_experiment": "1; 1", "n_dgp_cells_main_text": "2", "cell_count_status": "exact", "n_replications_by_experiment": "100; 100", "method_proposed": "MGWR", "comparators": "OLS; GWR; MGWR", "metrics": "bandwidth recovery; parameter-surface RMSE; residual sum of squares; computation time"},
    "G05": {"n_simulation_experiments": "2", "n_dgp_structures": "3 GWR coefficient structures", "n_cells_by_experiment": "18 principal settings; same settings for bootstrap tests", "n_dgp_cells_main_text": "18", "cell_count_status": "exact_main_design", "n_replications_by_experiment": "200; 200", "internal_bootstrap_counts": "1000 per Monte Carlo replication", "method_proposed": "GWGlasso", "comparators": "GWGlasso; two residual-based bootstrap tests", "metrics": "classification/selection frequency; Type I error; rejection rate; AICc"},
    "G06": {"n_simulation_experiments": "2", "n_dgp_structures": "2 spatial domains/coefficient systems", "n_cells_by_experiment": "study 1: n=500,1000,2000 plus test settings; study 2: n=2000,5000", "n_dgp_cells_main_text": "lower_bound_5", "cell_count_status": "lower_bound", "n_replications_by_experiment": "500; 500", "internal_bootstrap_counts": "100 per test replication", "method_proposed": "BST/BPST spatially varying coefficient estimation and tests", "comparators": "BST; BPST; GWR", "metrics": "MSE; MSPE; bias; computation time; Type I error; power"},
    "G07": {"n_simulation_experiments": "1", "n_dgp_structures": "1 MGWR coefficient-surface DGP", "n_cells_by_experiment": "1", "n_dgp_cells_main_text": "1", "cell_count_status": "exact", "n_replications_by_experiment": "1000", "method_proposed": "analytical inference for MGWR", "comparators": "analytical MGWR standard errors versus experimental Monte Carlo standard errors", "metrics": "local coefficient SD/SE; confidence-interval behavior"},
    "G08": {"n_simulation_experiments": "2", "n_dgp_structures": "complete GWR-Lag; omitted-covariate GWR-Lag", "n_cells_by_experiment": "8; 4", "n_dgp_cells_main_text": "12", "cell_count_status": "exact", "n_replications_by_experiment": "500; 500", "method_proposed": "backfitting GWR-Lag estimator", "comparators": "backfitting; GWR maximum likelihood", "metrics": "average estimate; absolute bias; SD; RMSE"},
    "G09": {"n_simulation_experiments": "1", "n_dgp_structures": "1 multiscale Poisson DGP with three coefficient surfaces", "n_cells_by_experiment": "1", "n_dgp_cells_main_text": "1", "cell_count_status": "exact", "n_replications_by_experiment": "1000", "method_proposed": "MGWPR", "comparators": "Poisson GLM; GWPR; MGWPR", "metrics": "bandwidth/scale recovery; surface RMSE; AICc; deviance explained; response replication; computation time"},
    "G10": {"n_simulation_experiments": "1", "n_dgp_structures": "4 error distributions", "n_cells_by_experiment": "4 error distributions × 2 sample sizes = 8", "n_dgp_cells_main_text": "8", "cell_count_status": "exact", "n_replications_by_experiment": "100", "method_proposed": "adaptive spatially varying coefficient estimator", "comparators": "adaptive estimator; local-linear estimator; GWR", "metrics": "RASE; standard error; MSPE in empirical holdout"},
    "G11": {"n_simulation_experiments": "2", "n_dgp_structures": "2 parameter-surface/sample-size systems", "n_cells_by_experiment": "factorial levels of spatial autocorrelation × collinearity, plus higher-noise sensitivity", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "100 per parameter combination", "method_proposed": "diagnostic study of scale and correlation in GWR/MGWR", "comparators": "GWR; MGWR", "metrics": "bandwidth; relative RMSE; MAPE; local condition number"},
    "S01": {"n_simulation_experiments": "1", "n_dgp_structures": "2 (stationary; nonstationary response surfaces)", "n_cells_by_experiment": "2 simulated datasets", "n_dgp_cells_main_text": "2", "cell_count_status": "exact", "n_replications_by_experiment": "50 fits per simulated dataset", "method_proposed": "nonstationary Gaussian-process regression", "comparators": "stationary GP; standard smoothers; Bayesian adaptive-basis alternatives", "metrics": "out-of-sample predictive error; interval behavior", "out_of_sample_evaluation": "yes", "validation_scheme": "simulated test locations; repeated training fits; empirical holdout (120 train/30 test per year)"},
    "S02": {"n_simulation_experiments": "2", "n_dgp_structures": "stationary Matérn covariance with smoothness/range settings", "n_cells_by_experiment": "experiment 1: sample sizes 49–784 × 3 smoothness values × random/regular designs where applicable; experiment 2: taper type/support × covariance smoothness/range", "n_dgp_cells_main_text": "unclear", "cell_count_status": "continuous_or_figure_grid_not_fully_enumerated", "n_replications_by_experiment": "100 random location configurations per sample-size setting; deterministic fixed grid", "method_proposed": "covariance tapering for kriging", "comparators": "exact BLUP; tapered predictor; nearest-neighbor kriging; hard-threshold taper", "metrics": "MSE ratios; naive-versus-actual MSE; computation time", "out_of_sample_evaluation": "yes", "validation_scheme": "prediction at a fixed unobserved center location"},
    "S03": {"n_simulation_experiments": "1", "n_dgp_structures": "1 stationary exponential Gaussian process", "n_cells_by_experiment": "3 taper ranges, with MLE and one-/two-taper estimators", "n_dgp_cells_main_text": "3", "cell_count_status": "exact_for_dgp_parameter_cells", "n_replications_by_experiment": "1000", "method_proposed": "one-taper and two-taper likelihood estimators", "comparators": "full maximum likelihood; one-taper; two-taper", "metrics": "bias; empirical variance; information-based variance estimates", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter-estimation Monte Carlo"},
    "S04": {"n_simulation_experiments": "2", "n_dgp_structures": "2 (stationary anisotropic; nonstationary spatial process)", "n_cells_by_experiment": "example 1: n=3000 × several knot sizes/configurations; example 2: n=15000 × predictive-process configurations", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "one generated realization per example; no repeated-DGP count reported", "internal_bootstrap_counts": "none", "method_proposed": "Gaussian predictive process", "comparators": "parent full GP; predictive-process variants", "metrics": "parameter recovery; DIC/model fit; predictive error; computation time", "out_of_sample_evaluation": "yes", "validation_scheme": "held-out simulated locations; MCMC iterations are computational draws, not DGP replications"},
    "S05": {"n_simulation_experiments": "3", "n_dgp_structures": "2 principal nonstationary covariance systems (variance modulation; spatially varying smoothness)", "n_cells_by_experiment": "two smoothness settings for variance modulation; one varying-smoothness field; joint variance/smoothness estimation", "n_dgp_cells_main_text": "lower_bound_4", "cell_count_status": "lower_bound", "n_replications_by_experiment": "single realizations; no repeated-DGP count reported", "method_proposed": "local likelihood estimation of nonstationary covariance parameters", "comparators": "alternative bandwidth selectors and bias-corrected local estimators", "metrics": "parameter-surface bias/error; likelihood risk", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample recovery of known spatial parameter surfaces"},
    "S06": {"n_simulation_experiments": "2", "n_dgp_structures": "2 nonstationary parameter configurations", "n_cells_by_experiment": "n=2000 benchmark with fixed knots/taper; n=8000 prediction comparison for 2 parameter sets across knot numbers/taper ranges", "n_dgp_cells_main_text": "lower_bound_3", "cell_count_status": "lower_bound_continuous_tuning_grid", "n_replications_by_experiment": "one generated realization per parameter configuration; no repeated-DGP count reported", "method_proposed": "full-scale covariance approximation", "comparators": "full covariance model; predictive process; covariance tapering", "metrics": "posterior parameter summaries; MSPE; computation time", "out_of_sample_evaluation": "yes", "validation_scheme": "500 held-out locations in n=2000 study; 7000 train/1000 holdout in n=8000 study; MCMC iterations excluded from DGP repetitions"},
    "S07": {"n_simulation_experiments": "1", "n_dgp_structures": "1 stationary Gaussian-process regression", "n_cells_by_experiment": "NNGP m=10 and 20; GPP knot settings; full GP", "n_dgp_cells_main_text": "lower_bound_4", "cell_count_status": "lower_bound_method_configuration_count", "n_replications_by_experiment": "one synthetic dataset; no repeated-DGP count reported", "method_proposed": "nearest-neighbor Gaussian process (NNGP)", "comparators": "NNGP variants; Gaussian predictive process; full GP", "metrics": "posterior parameter summaries; DIC; RMSPE; predictive-interval width; computation time", "out_of_sample_evaluation": "yes", "validation_scheme": "out-of-sample predictions; 25000 MCMC iterations excluded from DGP repetitions"},
    "S08": {"n_simulation_experiments": "2", "n_dgp_structures": "2 (one-dimensional Matérn; two-dimensional exponential)", "n_cells_by_experiment": "1D: sample sizes about 2000–1966080 × fixed/increasing domain × approximation resolutions; 2D: n=3211264 × approximation settings", "n_dgp_cells_main_text": "unclear", "cell_count_status": "continuous_or_figure_grid_not_fully_enumerated", "n_replications_by_experiment": "5; unclear/single realization", "method_proposed": "multi-resolution approximation (M-RA)", "comparators": "exact GP/0-RA; one-resolution/full-scale approximations; M-RA variants", "metrics": "log-score; computation time", "out_of_sample_evaluation": "no", "validation_scheme": "likelihood approximation on generated data; fixed- and increasing-domain sequences"},
    "S09": {"n_simulation_experiments": "1 Monte Carlo experiment plus 2 deterministic calibration experiments", "n_dgp_structures": "stationary Matérn fields with smoothness 1 or 2 and varying ranges/windows/replicate counts", "n_cells_by_experiment": "11 × 4 × 2 × 9 = 792 Monte Carlo cells", "n_dgp_cells_main_text": "792", "cell_count_status": "exact", "n_replications_by_experiment": "100 per cell", "method_proposed": "local Matérn estimation with Matérn-to-SAR numerical calibration", "comparators": "Matérn covariance; calibrated SAR representation", "metrics": "percent error in range estimates; correlation-matrix approximation error", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter recovery; deterministic calibration runs kept separate from DGP repetitions"},
    "S10": {"n_simulation_experiments": "1", "n_dgp_structures": "2 exponential Gaussian processes (range 1; range 5)", "n_cells_by_experiment": "5 grid sizes × 2 ranges = 10 DGP scenarios; algorithms evaluated at 4 neighbor sizes or 2 quasi-Monte-Carlo sizes", "n_dgp_cells_main_text": "10", "cell_count_status": "exact_dgp_scenarios", "n_replications_by_experiment": "one Gaussian-process dataset/scenario; no repeated-DGP count reported", "internal_bootstrap_counts": "none", "randomization_counts": "5 stochastic algorithm repetitions per calculation (not DGP repetitions)", "method_proposed": "Vecchia approximation to high-dimensional Gaussian CDFs", "comparators": "Vecchia conditioning schemes; Genz-Bretz quasi-Monte-Carlo", "metrics": "estimated log CDF; numerical variability; computation time", "out_of_sample_evaluation": "no", "validation_scheme": "numerical agreement with quasi-Monte-Carlo benchmark; five algorithm replications separated from DGP replication"},
    "T01": {"n_simulation_experiments": "1", "n_dgp_structures": "1 spatial panel error-components model", "n_cells_by_experiment": "7 spatial-autoregressive values × 3 W matrices = 21", "n_dgp_cells_main_text": "21", "cell_count_status": "exact", "n_replications_by_experiment": "1000 per cell", "method_proposed": "GM estimators and feasible GLS for spatial panel error components", "comparators": "three GM variants; iterated GM/FGLS; maximum likelihood", "metrics": "robust RMSE based on median and interquantile range", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter-estimation Monte Carlo"},
    "T02": {"n_simulation_experiments": "2", "n_dgp_structures": "2 time-varying W patterns (left-right/queen; rook/queen)", "n_cells_by_experiment": "2 parameter vectors × 2 n × 2 T = 8 per W pattern; estimations under correct and four misspecified W specifications", "n_dgp_cells_main_text": "16", "cell_count_status": "exact_dgp_cells_lower_bound_if_supplementary_designs_counted", "n_replications_by_experiment": "500 per cell", "method_proposed": "bias-corrected ML for panels with time-varying spatial weights", "comparators": "uncorrected MLE; bias-corrected MLE under correct, averaged, left-right, queen and rook W", "metrics": "bias; SD; RMSE; coverage probability", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter estimation under W misspecification"},
    "T03": {"n_simulation_experiments": "3", "n_dgp_structures": "4 principal dynamic spatial-panel parameter specifications plus factor-number/noise sensitivity", "n_cells_by_experiment": "4 specifications × 3 n × 3 T = 36 principal cells; additional redundant-factor and factor-strength cells", "n_dgp_cells_main_text": "lower_bound_36", "cell_count_status": "lower_bound", "n_replications_by_experiment": "1000 per design", "method_proposed": "bias-corrected QML for dynamic spatial panels with interactive effects", "comparators": "QMLE; bias-corrected QMLE; multiple factor-number criteria", "metrics": "bias; coverage probability; factor-number selection accuracy", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter recovery and model-dimension selection"},
    "T04": {"n_simulation_experiments": "1", "n_dgp_structures": "1 endogenous time-varying-W spatial panel with three endogeneity levels", "n_cells_by_experiment": "3 endogeneity levels × 2 T values = 6 principal DGP cells (n=100)", "n_dgp_cells_main_text": "6", "cell_count_status": "exact_principal_design", "n_replications_by_experiment": "500 per cell", "method_proposed": "QMLE for endogenous time-varying spatial weights", "comparators": "correct endogenous-W QMLE; exogenous-W QMLE; direct and transformation approaches; bias corrections", "metrics": "bias; SD; RMSE; coverage probability", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter estimation under correct and misspecified W endogeneity"},
    "T05": {"n_simulation_experiments": "2", "n_dgp_structures": "endogenous time-varying-W spatial panel with factor-number sensitivity", "n_cells_by_experiment": "4 spatial-interaction levels × 2 endogeneity levels × reported n/T settings; additional factor-number misspecification cells", "n_dgp_cells_main_text": "lower_bound_8", "cell_count_status": "lower_bound", "n_replications_by_experiment": "1000 per design", "method_proposed": "bias-corrected QML with endogenous spatial weights and interactive effects", "comparators": "original and bias-corrected QMLE; exogenous-W misspecification; alternative factor counts", "metrics": "bias; SD; RMSE; coverage probability", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter recovery and misspecification analysis"},
    "T06": {"n_simulation_experiments": "3", "n_dgp_structures": "3 FE-SDPD DGPs (general model; spatial Durbin extension; SL/STL comparison)", "n_cells_by_experiment": "DGP × 2 heteroskedasticity patterns/homoskedastic case × 3 error distributions × 2 T × 4 N × SNR/parameter settings", "n_dgp_cells_main_text": "unclear", "cell_count_status": "large_factorial_not_fully_enumerated", "n_replications_by_experiment": "2000 per parameter combination", "method_proposed": "robust M-estimator for fixed-effects spatial dynamic panels", "comparators": "conditional QMLE; homoskedastic M-estimator; robust optimal GMM", "metrics": "empirical mean; SD; robust estimated SE; bias; efficiency", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter and variance-estimator Monte Carlo"},
    "T07": {"n_simulation_experiments": "3", "n_dgp_structures": "3 correlated/random-effects spatial dynamic panel DGPs", "n_cells_by_experiment": "DGP × 3 W schemes × 3 error distributions × 2 T × 4 N × spatial-parameter settings", "n_dgp_cells_main_text": "unclear", "cell_count_status": "large_factorial_not_fully_enumerated", "n_replications_by_experiment": "2000 per parameter combination", "method_proposed": "M-estimator and robust covariance estimator for CRE-SDPD", "comparators": "conditional QMLE; M-estimator; full QMLE in spatial-error special case", "metrics": "empirical mean; SD; robust estimated SE; bias; efficiency", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample parameter and standard-error recovery"},
    "T08": {"n_simulation_experiments": "1", "n_dgp_structures": "2 error distributions (normal; t(3)) in high-dimensional spatial dynamic panel", "n_cells_by_experiment": "3 (n,T) settings × 2 error distributions = 6", "n_dgp_cells_main_text": "6", "cell_count_status": "exact", "n_replications_by_experiment": "1000 per cell", "method_proposed": "EDLS+ penalized estimation and model selection", "comparators": "oracle; LASSO; MCP; SCAD; OGA+; instrumental-variable method", "metrics": "MSE; correct zeros; incorrectly removed nonzeros; computation time", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample estimation and variable-selection recovery"},
    "T09": {"n_simulation_experiments": "2", "n_dgp_structures": "homoskedastic and heteroskedastic spatial dynamic quantile panel", "n_cells_by_experiment": "2 variance structures × 3 N × 2 T × 3 quantiles = 36", "n_dgp_cells_main_text": "36", "cell_count_status": "exact", "n_replications_by_experiment": "1000 per cell", "method_proposed": "IV minimum-distance quantile regression", "comparators": "IV-MDQR; MDQR; IV fixed-effects quantile regression", "metrics": "bias; RMSE; computation time", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample finite-sample parameter performance"},
    "T10": {"n_simulation_experiments": "2", "n_dgp_structures": "2 (separable; nonseparable latent-dimension space-time covariance)", "n_cells_by_experiment": "3 separable parameter settings; 2×2×2=8 nonseparable settings; large-data subsampling experiment", "n_dgp_cells_main_text": "11 principal covariance cells plus 1 large-data setting", "cell_count_status": "exact_principal_design", "n_replications_by_experiment": "200 per covariance cell; 100 in large-data experiment", "method_proposed": "dimension expansion for nonstationary space-time covariance", "comparators": "true model; stationary model; BSZ; BSZ plus stationary temporal model", "metrics": "drop-one MSPE; log score", "out_of_sample_evaluation": "yes", "validation_scheme": "drop-one prediction; large-data experiment evaluates 100 randomly dropped observations"},
    "C01": {"n_simulation_experiments": "multiple size/power experiments for univariate and multivariate symmetry/separability tests", "n_dgp_structures": "univariate and multivariate space-time autoregressive processes under null and alternatives", "n_cells_by_experiment": "grid size × time length × temporal correlation × null/alternative configurations", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "3000 per cell", "method_proposed": "self-normalized tests of space-time symmetry and separability", "comparators": "two proposed self-normalized statistics; Li et al. subsampling-based test", "metrics": "empirical size; size-adjusted power", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample hypothesis-test calibration"},
    "C02": {"n_simulation_experiments": "4", "n_dgp_structures": "correct kriging models (constant/covariate means, smooth/rough fields); omitted-covariate misspecification; estimated error covariance; non-Gaussian covariates", "n_cells_by_experiment": "monitor counts 20/40 × exposure-surface/mean-model and misspecification settings × SIMEX assumptions", "n_dgp_cells_main_text": "unclear", "cell_count_status": "table_reconstruction_required", "n_replications_by_experiment": "unclear", "internal_bootstrap_counts": "200 per spatial-SIMEX standard-error calculation", "method_proposed": "spatial SIMEX for misspecified exposure models", "comparators": "naive plug-in; Berkson-error analysis; linear and quadratic spatial SIMEX", "metrics": "health-effect bias; standard error; confidence-interval coverage", "out_of_sample_evaluation": "yes", "validation_scheme": "held-out monitors used to estimate classical-error covariance in designated scenarios; bootstrap kept separate from DGP repetitions"},
    "C03": {"n_simulation_experiments": "1 principal factorial plus supplementary sensitivity experiments", "n_dgp_structures": "2 response distributions (Poisson; binomial) with spatial covariate measurement error and residual spatial effect", "n_cells_by_experiment": "2 responses × 3 measurement-error levels × 3 sample sizes = 18 principal cells", "n_dgp_cells_main_text": "18", "cell_count_status": "exact_principal_design", "n_replications_by_experiment": "1000 per sample-size/response/error setting", "method_proposed": "double fixed-rank kriging (dFRK)", "comparators": "dFRK; corrected nonspatial; naive spatial FRK; naive nonspatial", "metrics": "coefficient bias; estimated-to-empirical SD ratio; predictive MSE; predictive deviance; AUC", "out_of_sample_evaluation": "yes", "validation_scheme": "simulation parameter recovery; empirical train/test prediction in Carolina-wren application"},
    "C04": {"n_simulation_experiments": "2", "n_dgp_structures": "heteroskedastic fields on irregular horseshoe domain; anisotropic fields on square domain", "n_cells_by_experiment": "3 heteroskedastic scenarios + 3 anisotropy scenarios = 6, each evaluated at 5 quantiles", "n_dgp_cells_main_text": "6", "cell_count_status": "exact_dgp_scenarios", "n_replications_by_experiment": "100 per scenario", "method_proposed": "spatial quantile regression with PDE regularization (SQR-PDE)", "comparators": "SOAP/H-SOAP; TPS/H-TPS; quantile smoothing splines; isotropic/anisotropic SQR-PDE", "metrics": "quantile-surface RMSE; computation time", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample recovery of known quantile fields"},
    "C05": {"n_simulation_experiments": "2", "n_dgp_structures": "homoskedastic and heteroskedastic partially linear varying-coefficient SAR", "n_cells_by_experiment": "2 DGPs × 4 sample sizes × 3 quantiles = 24 principal estimation cells; test-power alternatives reported separately", "n_dgp_cells_main_text": "24", "cell_count_status": "exact_principal_design", "n_replications_by_experiment": "1000 per cell", "method_proposed": "instrumental-variable quantile regression for PLVCSAR", "comparators": "IVQR; ordinary quantile regression; constant-coefficient SAR", "metrics": "bias; RMSE; mean absolute deviation error; confidence intervals; test size; power", "out_of_sample_evaluation": "no", "validation_scheme": "in-sample estimation and hypothesis-test calibration"},
}

# Validation refers to predictive assessment on observations not used to fit
# the model. Parameter recovery, hypothesis-test size/power, MCMC diagnostics,
# and repeated numerical integration are coded as in-sample.
VALIDATION_CODING = {
    **{key: "no" for key in ["E01", "E03", "E04", "E05", "E06", "E07", "E08", "E09", "E10", "E11", "E12", "E13", "E14"]},
    "G03": "unclear", "G04": "no", "G05": "no", "G06": "yes", "G07": "no",
    "G08": "no", "G09": "no", "G10": "yes", "G11": "no",
}


def clean(text: str | None) -> str:
    return re.sub(r"\s+", " ", text or "").strip()


def clipped(text: str, limit: int = 650) -> str:
    text = clean(text)
    return text if len(text) <= limit else text[: limit - 1].rstrip() + "…"


def sections(path: Path) -> list[tuple[str, str]]:
    root = ET.parse(path).getroot()
    result: list[tuple[str, str]] = []
    body = root.find(".//tei:text/tei:body", NS)
    if body is None:
        return result
    for div in body.findall(".//tei:div", NS):
        head = clean(" ".join(div.find("tei:head", NS).itertext())) if div.find("tei:head", NS) is not None else ""
        paras = [clean(" ".join(p.itertext())) for p in div.findall("./tei:p", NS)]
        paras += [clean(" ".join(f.itertext())) for f in div.findall("./tei:figure/tei:figDesc", NS)]
        text = clean(" ".join(x for x in paras if x))
        if text:
            result.append((head or "[section sans titre]", text))
    if not result:
        text = clean(" ".join(body.itertext()))
        if text:
            result.append(("[corps]", text))
    return result


def best_evidence(parts: list[tuple[str, str]], pattern: re.Pattern[str]) -> tuple[str, str]:
    ranked = []
    for head, text in parts:
        score = 4 * len(pattern.findall(head)) + len(pattern.findall(text))
        if score:
            ranked.append((score, head, text))
    if not ranked:
        return "", ""
    _, head, text = max(ranked, key=lambda x: x[0])
    match = pattern.search(text)
    start = max(0, (match.start() if match else 0) - 180)
    end = min(len(text), (match.end() if match else 0) + 470)
    return clipped(head, 180), clipped(text[start:end])


def real_evidence(parts: list[tuple[str, str]]) -> tuple[str, str]:
    """Prefer explicitly labelled empirical sections over incidental wording."""
    candidates = [(head, text) for head, text in parts if REAL_HEAD_RE.search(head)]
    if not candidates:
        return "", ""
    return (
        clipped(" | ".join(head for head, _ in candidates), 360),
        clipped(" || ".join(f"[{head}] {text}" for head, text in candidates), 1400),
    )


def yes_no_unclear(found: bool, scope_present: bool = True) -> str:
    return "yes" if found else ("unclear" if scope_present else "NA")


def simulation_details(parts: list[tuple[str, str]]) -> dict[str, str]:
    selected = [(h, t) for h, t in parts if SIM_HEAD_RE.search(h)]
    if not selected:
        selected = [(h, t) for h, t in parts if SIM_RE.search(t) and ("result" in h.lower() or "conclusion" not in h.lower())]
    sim_text = clean(" ".join(t for _, t in selected))
    heads = [h for h, _ in selected]
    numbered = set(re.findall(r"(?:simulation|experiment)\s*(?:study|setup|example)?\s*(\d+)", " ".join(heads), re.I))
    n_experiments = str(len(numbered)) if numbered else ("1" if selected else "unclear")
    dgp_numbers = {int(x) for x in re.findall(r"\bDGP\s*([0-9]+)\b", sim_text, re.I)}
    n_dgp = str(max(dgp_numbers)) if dgp_numbers else "unclear"
    reps = []
    for raw in REPLICATION_RE.findall(sim_text):
        value = re.sub(r"[ ,]", "", raw)
        if value.isdigit() and 10 <= int(value) <= 1000000 and value not in reps:
            reps.append(value)
    bootstrap_counts = []
    for value in re.findall(r"(\d[\d, ]*)\s+bootstrap(?:s| samples| replications| repetitions)?", sim_text, re.I):
        normalized = re.sub(r"[ ,]", "", value)
        if normalized.isdigit() and normalized not in bootstrap_counts:
            bootstrap_counts.append(normalized)
    randomization_counts = []
    for value in re.findall(r"(\d[\d, ]*)\s+(?:randomizations?|permutations?)", sim_text, re.I):
        normalized = re.sub(r"[ ,]", "", value)
        if normalized.isdigit() and normalized not in randomization_counts:
            randomization_counts.append(normalized)
    factorials = []
    for expr in re.findall(r"\b\d+\s*[×x]\s*\d+(?:\s*[×x]\s*\d+){1,5}\b", sim_text):
        normalized = re.sub(r"\s", "", expr).replace("x", "×")
        if normalized not in factorials:
            factorials.append(normalized)
    metric_names = []
    for match in METRIC_RE.finditer(sim_text):
        name = match.group(0).upper() if len(match.group(0)) <= 5 else match.group(0).lower()
        if name not in metric_names:
            metric_names.append(name)
    comparison_sentences = []
    for sentence in re.split(r"(?<=[.!?])\s+", sim_text):
        if re.search(r"\b(compar(?:e|ed|ison)|against|versus| vs\.? )\b", sentence, re.I):
            comparison_sentences.append(clipped(sentence, 420))
        if len(comparison_sentences) == 3:
            break
    return {
        "n_simulation_experiments": n_experiments,
        "n_dgp_structures": n_dgp,
        "n_cells_by_experiment": "; ".join(factorials) if factorials else "unclear",
        "n_dgp_cells_main_text": "unclear",
        "cell_count_status": "factorial_expression_found" if factorials else "unclear",
        "n_replications_by_experiment": "; ".join(reps) if reps else "unclear",
        "internal_bootstrap_counts": "; ".join(bootstrap_counts) if bootstrap_counts else "none_explicitly_found",
        "randomization_counts": "; ".join(randomization_counts) if randomization_counts else "none_explicitly_found",
        "comparators": " | ".join(comparison_sentences) if comparison_sentences else "unclear",
        "metrics": "; ".join(metric_names) if metric_names else "unclear",
        "simulation_sections_reviewed": " | ".join(heads),
        "simulation_text_characters_reviewed": str(len(sim_text)),
        "simulation_scope_note": "DGP replications; bootstrap/randomization must be kept separate during manual verification.",
        "_sim_text": sim_text,
    }


def build_row(source: dict[str, str], root: Path, citations: dict[str, dict]) -> dict[str, str]:
    tei = root / source["tei_path"]
    parts = sections(tei)
    whole = " ".join(f"{h} {t}" for h, t in parts)
    sim_head, sim_excerpt = best_evidence(parts, SIM_RE)
    real_head, real_excerpt = real_evidence(parts)
    sim_found = bool(SIM_RE.search(whole))
    real_found = bool(real_head)
    perf_found = bool(PERF_RE.search(real_excerpt))
    details = simulation_details(parts)
    citation = citations.get(source["id"], {})
    cited_by = citation.get("cited_by_count", "")
    row = {
        "id": source["id"],
        "family": source["family"],
        "title": source["title"],
        "doi": source["doi"],
        "tei_path": source["tei_path"],
        "openalex_cited_by_count": str(cited_by),
        "openalex_id": citation.get("openalex_id", ""),
        "citation_retrieved_at": citation.get("retrieved_at", ""),
        "citation_tier": (
            "very_high_500_plus" if isinstance(cited_by, int) and cited_by >= 500
            else "high_200_499" if isinstance(cited_by, int) and cited_by >= 200
            else "below_200" if isinstance(cited_by, int) else "unavailable"
        ),
        "screening_decision": "candidate_review" if sim_found else "exclude_review",
        "screening_reason": "simulation evidence found; confirm methodological contribution" if sim_found else "no simulation evidence automatically located",
        "primary_parametric_dgp_analysis": "yes" if sim_found else "no",
        "influential_contextual_stratum": "no",
        "monte_carlo_status": yes_no_unclear(sim_found),
        "n_simulation_experiments": details["n_simulation_experiments"],
        "n_dgp_structures": details["n_dgp_structures"],
        "n_cells_by_experiment": details["n_cells_by_experiment"],
        "n_dgp_cells_main_text": details["n_dgp_cells_main_text"],
        "cell_count_status": details["cell_count_status"],
        "n_replications_by_experiment": details["n_replications_by_experiment"],
        "internal_bootstrap_counts": details["internal_bootstrap_counts"],
        "randomization_counts": details["randomization_counts"],
        "real_data_status": yes_no_unclear(real_found),
        "n_real_datasets": "unclear",
        "real_dataset_class": "unclear",
        "real_dataset_names": "unclear",
        "real_data_role": "unclear",
        "n_real_with_perf": "unclear",
        "out_of_sample_evaluation": yes_no_unclear(perf_found),
        "validation_scheme": "unclear",
        "method_proposed": "unclear",
        "comparators": details["comparators"],
        "metrics": details["metrics"],
        "simulation_sections_reviewed": details["simulation_sections_reviewed"],
        "simulation_text_characters_reviewed": details["simulation_text_characters_reviewed"],
        "simulation_scope_note": details["simulation_scope_note"],
        "simulation_evidence_section": sim_head,
        "simulation_evidence_excerpt": sim_excerpt,
        "real_data_evidence_section": real_head,
        "real_data_evidence_excerpt": real_excerpt,
        "coding_status": "prefilled_needs_manual_review",
        "coder_notes": "Automated prefill from TEI; counts and scientific eligibility require full-text verification.",
    }
    for name, pattern in AXES.items():
        row[name] = "yes_candidate" if sim_found and pattern.search(details["_sim_text"]) else "unclear"
    if source["id"] in REAL_DATA_CODING:
        count, names, role = REAL_DATA_CODING[source["id"]]
        row["real_data_status"] = "yes" if count else "no"
        row["n_real_datasets"] = str(count)
        row["real_dataset_class"] = "0" if count == 0 else ("1" if count == 1 else "2")
        row["real_dataset_names"] = names
        row["real_data_role"] = role
        row["coding_status"] = "real_data_verified_simulation_pending"
        row["coder_notes"] = "Empirical-data count read from full TEI; simulation design and inclusion still require verification."
    if source["id"] in SCREENING_OVERRIDES:
        decision, reason, mc_status = SCREENING_OVERRIDES[source["id"]]
        row["screening_decision"] = decision
        row["screening_reason"] = reason
        row["monte_carlo_status"] = mc_status
        if source["id"] in {"E02", "G01", "G02"}:
            row["primary_parametric_dgp_analysis"] = "no"
        if source["id"] in {"G01", "G02"}:
            row["influential_contextual_stratum"] = "yes"
    if source["id"] in SIMULATION_MANUAL_CODING:
        row.update(SIMULATION_MANUAL_CODING[source["id"]])
        row["coding_status"] = "simulation_manually_verified"
        row["coder_notes"] = "Simulation design checked against full TEI; uncertainty is explicitly retained where tables do not permit an exact total."
    if source["id"] in VALIDATION_CODING:
        row["out_of_sample_evaluation"] = VALIDATION_CODING[source["id"]]
    return row


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    manifest = args.manifest if args.manifest.is_absolute() else root / args.manifest
    output = args.output if args.output.is_absolute() else root / args.output
    with manifest.open(encoding="utf-8-sig", newline="") as handle:
        sources = list(csv.DictReader(handle, delimiter="\t"))
    citation_path = manifest.parent / "openalex_citations_50_articles_2026-09-17.json"
    citations = json.loads(citation_path.read_text(encoding="utf-8")) if citation_path.exists() else {}
    rows = [build_row(source, root, citations) for source in sources]
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), delimiter="\t", quoting=csv.QUOTE_MINIMAL)
        writer.writeheader()
        writer.writerows(rows)
    print(f"rows={len(rows)} output={output}")
    print("monte_carlo_status", dict(Counter(r["monte_carlo_status"] for r in rows)))
    print("real_data_status", dict(Counter(r["real_data_status"] for r in rows)))


if __name__ == "__main__":
    main()
