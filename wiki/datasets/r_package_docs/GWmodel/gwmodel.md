# GWmodel package help

## Package Description

- Package: GWmodel
- Title: Geographically-Weighted Models
- Version: 2.4-1
- Date: 2024-09-07
- Description: Techniques from a particular branch of spatial statistics,termed geographically-weighted (GW) models. GW models suit situations when data are not described well by some global model, but where there are spatial regions where a suitably localised calibration provides a better description. 'GWmodel' includes functions to calibrate: GW summary statistics (Brunsdon et al., 2002)<doi: 10.1016/s0198-9715(01)00009-6>, GW principal components analysis (Harris et al., 2011)<doi: 10.1080/13658816.2011.554838>, GW discriminant analysis (Brunsdon et al., 2007)<doi: 10.1111/j.1538-4632.2007.00709.x> and various forms of GW regression (Brunsdon et al., 1996)<doi: 10.1111/j.1538-4632.1996.tb00936.x>; some of which are provided in basic and robust (outlier resistant) forms.
- Authors@R: c(person(given = "Binbin",
                      family = "Lu",
                      role = c("aut", "cre"),
                      email = "binbinlu@whu.edu.cn"),
               person(given = "Paul",
                      family = "Harris",
                      role = "aut"),
               person(given = "Martin",
                      family = "Charlton",
                      role = "aut"),
               person(given = "Chris",
                      family = "Brunsdon",
                      role = "aut"),
               person(given = "Tomoki",
                      family = "Nakaya",
                      role = "aut"),
               person(given = "Daisuke",
                      family = "Murakami",
                      role = "ctb"),
               person(given = "Yigong",
                      family = "Hu",
                      role = "ctb"),
               person(given = c("Fiona", "H"),
                      family = "Evans",
                      role = "ctb"),
               person(given = "Hjalmar",
                      family = "H<c3><b6>glund",
                      role = "ctb"))
- Author: Binbin Lu [aut, cre],
  Paul Harris [aut],
  Martin Charlton [aut],
  Chris Brunsdon [aut],
  Tomoki Nakaya [aut],
  Daisuke Murakami [ctb],
  Yigong Hu [ctb],
  Fiona H Evans [ctb],
  Hjalmar H<c3><b6>glund [ctb]
- Maintainer: Binbin Lu <binbinlu@whu.edu.cn>
- Depends: R (>= 3.0.0), robustbase,sp (> 1.4-0), Rcpp (>= 1.0.12)
- Imports: methods, sf, grDevices, spacetime,spdep,spatialreg,FNN
- Suggests: mvoutlier, RColorBrewer, gstat,spData
- License: GPL (>= 2)
- URL: http://gwr.nuim.ie/

## Help Pages

- bw.ggwr: Bandwidth selection for generalised geographically weighted regression (GWR)
- bw.gtwr: Bandwidth selection for GTWR
- bw.gwda.rd: Bandwidth selection for GW Discriminant Analysis
- bw.gwpca.rd: Bandwidth selection for Geographically Weighted Principal Components Analysis (GWPCA)
- bw.gwr: Bandwidth selection for basic GWR
- bw.gwr.lcr.rd: Bandwidth selection for locally compensated ridge GWR (GWR-LCR)
- bw.gwss.average: Bandwidth selection for GW summary averages
- DubVoter.rd: Voter turnout data in Greater Dublin(SpatialPolygonsDataFrame)
- EWHP: House price data set (DataFrame) in England and Wales
- EWOutline.rd: Outline of England and Wales for data 
list("EWHP")
- Georgia: Georgia census data set (csv file)
- GeorgiaCounties.rd: Georgia counties data (SpatialPolygonsDataFrame)
- ggwr.basic: Generalised GWR models with Poisson and Binomial options
- ggwr.cv: Cross-validation score for a specified bandwidth for generalised GWR
- ggwr.cv.contrib: Cross-validation data at each observation location for a generalised GWR model
- gtwr: Geographically and Temporally Weighted Regression
- gw.dist: Distance matrix calculation
- gw.pcplot.rd: Geographically weighted parallel coordinate plot for investigating multivariate data sets
- gw.weight: Weight matrix calculation
- gwda.rd: GW Discriminant Analysis
- GWmodel-package: Geographically-Weighted Models
- gwpca.check.components.rd: Interaction tool with the GWPCA glyph map
- gwpca.cv: Cross-validation score for a specified bandwidth for GWPCA
- gwpca.cv.contrib: Cross-validation data at each observation location for a GWPCA
- gwpca.glyph.plot.rd: Multivariate glyph plots of GWPCA loadings
- gwpca.montecarlo.1.rd: Monte Carlo (randomisation) test for significance of GWPCA eigenvalue variability

for the first component only - option 1
- gwpca.montecarlo.2.rd: Monte Carlo (randomisation) test for significance of GWPCA eigenvalue variability

