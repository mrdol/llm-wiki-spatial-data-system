Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

leuk: Survival Times and White Blood Counts for Leukaemia Patients

Survival Times and White Blood Counts for Leukaemia Patients

Description

     A data frame of data from 33 leukaemia patients.

Usage

     leuk

Format

     A data frame with columns:

     ‘wbc’ white blood count.

     ‘ag’ a test result, ‘"present"’ or ‘"absent"’.

     ‘time’ survival time in weeks.

Details

     Survival times are given for 33 patients who died from acute
     myelogenous leukaemia.  Also measured was the patient's white
     blood cell count at the time of diagnosis.  The patients were also
     factored into 2 groups according to the presence or absence of a
     morphologic characteristic of white blood cells. Patients termed
     AG positive were identified by the presence of Auer rods and/or
     significant granulation of the leukaemic cells in the bone marrow
     at the time of diagnosis.

Source

     Cox, D. R. and Oakes, D. (1984) _Analysis of Survival Data_.
     Chapman & Hall, p. 9.

     Taken from

     Feigl, P. & Zelen, M. (1965) Estimation of exponential survival
     probabilities with concomitant information. _Biometrics_ *21*,
     826-838.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

wbc: integer ; missing=0 ; examples=2300, 750, 4300

ag: factor ; missing=0 ; examples=present

time: integer ; missing=0 ; examples=65, 156, 100

Examples
Run this code

     library(survival)
     plot(survfit(Surv(time) ~ ag, data = leuk), lty = 2:3, col = 2:3)

     # now Cox models
     leuk.cox <- coxph(Surv(time) ~ ag + log(wbc), leuk)
     summary(leuk.cox)

