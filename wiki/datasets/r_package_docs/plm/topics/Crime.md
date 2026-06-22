Rdocumentation
powered by

Search all packages and functions
plm (version 2.6.7)

Crime in North Carolina

Description

     a panel of 90 observational units (counties) from 1981 to 1987

Format

     A data frame containing :

     county county identifier

     year year from 1981 to 1987

     crmrte crimes committed per person

     prbarr 'probability' of arrest

     prbconv 'probability' of conviction

     prbpris 'probability' of prison sentence

     avgsen average sentence, days

     polpc police per capita

     density people per square mile

     taxpc tax revenue per capita

     region factor. One of 'other', 'west' or 'central'.

     smsa factor. (Also called "urban".) Does the individual reside in
          a SMSA (standard metropolitan statistical area)?

     pctmin percentage minority in 1980

     wcon weekly wage in construction

     wtuc weekly wage in transportation, utilities, communications

     wtrd weekly wage in wholesale and retail trade

     wfir weekly wage in finance, insurance and real estate

     wser weekly wage in service industry

     wmfg weekly wage in manufacturing

     wfed weekly wage in federal government

     wsta weekly wage in state government

     wloc weekly wage in local government

     mix offence mix: face-to-face/other

     pctymle percentage of young males (between ages 15 to 24)

     lcrmrte log of crimes committed per person

     lprbarr log of 'probability' of arrest

     lprbconv log of 'probability' of conviction

     lprbpris log of 'probability' of prison sentence

     lavgsen log of average sentence, days

     lpolpc log of police per capita

     ldensity log of people per square mile

     ltaxpc log of tax revenue per capita

     lpctmin log of percentage minority in 1980

     lwcon log of weekly wage in construction

     lwtuc log of weekly wage in transportation, utilities,
          communications

     lwtrd log of weekly wage in wholesale and retail trade

     lwfir log of weekly wage in finance, insurance and real estate

     lwser log of weekly wage in service industry

     lwmfg log of weekly wage in manufacturing

     lwfed log of weekly wage in federal government

     lwsta log of weekly wage in state government

     lwloc log of weekly wage in local government

     lmix log of offence mix: face-to-face/other

     lpctymle log of percentage of young males (between ages 15 to 24)

Details

     _total number of observations_ : 630

     _observation_ : regional

     _country_ : United States

     The variables l* (lcrmrte, lprbarr, ...) contain the pre-computed
     logarithms of the base variables as found in the original data
     set. Note that these values slightly differ from what R's log()
     function yields for the base variables.  In order to reproduce
     examples from the literature, the pre-computed logs need to be
     used, otherwise the results differ slightly.

Source

     Journal of Applied Econometrics Data Archive (complements Baltagi
     (2006)):

     <http://qed.econ.queensu.ca/jae/2006-v21.4/baltagi/>

     Online complements to Baltagi (2001):

     <https://www.wiley.com/legacy/wileychi/baltagi/>

     Online complements to Baltagi (2013):

     <https://bcs.wiley.com/he-bcs/Books?action=resource&bcsId=4338&itemId=1118672321&resourceId=13452>

     See also Journal of Applied Econometrics data archive entry for
     Baltagi (2006) at
     <http://qed.econ.queensu.ca/jae/2006-v21.4/baltagi/>.

References

     Cornwell C, Trumbull WN (1994). “Estimating the economic model of
     crime with panel data.” _Review of Economics and Statistics_,
     *76*, 360-366.

     Baltagi BH (2006). “Estmating an economic model of crime using
     panel data from North Carolina.” _Journal of Applied
     Econometrics_, *21*(4).

     Baltagi BH (2001). _Econometric Analysis of Panel Data_, 3rd
     edition. John Wiley and Sons ltd.

     Baltagi BH (2013). _Econometric Analysis of Panel Data_, 5th
     edition. John Wiley and Sons ltd.


Variables detected from installed object

county: integer ; missing=0 ; examples=1

year: integer ; missing=0 ; examples=81, 82, 83

crmrte: numeric ; missing=0 ; examples=0.0398849, 0.0383449, 0.0303048

