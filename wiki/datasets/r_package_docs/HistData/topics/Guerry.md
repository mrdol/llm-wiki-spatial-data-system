Rdocumentation
powered by

Search all packages and functions
HistData (version 1.0.0)

Data from A.-M. Guerry, "Essay on the Moral Statistics of France"

Description

     Andre-Michel Guerry (1833) was the first to systematically collect
     and analyze social data on such things as crime, literacy and
     suicide with the view to determining social laws and the relations
     among these variables.

     The ‘Guerry’ data frame comprises a collection of 'moral
     variables' on the 86 departments of France around 1830.  A few
     additional variables have been added from other sources.

Format

     A data frame with 86 observations (the departments of France) on
     the following 23 variables.

     ‘dept’ Department ID: Standard numbers for the departments, except
          for Corsica (200)

     ‘Region’ Region of France ('N'='North', 'S'='South', 'E'='East',
          'W'='West', 'C'='Central'). Corsica is coded as NA

     ‘Department’ Department name: Departments are named according to
          usage in 1830, but without accents.  A factor with levels
          ‘Ain’, ‘Aisne’, ‘Allier’, ..., ‘Vosges’, ‘Yonne’

     ‘Crime_pers’ Population per Crime against persons. Source: A2
          (Compte general, 1825-1830)

     ‘Crime_prop’ Population per Crime against property. Source: A2
          (Compte general, 1825-1830)

     ‘Literacy’ Percent Read & Write: Percent of military conscripts
          who can read and write. Source: A2

     ‘Donations’ Donations to the poor. Source: A2 (Bulletin des lois)

     ‘Infants’ Population per illegitimate birth. Source: A2 (Bureau
          des Longitudes, 1817-1821)

     ‘Suicides’ Population per suicide. Source: A2 (Compte general,
          1827-1830)

     ‘MainCity’ Size of principal city ('1:Sm', '2:Med', '3:Lg'), used
          as a surrogate for population density. Large refers to the
          top 10, small to the bottom 10; all the rest are classed
          Medium. Source: A1. An ordered factor with levels ‘1:Sm’ <
          ‘2:Med’ < ‘3:Lg’

     ‘Wealth’ Per capita tax on personal property. A ranked index based
          on taxes on personal and movable property per inhabitant.
          Source: A1

     ‘Commerce’ Commerce and Industry, measured by the rank of the
          number of patents / population. Source: A1

     ‘Clergy’ Distribution of clergy, measured by the rank of the
          number of Catholic priests in active service / population.
          Source: A1 (Almanach officiel du clergy, 1829)

     ‘Crime_parents’ Crimes against parents, measured by the rank of
          the ratio of crimes against parents to all crimes- Average
          for the years 1825-1830. Source: A1 (Compte general)

     ‘Infanticide’ Infanticides per capita. A ranked ratio of number of
          infanticides to population- Average for the years 1825-1830.
          Source: A1 (Compte general)

     ‘Donation_clergy’ Donations to the clergy. A ranked ratio of the
          number of bequests and donations inter vivios to population-
          Average for the years 1815-1824. Source: A1 (Bull. des lois,
          ordunn. d'autorisation)

     ‘Lottery’ Per capita wager on Royal Lottery. Ranked ratio of the
          proceeds bet on the royal lottery to population- Average for
          the years 1822-1826. Source: A1 (Compte rendus par le
          ministere des finances)

     ‘Desertion’ Military desertion, ratio of the number of young
          soldiers accused of desertion to the force of the military
          contingent, minus the deficit produced by the insufficiency
          of available billets- Average of the years 1825-1827. Source:
          A1 (Compte du ministere du guerre, 1829 etat V)

     ‘Instruction’ Instruction. Ranks recorded from Guerry's map of
          Instruction. Note: this is inversely related to ‘Literacy’
          (as defined here)

     ‘Prostitutes’ Prostitutes in Paris. Number of prostitutes
          registered in Paris from 1816 to 1834, classified by the
          department of their birth Source: Parent-Duchatelet (1836),
          _De la prostitution en Paris_

     ‘Distance’ Distance to Paris (km). Distance of each department
          centroid to the centroid of the Seine (Paris) Source:
          calculated from department centroids

     ‘Area’ Area (1000 km^2). Source: Angeville (1836)

     ‘Pop1831’ 1831 population. Population in 1831, taken from
          Angeville (1836), _Essai sur la Statistique de la Population
          fran?ais_, in 1000s

Details

     Note that most of the variables (e.g., ‘Crime_pers’) are scaled so
     that 'more is better' morally. This is done by expressing "bad"
     numbers as _population per_ crime or by using ranks. Thus, in his
     choropleth maps, he was able to assign darker shading consistently
     to the departments that were worse.

     Values for the quantitative variables displayed on Guerry's maps
     were taken from Table A2 in the English translation of Guerry
     (1833) by Whitt and Reinking.  Values for the ranked variables
     were taken from Table A1, with some corrections applied.  The
     maximum is indicated by rank 1, and the minimum by rank 86.

Source

     Angeville, A. (1836). _Essai sur la Statistique de la Population
     fran?aise_ Paris: F. Doufour.

     Guerry, A.-M. (1833). _Essai sur la statistique morale de la
     France_ Paris: Crochard. English translation: Hugh P. Whitt and
     Victor W. Reinking, Lewiston, N.Y. : Edwin Mellen Press, 2002.

     Parent-Duchatelet, A. (1836). _De la prostitution dans la ville de
     Paris_, 3rd ed, 1857, p. 32, 36

     See the example by John Russell for the 30DayChartChallenge

References

     Dray, S. and Jombart, T. (2011). A Revisit Of Guerry's Data:
     Introducing Spatial Constraints In Multivariate Analysis.  _The
     Annals of Applied Statistics_, Vol. 5, No. 4, 2278-2299.
     <https://arxiv.org/pdf/1202.6485>, DOI: 10.1214/10-AOAS356.

     Brunsdon, C. and Dykes, J. (2007).  Geographically weighted
     visualization: interactive graphics for scale-varying exploratory
     analysis.  Geographical Information Science Research Conference
     (GISRUK 07), NUI Maynooth, Ireland, April, 2007.

     Friendly, M. (2007). A.-M. Guerry's Moral Statistics of France:
     Challenges for Multivariable Spatial Analysis.  _Statistical
     Science_, 22, 368-399.

     Friendly, M. (2007). Data from A.-M. Guerry, Essay on the Moral
     Statistics of France (1833),
     <http://datavis.ca/gallery/guerry/guerrydat.html>.

See Also

     The ‘Guerry’ package for maps of France: ‘gfrance’, related data,
     creating maps of his data and multivariate spatial analysis.


Variables detected from installed object

dept: integer ; missing=0 ; examples=1, 2, 3

Region: factor ; missing=1 ; examples=E, N, C

Department: factor ; missing=0 ; examples=Ain, Aisne, Allier

Crime_pers: integer ; missing=0 ; examples=28870, 26226, 26747

Crime_prop: integer ; missing=0 ; examples=15890, 5521, 7925

Literacy: integer ; missing=0 ; examples=37, 51, 13

Donations: integer ; missing=0 ; examples=5098, 8901, 10973

Infants: integer ; missing=0 ; examples=33120, 14572, 17044

Suicides: integer ; missing=0 ; examples=35039, 12831, 114121

MainCity: ordered/factor ; missing=0 ; examples=2:Med

Wealth: integer ; missing=0 ; examples=73, 22, 61

Commerce: integer ; missing=0 ; examples=58, 10, 66

Clergy: integer ; missing=0 ; examples=11, 82, 68

Crime_parents: integer ; missing=0 ; examples=71, 4, 46

Infanticide: integer ; missing=0 ; examples=60, 82, 42

Donation_clergy: integer ; missing=0 ; examples=69, 36, 76

Lottery: integer ; missing=0 ; examples=41, 38, 66

Desertion: integer ; missing=0 ; examples=55, 82, 16

Instruction: integer ; missing=0 ; examples=46, 24, 85

Prostitutes: integer ; missing=0 ; examples=13, 327, 34

Distance: numeric ; missing=0 ; examples=218.372, 65.945, 161.927

Area: integer ; missing=0 ; examples=5762, 7369, 7340

Pop1831: numeric ; missing=0 ; examples=346.03, 513, 298.26

Examples
Run this code

     data(Guerry)
     ## maybe str(Guerry) ; plot(Guerry) ...

