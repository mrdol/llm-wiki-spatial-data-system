# surveillance package help

## Package Description

- Package: surveillance
- Title: Temporal and Spatio-Temporal Modeling and Monitoring of Epidemic
Phenomena
- Version: 1.25.0
- Date: 2025-06-24
- Description: Statistical methods for the modeling and monitoring of time series
    of counts, proportions and categorical data, as well as for the modeling
    of continuous-time point processes of epidemic phenomena.
    The monitoring methods focus on aberration detection in count data time
    series from public health surveillance of communicable diseases, but
    applications could just as well originate from environmetrics,
    reliability engineering, econometrics, or social sciences. The package
    implements many typical outbreak detection procedures such as the
    (improved) Farrington algorithm, or the negative binomial GLR-CUSUM
    method of Hoehle and Paul (2008) <doi:10.1016/j.csda.2008.02.015>.
    A novel CUSUM approach combining logistic and multinomial logistic
    modeling is also included. The package contains several real-world data
    sets, the ability to simulate outbreak data, and to visualize the
    results of the monitoring in a temporal, spatial or spatio-temporal
    fashion. A recent overview of the available monitoring procedures is
    given by Salmon et al. (2016) <doi:10.18637/jss.v070.i10>.
    For the retrospective analysis of epidemic spread, the package provides
    three endemic-epidemic modeling frameworks with tools for visualization,
    likelihood inference, and simulation. hhh4() estimates models for
    (multivariate) count time series following Paul and Held (2011)
    <doi:10.1002/sim.4177> and Meyer and Held (2014) <doi:10.1214/14-AOAS743>.
    twinSIR() models the susceptible-infectious-recovered (SIR) event
    history of a fixed population, e.g, epidemics across farms or networks,
    as a multivariate point process as proposed by Hoehle (2009)
    <doi:10.1002/bimj.200900050>. twinstim() estimates self-exciting point
    process models for a spatio-temporal point pattern of infective events,
    e.g., time-stamped geo-referenced surveillance data, as proposed by
    Meyer et al. (2012) <doi:10.1111/j.1541-0420.2011.01684.x>.
    A recent overview of the implemented space-time modeling frameworks
    for epidemic phenomena is given by Meyer et al. (2017)
    <doi:10.18637/jss.v077.i11>.
- Authors@R: c(
    MH = person("Michael", "Hoehle",
                role = c("aut", "ths"),
                comment = c(ORCID = "0000-0002-0423-6702")),
    SM = person("Sebastian", "Meyer",
                email = "seb.meyer@fau.de",
                role = c("aut", "cre"),
                comment = c(ORCID = "0000-0002-1791-9449")),
    MP = person("Michaela", "Paul",
                role = "aut"),
    LH = person("Leonhard", "Held",
                role = c("ctb", "ths"),
                comment = c(ORCID = "0000-0002-8686-5325")),
    person("Howard", "Burkom", role = "ctb"),
    person("Thais", "Correa", role = "ctb"),
    person("Mathias", "Hofmann", role = "ctb"),
    person("Christian", "Lang", role = "ctb"),
    person("Juliane", "Manitz", role = "ctb"),
    person("Sophie", "Reichert", role = "ctb"),
    person("Andrea", "Riebler", role = "ctb"),
    person("Daniel", "Sabanes Bove", role = "ctb"),
    MS = person("Maelle", "Salmon", role = "ctb"),
    DS = person("Dirk", "Schumacher", role = "ctb"),
    person("Stefan", "Steiner", role = "ctb"),
    person("Mikko", "Virtanen", role = "ctb"),
    person("Wei", "Wei", role = "ctb"),
    person("Valentin", "Wimmer", role = "ctb"),
    person("R Core Team", role = "ctb",
           comment = c(ROR = "02zz1nj61",
                       "src/ks.c and a few code fragments of standard S3 methods"))
    )
