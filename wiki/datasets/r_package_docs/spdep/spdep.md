# spdep package help

## Package Description

- Package: spdep
- Title: Spatial Dependence: Weighting Schemes, Statistics
- Version: 1.4-2
- Date: 2026-02-13
- Description: A collection of functions to create spatial weights matrix
  objects from polygon 'contiguities', from point patterns by distance and
  tessellations, for summarizing these objects, and for permitting their
  use in spatial data analysis, including regional aggregation by minimum
  spanning tree; a collection of tests for spatial 'autocorrelation',
  including global 'Morans I' and 'Gearys C' proposed by 'Cliff' and 'Ord'
  (1973, ISBN: 0850860369) and (1981, ISBN: 0850860814), 'Hubert/Mantel'
  general cross product statistic, Empirical Bayes estimates and
  'Assunção/Reis' (1999) <doi:10.1002/(SICI)1097-0258(19990830)18:16%3C2147::AID-SIM179%3E3.0.CO;2-I> Index, 'Getis/Ord' G ('Getis' and 'Ord' 1992)
  <doi:10.1111/j.1538-4632.1992.tb00261.x> and multicoloured
  join count statistics, 'APLE' ('Li et al.' )
  <doi:10.1111/j.1538-4632.2007.00708.x>, local 'Moran's I', 'Gearys C' 
  ('Anselin' 1995) <doi:10.1111/j.1538-4632.1995.tb00338.x> and
  'Getis/Ord' G ('Ord' and 'Getis' 1995)
  <doi:10.1111/j.1538-4632.1995.tb00912.x>,
  'saddlepoint' approximations ('Tiefelsdorf' 2002)
  <doi:10.1111/j.1538-4632.2002.tb01084.x> and exact tests
  for global and local 'Moran's I' ('Bivand et al.' 2009)
  <doi:10.1016/j.csda.2008.07.021> and 'LOSH' local indicators
  of spatial heteroscedasticity ('Ord' and 'Getis')
  <doi:10.1007/s00168-011-0492-y>. The implementation of most of
  these measures is described in 'Bivand' and 'Wong' (2018)
  <doi:10.1007/s11749-018-0599-x>, with further extensions in 'Bivand' (2022)
  <doi:10.1111/gean.12319>. 'Lagrange' multiplier tests for spatial dependence
  in linear models are provided ('Anselin et al'. 1996)
  <doi:10.1016/0166-0462(95)02111-6>, as are 'Rao' score tests for hypothesised
  spatial 'Durbin' models based on linear models ('Koley' and 'Bera' 2023)
  <doi:10.1080/17421772.2023.2256810>. Additions in 2024 include Local
  Indicators for Categorical Data based on 'Carrer et al.' (2021)
  <doi:10.1016/j.jas.2020.105306> and 'Bivand et al.' (2017)
  <doi:10.1016/j.spasta.2017.03.003>; also Weighted Multivariate Spatial
  Autocorrelation Measures ('Bavaud' 2024) <doi:10.1111/gean.12390>.
  <doi:10.1080/17421772.2023.2256810>. A local indicators for categorical data
  (LICD) implementation based on 'Carrer et al.' (2021) 
  <doi:10.1016/j.jas.2020.105306> and 'Bivand et al.' (2017) 
  <doi:10.1016/j.spasta.2017.03.003> was added in 1.3-7. Multivariate
  'spatialdelta' ('Bavaud' 2024) <doi:10.1111/gean.12390> was added in 1.3-13 ('Bivand' 2025 <doi:10.26034/la.cdclsl.2025.8343>).
  From 'spdep' and 'spatialreg' versions >= 1.2-1, the model fitting functions
  previously present in this package are defunct in 'spdep' and may be found
  in 'spatialreg'.
