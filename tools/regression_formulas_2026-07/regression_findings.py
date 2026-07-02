\
# -*- coding: utf-8 -*-
"""Reference table: dataset_id (fiche filename stem) -> regression findings.

status: bon_candidat | a_verifier | mauvais_candidat | mis_de_cote
evidence: verbatim | code | article | None
"""

FINDINGS = {}

def add(did, status, formula=None, method=None, source=None, evidence=None, note=None, homolog=None):
    FINDINGS[did] = dict(status=status, formula=formula, method=method, source=source,
                          evidence=evidence, note=note, homolog=homolog)

# ---------------------------------------------------------------------
# BONS CANDIDATS (22)
# ---------------------------------------------------------------------

add("Python_geodatasets_geoda.guerry", "bon_candidat",
    formula="Crime_pers ~ Region+Literacy+Donations+Infants+Suicides",
    method="OLS",
    source="cran.r-project.org/web/packages/Guerry/vignettes/guerry-multivariate.html",
    evidence="verbatim")

add("Python_geodatasets_geoda.home_sales", "bon_candidat",
    formula="price~bs(x1)+bs(x2)+bs(x3)+bs(x4)+bs(x5)+fact_date (splines) et price~sqft_liv (SEM)",
    method="Splines / SEM (erreur spatiale)",
    source="rstudio-pubs-static.s3.amazonaws.com/155304_cc51f448116744069664b35e7762999f.html ; arxiv.org/pdf/2507.07113",
    evidence="verbatim")

add("Python_geodatasets_geoda.lasrosas", "bon_candidat",
    formula="YIELD~N+N2+TOPO/TOP2-4+NXTOPz",
    method="SEM heteroskedastique",
    source="geodacenter.github.io/data-and-lab/lasrosas/ ; DOI:10.1111/j.0002-9092.2004.00610.x",
    evidence="verbatim",
    homolog="R_agridat_lasrosas.corn_lasrosas.corn")

add("Python_geodatasets_geoda.ndvi", "bon_candidat",
    formula="GREEN~TEMP+PREC",
    method="Autoregression spatiale discrete",
    source="geodacenter.github.io/data-and-lab/ndvi/ ; Anselin (1993)",
    evidence="verbatim")

add("Python_geodatasets_geoda.police", "bon_candidat",
    formula="POL~TAX+TRANS+INC+CRIME+UNEMP+OWNER+COLLEGE+WHITE+OUT",
    method="OLS",
    source="Kelejian & Robinson (1992), RSUE 22:317-331, DOI:10.1016/0166-0462(92)90032-V",
    evidence="verbatim")

add("Python_geodatasets_geoda.us_sdoh", "bon_candidat",
    formula="YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime(+W*YPLL)",
    method="OLS/SAR",
    source="Kolak et al. (2020), DOI:10.1001/jamanetworkopen.2019.19928",
    evidence="verbatim")

add("Python_geodatasets_geoda.nyc_education", "bon_candidat",
    formula="mean_inc~sub18+PER_PRV_SC+YOUTH_DROP+HS_DROP+COL_DEGREE+SCHOOL_CT",
    method="OLS/GWR/GWRBoost",
    source="arxiv.org/pdf/2212.05814",
    evidence="verbatim")

add("Python_geodatasets_spdata.boston", "bon_candidat",
    formula="log(CMEDV)~CRIM+ZN+INDUS+CHAS+I(NOX^2)+I(RM^2)+AGE+log(DIS)+log(RAD)+TAX+PTRATIO+B+log(LSTAT)",
    method="OLS hedonique",
    source="rdrr.io/cran/spData/man/boston.html",
    evidence="verbatim")

add("Python_geodatasets_spdata.columbus", "bon_candidat",
    formula="CRIME~HOVAL+INC",
    method="OLS/Lag/Erreur",
    source="rdrr.io/cran/spData/man/columbus.html ; Anselin (1988)",
    evidence="verbatim",
    homolog="R_spdep_oldcol_COL.OLD")

