Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

MMRcoverageDE: MMR coverage levels in the 16 states of Germany

MMR coverage levels in the 16 states of Germany

Description

     Coverage levels at school entry for the first and second dose of
     the combined measles-mumps-rubella (MMR) vaccine in 2006,
     estimated from children presenting vaccination documents at school
     entry examinations.

Usage

     data(MMRcoverageDE)

Format

     A ‘data.frame’ containing 19 rows and 5 columns with variables

     state Names of states: the 16 federal states are followed by the
          total of Germany, as well as the total of West and East
          Germany.

     nOfexaminedChildren Number of children examined.

     withVaccDocument Percentage of children who presented vaccination
          documents.

     MMR1 Percentage of children with vaccination documents, who
          received at least 1 dose of MMR vaccine.

     MMR2 Percentage of children with vaccination documents, who
          received at least 2 doses of MMR vaccine.

     Coverage levels were derived from vaccination documents presented
     at medical examinations, which are conducted by local health
     authorities at school entry each year. Records include information
     about the receipt of 1st and 2nd doses of MMR, but no information
     about dates.  Note that information from children who did not
     present a vaccination document on the day of the medical
     examination, is not included in the estimated coverage.

Source

     Robert Koch-Institut (2008) Zu den Impfquoten bei den
     Schuleingangsuntersuchungen in Deutschland 2006.
     Epidemiologisches Bulletin, *7*, 55-57

References

     Herzog, S.A., Paul, M. and Held, L. (2011) Heterogeneity in
     vaccination coverage explains the size and occurrence of measles
     epidemics in German surveillance data. Epidemiology and Infection,
     *139*, 505-515.

See Also

     ‘measlesDE’


Variables detected from installed object

state: factor ; missing=0 ; examples=Baden-Wuerttemberg, Bayern, Berlin

nOfexaminedChildren: integer ; missing=0 ; examples=104046, 131898, 27400

withVaccDocument: numeric ; missing=0 ; examples=0.921, 0.934, 0.919

MMR1: numeric ; missing=0 ; examples=0.937, 0.917, 0.938

MMR2: numeric ; missing=0 ; examples=0.787, 0.757, 0.836