- Authors@R: c(person("Roger", "Bivand", role = c("cre", "aut"), 
           email = "Roger.Bivand@nhh.no",
           comment=c(ORCID="0000-0003-2392-6140", ROR="04v53s997")),
	person("Micah", "Altman", role = "ctb"),
	person("Luc", "Anselin", role = "ctb"),
	person("Renato", "Assunção", role = "ctb"),
	person("Anil", "Bera", role = "ctb"),
	person("Olaf", "Berke", role = "ctb"),
	person("F. Guillaume", "Blanchet", role = "ctb"),
	person("Marilia", "Carvalho", role = "ctb"),
	person("Bjarke", "Christensen", role = "ctb"),
	person("Yongwan", "Chun", role = "ctb"),
	person("Carsten", "Dormann", role = "ctb"),
	person("Stéphane", "Dray", role = "ctb"),
        person("Dewey", "Dunnington", role = c("ctb"),
           comment = c(ORCID = "0000-0002-9415-4582")),
	person("Virgilio", "Gómez-Rubio", role = "ctb"),
	person("Malabika", "Koley", role = "ctb"),
	person("Tomasz", "Kossowski", role = "ctb",
           comment = c(ORCID = "0000-0002-9976-4398")),
	person("Elias", "Krainski", role = "ctb"),
	person("Pierre", "Legendre", role = "ctb"),
	person("Nicholas", "Lewin-Koh", role = "ctb"),
	person("Angela", "Li", role = "ctb"),
	person("Giovanni", "Millo", role = "ctb"),
	person("Werner", "Mueller", role = "ctb"),
	person("Hisaji", "Ono", role = "ctb"),
	person("Josiah", "Parry", role = "ctb",
           comment = c(ORCID = "0000-0001-9910-865X")),
	person("Pedro", "Peres-Neto", role = "ctb"),
	person("Michał", "Pietrzak", role = "ctb",
           comment = c(ORCID = "0000-0002-9263-4478")),
	person("Gianfranco", "Piras", role = "ctb"),
	person("Markus", "Reder", role = "ctb"),
	person("Jeff", "Sauer", role = "ctb"),
	person("Michael", "Tiefelsdorf", role = "ctb"),
	person("René", "Westerholt", role="ctb"),
	person("Justyna", "Wilk", role = "ctb",
           comment = c(ORCID = "0000-0003-1495-2910")),
	person("Levi", "Wolf", role = "ctb"),
	person("Danlin", "Yu", role = "ctb"))