add("Python_geodatasets_spdata.eire", "bon_candidat",
    formula="A~towns+pale",
    method="OLS",
    source="rdrr.io/cran/spData/man/eire.html",
    evidence="verbatim")

add("Python_geodatasets_spdata.nydata", "bon_candidat",
    formula="CASES~PEXPOSURE+PCTOWNHOME+PCTAGE65P+offset(log(POP8))",
    method="GLM Poisson",
    source="hughst.github.io/week-7/ ; SISMID 2022 (L. Waller)",
    evidence="verbatim")

add("Python_libpysal_Baltimore", "bon_candidat",
    formula="PRICE~NROOM+DWELL+NBATH+PATIO+FIREPL+AC+BMENT+NSTOR+GAR+AGE+CITCOU+LOTSZ+SQFT",
    method="OLS hedonique",
    source="github.com/Nowosad/spData/blob/master/R/baltimore.R ; Dubin (1992)",
    evidence="verbatim")

add("Python_libpysal_Ohiolung", "bon_candidat",
    formula="kappa_ijkt = mu + s_j*alpha + r_k*beta + s_j*r_k*gamma + p_i*rho + c_t + phi_it (Poisson)",
    method="Bayesien hierarchique CAR",
    source="Xia & Carlin (1998), DOI:10.1002/(SICI)1097-0258(19980930)17:18<2025",
    evidence="verbatim")

add("Python_libpysal_georgia", "bon_candidat",
    formula="PctBach~PctRural+PctFB+PctBlack+PctEld",
    method="GWR",
    source="Fotheringham, Brunsdon & Charlton (2002), Wiley",
    evidence="verbatim",
    note="Formule identifiee via la documentation du package R equivalent GWmodel::Gedu.counties — meme jeu de donnees sous-jacent (Georgia, Fotheringham et al. 2002).",
    homolog="R_GWmodel_GeorgiaCounties_Gedu.counties")

add("R_GWmodel_GeorgiaCounties_Gedu.counties", "bon_candidat",
    formula="PctBach~PctRural+PctFB+PctBlack+PctEld",
    method="GWR",
    source="Fotheringham, Brunsdon & Charlton (2002), Wiley",
    evidence="verbatim",
    homolog="Python_libpysal_georgia")

add("R_GWmodel_EWHP_ewhp", "bon_candidat",
    formula="PurPrice~BldIntWr+BldPostW+Bld60s+Bld70s+Bld80s+TypDetch+TypSemiD+TypFlat+FlrArea",
    method="GWR/OLS",
    source="Gollini et al. (2015), JSS 63, arxiv.org/pdf/1306.0413",
    evidence="verbatim")

add("R_GWmodel_LondonBorough_londonborough", "bon_candidat",
    formula="Prix immobilier ~ 18 variables hedoniques (dataset associe LondonHP porte les observations ponctuelles ; londonborough = polygones d'arrondissements de reference spatiale)",
    method="GWR non-euclidienne",
    source="rdrr.io/cran/GWmodel/man/LondonHP.html ; Lu et al. (2014)",
    evidence="verbatim",
    note="La formule et les variables hedoniques sont portees par le dataset ponctuel associe LondonHP (meme package GWmodel) ; londonborough fournit les polygones d'arrondissement utilises comme reference spatiale/jointure.",
    homolog="R_GWmodel_LondonHP_londonhp")

add("R_GWmodel_LondonHP_londonhp", "bon_candidat",
    formula="Prix immobilier ~ 18 variables hedoniques",
    method="GWR non-euclidienne",
    source="rdrr.io/cran/GWmodel/man/LondonHP.html ; Lu et al. (2014)",
    evidence="verbatim",
    note="Dataset ponctuel portant les observations hedoniques ; londonborough (meme package) fournit les polygones d'arrondissement associes.",
    homolog="R_GWmodel_LondonBorough_londonborough")

add("R_SpatialEpi_pennLC_sf_pennLC_sf", "bon_candidat",
    formula="Y~offset(log(E))+smoking",
    method="Poisson/BYM",
    source="Kim, Wakefield & Moise (2025) ; paulamoraga.com/book-spatial",
    evidence="verbatim")

