# spaMM package help

## Package Description

- Package: spaMM
- Title: Mixed-Effect Models, with or without Spatial Random Effects
- Version: 4.6.65
- Date: 2026-04-05
- Description: Inference based on models with or without spatially-correlated random effects, multivariate responses, or non-Gaussian random effects (e.g., Beta). Variation in residual variance (heteroscedasticity) can itself be represented by a mixed-effect model. Both classical geostatistical models (Rousset and Ferdy 2014 <doi:10.1111/ecog.00566>), and Markov random field models on irregular grids (as considered in the 'INLA' package, <https://www.r-inla.org>), can be fitted, with distinct computational procedures exploiting the sparse matrix representations for the latter case and other autoregressive models. Laplace approximations are used for likelihood or restricted  likelihood. Penalized quasi-likelihood and other variants discussed in the h-likelihood literature (Lee and Nelder 2001 <doi:10.1093/biomet/88.4.987>) are also implemented. 
- Authors@R: c(person("François", "Rousset", role = c("aut", "cre", "cph"),
                     email = "francois.rousset@umontpellier.fr",
                     comment = c(ORCID = "0000-0003-4670-0371")),
              person("Jean-Baptiste", "Ferdy", role = c("aut","cph")),
              person("Alexandre", "Courtiol", role = "aut",
                     comment = c(ORCID = "0000-0003-0637-2959"))
              )
- Author: François Rousset [aut, cre, cph] (ORCID:
    <https://orcid.org/0000-0003-4670-0371>),
  Jean-Baptiste Ferdy [aut, cph],
  Alexandre Courtiol [aut] (ORCID:
    <https://orcid.org/0000-0003-0637-2959>)
- Maintainer: François Rousset <francois.rousset@umontpellier.fr>
- Depends: R (>= 3.5.0)
- Imports: methods, stats, graphics, Matrix, MASS, proxy, Rcpp (>=
0.12.10), nlme, nloptr, minqa, pbapply, cli, gmp (>= 0.6.0),
ROI, boot, geometry (>= 0.4.0), numDeriv, backports, reformulas
- Suggests: maps, testthat, rcdd, foreach, future, future.apply, RANN,
Infusion (>= 1.3.0), IsoriX (>= 0.8.1), blackbox (>= 1.1.25),
RSpectra, ROI.plugin.glpk, lme4, rsae, multilevel, agridat,
fmesher
- License: CeCILL-2
- URL: https://gitlab.mbb.univ-montp2.fr/francois/spamm-ref

## Help Pages

- adjlg: Simulated data set for testing sparse-precision code
- AIC: Extractors for information criteria such as AIC
- algebra: Control of matrix-algebraic methods
- aliases: Variable aliases for multivariate-response fits
- anova.HLfit: ANOVA tables (and likelihood ratio tests).
- arabidopsis: Arabidopsis genetic and climatic data
- ARp: Random effect with AR(p) (autoregressive of order p) or ARMA(p,q) structure.
- as_LMLT: Conversion to input for procedures from lmerTest package
- autoregressive: Fitting autoregressive models
- beta_resp: Beta-distribution family object
- betabin: Beta-binomial family object
- blackcap: Genetic polymorphism in relation to migration in the blackcap
- CauchyCorr: Cauchy correlation function and Cauchy formula term
- clinics: Toy dataset for binomial response
- COMPoisson: Conway-Maxwell-Poisson (COM-Poisson) GLM family
- composite_ranef: Composite random effects
- confint: Confidence intervals
- control.HLfit: Control parameters of the HLfit fitting algorithm
- convergence: Assessing convergence for fitted models
- corMatern: Matern Correlation Structure as a corSpatial object
- corr_family: list("corr_family")
 objects
- corrFamily: Using corrFamily constructors and descriptors.
- corrFamily-definition: corrFamily definition
- corrFamily-design: Designing new corrFamily descriptors for parametric correlation families
- corrHLfit: Fits a mixed model, typically a spatial GLMM.
- corrMatrix: Using the 
list("corrMatrix")
 and 
list("distmatrix")
 arguments
- covStruct: Specifying correlation structures
- diallel: Random-effect structures for symmetric or antisymmetric dyadic interactions
- diallel_fixed: Fixed-effect terms for dyadic interactions
- div_info: Information about numerical problems
- DoF: Degrees of freedom extractor
- dofuture: Interface for parallel computations
- dopar: Interface for parallel computations
- drop1.HLfit: Drop all possible single fixed-effect terms from a model
- eval_replicate: Evaluating bootstrap replicates
- extractors: Functions to extract various components of a fit.
- extreme_eig: Utilities for regularization of a matrix
- fitme: Fitting function for fixed- and mixed-effect models with GLM response.
- fitmv: Fitting multivariate responses
- fix_predVar: Prediction from models with nearly-singular covariance matrices
- fixed: Fixing some parameters
- fixed.LRT: Likelihood ratio test of fixed effects.
- freight: Freight dataset
- genX2X: Fitting fixed-effects coefficients shared between submodels
- get_cPredVar: Estimation of prediction variance with bootstrap correction
- get_fittedPars: Operations on lists of parameters
- get_inits_from_fit: Initiate a fit from another fit
- get_matrix: Extract matrices from a fit
- get_RLRSim_args: Extractors of arguments for functions from package RLRsim
- GLM.fit: Fitting generalized linear models without initial-value or divergence headaches
- gof: Goodness of fit test
- good-practice: Clear and trustworthy formulas and prior weights
- Gryphon: Gryphon data
- hatvalues.HLfit: Leverage extractor for HLfit objects
- HLCor: Fits a (spatially) correlated mixed model, for given correlation parameters
- HLfit: Fit mixed models with given correlation matrix
- how: Extract information about how an object was obtained
- IMRF: Interpolated Markov Random Field models
- inits: Controlling optimization strategy through initial values
- inverse.Gamma: Distribution families for Gamma and inverse Gamma-distributed random effects
- is_separated: Checking for (quasi-)separation in binomial-response model.
- Leuca: Leucadendron data
- lev2bool: Conversion of factor to 0/1 variable
- llm.fit: Link-linear regression models (LLMs)
- Loaloa: Loa loa prevalence in North Cameroon, 1991-2001
- LRT: Likelihood ratio tests of fixed and random effects.
- make.scaled.dist: Scaled distances between unique locations
- mapMM: Colorful plots of predictions in two-dimensional space.
- mat_sqrt: Computation of 
list("square root")
 of symmetric positive definite matrix
- MaternCorr: Matern correlation function and Matern formula term.
- MaternIMRF: corrFamily constructor for Interpolated Markov Random Field (IMRF) covariance structure approximating a 2D Matern correlation model.
- method: Fitting methods (objective functions maximized)
- MSFDR: Multiple-Stage False Discovery Rate procedure
- multinomial: Analyzing multinomial data
- mv: Virtual factor for multivariate responses
- negbin: Family function for negative binomial 
list("2")
 response (including truncated variant).
- negbin1: Alternative negative-binomial family
- numInfo: Information matrix
- optimBounds: Optimization bounds
- options: spaMM options settings
- PAIRfn: Correlated random effects in dyadic interactions
- pedigree: Fit mixed-effects models incorporating pedigrees
- phi-resid.model: Residual dispersion model for gaussian and Gamma response
- plot.HL: Model checking plots for mixed models
- plot_effect: Partial-dependence effects and plots
- PLS-internals: Internal functions for procedure using the ((I,0),(Z,X)) block-order
- pois4mlogit: Fit multinomial logit models and multivariate-response models including them.
- poisson: Family function for GLMs and mixed models with Poisson and zero-truncated Poisson response.
- post-fit: Applying post-fit procedures from other packages on spaMM results
- predict: Prediction from a model fit
- predVar: Prediction and response variances
- R2: Pseudo R-squared
- random-effects: Structure of random effects
- rankinfo: Checking the rank of the fixed-effects design matrix
- register_cF: Declare corrFamily constructor for use in formula
- resid.model: Structured dispersion models
- residuals.HLfit: Extract model residuals
- residVar: Residual variance extractor
- salamander: Salamander mating data
- scotlip: Lip cancer in Scotland 1975 - 1980
- seaMask: Masks of seas or lands
- seeds: Seed germination data
- setNbThreads: Parallel computations in fits
- simulate: Simulate realizations of a fitted model.
- spaMM: Inference in mixed models, in particular spatial GLMMs
- spaMM-conventions: spaMM conventions and differences from related fitting procedures
- spaMM-internal: Internal spaMM Functions
- spaMM-S3: S3 methods of generics defined in other packages
- spaMM.filled.contour: Level (Contour) Plots with better aspect ratio control (for geographical maps, at least)
- spaMM_boot: Parametric bootstrap
- spaMMcolors: A flashy color palette.
- stripHLfit: Reduce the size of fitted objects
- summary.HL: Summary and print methods for fit and test results.
- transffit: Transformation of the data.
- update: Updates a fit
- vcov: Extract covariance or correlation components from a fitted model object
- verbose: Tracking progress of fits
- wafers: Data from a resistivity experiment for semiconductor materials.
- welding: Welding data set
- WinterWheat: Example of yield stability analysis
- wrap_parallel: Selecting interfaces for parallelisation
- ZAXlist: S4 classes for structured matrices

## Package Rd Help

Inference in mixed models, in particular spatial GLMMs

Description

     Fits a range of mixed-effect models, including those with
     spatially correlated random effects. The random effects are either
     Gaussian (which defines GLMMs), or other distributions (which
     defines the wider class of hierarchical GLMs), or simply absent
     (which makes a LM or GLM).  Multivariate-response models can be
     fitted by the 'fitmv' function. Other models can be fitted by
     'fitme'. Also available are previously conceived fitting functions
     'HLfit' (sometimes faster, for non-spatial models), 'HLCor'
     (sometimes faster, for conditional-autoregressive models and
     fixed-correlation models), and 'corrHLfit' (now of lesser
     interest). A variety of post-fit procedures are available for
     prediction, simulation and testing (see, e.g., 'fixedLRT',
     'simulate' and 'predict').

     A variety of special syntaxes for fixed effects, such as 'poly',
     'splines::''ns' or 'bs', or 'lmDiallel::GCA', may be handled
     natively although some might not be fully handled by post-fit
     procedures such as 'predict'. 'poly' is fully handled.
     'lmDiallel::GCA' is not suitable for prediction due to its
     inherent limitations, but see 'X.GCA' for a more functional
     alternative for diallel/multi-membership fixed-effect terms. Note
     that packages implementing these terms must be attached to the
     search list as '::' will not be properly understood in a
     'formula'.

     Both maximum likelihood (ML) and restricted likelihood (REML) can
     be used for linear mixed models, and extensions of these methods
     using Laplace approximations are used for non-Gaussian random
     response. Several variants of these methods discussed in the
     literature are included (see Details in 'HLfit'), the most notable
     of which may be "PQL/L" for binary-response GLMMs (see Example for
     'arabidopsis' data). PQL methods implemented in spaMM are closer
     to (RE)ML methods than those implemented in 'MASS::glmmPQL'.

Details

     The standard response families 'gaussian', 'binomial', 'poisson',
     and 'Gamma' are handled, as well as negative binomial (see
     'negbin1' and 'negbin2'), beta ('beta_resp'), beta-binomial
     ('betabin'), zero-truncated poisson and negative binomial and
     Conway-Maxwell-Poisson response (see 'Tpoisson', 'Tnegbin' and
     'COMPoisson'). A 'multi' family look-alike is also available for
     'multinomial' response, with some constraints.

     The variance parameter of residual error is denoted phi ('phi'):
     this is the residual variance for gaussian response, but for
     Gamma-distributed response, the residual variance is phimu^2 where
     mu is expected response. A (possibly mixed-effects) linear
     predictor for phi, modeling heteroscedasticity, can be considered
     (see Examples).

     The package fits models including several nested or crossed random
     effects, including autocorrelated ones. An interface is being
     developed allowing users to implement their own parametric
     correlation models (see 'corrFamily'), beyond the following ones
     which are built in 'spaMM':
     * geostatistical ('Matern', 'Cauchy'),
     * interpolated Markov Random Fields ('IMRF', 'MaternIMRFa'),
     * autoregressive time-series ('AR1', 'ARp', 'ARMA'),
     * conditional autoregressive as specified by an 'adjacency'
     matrix,
     * pairwise interactions with individual-level random effects, such
     as diallel experiments ('diallel'),
     * or any fixed correlation matrix ('corrMatrix').

     GLMMs and HGLMs are fit via Laplace approximations for (1) the
     marginal likelihood with respect to random effects and (2) the
     restricted likelihood (as in REML), i.e. the likelihood of random
     effect parameters given the fixed effect estimates. All handled
     models can be formulated in terms of a linear predictor of the
     traditional form 'offset'+ *X*beta + *Z b*, where *X* is the
     design matrix of fixed effects, beta ('beta') is a vector of
     fixed-effect coefficients, *Z* is a "design matrix" for the random
     effects (which is instead denoted *M*=*ZAL* elsewhere in the
     package documentation), and *b* a vector of random effect values.
     The general structure of *Mb* is described in 'random-effects'.

     Gaussian and non-gaussian random effects can be fitted. Different
     *gaussian* random-effect terms are handled, with the following
     effects:

     * (1|<RHS>), for non-autocorrelated random effects as in lme4;
     * (<LHS>|<RHS>), for random-coefficient terms as in lme4, *and
        additional terms depending on the <LHS> type* (further detailed below);
     * (<LHS> || <RHS>) is interpreted as in lme4: any such term is immediately
        converted to ( (1|<RHS>) + (0+<LHS>|<RHS>) ). It should be counted as two
        random effects for all purposes (e.g., for fixing the variances of the
        random effects). However, this syntax is useless when the LHS includes a
        factor (see help('lme4::expandDoubleVerts')).
     * <prefix>(1|<RHS>), to specify autocorrelated random effects,
        e.g. Matern(1|long+lat).
     * <prefix>(<LHS>|<RHS>), where the <LHS> can be used to alter the
        autocorrelated random effect as detailed below.

     Different LHS types of *gaussian* '(<LHS>|<RHS>)' random-effect
     terms are handled, with the following effects:

     * <logical> (TRUE/FALSE): affects only responses for which <LHS> is TRUE.
     * <factor built from a logical>: same a <logical> case;
     * <factor not built from a logical>: random-coefficient term as in lme4;
     * 0 + <factor not built from a logical>: same but contrasts are not used;
     * factors specified by the mv(...) expression, generate random-coefficient
       terms specific to multivariate-response models fitted by fitmv() (see
       help("mv")). 0 + mv(...) has the expected effect of not using contrasts;
     * <numeric> (but not '0+<numeric>'): random-coefficient term as in lme4,
       with 2*2 covariance matrix of effects on Intercept and slope;
     * 0 + <numeric>: no Intercept so no covariance matrix (random-slope-only
        term);

     The '0 + <numeric>' effect is achieved by direct control of the
     elements of the incidence matrix *Z* through the '<LHS>' term: for
     numeric 'z', such elements are multiplied by 'z' values, and thus
     provide a variance of order O('z' *squared*).

     If one wishes to fit uncorrelated group-specific random-effects
     with distinct variances for different groups or for different
     response variables, three syntaxes are thus possible. The most
     general, suitable for fitting several variances (see 'GxE' for an
     example), is to fit a (0 + <factor>| <RHS>) random-coefficient
     term with correlation(s) fixed to 0. Alternatively, one can define
     *numeric* (0|1) variables for each group (as 'as.numeric(<boolean
     for given group membership>)'), and use each of them in a 0 +
     <numeric> LHS (so that the variance of each such random effect is
     zero for response not belonging to the given group). See
     'lev2bool' for various ways of specifying such indicator variables
     for several levels.

     *Gaussian* '<prefix>(<LHS not 1>|<RHS>)' random-effect terms may
     be handled, with two main cases depending on the LHS type,
     motivated by the following example: independent Matérn effects can
     be fitted for males and females by using the syntax
     'Matern(male|.) + Matern(female|.)', where 'male' and 'female' are
     TRUE/FALSE (or a factor with TRUE/FALSE levels). In contrast to a
     '(male|.)' term, no random-coefficient correlation matrix is
     fitted. However, for some other types of RHS, one can fit
     _composite random effects_ combining a random-coefficient
     correlation matrix and the correlation model defined by the
     "prefix". This combination is defined in 'composite-ranef'. This
     leads to the following distinction:
     * The terms are *not* composite random effects when the non-''1''
     LHS type is boolean or factor-from-boolean, a just illustrated,
     but also '0+<numeric>': for example, 'Matern(0+<numeric>|.)'
     represents an autocorrelated random-slope (only) term or,
     equivalently, a direct specification of heteroscedasticity of the
     Matérn random effect.
     * By contrast, 'Matern(<numeric>|.)' implies estimating a
     random-coefficient covariance matrix and thus defines a composite
     random effects, as does an LHS that is a factor constructed from
     numeric or character levels.
     Composite random effects can be fitted in principle for all
     "prefixes", including for '<corrFamily>' terms. In practice, this
     functionality has been checked for 'Matern', 'corrMatrix', 'AR1'
     and the 'ARp'-corrFamily term. In these terms, the '<.> %in% <.>'
     form of nested random effect is allowed.

     The syntax '(z-1|.)', for *numeric* 'z' only, can also be used to
     fit *some heteroscedastic non-Gaussian* random effects. For
     example, a Gamma random-effect term '(wei-1|block)' specifies an
     heteroscedastic Gamma random effect u with constant mean 1 and
     variance 'wei^2' lambda, where lambda is still the estimated
     variance parameter. See Details of 'negbin' for a possible
     application. Here, this effect is not implemented through direct
     control of *Z* (multiplying the elements of an incidence matrix
     *Z* by 'wei'), as this would have a different effect on the
     distribution of the random effect term. '(z|.)' is not defined for
     _non-Gaussian_ random effects. It could mean that a correlation
     structure between random intercepts and random slopes for (say)
     Gamma-distributed random effects is considered, but such
     correlation structures are not well-specified by their correlation
     matrix.

Author(s):

     'spaMM' was initially published by François Rousset and
     Jean-Baptiste Ferdy, and is continually developed by F. Rousset
     and tested by Alexandre Courtiol.

References

     Lee, Y., Nelder, J. A. and Pawitan, Y. (2006). Generalized linear
     models with random effects: unified analysis via h-likelihood.
     Chapman & Hall: London.

     Rousset F., Ferdy, J.-B. (2014) Testing environmental and genetic
     effects in the presence of spatial autocorrelation. Ecography, 37:
     781-790.  doi:10.1111/ecog.00566
     <https://doi.org/10.1111/ecog.00566>

See Also

     See the 'test' directory of the package for many additional
     examples of 'spaMM' usage beyond those from the formal
     documentation.

     See 'fitmv' for multivariate-response models.

     Specific information for installation of 'spaMM' dependencies from
     source may be found at
     <https://gitlab.mbb.univ-montp2.fr/francois/spamm-ref#installation>.

Examples

     data("wafers")
     data("scotlip") ## loads 'scotlip' data frame, but also 'Nmatrix'

     ##     Linear model
     fitme(y ~ X1, data=wafers)

     ##     GLM
     fitme(y ~ X1, family=Gamma(log), data=wafers)
     fitme(cases ~ I(log(population)), data=scotlip, family=poisson)

     ##     Non-spatial GLMMs
     fitme(y ~ 1+(1|batch), family=Gamma(log), data=wafers)
     fitme(cases ~ 1+(1|gridcode), data=scotlip, family=poisson)
     #
     # Random-slope model (mind the output!)
     fitme(y~X1+(X2|batch),data=wafers, method="REML")

     ## Spatial, conditional-autoregressive GLMM
     if (spaMM.getOption("example_maxtime")>2) {
       fitme(cases ~ I(log(population))+adjacency(1|gridcode), data=scotlip, family=poisson,
             adjMatrix=Nmatrix) # with adjacency matrix provided by data("scotlip")
     }
     # see ?adjacency for more details on these models

     ## Spatial, geostatistical GLMM:
     # see e.g. examples in ?fitme, ?corrHLfit, ?Loaloa, or ?arabidopsis;
     # see examples in ?Matern for group-specific spatial effects.

     ##     Hierachical GLMs with non-gaussian random effects
      data("salamander")
     if (spaMM.getOption("example_maxtime")>1) {
      # both gaussian and non-gaussian random effects
      fitme(cbind(Mate,1-Mate)~1+(1|Female)+(1|Male),family=binomial(),
             rand.family=list(gaussian(),Beta(logit)),data=salamander)

      # Random effect of Male nested in that of Female:
      fitme(cbind(Mate,1-Mate)~1+(1|Female/Male),
            family=binomial(),rand.family=Beta(logit),data=salamander)
      # [ also allowed is cbind(Mate,1-Mate)~1+(1|Female)+(1|Male %in% Female) ]
     }

     ##    Modelling residual variance ( = structured-dispersion models)
     # GLM response, fixed effects for residual variance
     fitme( y ~ 1,family=Gamma(log),
           resid.model = ~ X3+I(X3^2) ,data=wafers)
     #
     # GLMM response, and mixed effects for residual variance
     if (spaMM.getOption("example_maxtime")>1.5) {
       fitme(y ~ 1+(1|batch),family=Gamma(log),
             resid.model = ~ 1+(1|batch) ,data=wafers)
     }