prbarr: numeric ; missing=0 ; examples=0.289696, 0.338111, 0.330449

prbconv: numeric ; missing=0 ; examples=0.402062, 0.433005, 0.525703

prbpris: numeric ; missing=0 ; examples=0.472222, 0.506993, 0.479705

avgsen: numeric ; missing=0 ; examples=5.61, 5.59, 5.8

polpc: numeric ; missing=0 ; examples=0.0017868, 0.0017666, 0.0018358

density: numeric ; missing=0 ; examples=2.307159, 2.330254, 2.341801

taxpc: numeric ; missing=0 ; examples=25.69763, 24.87425, 26.45144

region: factor ; missing=0 ; examples=central

smsa: factor ; missing=0 ; examples=no

pctmin: numeric ; missing=0 ; examples=20.2187

wcon: numeric ; missing=0 ; examples=206.4803, 212.7542, 219.7802

wtuc: numeric ; missing=0 ; examples=333.6209, 369.2964, 1394.803

wtrd: numeric ; missing=0 ; examples=182.333, 189.5414, 196.6395

wfir: numeric ; missing=0 ; examples=272.4492, 300.8788, 309.9696

wser: numeric ; missing=0 ; examples=215.7335, 231.5767, 240.1568

wmfg: numeric ; missing=0 ; examples=229.12, 240.33, 269.7

wfed: numeric ; missing=0 ; examples=409.37, 419.7, 438.85

wsta: numeric ; missing=0 ; examples=236.24, 253.88, 250.36

wloc: numeric ; missing=0 ; examples=231.47, 236.79, 248.58

mix: numeric ; missing=0 ; examples=0.0999179, 0.1030491, 0.0806787

pctymle: numeric ; missing=0 ; examples=0.0876968, 0.0863767, 0.0850909

lcrmrte: numeric ; missing=0 ; examples=-3.22175693511963, -3.26113390922546, -3.49644899368286

lprbarr: numeric ; missing=0 ; examples=-1.23892295360565, -1.08438098430634, -1.10730302333832

lprbconv: numeric ; missing=0 ; examples=-0.911149024963379, -0.837005972862244, -0.643018782138824

lprbpris: numeric ; missing=0 ; examples=-0.750306129455566, -0.679258108139038, -0.734583914279938

lavgsen: numeric ; missing=0 ; examples=1.72455096244812, 1.72097897529602, 1.75785803794861

lpolpc: numeric ; missing=0 ; examples=-6.3273401260376, -6.33870410919189, -6.30029106140137

ldensity: numeric ; missing=0 ; examples=0.836017072200775, 0.845977306365967, 0.850920379161835

lwcon: numeric ; missing=0 ; examples=5.33020496368408, 5.36013698577881, 5.39262819290161

lwtuc: numeric ; missing=0 ; examples=5.81000518798828, 5.91160011291504, 7.24050903320313

lwtrd: numeric ; missing=0 ; examples=5.20583486557007, 5.24460697174072, 5.2813720703125

lwfir: numeric ; missing=0 ; examples=5.60745191574097, 5.70670700073242, 5.73647499084473

lwser: numeric ; missing=0 ; examples=5.3740439414978, 5.44491100311279, 5.48129177093506

lwmfg: numeric ; missing=0 ; examples=5.43424606323242, 5.48201322555542, 5.59731006622314

lwfed: numeric ; missing=0 ; examples=6.01461887359619, 6.03953981399536, 6.08415699005127

lwsta: numeric ; missing=0 ; examples=5.46484804153442, 5.53686189651489, 5.52290010452271

lwloc: numeric ; missing=0 ; examples=5.44444990158081, 5.46717405319214, 5.51576519012451

lpctymle: numeric ; missing=0 ; examples=-2.43387007713318, -2.44903802871704, -2.464035987854

lpctmin: numeric ; missing=0 ; examples=3.00660800933838

ltaxpc: numeric ; missing=0 ; examples=3.24639892578125, 3.21383309364319, 3.27531099319458

lmix: numeric ; missing=0 ; examples=-2.30340695381165, -2.27254891395569, -2.51728105545044