add("R_agridat_gartner.corn_gartner.corn", "bon_candidat",
    formula="yield~elevation",
    method="GWR",
    source="Rakshit et al. (2020), Field Crops Research 255:107783",
    evidence="article")

add("R_agridat_ortiz.tomato.covs_ortiz.tomato.covs", "bon_candidat",
    formula="env*gen~env*cov",
    method="PLS",
    source="cran.r-project.org/web/packages/agridat/agridat.pdf (catalogue officiel)",
    evidence="verbatim")

add("R_agridat_usgs.herbicides_usgs.herbicides", "bon_candidat",
    formula="log(DetectFreq)~log(UsageAgricole)+log(DemiVieSol)+log(Koc)+log(ProfondeurPuits)",
    method="Regression multiple log-log",
    source="USGS WRIR 98-4245, water.usgs.gov/nawqa/pnsp/pubs/wrir984245/",
    evidence="article")

add("R_gstat_meuse.all_meuse.all", "bon_candidat",
    formula="log(zinc)~sqrt(dist) (idem cadmium/lead/copper)",
    method="OLS + krigeage universel",
    source="Tutoriel officiel gstat (Pebesma)",
    evidence="verbatim",
    homolog="R_sp_meuse_meuse")

add("R_spData_house_house", "bon_candidat",
    formula="log(price)~TLA+Frontage+Depth+age+beds+baths+... (24 variables)",
    method="OLS/SAR/krigeage",
    source="github.com/Nowosad/spData/blob/master/R/house.R ; LeSage & Pace (2004)",
    evidence="verbatim")

# ---------------------------------------------------------------------
# A VERIFIER (8)
# ---------------------------------------------------------------------

add("Python_geodatasets_geoda.chile_labor", "a_verifier",
    note="Piste reelle (Rowe & Bell 2020, DOI:10.1007/978-981-10-0230-4_6) mais micro-donnees individuelles != fichier FLMA agrege distribue par GeoDa.",
    source="DOI:10.1007/978-981-10-0230-4_6",
    evidence="article")

add("Python_geodatasets_geoda.cincinnati", "a_verifier",
    formula="WHITE~AGE_0_5+...+AGE_85",
    method="GWR",
    note="Formule GWR trouvee mais lien source (pysal.org/gwlearn/dev) confirme 404 ; pas de lien stable retrouve.",
    evidence="article")

add("Python_geodatasets_spdata.wheat", "a_verifier",
    note="Formule reelle existante (Christensen & Eidsvik 2024) mais format covariance spatiale GDEF, pas regression classique. Dataset R spData::wheat expose ici via le wrapper Python geodatasets.",
    source="arxiv.org/pdf/2407.02684",
    evidence="article")

add("R_gstat_jura_jura.pred", "a_verifier",
    note="Modele de krigeage/cokriging (Goovaerts 1997), pas OLS classique.",
    source="Goovaerts (1997)",
    evidence="article")

add("R_gstat_jura_jura.val", "a_verifier",
    note="Modele de krigeage/cokriging (Goovaerts 1997), pas OLS classique.",
    source="Goovaerts (1997)",
    evidence="article")

add("R_gstat_oxford_oxford", "a_verifier",
    note="Non creuse en detail lors de la recherche manuelle.")

add("R_spData_properties_properties", "a_verifier",
    note="Appartements Athenes 2017, distance metro — usage hedonique plausible mais non confirme par une source verifiable.")

add("R_spatstat.data_nbfires_nbfires", "a_verifier",
    note="Processus ponctuel (feux Nouveau-Brunswick) ; modeles d'intensite/logistique spatiale possibles mais aucune formule nommee confirmee.")

add("R_ade4_oribatid_oribatid", "a_verifier",
    formula="RDA/CCA contrainte (pcaiv)",
    method="Ordination sous contrainte",
    note="Documentee par Borcard & Legendre (1994) mais format ordination multivariee, pas regression classique a variable dependante unique.",
    source="Borcard & Legendre (1994)",
    evidence="article")

