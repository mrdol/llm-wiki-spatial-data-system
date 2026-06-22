Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

morphosport: Athletes' Morphology

Athletes' Morphology

Description

     This data set gives a morphological description of 153 athletes
     split in five different sports.

Usage

     data(morphosport)

Format

     ‘morphosport’ is a list of 2 objects.

     tab is a data frame with 153 athletes and 5 variables.

     sport is a factor with 6 items

Details

     Variables of ‘morphosport$tab’ are the following ones: dbi
     (biacromial diameter (cm)), tde (height (cm)), tas (distance from
     the buttocks to the top of the head (cm)), lms (length of the
     upper limbs (cm)), poids (weigth (kg)).
     The levels of ‘morphosport$sport’ are: athl (athletics), foot
     (football), hand (handball), judo, nata (swimming), voll
     (volleyball).

Source

     Mimouni , N. (1996) _Contribution de méthodes biométriques à
     l'analyse de la morphotypologie des sportifs_.  Thèse de doctorat.
     Université Lyon 1.

Examples
Run this code

     data(morphosport)
     plot(discrimin(dudi.pca(morphosport$tab, scan = FALSE),
         morphosport$sport, scan = FALSE))