for the first component only - option 2
- gwpca.rd: GWPCA
- gwr.basic.rd: Basic GWR model
- gwr.bootstrap.rd: Bootstrap GWR
- gwr.collin.diagno: Local collinearity diagnostics for basic GWR
- gwr.cv: Cross-validation score for a specified bandwidth for basic GWR
- gwr.cv.contrib: Cross-validation data at each observation location for a basic GWR model
- gwr.hetero.rd: Heteroskedastic GWR
- gwr.lcr.cv: Cross-validation score for a specified bandwidth for GWR-LCR model
- gwr.lcr.cv.contrib: Cross-validation data at each observation location for the GWR-LCR model
- gwr.lcr.rd: GWR with a locally-compensated ridge term
- gwr.mink.approach.rd: Minkovski approach for GWR
- gwr.mink.matrixview.rd: Visualisation of the results from 
list(list("gwr.mink.approach"))
- gwr.mink.pval.rd: Select the values of p for the Minkowski approach for GWR
- gwr.mixed.rd: Mixed GWR
- gwr.model.selection: Model selection for GWR with a given set of independent variables
- gwr.model.sort: Sort the results of the GWR model selection function 
list(list("gwr.model.selection"))
.
- gwr.model.view.rd: Visualise the GWR models from 
list(list("gwr.model.selection"))
- gwr.montecarlo: Monte Carlo (randomisation) test for significance of GWR parameter variability
- gwr.multiscale.rd: Multiscale GWR
- gwr.predict: GWR used as a spatial predictor
- gwr.robust: Robust GWR model
- gwr.scalable.rd: Scalable GWR
- gwr.t.adjust.rd: Adjust p-values for multiple hypothesis tests in basic GWR
- gwr.write: Write the GWR results into files
- gwss.montecarlo: Monte Carlo (randomisation) test for 
list("gwss")
- gwss.rd: Geographically weighted summary statistics (GWSS)
- LondonBorough.rd: London boroughs data
- LondonHP: London house price data set (SpatialPointsDataFrame)
- st.dist: Spatio-temporal distance matrix calculation
- USelect.rd: Results of the 2004 US presidential election at the county level (SpatialPolygonsDataFrame)

## Package Rd Help

Geographically-Weighted Models

Description

     In GWmodel, we introduce techniques from a particular branch of
     spatial statistics, termed geographically-weighted (GW) models. GW
     models suit situations when data are not described well by some
     global model, but where there are spatial regions where a suitably
     localised calibration provides a better description. GWmodel
     includes functions to calibrate: GW summary statistics, GW
     principal components analysis, GW discriminant analysis and
     various forms of GW regression; some of which are provided in
     basic and robust (outlier resistant) forms. In particular, the
     high-performence computing technologies, including multi-thread
     and CUDA techniques are started to be adopted for efficient
     calibrations.

Details

       Package:   GWmodel
       Type:      Package
       Version:   2.4-1
       Date:      2024-09-06
       License:   GPL (>=2)
       LazyLoad:  yes

Note:

     Acknowledgements: We gratefully acknowledge support from National
     Natural Science Foundation of China (42071368); Science Foundation
     Ireland under the National Development Plan through the award of a
     Strategic Research Centre grant 07-SRC-I1168.

     Beta versions can always be found at
     <https://github.com/lbb220/GWmodel>, which includes all the newly
     developed functions for GW models.

     For latest tutorials on using GWmodel please go to:
     <https://rpubs.com/gwmodel>

Author(s):

     Binbin Lu, Paul Harris, Martin Charlton, Chris Brunsdon, Tomoki
     Nakaya, Daisuke Murakami,Isabella Gollini[ctb], Yigong Hu[ctb],
     Fiona H Evans[ctb]

     Maintainer: Binbin Lu <binbinlu@whu.edu.cn>

References

     Gollini I, Lu B, Charlton M, Brunsdon C, Harris P (2015) GWmodel:
     an R Package for exploring Spatial Heterogeneity using
     Geographically Weighted Models. Journal of Statistical Software,
     63(17):1-50, doi: 10.18637/jss.v063.i17 (URL:
     https://doi.org/10.18637/jss.v063.i17)

     Lu B, Harris P, Charlton M, Brunsdon C (2014) The GWmodel R
     Package: further topics for exploring Spatial Heterogeneity using
     Geographically Weighted Models. Geo-spatial Information Science
     17(2): 85-101, doi: 10.1080/10095020.2014.917453 (URL:
     https://doi.org/10.1080/10095020.2014.917453)

     Lu, B., Hu, Y., Yang, D., Liu, Y., Ou, G., Harris, P., Brunsdon,
     C., Comber, A., Dong, G., 2024. Gwmodels: A standalone software to
     train geographically weighted models. Geo-spatial Information
     Science, 1-23.

     Lu, B., Hu, Y., Murakami, D., Brunsdon, C., Comber, A., Charlton,
     M., Harris, P., 2022. High-performance solutions of geographically
     weighted regression in r. Geo-spatial Information Science 25 (4),
     536-549.