# ---------------------------------------------------------------------
# MAUVAIS CANDIDATS (48)
# ---------------------------------------------------------------------

GEODA_BAD_GENERIC = (
    "Aucune regression canonique documentee retrouvee dans la litterature ou la "
    "documentation du package pour ce jeu de donnees lors de la recherche manuelle "
    "exhaustive (web + sources primaires)."
)
for name in ["airbnb", "charleston1", "charleston2", "chicago_health", "health",
             "health_indicators", "hickory1", "hickory2", "lansing1", "lansing2",
             "milwaukee1", "nyc", "nyc_neighborhoods", "orlando1", "phoenix_acs",
             "sacramento1", "savannah1", "seattle1", "tampa1"]:
    add(f"Python_geodatasets_geoda.{name}", "mauvais_candidat", note=GEODA_BAD_GENERIC)

add("Python_geodatasets_geoda.chicago_commpop", "mauvais_candidat",
    note="Usage confirme = reprojection/jointure CRS entre geographies communautaires de Chicago, pas de regression documentee.")

add("Python_geodatasets_geoda.nepal", "mauvais_candidat",
    note="Variables invoquees dans certaines pistes de recherche confirmees absentes du fichier reel distribue par GeoDa.")

add("Python_geodatasets_naturalearth.cities", "mauvais_candidat",
    note="Jeu de points de villes (coordonnees + noms) sans variable de reponse — pas de regression par nature.")

add("Python_libpysal_Elections", "mauvais_candidat", note="Aucune regression documentee retrouvee.")
add("Python_libpysal_NYC_Socio-Demographics", "mauvais_candidat", note="Aucune regression documentee retrouvee.")

add("R_ade4_doubs_doubs", "mauvais_candidat",
    note="Utile seulement pour analyse multivariee (ACP/RDA `pcaiv`), pas de regression a variable dependante unique documentee.")

add("R_spDataLarge_pol_pres15_pol_pres15", "mauvais_candidat",
    note="Elections POLONAISES (et non espagnoles malgre le nom) de 2015 ; usage confirme = clustering SKATER (regionalisation), pas de regression.")

add("R_spData_nz_nz", "mauvais_candidat",
    note="Jeu de polygones administratifs (Nouvelle-Zelande) sans variable de reponse documentee pour une regression canonique.")

add("R_spData_world_world", "mauvais_candidat",
    note="Jeu de polygones pays au niveau mondial, utilise comme fond de carte / exemples cartographiques, pas de regression documentee.")

MEUSE_GRID_NOTE = (
    "Grille de prediction (covariables uniquement, pas d'observations de la variable "
    "reponse) utilisee pour le krigeage universel de `meuse`/`meuse.all` — pas un jeu "
    "de regression autonome."
)
add("R_sp_meuse.grid_meuse.grid", "mauvais_candidat", note=MEUSE_GRID_NOTE)
add("R_sp_meuse.grid_ll_meuse.grid_ll", "mauvais_candidat", note=MEUSE_GRID_NOTE)

ADE4_BAD_NOTE = (
    "Package ade4 = ordination multivariee (ACP/RDA/CCA) ; structure de donnees "
    "confirmee a 5 reprises independantes (doubs/avijons/oribatid/mafragh/jv73) comme "
    "non adaptee a une regression canonique a variable dependante unique."
)
for name in ["atlas", "atya", "avijons", "buech", "butterfly", "elec88", "irishdata",
             "julliot", "jv73", "kcponds", "macon", "mafragh", "pcw", "sarcelles",
             "t3012", "tintoodiel", "vegtf", "zealand"]:
    add(f"R_ade4_{name}_{name}", "mauvais_candidat", note=ADE4_BAD_NOTE)

# ---------------------------------------------------------------------
# HOMOLOGUES PYTHON/R DETECTES LORS DU BALAYAGE COMPLET (Tache 3)
# ---------------------------------------------------------------------

