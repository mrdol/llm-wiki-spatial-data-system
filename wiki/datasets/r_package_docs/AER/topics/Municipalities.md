Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

Municipalities: Municipal Expenditure Data

Municipal Expenditure Data

Description

     Panel data set for 265 Swedish municipalities covering 9 years
     (1979-1987).

Usage

     data("Municipalities")

Format

     A data frame containing 2,385 observations on 5 variables.

     municipality factor with ID number for municipality.

     year factor coding year.

     expenditures total expenditures.

     revenues total own-source revenues.

     grants intergovernmental grants received by the municipality.

Details

     Total expenditures contains both capital and current expenditures.

     Expenditures, revenues, and grants are expressed in million SEK.
     The series are deflated and in per capita form. The implicit
     deflator is a municipality-specific price index obtained by
     dividing total local consumption expenditures at current prices by
     total local consumption expenditures at fixed (1985) prices.

     The data are gathered by Statistics Sweden and obtained from
     Financial Accounts for the Municipalities (Kommunernas Finanser).

Source

     Journal of Applied Econometrics Data Archive.

     <http://qed.econ.queensu.ca/jae/2000-v15.4/dahlberg-johansson/>

References

     Dahlberg, M., and Johansson, E. (2000). An Examination of the
     Dynamic Behavior of Local Governments Using GMM Bootstrapping
     Methods.  _Journal of Applied Econometrics_, *15*, 401-416.

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

See Also

     ‘Greene2003’


Variables detected from installed object

municipality: factor ; missing=0 ; examples=114

year: factor ; missing=0 ; examples=1979, 1980, 1981

expenditures: numeric ; missing=0 ; examples=0.0229736, 0.0266307, 0.0273253

revenues: numeric ; missing=0 ; examples=0.018177, 0.0209142, 0.0210836

grants: numeric ; missing=0 ; examples=0.0054429, 0.0057304, 0.0056647

Examples
Run this code

     ## Greene (2003), Table 18.2
     data("Municipalities")
     summary(Municipalities)

