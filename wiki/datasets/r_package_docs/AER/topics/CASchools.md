Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

CASchools: California Test Score Data

California Test Score Data

Description

     The dataset contains data on test performance, school
     characteristics and student demographic backgrounds for school
     districts in California.

Usage

     data("CASchools")

Format

     A data frame containing 420 observations on 14 variables.

     district character. District code.

     school character. School name.

     county factor indicating county.

     grades factor indicating grade span of district.

     students Total enrollment.

     teachers Number of teachers.

     calworks Percent qualifying for CalWorks (income assistance).

     lunch Percent qualifying for reduced-price lunch.

     computer Number of computers.

     expenditure Expenditure per student.

     income District average income (in USD 1,000).

     english Percent of English learners.

     read Average reading score.

     math Average math score.

Details

     The data used here are from all 420 K-6 and K-8 districts in
     California with data available for 1998 and 1999.  Test scores are
     on the Stanford 9 standardized test administered to 5th grade
     students.  School characteristics (averaged across the district)
     include enrollment, number of teachers (measured as “full-time
     equivalents”, number of computers per classroom, and expenditures
     per student. Demographic variables for the students are averaged
     across the district.  The demographic variables include the
     percentage of students in the public assistance program CalWorks
     (formerly AFDC), the percentage of students that qualify for a
     reduced price lunch, and the percentage of students that are
     English learners (that is, students for whom English is a second
     language).

Source

     Online complements to Stock and Watson (2007).

References

     Stock, J. H. and Watson, M. W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’, ‘MASchools’


Variables detected from installed object

district: character ; missing=0 ; examples=75119, 61499, 61549

school: character ; missing=0 ; examples=Sunol Glen Unified, Manzanita Elementary, Thermalito Union Elementary

county: factor ; missing=0 ; examples=Alameda, Butte

grades: factor ; missing=0 ; examples=KK-08

students: numeric ; missing=0 ; examples=195, 240, 1550

teachers: numeric ; missing=0 ; examples=10.8999996185303, 11.1499996185303, 82.9000015258789

calworks: numeric ; missing=0 ; examples=0.510200023651123, 15.4167003631592, 55.032299041748

lunch: numeric ; missing=0 ; examples=2.04080009460449, 47.9166984558105, 76.3226013183594

computer: numeric ; missing=0 ; examples=67, 101, 169

expenditure: numeric ; missing=0 ; examples=6384.9111328125, 5099.380859375, 5501.95458984375

income: numeric ; missing=0 ; examples=22.6900005340576, 9.82400035858154, 8.97799968719482

english: numeric ; missing=0 ; examples=0, 4.58333349227905, 30.0000019073486

read: numeric ; missing=0 ; examples=691.599975585938, 660.5, 636.299987792969

math: numeric ; missing=0 ; examples=690, 661.900024414062, 650.900024414062

Examples
Run this code

     ## data and transformations
     data("CASchools")
     CASchools$stratio <- with(CASchools, students/teachers)
     CASchools$score <- with(CASchools, (math + read)/2)

     ## Stock and Watson (2007)
     ## p. 152
     fm1 <- lm(score ~ stratio, data = CASchools)
     coeftest(fm1, vcov = sandwich)

     ## p. 159
     fm2 <- lm(score ~ I(stratio < 20), data = CASchools)
     ## p. 199
     fm3 <- lm(score ~ stratio + english, data = CASchools)
     ## p. 224
     fm4 <- lm(score ~ stratio + expenditure + english, data = CASchools)

     ## Table 7.1, p. 242 (numbers refer to columns)
     fmc3 <- lm(score ~ stratio + english + lunch, data = CASchools)
     fmc4 <- lm(score ~ stratio + english + calworks, data = CASchools)
     fmc5 <- lm(score ~ stratio + english + lunch + calworks, data = CASchools)

     ## More examples can be found in:
     ## help("StockWatson2007")