add("R_agridat_lasrosas.corn_lasrosas.corn", "bon_candidat",
    formula="YIELD~N+N2+TOPO/TOP2-4+NXTOPz",
    method="SEM heteroskedastique",
    source="geodacenter.github.io/data-and-lab/lasrosas/ ; DOI:10.1111/j.0002-9092.2004.00610.x",
    evidence="verbatim",
    note=("Formule identifiee via l'homologue Python geodatasets::geoda.lasrosas — meme "
          "jeu de donnees sous-jacent (essai agronomique La Rosas, Cordoba, Argentine)."),
    homolog="Python_geodatasets_geoda.lasrosas")

add("R_sp_meuse_meuse", "bon_candidat",
    formula="log(zinc)~sqrt(dist) (idem cadmium/lead/copper)",
    method="OLS + krigeage universel",
    source="Tutoriel officiel gstat (Pebesma)",
    evidence="verbatim",
    note=("Formule identifiee via l'homologue R_gstat_meuse.all — meme jeu de donnees "
          "sous-jacent (metaux lourds riviere Meuse), distribue ici via le package sp "
          "(objet SpatialPointsDataFrame) plutot que gstat."),
    homolog="R_gstat_meuse.all_meuse.all")

add("R_spdep_oldcol_COL.OLD", "bon_candidat",
    formula="CRIME~HOVAL+INC",
    method="OLS/Lag/Erreur",
    source="rdrr.io/cran/spData/man/columbus.html ; Anselin (1988)",
    evidence="verbatim",
    note=("Formule identifiee via l'homologue Python geodatasets::spdata.columbus — "
          "meme jeu de donnees sous-jacent (Columbus, Ohio, Anselin 1988), distribue ici "
          "via spdep sous son nom historique COL.OLD."),
    homolog="Python_geodatasets_spdata.columbus")

# ---------------------------------------------------------------------
# TACHE 4 — Fiches non couvertes par le tableau de reference (balayage complet)
# Ces fiches portaient deja un formula_pub issu d'une passe d'enrichissement
# automatique anterieure (enrich_web.py, LLM+web_search) ; jugement de
# plausibilite/statut porte ici individuellement, avec correction quand
# la formule existante ne correspond pas aux colonnes reelles du dataset.
# ---------------------------------------------------------------------

add("R_GWmodel_DubVoter_Dub.voter", "bon_candidat",
    formula="GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64",
    method="GWR",
    source="Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24",
    evidence="verbatim",
    note="Formule deja presente (enrichissement anterieur enrich_web.py) et confirmee coherente avec les colonnes reelles du dataset ; jeu de donnees GWmodel classique (turnout electoral Dublin).")

add("R_GWmodel_USelect_USelect2004", "bon_candidat",
    formula="winner ~ unemploy + pctcoled + PEROVER65 + pcturban + WHITE",
    method="GWR (regression logistique/discriminante geographiquement ponderee)",
    source="Robinson, A. C. (2013) Geovisualization of the 2004 Presidential Election. Penn State / National Institutes of Health (web resource)",
    evidence="article",
    note="Formule deja presente (enrichissement anterieur) ; source de type ressource web non publiee en revue, coherente avec les colonnes reelles.")

add("R_agridat_wallace.iowaland_wallace.iowaland", "bon_candidat",
    formula="fedval~yield+corn+grain+untillable",
    method="OLS hedonique (valeur des terres agricoles)",
    source="Larry Winner, Spatial Data Analysis, https://www.stat.ufl.edu/~winner/data/iowaland.txt (dataset reference, flagge 'formule referencee dans catalogue' par agridat.pdf officiel)",
    evidence="code",
    note="Aucune equation ajustee explicite retrouvee dans la source ; formule reconstruite a partir de la liste de variables reelle du dataset (Y=fedval/stval valeur des terres, X=yield/corn/grain/untillable caracteristiques agronomiques du comte).")