- Author: Michael Hoehle [aut, ths] (ORCID:
    <https://orcid.org/0000-0002-0423-6702>),
  Sebastian Meyer [aut, cre] (ORCID:
    <https://orcid.org/0000-0002-1791-9449>),
  Michaela Paul [aut],
  Leonhard Held [ctb, ths] (ORCID:
    <https://orcid.org/0000-0002-8686-5325>),
  Howard Burkom [ctb],
  Thais Correa [ctb],
  Mathias Hofmann [ctb],
  Christian Lang [ctb],
  Juliane Manitz [ctb],
  Sophie Reichert [ctb],
  Andrea Riebler [ctb],
  Daniel Sabanes Bove [ctb],
  Maelle Salmon [ctb],
  Dirk Schumacher [ctb],
  Stefan Steiner [ctb],
  Mikko Virtanen [ctb],
  Wei Wei [ctb],
  Valentin Wimmer [ctb],
  R Core Team [ctb] (ROR: <https://ror.org/02zz1nj61>, src/ks.c and a few
    code fragments of standard S3 methods)
- Maintainer: Sebastian Meyer <seb.meyer@fau.de>
- Depends: R (>= 3.6.0), methods, grDevices, graphics, stats, utils, sp
(>= 2.1-4), xtable (>= 1.7-0)
- Imports: polyCub (>= 0.8.0), MASS, Matrix, nlme, spatstat.geom
- Suggests: parallel, grid, gridExtra (>= 2.0.0), lattice (>= 0.20-44),
colorspace, scales, animation, msm, spc, coda, runjags, INLA,
spdep, numDeriv, maxLik, gsl, fanplot, hhh4contacts, quadprog,
memoise, polyclip, intervals, splancs, gamlss, MGLM (>= 0.1.0),
sf, tinytest (>= 1.4.1), knitr
- License: GPL-2
- URL: https://surveillance.R-Forge.R-project.org/

## Help Pages

- abattoir: Abattoir Data
- addFormattedXAxis: Formatted Time Axis for 
list("\"sts\"")
 Objects
- addSeason2formula: Add Harmonics to an Existing Formula
- aggregate.disProg: Aggregate a 
list("disProg")
 Object
- algo.bayes: The Bayes System
- algo.call: Query Transmission to Specified Surveillance Algorithm
- algo.cdc: The CDC Algorithm
- algo.compare: Comparison of Specified Surveillance Systems using Quality Values
- algo.cusum: CUSUM method
- algo.farrington: Surveillance for Count Time Series Using the Classic Farrington Method
- algo.farrington.assign.weights: Assign weights to base counts
- algo.farrington.fitGLM: Fit Poisson GLM of the Farrington procedure for a single time point
- algo.farrington.threshold: Compute prediction interval for a new observation
- algo.glrnb: Count Data Regression Charts
- algo.hmm: Hidden Markov Model (HMM) method
- algo.outbreakP: Semiparametric surveillance of outbreaks
- algo.quality: Computation of Quality Values for a Surveillance System Result
- algo.rki: The system used at the RKI
- algo.rogerson: Modified CUSUM method as proposed by Rogerson and Yamada (2004)
- algo.summary: Summary Table Generation for Several Disease Chains
- all.equal: Test if Two Model Fits are (Nearly) Equal
- animate: Generic animation of spatio-temporal objects
- anscombe.residuals: Compute Anscombe Residuals
- arlCusum: Calculation of Average Run Length for discrete CUSUM schemes
- backprojNP: Non-parametric back-projection of incidence cases to exposure cases

  using a known incubation time as in Becker et al (1991)
- bestCombination: Partition of a number into two factors
- boda: Bayesian Outbreak Detection Algorithm (BODA)
- bodaDelay: Bayesian Outbreak Detection in the Presence of Reporting Delays
- calibration: Calibration Tests for Poisson or Negative Binomial Predictions
- campyDE: Campylobacteriosis and Absolute Humidity in Germany 2002-2011
- categoricalCUSUM: CUSUM detector for time-varying categorical time series
- checkResidualProcess: Check the residual process of a fitted 
list("twinSIR")
 or 
list("twinstim")
- clapply: Conditional 
list("lapply")
- coeflist: List Coefficients by Model Component
- create.disProg: Creating an object of class 
list("disProg")
 (DEPRECATED)
- deleval: Surgical Failures Data
- discpoly: Polygonal Approximation of a Disc/Circle
- disProg2sts: Convert disProg object to sts and vice versa
- earsC: Surveillance for a count data time series using the EARS C1, C2

  or C3 method and its extensions
- epidata: Continuous-Time SIR Event History of a Fixed Population
- epidata_animate: Spatio-Temporal Animation of an Epidemic
- epidata_intersperse: Impute Blocks for Extra Stops in 
list("\"epidata\"")
 Objects
- epidata_plot: Plotting the Evolution of an Epidemic
- epidata_summary: Summarizing an Epidemic
- epidataCS: Continuous Space-Time Marked Point Patterns with Grid-Based Covariates
- epidataCS_aggregate: Conversion (aggregation) of 
list("\"epidataCS\"")
 to 
list("\"epidata\"")
 or 
list("\"sts\"")
- epidataCS_animate: Spatio-Temporal Animation of a Continuous-Time Continuous-Space Epidemic
- epidataCS_permute: Randomly Permute Time Points or Locations of 
list("\"epidataCS\"")
- epidataCS_plot: Plotting the Events of an Epidemic over Time and Space
- epidataCS_update: Update method for 
list("\"epidataCS\"")
- estimateGLRNbHook: Hook function for in-control mean estimation
- fanplot: Fan Plot of Forecast Distributions
- farringtonFlexible: Surveillance for Univariate Count Time Series Using an Improved Farrington Method
- find.kh: Determine the k and h values in a standard normal setting
- findH: Find decision interval for given in-control ARL and reference value
- findK: Find Reference Value
- fluBYBW: Influenza in Southern Germany
- formatDate: Convert Dates to Character (Including Quarter Strings)
- formatPval: Pretty p-Value Formatting
- glm_epidataCS: Fit an Endemic-Only 
list("twinstim")
 as a Poisson-
list("glm")
- ha: Hepatitis A in Berlin
- hagelloch: 1861 Measles Epidemic in the City of Hagelloch, Germany
- hcl.colors: HCL-based Heat Colors from the 
list("colorspace")
 Package
- hepatitisA: Hepatitis A in Germany
- hhh4: Fitting HHH Models with Random Effects and Neighbourhood Structure
- hhh4_formula: Specify Formulae in a Random Effects HHH Model
- hhh4_internals: Internal Functions Dealing with 
list("hhh4")
 Models
- hhh4_methods: Print, Summary and other Standard Methods for 
list("\"hhh4\"")
 Objects
- hhh4_plot: Plots for Fitted 
list("hhh4")
-models
- hhh4_predict: Predictions from a 
list("hhh4")
 Model
- hhh4_simulate: Simulate 
list("\"hhh4\"")
 Count Time Series
- hhh4_simulate_plot: Plot Simulations from 
list("\"hhh4\"")
 Models
- hhh4_simulate_scores: Proper Scoring Rules for Simulations from 
list("hhh4")
 Models
- hhh4_update: list("update")
 a fitted 
list("\"hhh4\"")
 model
- hhh4_validation: Predictive Model Assessment for 
list("hhh4")
 Models
- hhh4_W: Power-Law and Nonparametric Neighbourhood Weights for 
list("hhh4")
-Models
- hhh4_W_utils: Extract Neighbourhood Weights from a Fitted 
list("hhh4")
 Model
- husO104Hosp: Hospitalization date for HUS cases of the STEC outbreak in Germany, 2011
- imdepi: Occurrence of Invasive Meningococcal Disease in Germany
- imdepifit: Example 
list("twinstim")
 Fit for the 
list("imdepi")
 Data
- influMen: Influenza and meningococcal infections in Germany, 2001-2006
- intensityplot: Plot Paths of Point Process Intensities
- intersectPolyCircle: Intersection of a Polygonal and a Circular Domain
- isoWeekYear: Find ISO Week and Year of Date Objects
- knox: Knox Test for Space-Time Interaction
- ks.plot.unif: Plot the ECDF of a uniform sample with Kolmogorov-Smirnov bounds
- layout.labels: Layout Items for 
list("spplot")
- linelist2sts: Convert Dates of Individual Case Reports into a

  Time Series of Counts
- LRCUSUM.runlength: Run length computation of a CUSUM detector
- m1: RKI SurvStat Data
- magic.dim: Compute Suitable k1 x k2 Layout for Plotting
- makeControl: Generate 
list("control")
 Settings for an 
list("hhh4")
 Model
- marks: Import from package 
list("spatstat.geom")
- measles.weser: Measles in the Weser-Ems region of Lower Saxony, Germany, 2001-2002
- measlesDE: Measles in the 16 states of Germany
- meningo.age: Meningococcal infections in France 1985-1997
- MMRcoverageDE: MMR coverage levels in the 16 states of Germany
- momo: Danish 1994-2008 all-cause mortality data for eight age groups
- multiplicity: Import from package 
list("spatstat.geom")
- multiplicity.Spatial: Count Number of Instances of Points
- nbOrder: Determine Neighbourhood Order Matrix from Binary Adjacency Matrix
- nowcast: Adjust a univariate time series of counts for observed

  but-not-yet-reported events
- pairedbinCUSUM: Paired binary CUSUM and its run-length computation
- permutationTest: Monte Carlo Permutation Test for Paired Individual Scores
- pit: Non-Randomized Version of the PIT Histogram (for Count Data)
- plapply: Verbose and Parallel 
list("lapply")
- plot.disProg: Plot Observed Counts and Defined Outbreak States of a 

  (Multivariate) Time Series
- plot.survRes: Plot a 
list("survRes")
 object
- poly2adjmat: Derive Adjacency Structure of 
list("\"SpatialPolygons\"")
- polyAtBorder: Indicate Polygons at the Border
- primeFactors: Prime Number Factorization
- print.algoQV: Print Quality Value Object
- R0: Computes reproduction numbers from fitted models
- ranef: Import from package 
list("nlme")
- refvalIdxByDate: Compute indices of reference value using Date class
- residualsCT: Extract Cox-Snell-like Residuals of a Fitted Point Process
- rotaBB: Rotavirus cases in Brandenburg, Germany, during 2002-2013 stratified by 5 age categories
- runifdisc: Sample Points Uniformly on a Disc
- salmAllOnset: Salmonella cases in Germany 2001-2014 by data of symptoms onset
- salmHospitalized: Hospitalized Salmonella cases in Germany 2004-2014
- salmNewport: Salmonella Newport cases in Germany 2004-2013
- salmonella.agona: Salmonella Agona cases in the UK 1990-1995
- scores: Proper Scoring Rules for Poisson or Negative Binomial Predictions
- shadar: Salmonella Hadar cases in Germany 2001-2006
- sim.pointSource: Simulate Point-Source Epidemics
- sim.seasonalNoise: Generation of Background Noise for Simulated Timeseries
- stcd: Spatio-temporal cluster detection
- stK: Diggle et al (1995) K-function test for space-time clustering
- sts-class: Class 
list("\"sts\"")
 -- surveillance time series
- sts_animate: Animated Maps and Time Series of Disease Counts or Incidence
- sts_creation: Simulate Count Time Series with Outbreaks
- sts_ggplot: Time-Series Plots for 
list("\"sts\"")
 Objects Using 
list("ggplot2")
- sts_observation: Create an 
list("sts")
 object with a given observation date
- sts_tidy: Convert an 
list("\"sts\"")
 Object to a Data Frame in Long (Tidy) Format
- stsAggregate: Aggregate an 
list("\"sts\"")
 Object Over Time or Across Units
- stsBP-class: Class "stsBP" -- a class inheriting from class 
list("sts")
 which

  allows the user to store the results of back-projecting or nowcasting

  surveillance time series
- stsNC-class: Class "stsNC" -- a class inheriting from class 
list("sts")
 which

  allows the user to store the results of back-projecting

  surveillance time series
- stsNClist_animate: Animate a Sequence of Nowcasts
- stsNewport: Salmonella Newport cases in Germany 2001-2015
- stsplot: Plot Methods for Surveillance Time-Series Objects
- stsplot_space: Map of Disease Counts/Incidence accumulated over a Given Period
- stsplot_time: Time-Series Plots for 
list("\"sts\"")
 Objects
- stsSlots: Generic Functions to Access 
list("\"sts\"")
 Slots
- stsXtrct: Subsetting 
list("\"sts\"")
 Objects
- surveillance-defunct: Defunct Functions in Package 
list("surveillance")
- surveillance-package: list("surveillance")
: 
c("\\Sexpr[results=rd,stage=build]{tools:::Rd_package_title(\"#1\")}", "surveillance")
Temporal and Spatio-Temporal Modeling and Monitoring of Epidemic Phenomena
- surveillance.options: Options of the 
list("surveillance")
 Package
- toLatex.sts: list("toLatex")
-Method for 
list("\"sts\"")
 Objects
- twinSIR: Fit an Additive-Multiplicative Intensity Model for SIR Data
- twinSIR_cox: Identify Endemic Components in an Intensity Model
- twinSIR_exData: Toy Data for 
list("twinSIR")
- twinSIR_intensityplot: Plotting Paths of Infection Intensities for 
list("twinSIR")
 Models
- twinSIR_methods: Print, Summary and Extraction Methods for 
list("\"twinSIR\"")
 Objects
- twinSIR_profile: Profile Likelihood Computation and Confidence Intervals
- twinSIR_simulation: Simulation of Epidemic Data
- twinstim: Fit a Two-Component Spatio-Temporal Point Process Model
- twinstim_epitest: Permutation Test for Space-Time Interaction in 
list("\"twinstim\"")
- twinstim_iaf: Temporal and Spatial Interaction Functions for 
list("twinstim")
- twinstim_iafplot: Plot the Spatial or Temporal Interaction Function of a 
list("twimstim")
- twinstim_intensity: Plotting Intensities of Infection over Time or Space
- twinstim_methods: Print, Summary and Extraction Methods for 
list("\"twinstim\"")
 Objects
- twinstim_plot: Plot methods for fitted 
list("twinstim")
's
- twinstim_profile: Profile Likelihood Computation and Confidence Intervals for

list("twinstim")
 objects
- twinstim_siaf: Spatial Interaction Function Objects
- twinstim_siaf_simulatePC: Simulation from an Isotropic Spatial Kernel via Polar Coordinates
- twinstim_simEndemicEvents: Quick Simulation from an Endemic-Only 
list("twinstim")
- twinstim_simulation: Simulation of a Self-Exciting Spatio-Temporal Point Process
- twinstim_step: Stepwise Model Selection by AIC
- twinstim_tiaf: Temporal Interaction Function Objects
- twinstim_update: list("update")
-method for 
list("\"twinstim\"")
- unionSpatialPolygons: Compute the Unary Union of 
list("\"SpatialPolygons\"")
- untie: Randomly Break Ties in Data
- wrap.algo: Multivariate Surveillance through independent univariate algorithms
- zetaweights: Power-Law Weights According to Neighbourhood Order

## Package Rd Help

'surveillance': Temporal and Spatio-Temporal Modeling and Monitoring of
Epidemic Phenomena

Description

     The R package 'surveillance' implements statistical methods for
     the retrospective modeling and prospective monitoring of epidemic
     phenomena in temporal and spatio-temporal contexts.  Focus is on
     (routinely collected) public health surveillance data, but the
     methods just as well apply to data from environmetrics,
     econometrics or the social sciences. As many of the monitoring
     methods rely on statistical process control methodology, the
     package is also relevant to quality control and reliability
     engineering.

Details

     The package implements many typical outbreak detection procedures
     such as Stroup et al. (1989), Farrington et al. (1996), Rossi et
     al. (1999), Rogerson and Yamada (2001), a Bayesian approach
     (Höhle, 2007), negative binomial CUSUM methods (Höhle and Mazick,
     2009), and a detector based on generalized likelihood ratios
     (Höhle and Paul, 2008), see 'wrap.algo'.  Also CUSUMs for the
     prospective change-point detection in binomial, beta-binomial and
     multinomial time series are covered based on generalized linear
     modeling, see 'categoricalCUSUM'.  This includes, e.g., paired
     comparison Bradley-Terry modeling described in Höhle (2010), or
     paired binary CUSUM ('pairedbinCUSUM') described by Steiner et al.
     (1999).  The package contains several real-world datasets, the
     ability to simulate outbreak data, visualize the results of the
     monitoring in temporal, spatial or spatio-temporal fashion. In
     dealing with time series data, the fundamental data structure of
     the package is the S4 class 'sts' wrapping observations,
     monitoring results and date handling for multivariate time series.
     A recent overview of the available monitoring procedures is given
     by Salmon et al. (2016).

     For the retrospective analysis of epidemic spread, the package
     provides three endemic-epidemic modeling frameworks with tools for
     visualization, likelihood inference, and simulation.  The function
     'hhh4' offers inference methods for the (multivariate) count time
     series models of Held et al. (2005), Paul et al. (2008), Paul and
     Held (2011), Held and Paul (2012), and Meyer and Held (2014). See
     'vignette("hhh4")' for a general introduction and
     'vignette("hhh4_spacetime")' for a discussion and illustration of
     spatial 'hhh4' models.  Self-exciting point processes are modeled
     through endemic-epidemic conditional intensity functions.
     'twinSIR' (Höhle, 2009) models the
     susceptible-infectious-recovered (SIR) event history of a fixed
     population, e.g, epidemics across farms or networks; see
     'vignette("twinSIR")' for an illustration.  'twinstim' (Meyer et
     al., 2012) fits spatio-temporal point process models to point
     patterns of infective events, e.g., time-stamped geo-referenced
     surveillance data on infectious disease occurrence; see
     'vignette("twinstim")' for an illustration.  A recent overview of
     the implemented space-time modeling frameworks for epidemic
     phenomena is given by Meyer et al. (2017).

Acknowledgements:

     Substantial contributions of code by: Leonhard Held, Howard
     Burkom, Thais Correa, Mathias Hofmann, Christian Lang, Juliane
     Manitz, Sophie Reichert, Andrea Riebler, Daniel Sabanes Bove,
     Maelle Salmon, Dirk Schumacher, Stefan Steiner, Mikko Virtanen,
     Wei Wei, Valentin Wimmer.

     Furthermore, the authors would like to thank the following people
     for ideas, discussions, testing and feedback: Doris Altmann,
     Johannes Bracher, Caterina De Bacco, Johannes Dreesman, Johannes
     Elias, Marc Geilhufe, Jim Hester, Kurt Hornik, Mayeul Kauffmann,
     Junyi Lu, Lore Merdrignac, Tim Pollington, Marcos Prates, André
     Victor Ribeiro Amaral, Brian D. Ripley, François Rousseu, Barry
     Rowlingson, Christopher W. Ryan, Klaus Stark, Yann Le Strat, André
     Michael Toschke, Wei Wei, George Wood, Achim Zeileis, Bing Zhang.

Author(s):

     Michael Hoehle, Sebastian Meyer, Michaela Paul

     Maintainer: Sebastian Meyer <mailto:seb.meyer@fau.de>

References

     'citation(package="surveillance")' gives the two main software
     references for the modeling (Meyer et al., 2017) and the
     monitoring (Salmon et al., 2016) functionalities:

        * Meyer S, Held L, Höhle M (2017). "Spatio-Temporal Analysis of
          Epidemic Phenomena Using the R Package surveillance."
          _Journal of Statistical Software_, *77*(11), 1-55.
          doi:10.18637/jss.v077.i11
          <https://doi.org/10.18637/jss.v077.i11>.

        * Salmon M, Schumacher D, Höhle M (2016). "Monitoring Count
          Time Series in R: Aberration Detection in Public Health
          Surveillance." _Journal of Statistical Software_, *70*(10),
          1-35. doi:10.18637/jss.v070.i10
          <https://doi.org/10.18637/jss.v070.i10>.

     Further references are listed in 'surveillance:::REFERENCES'.

     If you use the 'surveillance' package in your own work, please do
     cite the corresponding publications.

See Also

     <https://surveillance.R-forge.R-project.org/>

Examples

     ## Additional documentation and illustrations of the methods are
     ## available in the form of package vignettes and demo scripts:
     vignette(package = "surveillance")
     demo(package = "surveillance")

