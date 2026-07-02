---
title: Couverture papiers (KG) des jeux spatiaux/ST et manques a sourcer
type: analysis
created: 2026-06-25
sources:
  - data/Final_datasets/sf/catalogue_sf_index.RData
  - .kg/graph.sqlite (tools/kg/07_export_agent_index.py papers-for-dataset)
tags: [datasets, papers, kg, grobid, sourcing]
---

# Papiers de modelisation par jeu de donnees (KG d'abord)

Sur **116 jeux uniques** (R + Python) de l'index `sf` : **51 ont au moins un papier/reference dans le KG**, **65 n'en ont pas** et sont a sourcer.

Detail complet (DOI / reference) : `papiers_modelisation_120_couverture.csv`.

## Jeux AVEC papier/reference dans le KG

| Lang | Package | Dataset | Preuve | DOI / titre |
|---|---|---|---|---|
| Python | geodatasets | boston | catalog | Hedonic prices and the demand for clean air. _J. Environ. Economics and Management_ *5*, 81-102. Belsley D.A., Kuh, E. and Welsch, R.E. (198 |
| Python | geodatasets | cincinnati | doi | 10.1016/j.compenvurbsys.2022.101845 |
| Python | geodatasets | cities | catalog | Visions and Re-visions of Charles Joseph Minard, _Journal of Educational and Behavioral Statistics_, *27*, No. 1, 31-51. Friendly, M. (2003) |
| Python | geodatasets | columbus | doi | 10.1007/s13253-023-00571-0 |
| Python | geodatasets | eire | catalog | , - Bailey and Gatrell 1995, ch. 1 for blood group data, Cliff and Ord (1973), p. 107 for remaining variables (also after O'Sullivan, 1968). |
| Python | geodatasets | guerry | doi | 10.1214/10-aoas356 |
| Python | geodatasets | health | doi | 10.1214/aos/1176347963.pdf |
| Python | geodatasets | home_sales | doi | 10.1080/13658816.2024.2342319 |
| Python | geodatasets | lasrosas | doi | 10.1111/j.0002-9092.2004.00610.x |
| Python | geodatasets | nyc | doi | 10.1016/j.compenvurbsys.2022.101845 |
| Python | geodatasets | nyc_neighborhoods | doi | 10.1016/j.compenvurbsys.2022.101845 |
| Python | geodatasets | nydata | catalog | _Applied Spatial Statistics for Public Health Data_ |
| Python | geodatasets | wheat | doi | 10.3733/hilg.v27n05p183 |
| Python | libpysal | Baltimore | doi | 10.1016/0166-0462(92)90038-j |
| Python | libpysal | NYC Socio-Demographics | doi | 10.1016/j.compenvurbsys.2022.101845 |
| Python | libpysal | Snow | catalog | _Cartographies of Disease: Maps, Mapping, and Medicine_. ESRI Press. ISBN: 9781589481206. Koch, T. (2004). The Map as Intent: Variations on  |
| Python | libpysal | baltim | doi | 10.1016/0166-0462(92)90038-j |
| Python | libpysal | georgia | catalog | , Geographically Weighted Regression: The Analysis of Spatially Varying Relationships, Chichester: Wiley. |
| R | GWmodel | DubVoter | catalog | Turnout or turned off? Electoral participation in Dublin in the early 21st Century |
| R | GWmodel | EWHP | doi | 10.1080/13658816.2013.865739 |
| R | GWmodel | LondonHP | doi | 10.1080/13658816.2013.865739 |
| R | HistData | Snow.polygons | catalog | _Cartographies of Disease: Maps, Mapping, and Medicine_. ESRI Press. ISBN: 9781589481206. Koch, T. (2004). The Map as Intent: Variations on  |
| R | SpatialEpi | pennLC_sf | tei | Spatial Data Analysis with R |
| R | ade4 | chevaine | catalog | Spatial aspects of genetic differentiation of the European chub in the Rhone River basin. _Journal of Fish Biology_, *49*, 714-726. See a da |
| R | ade4 | irishdata | catalog | The contiguity ratio and statistical mapping. _The incorporated Statistician_, *5*, 3, 115-145. Cliff, A.D. and Ord, J.K. (1973) _Spatial au |
| R | ade4 | julliot | doi | 10.1111/mec.15833 |
| R | ade4 | mafragh | doi | 10.1111/j.1365-2745.2010.01743.x |
| R | ade4 | pcw | catalog | Community ecology in the age of multivariate multiscale spatial analysis. _Ecological Monographs_, *82*, 257-275. | Condit, R., N. Pitman, E |
| R | ade4 | vegtf | catalog | Spatial ordination of vegetation data using a generalization of Wartenberg's multivariate spatial correlation. _Journal of vegetation scienc |
| R | agridat | gartner.corn | doi | 10.1016/j.fcr.2020.107783 |
| R | agridat | lasrosas.corn | doi | 10.1111/j.0002-9092.2004.00610.x |
| R | agridat | ortiz.tomato.covs | doi | 10.1007/s10681-006-9248-7 |
| R | agridat | usgs.herbicides | catalog | ". U.S. Geological Survey Open File Report 03-217. Herbicide data from table 5, page 30-37. Site coordinates page 7-8. https://ks.water.usgs |
| R | agridat | wallace.iowaland | doi | 10.2307/3138610 |
| R | gstat | jura | catalog | Geostatistics for Natural Resources Evaluation. Oxford Univ. Press, New-York, 483 p. Appendix C describes (and gives) the Jura data set. Att |
| R | gstat | meuse.all | catalog | Principles of Geographical Information Systems. Oxford University Press. |
| R | gstat | oxford | catalog | Principles of Geographical Information Systems. Oxford University Press. | Data: 126 soil augerings on a 100 x 100m square grid, with 6 colu |
| R | sp | meuse | doi | 10.1007/s13253-023-00571-0 |
| R | sp | meuse.grid | doi | 10.1007/s13253-023-00571-0 |
| R | spData | depmunic | doi | 10.1007/s13253-023-00571-0 |
| R | spData | house | doi | 10.1080/13658816.2013.865739 |
| R | spData | nz | catalog | Fundamental investigation on the preparation of gradient structures by sedimentation of different powder fractions under gravity. _Proc. of  |
| R | spData | world | doi | 10.1007/s13253-023-00571-0 |
| R | spDataLarge | lsl | doi | 10.1016/j.geomorph.2011.10.029 |
| R | spaMM | Leuca | doi | 10.1214/aos/1176347963.pdf |
| R | spaMM | Loaloa | catalog | Model-based geostatistics, Springer series in statistics, Springer, New York. Diggle, P. J., Thomson, M. C., Christensen, O. F., Rowlingson, |
| R | spaMM | arabidopsis | doi | 10.1111/ecog.00566 |
| R | spatstat.data | nbfires | doi | 10.1007/s10651-007-0085-1 |
| R | spdep | oldcol | doi | 10.1007/978-94-015-7799-1 |
| R | surveillance | hagelloch | doi | 10.18637/jss.v077.i11 |
| R | surveillance | imdepi | doi | 10.1111/j.1541-0420.2011.01684.x |

## Manques a sourcer (0 papier KG) — a cibler pour telechargement -> GROBID

Regroupes par origine. Beaucoup de jeux Python sont des donnees d'exemple GeoDa/PySAL : un meme article/manuel peut couvrir plusieurs jeux.

### Python / geodatasets (28)
airbnb, charleston1, charleston2, chicago_commpop, chicago_health, chile_labor, health_indicators, hickory1, hickory2, lansing1, lansing2, milwaukee1, milwaukee2, ndvi, nepal, nyc_education, orlando1, orlando2, phoenix_acs, police, sacramento1, sacramento2, savannah1, savannah2, seattle1, seattle2, tampa1, us_sdoh

### Python / libpysal (8)
Elections, Milwaukee2, Ohiolung, Orlando2, Sacramento2, Savannah2, Seattle2, chicagoSDOH

### Python / xarray (3)
ASE_ice_velocity, air_temperature_gradient, example_1

### R / GWmodel (3)
GeorgiaCounties, LondonBorough, USelect

### R / ade4 (17)
atlas, atya, avijons, buech, butterfly, doubs, elec88, ggtortoises, jv73, kcponds, macon, oribatid, sarcelles, t3012, tintoodiel, westafrica, zealand

### R / dismo (1)
acaule

### R / gstat (1)
DE_RB_2005

### R / sfdep (1)
guerry_nb

### R / sp (1)
meuse.grid_ll

### R / spData (1)
properties

### R / spDataLarge (1)
pol_pres15

## Prochaine etape proposee

Recherche web ciblee (articles + livres ayant modelise ces jeux) pour remplir les manques, puis je te liste DOI + lien de telechargement ; tu deposes les PDF dans `corpus/papers/raw_pdf/` et on lance GROBID (`python tools/kg/run_all.py --run-grobid`), ou tu me demandes de le faire.