add("R_gstat_DE_RB_2005_DE_RB_2005", "a_verifier",
    formula="PM10 ~ 1 (modele de tendance spatio-temporelle, puis krigeage des residus)",
    method="Krigeage spatio-temporel",
    source="Graler B., Pebesma E., Heuvelink G. (2016) Spatio-Temporal Interpolation using gstat. The R Journal, 8(1), 204-218",
    evidence="verbatim",
    note="Formule deja presente (enrichissement anterieur) : modele intercept-only utilise comme tendance de base avant krigeage spatio-temporel des residus dans le tutoriel gstat officiel — pas une regression multi-covariables classique.")

add("R_spDataLarge_lsl_lsl", "bon_candidat",
    formula="lslpts ~ slope + cplan + cprof + elev + log10_carea",
    method="GLM logistique (classification binaire glissements de terrain)",
    source="Muenchow, J., Brenning, A., Richter, R. (2012) Geomorphic process rates of landslides along a humidity gradient in the tropical Andes. Geomorphology 139-140, 271-284. DOI:10.1016/j.geomorph.2011.10.029",
    evidence="verbatim",
    note="Formule deja presente (enrichissement anterieur), coherente avec les colonnes reelles et le DOI Bloc 2 ; dataset canonique du chapitre 'Statistical learning' de Geocomputation with R.")

add("R_spData_depmunic_depmunic", "a_verifier",
    formula="y_ij = rho*W_i*y + x'_ij*beta + z'_j*gamma + theta_j (modele hierarchique spatial general, Dong & Harris 2014) — NON instancie sur les colonnes reelles",
    method="Modele autoregressif spatial hierarchique (SAR multi-niveaux)",
    source="Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis. DOI:10.1111/gean.12049",
    evidence="article",
    note=("La formule presente (enrichissement anterieur) est l'equation generique de la classe "
          "de modeles du papier Dong & Harris (notation y_ij/x_ij/z_j), pas une instanciation sur "
          "les colonnes reelles (airbnb, pop_rest, museums, population, greensp, area). Candidat "
          "par analogie propose : airbnb~museums+population+greensp+area (OLS), coherent avec la "
          "structure hedonique/attractivite du departement, mais NON verifie dans une source "
          "explicitement chiffree sur ce jeu precis (N=7, tres petit echantillon)."))

add("R_spaMM_Leuca_Leuca", "bon_candidat",
    formula="fec_div ~ sex + Matern(1|x+y %in% sex)",
    method="GLMM geostatistique (effet spatial Matern sexe-specifique)",
    source="Tonnabel J. et al. (2021) Sex-specific spatial variation in fitness in the highly dimorphic Leucadendron rubrum. Molecular Ecology, 30:1721-1735. DOI:10.1111/mec.15833",
    evidence="verbatim",
    note="Formule deja presente (enrichissement anterieur), coherente avec le DOI Bloc 2 et les colonnes reelles.")

add("R_spaMM_Loaloa_Loaloa", "bon_candidat",
    formula="cbind(npos, ntot-npos) ~ elev1+elev2+elev3+elev4+maxNDVI1+seNDVI+Matern(1|longitude+latitude)",
    method="GLMM binomial geostatistique (Matern)",
    source="Diggle P.J. et al. (2007) Spatial modelling and the prediction of Loa loa risk. Annals of Tropical Medicine and Parasitology, 101(6), 499-509. DOI:10.1179/136485907X229121",
    evidence="verbatim",
    note="Formule deja presente (enrichissement anterieur) ; dataset canonique de la litterature de geostatistique pour donnees binomiales (Diggle & Ribeiro).")

add("R_spaMM_arabidopsis_arabidopsis", "bon_candidat",
    formula="cbind(pos1046738, 1-pos1046738) ~ seasonal + Matern(1|LAT+LONG)",
    method="GLMM binomial geostatistique (Matern), genomique du paysage",
    source="Fournier-Level A. et al. (2011) A map of local adaptation in Arabidopsis thaliana. Science 334: 86-89. DOI:10.1126/science.1209271",
    evidence="verbatim",
    note="Formule deja presente (enrichissement anterieur), coherente avec le DOI Bloc 2 ; meme structure applicable aux 3 autres SNP binaires du dataset.")

