Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

salamander: Salamander mating data

Salamander mating data

Description

     Data from a salamander mating experiment discussed by McCullagh
     and Nelder (1989, Ch. 14). Twenty males and twenty females from
     two populations (Rough Butt and Whiteside) were each paired with 6
     individuals from their own or from the other population. The
     experiments were later published by Arnold et al. (1996).

Usage

     data("salamander")

Format

     The data frame includes 360 observations on the following
     variables:

     Female Index of the female;

     Male Index of the male;

     Mate Whether the pair successfully mated or not;

     TypeF Population of origin of female;

     TypeM Population of origin of male;

     Cross Interaction term between ‘TypeF’ and ‘TypeM’;

     Season A factor with levels ‘Summer’ and ‘Fall’;

     Experiment Index of experiment

Source

     The data frame was borrowed from the ‘HGLMMM’ package (Molas and
     Lesaffre, 2011), version 0.1.2.

References

     Arnold, S.J., Verrell, P.A., and Tilley S.G. (1996) The evolution
     of asymmetry in sexual isolation: a model and a test case.
     Evolution 50, 1024-1033.

     McCullagh, P. and Nelder, J.A. (1989). Generalized Linear Models,
     2nd edition. London: Chapman & Hall.

     Molas, M., Lesaffre, E. (2011) Hierarchical Generalized Linear
     Models: The R Package HGLMMM. Journal of Statistical Software 39,
     1-20.


Variables detected from installed object

Cross: factor ; missing=0 ; examples=RR, RW

Experiment: integer ; missing=0 ; examples=1

Female: integer ; missing=0 ; examples=1

Male: integer ; missing=0 ; examples=1, 14, 5

Mate: integer ; missing=0 ; examples=1

Season: factor ; missing=0 ; examples=Summer

TypeF: factor ; missing=0 ; examples=R

TypeM: factor ; missing=0 ; examples=R, W

Examples
Run this code

     data("salamander")

     ## Not run:

     HLfit(cbind(Mate,1-Mate)~TypeF+TypeM+TypeF*TypeM+(1|Female)+(1|Male),
           family=binomial(),data=salamander,method="ML")
     # equivalent fo using fitme(), but here a bit faster
     ## End(Not run)

