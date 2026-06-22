Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

syndicats: Two Questions asked on a Sample of 1000 Respondents

Two Questions asked on a Sample of 1000 Respondents

Description

     This data set is extracted from an opinion poll (period 1970-1980)
     on 1000 respondents.

Usage

     data(syndicats)

Format

     The ‘syndicats’ data frame has 5 rows and 4 columns.
     "Which politic family are you agreeing about?" has 5 response
     items : ‘extgauche’ (extreme left) ‘left’ ‘center’ ‘right’ and
     ‘extdroite’ (extreme right)
     "What do you think of the trade importance?" has 4 response items
     : ‘trop’ (too important) ‘adequate’ ‘insufficient’ ‘nesaispas’ (no
     opinion)

Source

     unknown


Variables detected from installed object

trop: integer ; missing=0 ; examples=10, 80, 55

convenable: integer ; missing=0 ; examples=31, 90, 58

insuffisant: integer ; missing=0 ; examples=85, 118, 31

nesaispas: integer ; missing=0 ; examples=4, 52, 36

Examples
Run this code

     data(syndicats)
     par(mfrow = c(1,2))
     dudi1 <- dudi.coa(syndicats, scan = FALSE)
     score (dudi1, 1, TRUE)
     score (dudi1, 1, FALSE)

