Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

worldbank_df: World Bank data

World Bank data

Description

     The object loaded is a ‘data.frame’ object containing data from
     World Bank

Usage

     worldbank_df

Format

     Formal class 'data.frame'; the data contains a data.frame with 177
     obs. of 7 variables:

        * name: character vector of country names

        * iso_a2: character vector of ISO 2 character country codes

        * HDI: human development index (HDI)

        * urban_pop: urban population

        * unemployment: unemployment, total (% of total labor force)

        * pop_growth: population growth (annual %)

        * literacy: adult literacy rate, population 15+ years, both
          sexes (%)

Source

     <https://data.worldbank.org/>

See Also

     See the wbstats package:
     https://cran.r-project.org/web/packages/wbstats


Variables detected from installed object

name: character ; missing=0 ; examples=Afghanistan, Angola, Albania

iso_a2: character ; missing=3 ; examples=AF, AO, AL

HDI: numeric ; missing=130 ; examples=0.504, 0.352, 0.434

urban_pop: numeric ; missing=9 ; examples=8609463, 11649562, 1629715

unemployment: numeric ; missing=63 ; examples=17.4899997711182, 7.26999998092651, 17.5

pop_growth: numeric ; missing=9 ; examples=3.18320145523634, 3.48541253470949, -0.207046999760594

literacy: numeric ; missing=143 ; examples=66.0301132202148, 99.7889862060547, 61.5697288513184

Examples
Run this code

     data(worldbank_df)
     # or
     worldbank_df <- read.csv(system.file("misc/worldbank_df.csv", package="spData"))

     summary(worldbank_df)

