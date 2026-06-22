Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

Loaloa: Loa loa prevalence in North Cameroon, 1991-2001

Loa loa prevalence in North Cameroon, 1991-2001

Description

     This data set describes prevalence of infection by the nematode
     _Loa loa_ in North Cameroon, 1991-2001. This is a superset of the
     data discussed by Diggle and Ribeiro (2007) and Diggle et al.
     (2007). The study investigated the relationship between altitude,
     vegetation indices, and prevalence of the parasite.

Usage

     data("Loaloa")

Format

     The data frame includes 197 observations on the following
     variables:

     latitude latitude, in degrees.

     longitude longitude, in degrees.

     ntot sample size per location

     npos number of infected individuals per location

     maxNDVI maximum normalised-difference vegetation index (NDVI) from
          repeated satellite scans

     seNDVI standard error of NDVI

     elev1 altitude, in m.

     elev2,elev3,elev4 Additional altitude variables derived from the
          previous one, provided for convenience: respectively,
          positive values of altitude-650, positive values of
          altitude-1000, and positive values of altitude-1300

     maxNDVI1 a copy of maxNDVI modified as ‘maxNDVI1[maxNDVI1>0.8] <-
          0.8’

Source

     The data were last retrieved on March 1, 2013 from P.J. Ribeiro's
     web resources at
     ‘www.leg.ufpr.br/doku.php/pessoais:paulojus:mbgbook:datasets’. A
     current (2022-06-18) source is
     <https://www.lancaster.ac.uk/staff/diggle/moredata/Loaloa.txt>).

References

     Diggle, P., and Ribeiro, P. 2007. Model-based geostatistics,
     Springer series in statistics, Springer, New York.

     Diggle, P. J., Thomson, M. C., Christensen, O. F., Rowlingson, B.,
     Obsomer, V., Gardon, J., Wanji, S., Takougang, I., Enyong, P.,
     Kamgno, J., Remme, J. H., Boussinesq, M., and Molyneux, D. H.
     2007. Spatial modelling and the prediction of Loa loa risk:
     decision making under uncertainty, Ann. Trop. Med. Parasitol. 101,
     499-509.


Variables detected from installed object

longitude: numeric ; missing=0 ; examples=8.04186, 8.00433, 8.905556

latitude: numeric ; missing=0 ; examples=5.73675, 5.68028, 5.347222

ntot: numeric ; missing=0 ; examples=162, 167, 88

npos: numeric ; missing=0 ; examples=0, 1, 5

maxNDVI: numeric ; missing=0 ; examples=0.69, 0.74, 0.79

seNDVI: numeric ; missing=0 ; examples=0.1394377, 0.1529836, 0.1646169

elev1: numeric ; missing=0 ; examples=108, 99, 783

elev2: numeric ; missing=0 ; examples=0, 133

elev3: numeric ; missing=0 ; examples=0

elev4: numeric ; missing=0 ; examples=0

maxNDVI1: numeric ; missing=0 ; examples=0, 0.74, 0.79

Examples
Run this code

     data("Loaloa")
     if (spaMM.getOption("example_maxtime")>5) {
       fitme(cbind(npos,ntot-npos)~1 +Matern(1|longitude+latitude),
             data=Loaloa, family=binomial())
     }

     ### Variations on the model fit by Diggle et al.
     ###    on a subset of the Loaloa data
     ### In each case this shows the slight differences in syntax,
     ###    and the difference in 'typical' computation times,
     ###    when fit using corrHLfit() or fitme().

     if (spaMM.getOption("example_maxtime")>4) {
       corrHLfit(cbind(npos,ntot-npos)~elev1+elev2+elev3+elev4+maxNDVI1+seNDVI
                        +Matern(1|longitude+latitude),method="HL(0,1)",
                      data=Loaloa,family=binomial(),ranFix=list(nu=0.5))
     }
     if (spaMM.getOption("example_maxtime")>1.6) {
       fitme(cbind(npos,ntot-npos)~elev1+elev2+elev3+elev4+maxNDVI1+seNDVI
                        +Matern(1|longitude+latitude),method="HL(0,1)",
                      data=Loaloa,family=binomial(),fixed=list(nu=0.5))
     }

     if (spaMM.getOption("example_maxtime")>5.8) {
       corrHLfit(cbind(npos,ntot-npos)~elev1+elev2+elev3+elev4+maxNDVI1+seNDVI
                 +Matern(1|longitude+latitude),
                   data=Loaloa,family=binomial(),ranFix=list(nu=0.5))
     }
     if (spaMM.getOption("example_maxtime")>2.5) {
       fitme(cbind(npos,ntot-npos)~elev1+elev2+elev3+elev4+maxNDVI1+seNDVI
                 +Matern(1|longitude+latitude),
                   data=Loaloa,family=binomial(),fixed=list(nu=0.5),method="REML")
     }

     ## Diggle and Ribeiro (2007) assumed (in this package notation) Nugget=2/7:
     if (spaMM.getOption("example_maxtime")>7) {
       corrHLfit(cbind(npos,ntot-npos)~elev1+elev2+elev3+elev4+maxNDVI1+seNDVI
                +Matern(1|longitude+latitude),
                  data=Loaloa,family=binomial(),ranFix=list(nu=0.5,Nugget=2/7))
     }
     if (spaMM.getOption("example_maxtime")>1.3) {
       fitme(cbind(npos,ntot-npos)~elev1+elev2+elev3+elev4+maxNDVI1+seNDVI
                +Matern(1|longitude+latitude),method="REML",
                  data=Loaloa,family=binomial(),fixed=list(nu=0.5,Nugget=2/7))
     }

     ## with nugget estimation:
     if (spaMM.getOption("example_maxtime")>17) {
       corrHLfit(cbind(npos,ntot-npos)~elev1+elev2+elev3+elev4+maxNDVI1+seNDVI
                +Matern(1|longitude+latitude),
                  data=Loaloa,family=binomial(),
                  init.corrHLfit=list(Nugget=0.1),ranFix=list(nu=0.5))
     }
     if (spaMM.getOption("example_maxtime")>5.5) {
       fitme(cbind(npos,ntot-npos)~elev1+elev2+elev3+elev4+maxNDVI1+seNDVI
                +Matern(1|longitude+latitude),
                  data=Loaloa,family=binomial(),method="REML",
                  init=list(Nugget=0.1),fixed=list(nu=0.5))
     }

