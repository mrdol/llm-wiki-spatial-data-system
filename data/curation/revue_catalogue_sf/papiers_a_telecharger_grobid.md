---
title: Papiers/livres de modelisation a sourcer pour les 65 jeux sans papier KG
type: analysis
created: 2026-06-25
sources:
  - data/manifests/datasets/papiers_modelisation_120_couverture.csv
  - fiches Rd locales (wiki/datasets/r_package_docs/*/topics/)
  - recherche web (juin 2026)
tags: [papers, grobid, sourcing, datasets]
---

# Papiers a telecharger -> GROBID (jeux sans papier dans le KG)

Issu de deux sources : (1) les references citees dans les fiches Rd locales (surtout `ade4`), (2) une recherche web ciblee (GWmodel, gstat, pol_pres15, SDOH, GeoDa/PySAL). Detail tabulaire : `papiers_a_telecharger_grobid.csv`.

## Priorite haute (papier de modelisation + PDF librement telechargeable)

| Jeux | Papier / livre | Annee | DOI / lien |
|---|---|---|---|
| GWmodel::GeorgiaCounties, USelect, LondonBorough (+ DubVoter, EWHP, LondonHP) | Gollini, Lu, Charlton, Brunsdon & Harris — GWmodel: An R Package for Exploring Spatial Heterogeneity Using Geographically Weighted Models | 2015 | 10.18637/jss.v063.i17 |
| GWmodel (topics avances) | Lu, Harris, Charlton & Brunsdon — The GWmodel R package: further topics for exploring spatial heterogeneity | 2014 | 10.1080/10095020.2014.917453 |
| spDataLarge::pol_pres15 (alt.) | Pebesma & Bivand — Spatial Data Science: With Applications in R (CRC), ch.14 Areal | 2023 | https://r-spatial.org/book/ |
| gstat::DE_RB_2005 | Graler, Pebesma & Heuvelink — Spatio-Temporal Interpolation using gstat (The R Journal 8(1)) | 2016 | https://journal.r-project.org/articles/RJ-2016-014/ (RJ-2016-014) |
| gstat::DE_RB_2005 (classes ST) | Pebesma — spacetime: Spatio-Temporal Data in R (JSS 51(7)) | 2012 | 10.18637/jss.v051.i07 |
| ade4::oribatid | Borcard & Legendre — Environmental control and spatial structure in ecological communities (Env. Ecol. Stat. 1:37-61) ; Borcard, Legendre & Drapeau — Partialling out the spatial component (Ecology 73:1045-1055) | 1994 | 10.2307/1940179 (Ecology 1992) |
| ade4::avijons | Thioulouse, Chessel & Champely — Multivariate analysis of spatial patterns (Env. Ecol. Stat. 2:1-14) | 1995 | (Env. Ecol. Stat. 2:1-14) |
| ade4::ggtortoises | Ciofi, Milinkovitch, Gibbs, Caccone & Powell — Microsatellite analysis of genetic divergence among Galapagos tortoises (Molecular Ecology 11:2265-2283) | 2002 | (Mol. Ecol. 11:2265-2283) |
| ade4::tintoodiel | Borrego, Morales, de la Torre & Grande — Geochemical characteristics of heavy metal pollution, Tinto-Odiel estuary (Environmental Geology 41:785-796) | 2002 | (Environmental Geology 41:785-796) |
| ade4::westafrica | Hugueny & Leveque — Freshwater fish zoogeography in West Africa (Env. Biol. Fishes 39:365-380) | 1994 | (Env. Biol. Fishes 39:365-380) |
| Python geodatasets + libpysal : us_sdoh, chicagoSDOH | Kolak, Bhatt, Park, Padron & Molefe — Quantification of Neighborhood-Level Social Determinants of Health in the Continental US (JAMA Network Open 3(1):e1919928) | 2020 | 10.1001/jamanetworkopen.2019.19928 |
| Python geodatasets::guerry (+ R sfdep::guerry_nb) | Dray & Jombart — A revisit of Guerry's data: introducing spatial constraints in multivariate analysis (Annals of Applied Statistics 5(4):2278-2299) | 2011 | 10.1214/10-AOAS356 |
| Python (homicide) natregimes/ncovr si retenus | Baller, Anselin, Messner, Deane & Hawkins — Structural Covariates of US County Homicide Rates: Incorporating Spatial Effects (Criminology 39(3):561-590) | 2001 | 10.1111/j.1745-9125.2001.tb00933.x |
| Python geodatasets/libpysal : airbnb, charleston1/2, chicago_commpop, chicago_health, chile_labor, cincinnati, health_indicators, hickory1/2, lansing1/2, milwaukee1/2, ndvi, nepal, nyc_education, orlando1/2, phoenix_acs, police, sacramento1/2, savannah1/2, seattle1/2, tampa1, Elections, Ohiolung, Milwaukee2, Orlando2, Sacramento2, Savannah2, Seattle2 | Donnees d'exemple GeoDa Center / PySAL — depot commun + manuel : Anselin & Rey, Modern Spatial Econometrics in Practice (GeoDa Press, 2014) | 2014 | https://geodacenter.github.io/data-and-lab/  +  https://github.com/lanselin/spreg_sample_data |

## Reference mais acces difficile (livre / these / rapport)

| Jeux | Reference | DOI / lien |
|---|---|---|
| GWmodel (idem, fond methodologique) | Fotheringham, Brunsdon & Charlton — Geographically Weighted Regression: The Analysis of Spatially Varying Relationships (Wiley) | ISBN 9780471496168 |
| spDataLarge::pol_pres15 | Kopczewska — Applied Spatial Statistics and Econometrics: Data Analysis in R (Routledge) | ISBN 9780367470760 |
| spData::meuse.grid_ll | Rikken & Van Rijn — Soil pollution with heavy metals ... floodplains of the Meuse | (rapport Utrecht Univ.) |
| ade4::doubs | Chessel, Lebreton & Yoccoz — Proprietes de l'analyse canonique des correspondances (Rev. Stat. Appl. 35(4):55-72) ; Verneaux 1973 (these) | (Rev. Stat. Appl.) |
| ade4::butterfly / zealand | Manly — Multivariate Statistical Methods. A primer (Chapman & Hall) ; McKechnie et al. 1975 (Genetics 81:571-594) pour butterfly | ISBN (livre) |
| ade4::buech | Vespini, Legier & Champeau — Ecologie d'une riviere non amenagee : Le Buech (Annales de Limnologie 23:151-164) | (Ann. Limnol. 23:151-164) |
| ade4::atlas / atya / kcponds / sarcelles / t3012 / jv73 | References de source citees dans les fiches Rd (Lebreton 1977 ; Fievet et al. 2001 ; Cottenie 2002 ; Lebreton 1973 ; Besse 1979 ; Verneaux 1973) | voir fiches Rd |

## Pas de papier de modelisation attendu (a exclure du sourcing)

- **spData::properties** : (jeu pedagogique synthetique de spData)
- **ade4::elec88 / macon** : (donnees publiques / foire des vins)
- **dismo::acaule** : Donnees d'occurrence GBIF (Solanum acaule)
- **Python xarray : ASE_ice_velocity, air_temperature_gradient, example_1** : (jeux tutoriels xarray, rasters)

## Comment ingerer dans GROBID

1. Telecharger les PDF prioritaires (liens ci-dessus).
2. Les deposer dans `corpus/papers/raw_pdf/`.
3. Lancer `python tools/kg/run_all.py --run-grobid` (ou route incrementale `python tools/kg/ingest_papers.py --pdf "<fichier>.pdf" --title "<titre>"`).
4. Re-interroger `papers-for-dataset` pour confirmer le rattachement.

> Je peux telecharger moi-meme les PDF en open access (JSS, R Journal, PMC) et les deposer dans `corpus/papers/raw_pdf/` si tu me le demandes.