add("R_surveillance_hagelloch_hagelloch", "bon_candidat",
    formula="~ household + cox(AGE)",
    method="twinSIR (modele de survie / processus de comptage pour epidemie)",
    source="Neal PJ, Roberts GO (2004) Statistical inference and model selection for the 1861 Hagelloch measles epidemic. Biostatistics, 5(2), 249-261. DOI:10.1093/biostatistics/5.2.249",
    evidence="verbatim",
    note="Formule deja presente (enrichissement anterieur), coherente avec le DOI Bloc 2 ; version spatio-temporelle (N=70500) complementaire de hagelloch.df.",
    homolog="R_surveillance_hagelloch_hagelloch.df")

add("R_surveillance_hagelloch_hagelloch.df", "bon_candidat",
    formula="~ household + cox(AGE)",
    method="twinSIR (modele de survie / processus de comptage pour epidemie)",
    source="Neal PJ, Roberts GO (2004) Statistical inference and model selection for the 1861 Hagelloch measles epidemic. Biostatistics, 5(2), 249-261. DOI:10.1093/biostatistics/5.2.249",
    evidence="verbatim",
    note="Formule deja presente (enrichissement anterieur) ; version spatiale pure (N=188) complementaire de hagelloch.",
    homolog="R_surveillance_hagelloch_hagelloch")

add("Python_libpysal_Snow", "candidat_par_analogie",
    formula="deaths ~ dis_bspump + dis_sewers + dis_pestf + pestfield",
    method="GLM Poisson (analogie avec geoda.nydata / R_SpatialEpi_pennLC)",
    note=("CANDIDAT PAR ANALOGIE — non verifie. Aucune equation ajustee publiee retrouvee pour "
          "cette version agregee (N=1852) du dataset de John Snow (cholera, Londres 1854). "
          "Analogie proposee avec les modeles de comptage de cas de maladie en fonction de "
          "facteurs de proximite (geoda.nydata: CASES~PEXPOSURE+...; R_SpatialEpi pennLC_sf: "
          "Y~offset(log(E))+smoking), domaine substantiellement identique (epidemiologie spatiale "
          "de comptages ponctuels) et hypothese originale de Snow lui-meme (proximite a la pompe "
          "Broad Street comme facteur de risque)."),
    evidence="analogie")

add("Python_libpysal_chicagoSDOH", "candidat_par_analogie",
    formula="YPLL_rate ~ EP_MINRTY + EP_NOHSDP + Pov14 + Unemp14 + VCRIMERT15",
    method="OLS/GWR (analogie avec geoda.us_sdoh)",
    note=("CANDIDAT PAR ANALOGIE — non verifie, mais analogie forte a confirmer comme possible "
          "homologue Tache 3. Le dataset partage l'indicateur exact YPLL avec geoda.us_sdoh (bon "
          "candidat, formule YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime, source Kolak "
          "et al. 2020, DOI:10.1001/jamanetworkopen.2019.19928, etude realisee precisement sur "
          "Chicago). Il est possible que chicagoSDOH soit la microdonnee source de cette meme "
          "etude plutot qu'un simple analogue structurel — a verifier explicitement (mapping "
          "Advantage/Mobility/Opportunity/MICA vers EP_MINRTY/EP_NOHSDP/Pov14/Unemp14/VCRIMERT15 "
          "propose ici par correspondance de role, non par nom de colonne)."),
    source="Kolak et al. (2020), DOI:10.1001/jamanetworkopen.2019.19928 (etude source de l'analogie)",
    evidence="analogie")

# ---------------------------------------------------------------------
# MIS DE COTE (1)
# ---------------------------------------------------------------------

add("R_sfdep_guerry_nb_guerry_nb", "mis_de_cote",
    note=("Tres probablement la matrice/liste de voisinage (`nb`) associee au dataset "
          "Guerry, pas un dataset autonome. A ecarter automatiquement de toute recherche "
          "de formule de regression : voir la fiche `guerry` (Python_geodatasets_geoda.guerry "
          "et tout homologue R) dont `guerry_nb` est l'objet de voisinage derive."))

print(f"Total entries: {len(FINDINGS)}")
