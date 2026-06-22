Rdocumentation
powered by

Search all packages and functions
splm (version 1.6.5)

RiceFarms: Production of Rice in India

Production of Rice in India

Description

     yearly observations of 171 farms

     _number of observations_ : 1026

     _country_ : Indonesia

     _economic topic_ : producer behavior

     _econometrics topic_ : error component

Usage

     data(RiceFarms)

Format

     A dataframe containing :

     id the farm identifier

     time the growing season

     size the total area cultivated with rice, measured in hectares

     status land status, on of ‘'owner'’ (non sharecroppers, owner
          operators or leasholders or both), ‘'share'’ (sharecroppers),
          ‘'mixed'’ (mixed of the two previous status)

     varieties one of ‘'trad'’ (traditional varieties), ‘'high'’ (high
          yielding varieties) and ‘'mixed'’ (mixed varieties)

     bimas bIMAS is an intensification program ; one of ‘'no'’
          (non-bimas famer), ‘'yes'’ (bimas farmer) or ‘'mixed'’ (part
          but not all of farmer's land was registered to be in the
          bimas program)

     seed seed in kilogram

     urea urea in kilogram

     phosphate phosphate in kilogram

     pesticide pesticide cost in Rupiah

     pseed price of seed in Rupiah per kg

     purea price of urea in Rupiah per kg

     pphosph price of phosphate in Rupiah per kg

     hiredlabor hired labor in hours

     famlabor family labor in hours

     totlabor total labor (excluding harvest labor)

     wage labor wage in Rupiah per hour

     goutput gross output of rice in kg

     noutput net output, gross output minus harvesting cost (paid in
          terms of rice)

     price price of rough rice in Rupiah per Kg

     region one of ‘'wargabinangun'’, ‘'langan'’, ‘'gunungwangi'’,
          ‘'malausma'’, ‘'sukaambit'’, ‘'ciwangi'’

Source

     Journal of Applied Econometrics Data Archive.

References

     Qu Feng and William C. Horrace, (2012) “Alternative Measures of
     Technical Efficiency: Skew, Bias and Scale”, _Journal of Applied
     Econometrics_, *forthcoming*.

     Horrace, W.C.  and P.  Schmidt (1996) “Confidence statements for
     efficiency estimates from stochastic frontier models”, _Journal of
     Productivity Analysis_, * 7*, 257-282.


Variables detected from installed object

id: integer ; missing=0 ; examples=101001

time: numeric ; missing=0 ; examples=1, 2, 3

size: numeric ; missing=0 ; examples=3, 2, 1

status: factor ; missing=0 ; examples=owner

varieties: factor ; missing=0 ; examples=mixed, trad, high

bimas: factor ; missing=0 ; examples=mixed

seed: integer ; missing=0 ; examples=90, 40, 100

urea: integer ; missing=0 ; examples=900, 600, 700

phosphate: integer ; missing=0 ; examples=80, 0, 150

pesticide: integer ; missing=0 ; examples=6000, 3000, 5000

pseed: numeric ; missing=0 ; examples=80, 70, 140

purea: numeric ; missing=0 ; examples=75, 70

pphosph: numeric ; missing=0 ; examples=75, 70

hiredlabor: integer ; missing=0 ; examples=2875, 2110, 980

famlabor: integer ; missing=0 ; examples=40, 45, 95

totlabor: integer ; missing=0 ; examples=2915, 2155, 1075

wage: numeric ; missing=0 ; examples=68.49, 60.09, 51.99

goutput: integer ; missing=0 ; examples=7980, 4083, 2650

noutput: integer ; missing=0 ; examples=6800, 3500, 2242

price: numeric ; missing=0 ; examples=60, 65

region: factor ; missing=0 ; examples=wargabinangun

