Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

ha: Hepatitis A in Berlin

Hepatitis A in Berlin

Description

     Number of Hepatitis A cases among adult (age>18) males in Berlin,
     2001-2006. An increase is seen during 2006.

Usage

     data("ha")
     data("ha.sts")

Format

     ‘ha’ is a ‘disProg’ object containing 290 x 12 observations
     starting from week 1 in 2001 to week 30 in 2006.  ‘ha.sts’ was
     generated from ‘ha’ via the converter function ‘disProg2sts’ and
     includes a map of Berlin's districts.

Source

     Robert Koch-Institut: SurvStat: <https://survstat.rki.de/>;
     Queried on 25 August 2006.

     Robert Koch Institut, Epidemiologisches Bulletin 33/2006, p.290.

Examples
Run this code

     ## deprecated "disProg" object
     data("ha")
     ha
     plot(aggregate(ha))

     ## new-style "sts" object
     data("ha.sts")
     ha.sts
     plot(ha.sts, ~time)  # = plot(aggregate(ha.sts, by = "unit"))
     plot(ha.sts, ~unit, labels = TRUE)

