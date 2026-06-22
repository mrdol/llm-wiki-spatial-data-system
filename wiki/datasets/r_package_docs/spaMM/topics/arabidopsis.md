Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

arabidopsis: Arabidopsis genetic and climatic data

Arabidopsis genetic and climatic data

Description

     For 948 “accessions” from European Arabidopsis thaliana
     populations, this data set merges the genotypic information at
     four single nucleotide polymorphisms (SNP) putatively involved in
     adaptation to climate (Fournier-Level et al, 2011, Table 1), with
     13 climatic variables from Hancock et al. (2011).

Usage

     data("arabidopsis")

Format

     The data frame includes 948 observations on the following
     variables:

     pos1046738, pos5510910, pos6235221, pos8132698 Genotypes at four
          SNP loci

     LAT latitude

     LONG longitude

     seasonal, tempWarmest, tempColdest, preciWettest, preciDriest,
          preciCV, PAR_SPRING,

     growingL, conseqCold, conseqFrFree, RelHumidSp, dayLSp, aridity
          Thirteen climatic variables.  See Hancock et al. (2011) for
          details about these variables.

Details

     The response is binary so ‘method="PQL/L"’ seems warranted (see
     Rousset and Ferdy, 2014).

Source

     The data were retrieved from
     ‘http://bergelson.uchicago.edu/regmap-data/climate-genome-scan’ on
     22 February 2013 (they may no longer be available from there).

References

     Fournier-Level A, Korte A., Cooper M. D., Nordborg M., Schmitt J.,
     Wilczek AM (2011). A map of local adaptation in Arabidopsis
     thaliana. Science 334: 86-89.

     Hancock, A. M., Brachi, B., Faure, N., Horton, M. W., Jarymowycz,
     L. B., Sperone, F. G., Toomajian, C., Roux, F., and Bergelson, J.
     2011.  Adaptation to climate across the Arabidopsis thaliana
     genome, Science 334: 83-86.

     Rousset F., Ferdy, J.-B. (2014) Testing environmental and genetic
     effects in the presence of spatial autocorrelation. Ecography, 37:
     781-790.  doi:10.1111/ecog.00566
     <https://doi.org/10.1111/ecog.00566>


Variables detected from installed object

pos1046738: numeric ; missing=0 ; examples=0

pos5510910: numeric ; missing=0 ; examples=1, 0

pos6235221: numeric ; missing=0 ; examples=1, 0

pos8132698: numeric ; missing=0 ; examples=0, 1

LAT: numeric ; missing=0 ; examples=55.8364, 55.8422, 55.7

LONG: numeric ; missing=0 ; examples=13.3075, 13.3019, 13.2

seasonal: integer ; missing=0 ; examples=6187, 6173

tempWarmest: integer ; missing=0 ; examples=201, 202

tempColdest: integer ; missing=0 ; examples=-31, -27

preciWettest: integer ; missing=0 ; examples=71, 68

preciDriest: integer ; missing=0 ; examples=37, 35

preciCV: integer ; missing=0 ; examples=22, 21

PAR_SPRING: numeric ; missing=0 ; examples=71.57222

growingL: integer ; missing=0 ; examples=8

conseqCold: numeric ; missing=0 ; examples=17.9, 16.05

conseqFrFree: numeric ; missing=0 ; examples=158.41, 154.32

RelHumidSp: numeric ; missing=0 ; examples=71.525199, 71.894096

dayLSp: numeric ; missing=0 ; examples=13.222599, 13.199299

aridity: numeric ; missing=0 ; examples=1.27999997, 1.13800001

Examples
Run this code

     data("arabidopsis")
     if (spaMM.getOption("example_maxtime")>2.5) {
       fitme(cbind(pos1046738,1-pos1046738)~seasonal+Matern(1|LAT+LONG),
             fixed=list(rho=0.119278,nu=0.236990,lambda=8.599),
             family=binomial(),method="PQL/L",data=arabidopsis)
     }
     ## The above 'fixed' values are deduced from the following fit:
     if (spaMM.getOption("example_maxtime")>46) {
       SNPfit <- fitme(cbind(pos1046738,1-pos1046738)~seasonal+Matern(1|LAT+LONG),
                   verbose=c(TRACE=TRUE),
                   family=binomial(),method="PQL/L",data=arabidopsis)
       summary(SNPfit) # p_v=-125.0392
     }

