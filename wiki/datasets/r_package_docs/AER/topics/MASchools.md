Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

MASchools: Massachusetts Test Score Data

Massachusetts Test Score Data

Description

     The dataset contains data on test performance, school
     characteristics and student demographic backgrounds for school
     districts in Massachusetts.

Usage

     data("MASchools")

Format

     A data frame containing 220 observations on 16 variables.

     district character. District code.

     municipality character. Municipality name.

     expreg Expenditures per pupil, regular.

     expspecial Expenditures per pupil, special needs.

     expbil Expenditures per pupil, bilingual.

     expocc Expenditures per pupil, occupational.

     exptot Expenditures per pupil, total.

     scratio Students per computer.

     special Special education students (per cent).

     lunch Percent qualifying for reduced-price lunch.

     stratio Student-teacher ratio.

     income Per capita income.

     score4 4th grade score (math + English + science).

     score8 8th grade score (math + English + science).

     salary Average teacher salary.

     english Percent of English learners.

Details

     The Massachusetts data are district-wide averages for public
     elementary school districts in 1998. The test score is taken from
     the Massachusetts Comprehensive Assessment System (MCAS) test,
     administered to all fourth graders in Massachusetts public schools
     in the spring of 1998. The test is sponsored by the Massachusetts
     Department of Education and is mandatory for all public schools.
     The data analyzed here are the overall total score, which is the
     sum of the scores on the English, Math, and Science portions of
     the test. Data on the student-teacher ratio, the percent of
     students receiving a subsidized lunch and on the percent of
     students still learning english are averages for each elementary
     school district for the 1997-1998 school year and were obtained
     from the Massachusetts department of education. Data on average
     district income are from the 1990 US Census.

Source

     Online complements to Stock and Watson (2007).

References

     Stock, J. H. and Watson, M. W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’, ‘CASchools’


Variables detected from installed object

district: character ; missing=0 ; examples=1, 2, 3

municipality: character ; missing=0 ; examples=Abington, Acton, Acushnet

expreg: integer ; missing=0 ; examples=4201, 4129, 3627

expspecial: numeric ; missing=0 ; examples=7375.68994140625, 8573.990234375, 8081.72021484375

expbil: integer ; missing=0 ; examples=0

expocc: integer ; missing=0 ; examples=0

exptot: integer ; missing=0 ; examples=4646, 4930, 4281

scratio: numeric ; missing=9 ; examples=16.6000003814697, 5.69999980926514, 7.5

special: numeric ; missing=0 ; examples=14.6000003814697, 17.3999996185303, 12.1000003814697

lunch: numeric ; missing=0 ; examples=11.8000001907349, 2.5, 14.1000003814697

stratio: numeric ; missing=0 ; examples=19, 22.6000003814697, 19.2999992370605

income: numeric ; missing=0 ; examples=16.379, 25.792, 14.04

score4: numeric ; missing=0 ; examples=714, 731, 704

score8: numeric ; missing=40 ; examples=691, 693

salary: numeric ; missing=25 ; examples=34.3600006103516, 38.0629997253418, 32.4910011291504

english: numeric ; missing=0 ; examples=0, 1.24610590934753

Examples
Run this code

     ## Massachusetts
     data("MASchools")

     ## compare with California
     data("CASchools")
     CASchools$stratio <- with(CASchools, students/teachers)
     CASchools$score4 <- with(CASchools, (math + read)/2)

     ## Stock and Watson, parts of Table 9.1, p. 330
     vars <- c("score4", "stratio", "english", "lunch", "income")
     cbind(
       CA_mean = sapply(CASchools[, vars], mean),
       CA_sd   = sapply(CASchools[, vars], sd),
       MA_mean = sapply(MASchools[, vars], mean),
       MA_sd   = sapply(MASchools[, vars], sd))

     ## Stock and Watson, Table 9.2, p. 332, col. (1)
     fm1 <- lm(score4 ~ stratio, data = MASchools)
     coeftest(fm1, vcov = vcovHC(fm1, type = "HC1"))

     ## More examples, notably the entire Table 9.2, can be found in:
     ## help("StockWatson2007")

