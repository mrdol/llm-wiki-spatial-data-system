Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

banque: Table of Factors

Table of Factors

Description

     ‘banque’ gives the results of a bank survey onto 810 customers.

Usage

     data(banque)

Format

     This data frame contains the following columns:

       1. csp: "Socio-professional categories" a factor with levels

            * ‘agric’ Farmers

            * ‘artis’ Craftsmen, Shopkeepers, Company directors

            * ‘cadsu’ Executives and higher intellectual professions

            * ‘inter’ Intermediate professions

            * ‘emplo’ Other white-collar workers

            * ‘ouvri’ Manual workers

            * ‘retra’ Pensionners

            * ‘inact’ Non working population

            * ‘etudi’ Students

       2. duree: "Time relations with the customer" a factor with
          levels

            * ‘dm2’ <2 years

            * ‘d24’ [2 years, 4 years[

            * ‘d48’ [4 years, 8 years[

            * ‘d812’ [8 years, 12 years[

            * ‘dp12’ >= 12 years

       3. oppo: "Stopped a check?" a factor with levels

            * ‘non’ no

            * ‘oui’ yes

       4. age: "Customer's age" a factor with levels

            * ‘ai25’ [18 years, 25 years[

            * ‘ai35’ [25 years, 35 years[

            * ‘ai45’ [35 years, 45 years[

            * ‘ai55’ [45 years, 55 years[

            * ‘ai75’ [55 years, 75 years[

       5. sexe: "Customer's gender" a factor with levels

            * ‘hom’ Male

            * ‘fem’ Female

       6. interdit: "No checkbook allowed" a factor with levels

            * ‘non’ no

            * ‘oui’ yes

       7. cableue: "Possess a bank card?" a factor with levels

            * ‘non’ no

            * ‘oui’ yes

       8. assurvi: "Contrat of life insurance?" a factor with levels

            * ‘non’ no

            * ‘oui’ yes

       9. soldevu: "Balance of the current accounts" a factor with
          levels

            * ‘p4’ credit balance > 20000

            * ‘p3’ credit balance 12000-20000

            * ‘p2’ credit balance 4000-12000

            * ‘p1’ credit balance >0-4000

            * ‘n1’ debit balance 0-4000

            * ‘n2’ debit balance >4000

      10. eparlog: "Savings and loan association account amount" a
          factor with levels

            * ‘for’ > 20000

            * ‘fai’ >0 and <20000

            * ‘nul’ nulle

      11. eparliv: "Savings bank amount" a factor with levels

            * ‘for’ > 20000

            * ‘fai’ >0 and <20000

            * ‘nul’ nulle

      12. credhab: "Home loan owner" a factor with levels

            * ‘non’ no

            * ‘oui’ yes

      13. credcon: "Consumer credit amount" a factor with levels

            * ‘nul’ none

            * ‘fai’ >0 and <20000

            * ‘for’ > 20000

      14. versesp: "Check deposits" a factor with levels

            * ‘oui’ yes

            * ‘non’ no

      15. retresp: "Cash withdrawals" a factor with levels

            * ‘fai’ < 2000

            * ‘moy’ 2000-5000

            * ‘for’ > 5000

      16. remiche: "Endorsed checks amount" a factor with levels

            * ‘for’ >10000

            * ‘moy’ 10000-5000

            * ‘fai’ 1-5000

            * ‘nul’ none

      17. preltre: "Treasury Department tax deductions" a factor with
          levels

            * ‘nul’ none

            * ‘fai’ <1000

            * ‘moy’ >1000

      18. prelfin: "Financial institution deductions" a factor with
          levels

            * ‘nul’ none

            * ‘fai’ <1000

            * ‘moy’ >1000

      19. viredeb: "Debit transfer amount" a factor with levels

            * ‘nul’ none

            * ‘fai’ <2500

            * ‘moy’ 2500-5000

            * ‘for’ >5000

      20. virecre: "Credit transfer amount" a factor with levels

            * ‘for’ >10000

            * ‘moy’ 10000-5000

            * ‘fai’ <5000

            * ‘nul’ aucun

      21. porttit: "Securities portfolio estimations" a factor with
          levels

            * ‘nul’ none

            * ‘fai’ < 20000

            * ‘moy’ 20000-100000

            * ‘for’ >100000

Source

     anonymous


Variables detected from installed object

csp: factor ; missing=0 ; examples=ouvri, cadsu

duree: factor ; missing=0 ; examples=d48, d24

oppo: factor ; missing=0 ; examples=non

age: factor ; missing=0 ; examples=ai75, ai35

sexe: factor ; missing=0 ; examples=hom

interdit: factor ; missing=0 ; examples=non

cableue: factor ; missing=0 ; examples=non

assurvi: factor ; missing=0 ; examples=non

soldevu: factor ; missing=0 ; examples=n1, p1

eparlog: factor ; missing=0 ; examples=nul

eparliv: factor ; missing=0 ; examples=nul

credhab: factor ; missing=0 ; examples=non

credcon: factor ; missing=0 ; examples=nul

versesp: factor ; missing=0 ; examples=non

retresp: factor ; missing=0 ; examples=fai

remiche: factor ; missing=0 ; examples=nul

preltre: factor ; missing=0 ; examples=nul

prelfin: factor ; missing=0 ; examples=nul

viredeb: factor ; missing=0 ; examples=nul

virecre: factor ; missing=0 ; examples=nul

porttit: factor ; missing=0 ; examples=nul

Examples
Run this code

     data(banque)
     banque.acm <- dudi.acm(banque, scannf = FALSE, nf = 3)
     apply(banque.acm$cr, 2, mean)
     banque.acm$eig[1:banque.acm$nf] # the same thing

     if(adegraphicsLoaded()) {
       g <- s.arrow(banque.acm$c1, plabels.cex = 0.75)
     } else {
       s.arrow(banque.acm$c1, clab = 0.75)
     }

