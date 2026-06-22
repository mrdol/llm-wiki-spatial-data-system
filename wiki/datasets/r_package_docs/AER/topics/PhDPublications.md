Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

PhDPublications: Doctoral Publications

Doctoral Publications

Description

     Cross-section data on the scientific productivity of PhD students
     in biochemistry.

Usage

     data("PhDPublications")

Format

     A data frame containing 915 observations on 6 variables.

     articles Number of articles published during last 3 years of PhD.

     gender factor indicating gender.

     married factor. Is the PhD student married?

     kids Number of children less than 6 years old.

     prestige Prestige of the graduate program.

     mentor Number of articles published by student's mentor.

Source

     Online complements to Long (1997).

References

     Long, J.S. (1990). _Regression Models for Categorical and Limited
     Dependent Variables_. Thousand Oaks: Sage Publications.

     Long, J.S. (1997). The Origin of Sex Differences in Science.
     _Social Forces_, *68*, 1297-1315.


Variables detected from installed object

articles: integer ; missing=0 ; examples=0

gender: factor ; missing=0 ; examples=male, female

married: factor ; missing=0 ; examples=yes, no

kids: integer ; missing=0 ; examples=0

prestige: numeric ; missing=0 ; examples=2.51999998092651, 2.04999995231628, 3.75

mentor: integer ; missing=0 ; examples=7, 6

Examples
Run this code

     ## from Long (1997)
     data("PhDPublications")

     ## Table 8.1, p. 227
     summary(PhDPublications)

     ## Figure 8.2, p. 220
     plot(0:10, dpois(0:10, mean(PhDPublications$articles)), type = "b", col = 2,
       xlab = "Number of articles", ylab = "Probability")
     lines(0:10, prop.table(table(PhDPublications$articles))[1:11], type = "b")
     legend("topright", c("observed", "predicted"), col = 1:2, lty = rep(1, 2), bty = "n")

     ## Table 8.2, p. 228
     fm_lrm <- lm(log(articles + 0.5) ~ ., data = PhDPublications)
     summary(fm_lrm)
     -2 * logLik(fm_lrm)
     fm_prm <- glm(articles ~ ., data = PhDPublications, family = poisson)
     library("MASS")
     fm_nbrm <- glm.nb(articles ~ ., data = PhDPublications)

     ## Table 8.3, p. 246
     library("pscl")
     fm_zip <- zeroinfl(articles ~ . | ., data = PhDPublications)
     fm_zinb <- zeroinfl(articles ~ . | ., data = PhDPublications, dist = "negbin")

