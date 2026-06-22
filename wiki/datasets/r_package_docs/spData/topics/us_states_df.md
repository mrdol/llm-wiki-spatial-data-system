Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

us_states_df: the American Community Survey (ACS) data

the American Community Survey (ACS) data

Description

     The object loaded is a ‘data.frame’ object containing the US
     states data from the American Community Survey (ACS)

Usage

     us_states_df

Format

     Formal class 'data.frame'; the data contains a data.frame with 51
     obs. of 5 variables:

        * state: character vector of state names

        * median_income_10: numerical vector of median income in 2010

        * median_income_15: numerical vector of median income in 2010

        * poverty_level_10: numerical vector of number of people with
          income below poverty level in 2010

        * poverty_level_15: numerical vector of number of people with
          income below poverty level in 2015

Source

     <https://www.census.gov/programs-surveys/acs/>

See Also

     See the tidycensus package:
     https://cran.r-project.org/package=tidycensus


Variables detected from installed object

state: character ; missing=0 ; examples=Alabama, Alaska, Arizona

median_income_10: numeric ; missing=0 ; examples=21746, 29509, 26412

median_income_15: numeric ; missing=0 ; examples=22890, 31455, 26156

poverty_level_10: numeric ; missing=0 ; examples=786544, 64245, 933113

poverty_level_15: numeric ; missing=0 ; examples=887260, 72957, 1180690

Examples
Run this code

     data(us_states_df)

     summary(us_states_df)

