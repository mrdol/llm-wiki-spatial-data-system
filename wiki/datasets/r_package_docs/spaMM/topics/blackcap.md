Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

Genetic polymorphism in relation to migration in the blackcap

Description

     This data set is extracted from a study of genetic polymorphisms
     potentially associated to migration behaviour in the blackcap
     (Sylvia atricapilla). Across different populations in Europe and
     Africa, the average migration behaviour was found to correlate
     with average allele size (dependent on the number of repeats of a
     small DNA motif) at the locus ADCYAP1, encoding a neuropeptide.
     This data set is quite small and ill-suited for separating
     random-effect variance from residual variance. The likelihood
     surface for the Matérn model actually has local maxima.

Usage

     data("blackcap")

Format

     The data frame includes 14 observations on the following
     variables:

     latitude latitude, indeed.

     longitude longitude, indeed.

     migStatus migration status as determined by Mueller et al, from 0
          (resident populations) to 2.5 (long-distance migratory
          populations)

     means Mean allele sizes in each population

     pos Numerical index for the populations

Details

     Migration status was coded as : pure resident populations as '0',
     resident populations with some migratory restlessness as '0.5',
     partial migratory populations as '1', completely migratory
     populations migrating short-distances as '1.5',
     intermediate-distance migratory populations as '2' and distinct
     long-distance migratory populations as '2.5'.

Source

     Data from Mueller et al. (2011), including supplementary material
     now available from doi:10.1098/rspb.2010.2567
     <https://doi.org/10.1098/rspb.2010.2567>.

References

     Mueller, J. C., Pulido, F., and Kempenaers, B. 2011.
     Identification of a gene associated with avian migratory
     behaviour, Proc. Roy. Soc. (Lond.) B 278, 2848-2856.


Variables detected from installed object

latitude: numeric ; missing=0 ; examples=36.1291, 15.0522, 43.5226

longitude: numeric ; missing=0 ; examples=-5.3469, -23.601, 4.7189

migStatus: numeric ; missing=0 ; examples=0, 1

means: numeric ; missing=0 ; examples=161.4, 162.285714285714, 162.611111111111

pos: integer ; missing=0 ; examples=1, 2, 3

Examples
Run this code

     ## see 'fitme', 'corrHLfit' and 'fixedLRT' for examples involving these data