- Author: Roger Bivand [cre, aut] (ORCID:
    <https://orcid.org/0000-0003-2392-6140>, ROR:
    <https://ror.org/04v53s997>),
  Micah Altman [ctb],
  Luc Anselin [ctb],
  Renato Assunção [ctb],
  Anil Bera [ctb],
  Olaf Berke [ctb],
  F. Guillaume Blanchet [ctb],
  Marilia Carvalho [ctb],
  Bjarke Christensen [ctb],
  Yongwan Chun [ctb],
  Carsten Dormann [ctb],
  Stéphane Dray [ctb],
  Dewey Dunnington [ctb] (ORCID: <https://orcid.org/0000-0002-9415-4582>),
  Virgilio Gómez-Rubio [ctb],
  Malabika Koley [ctb],
  Tomasz Kossowski [ctb] (ORCID: <https://orcid.org/0000-0002-9976-4398>),
  Elias Krainski [ctb],
  Pierre Legendre [ctb],
  Nicholas Lewin-Koh [ctb],
  Angela Li [ctb],
  Giovanni Millo [ctb],
  Werner Mueller [ctb],
  Hisaji Ono [ctb],
  Josiah Parry [ctb] (ORCID: <https://orcid.org/0000-0001-9910-865X>),
  Pedro Peres-Neto [ctb],
  Michał Pietrzak [ctb] (ORCID: <https://orcid.org/0000-0002-9263-4478>),
  Gianfranco Piras [ctb],
  Markus Reder [ctb],
  Jeff Sauer [ctb],
  Michael Tiefelsdorf [ctb],
  René Westerholt [ctb],
  Justyna Wilk [ctb] (ORCID: <https://orcid.org/0000-0003-1495-2910>),
  Levi Wolf [ctb],
  Danlin Yu [ctb]
- Maintainer: Roger Bivand <Roger.Bivand@nhh.no>
- Depends: R (>= 3.3.0), methods, spData (>= 2.3.1), sf
- Imports: stats, deldir, boot (>= 1.3-1), graphics, utils, grDevices,
units, s2, e1071, sp (>= 1.0)
- Suggests: spatialreg (>= 1.2-1), Matrix, parallel, dbscan,
RColorBrewer, lattice, xtable, foreign, igraph, RSpectra,
knitr, classInt, tmap, spam, ggplot2, rmarkdown, tinytest,
rgeoda (>= 0.0.11.1), mipfp, Guerry, codingMatrices
- License: GPL (>= 2)
- URL: https://github.com/r-spatial/spdep/,
https://r-spatial.github.io/spdep/
- BugReports: https://github.com/r-spatial/spdep/issues/

## Help Pages

- aggregate.nb: Aggregate a spatial neighbours object
- airdist: Measure distance from plot
- autocov_dist: Distance-weighted autocovariate
- bhicv: Data set with 4 life condition indices of Belo Horizonte region
- card: Cardinalities for neighbours lists
- cell2nb: Generate neighbours list for grid cells
- choynowski: Choynowski probability map values
- COL.OLD: Columbus OH spatial analysis data set - old numbering
- columbus: Columbus OH spatial analysis data set
- compon: Depth First Search on Neighbor Lists
- diffnb: Differences between neighbours lists
- dnearneigh: Neighbourhood contiguity by distance
- droplinks: Drop  and add links in a neighbours list
- EBest: Global Empirical Bayes estimator
- EBImoran.mc: Permutation test for empirical Bayes index
- EBlocal: Local Empirical Bayes estimator
- edit.nb: Interactive editing of neighbours lists
- eire: Eire data sets
- geary: Compute Geary's C
- geary.mc: Permutation test for Geary's C statistic
- geary.test: Geary's C test for spatial autocorrelation
- globalG.test: Global G test for spatial autocorrelation
- graphneigh: Graph based spatial weights
- grid2nb: Construct neighbours for a GridTopology
- hotspotmap: Cluster Classifications for Local Indicators of Spatial Association and Local Indicators for Categorical Data
- include.self: Include self in neighbours list
- joincount.mc: Permutation test for same colour join count statistics
- joincount.multi: BB, BW and Jtot join count statistic for k-coloured factors
- joincount.test: BB join count statistic for k-coloured factors
- knearneigh: K nearest neighbours for spatial weights
- knn2nb: Neighbours list from knn object
- lag.listw: Spatial lag of a numeric vector
- lee: Compute Lee's statistic
- lee.mc: Permutation test for Lee's L statistic
- lee.test: Lee's L  test for spatial autocorrelation
- licd_multi: Local Indicators for Categorical Data
- listw2sn: Spatial neighbour sparse representation
- lm.morantest: Moran's I test for residual spatial autocorrelation
- lm.morantest.exact: Exact global Moran's I test
- lm.morantest.sad: Saddlepoint approximation of global Moran's I test
- lm.RStests: Rao's score (a.k.a Lagrange Multiplier) diagnostics for spatial dependence in linear models
- local_joincount_bv: Calculate the local bivariate join count
- local_joincount_uni: Calculate the local univariate join count
- localC: Compute Local Geary statistic
- localG: G and Gstar local spatial statistics
- localGS: A local hotspot statistic for analysing multiscale datasets
- localmoran: Local Moran's I statistic
- localmoran.exact: Exact local Moran's Ii tests
- localmoran.sad: Saddlepoint approximation of local Moran's Ii tests
- localmoran_bv: Compute the Local Bivariate Moran's I Statistic
- LOSH: Local spatial heteroscedasticity
- LOSH.cs: Chi-square based test for local spatial heteroscedasticity
- LOSH.mc: Bootstrapping-based test for local spatial heteroscedasticity
- mat2listw: Convert a square spatial weights matrix to a weights list object
- moran: Compute Moran's I
- moran.mc: Permutation test for Moran's I statistic
- moran.plot: Moran scatterplot
- moran.test: Moran's I test for spatial autocorrelation
- moran_bv: Compute the Global Bivariate Moran's I
- mstree: Find the minimal spanning tree
- nb2blocknb: Block up neighbour list for location-less observations
- nb2INLA: Output spatial neighbours for INLA
- nb2lines: Use vector files for import and export of weights
- nb2listw: Spatial weights for neighbours lists
- nb2listwdist: Distance-based spatial weights for neighbours lists
- nb2mat: Spatial weights matrices for neighbours lists
- nb2WB: Output spatial weights for WinBUGS
- nbcosts: Compute cost of edges
- nbdists: Spatial link distance measures
- nblag: Higher order neighbours lists
- nboperations: Set operations on neighborhood objects
- p.adjustSP: Adjust local association measures' p-values
- plot.mst: Plot the Minimum Spanning Tree
- plot.nb: Plot a neighbours list
- plot.skater: Plot the object of skater class
- poly2nb: Construct neighbours list from polygon list
- probmap: Probability mapping for rates
- prunecost: Compute cost of prune each edge
- prunemst: Prune a Minimun Spanning Tree
- read.gal: Read a GAL lattice file into a neighbours list
- read.gwt2nb: Read and write spatial neighbour files
- rotation: Rotate a set of point by a certain angle
- SD.RStests: Rao's score and adjusted Rao's score tests of linear hypotheses for spatial Durbin and spatial Durbin error models
- set.mcOption: Options for parallel support
- set.spChkOption: Control checking of spatial object IDs
- skater: Spatial 'K'luster Analysis by Tree Edge Removal
- sp.correlogram: Spatial correlogram
- sp.mantel.mc: Mantel-Hubert spatial general cross product statistic
- spatialdelta: Weighted Multivariate Spatial Autocorrelation Measures
- spdep: Return package version number
- spdep-defunct: Defunct Functions in Package 
list("spdep")
- spweights.constants: Provides constants for spatial weights matrices
- ssw: Compute the sum of dissimilarity
- subset.listw: Subset a spatial weights list
- subset.nb: Subset a neighbours list
- summary.nb: Print and summary function for neighbours and weights lists
- testnb: Test a neighbours list for symmetry
- tolerance.nb: Function to construct edges based on a tolerance angle and a maximum distance
- tri2nb: Neighbours list from tri object
- write.nb.gal: Write a neighbours list as a GAL lattice file

## Package Rd Help

Return package version number

Description

     The function retreives package version and build information

Usage

     spdep(build = FALSE)

Arguments

   build: if TRUE, also returns build information

Value:

     a character vector with one or two elements

Author(s):

     Roger Bivand <mailto:Roger.Bivand@nhh.no>

