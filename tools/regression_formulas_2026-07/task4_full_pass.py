\
# -*- coding: utf-8 -*-
"""Task 4, second pass (2026-07-02): analogy-formula review for the full set
of 59 fiches classified 'mauvais_candidat' (48) or 'a_verifier' (11) by the
first mission pass. For each, read the real Candidate Y/X variable lists and
judge, case by case, whether a structurally coherent analogy to an existing
'bon candidat' is defensible -- never based on a shared keyword or geography
alone. Where no defensible analogy exists, the existing classification is
kept and a note documents that the analogy question was reviewed and
rejected (not simply skipped).

Run after regression_findings.py / apply_findings.py (Tache 1-4 first pass).
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from regression_findings import FINDINGS
import apply_findings

PKG_DIR = apply_findings.PKG_DIR

NO_ANALOGY_SUFFIX = (
    " [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente "
    "identifiee avec un bon candidat existant -- statut inchange plutot que "
    "forcer un rapprochement faible.]"
)

# ---------------------------------------------------------------------
# Upgrades -- 25 datasets with a defensible candidat-par-analogie formula
# ---------------------------------------------------------------------

UPGRADES = {}


def upgrade(did, formula, method, analogy_to, note):
    UPGRADES[did] = dict(
        status="candidat_par_analogie",
        formula=formula,
        method=method,
        evidence="analogie",
        source=f"Analogie structurelle avec {analogy_to} (banque interne, mission 2026-07)",
        homolog=FINDINGS[did].get("homolog"),
        note=note,
    )


# --- "small area" GeoDa city template (9 datasets, same schema: Y=HH_INC/HSG_VAL/POV_TOT) ---
SMALL_AREA_ANALOGY_NOTE = (
    "CANDIDAT PAR ANALOGIE -- non verifie. Schema identique a 8 autres jeux 'small area' "
    "GeoDa (memes colonnes TOT_POP/POV_POP/WHITE/BLACK/EMPL16/OCC_MAN/OCC_OFF1). Analogie "
    "structurelle avec spdata.boston (bon candidat, log(CMEDV)~CRIM+...+B+LSTAT : valeur "
    "immobiliere/socioeconomique de secteur de recensement expliquee par la composition "
    "raciale et socioeconomique) : meme role de variables (Y = indicateur de valeur/richesse "
    "au niveau tract, X = composition demographique/raciale/emploi), domaine substantiellement "
    "identique (hedonique/socioeconomique a l'echelle du census tract)."
)
upgrade("Python_geodatasets_geoda.charleston1",
        "HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)
upgrade("Python_geodatasets_geoda.hickory1",
        "hsg_val~tot_pop+pov_pop+white+black+empl16+occ_man+occ_off1", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)
upgrade("Python_geodatasets_geoda.lansing1",
        "HSG_VAL~TOT_POP+POV_POP+WHITE+BLACK+EMPL16+OCC_MAN+OCC_OFF1", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)
upgrade("Python_geodatasets_geoda.orlando1",
        "HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)
upgrade("Python_geodatasets_geoda.sacramento1",
        "HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)
upgrade("Python_geodatasets_geoda.savannah1",
        "HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)
upgrade("Python_geodatasets_geoda.seattle1",
        "HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)
upgrade("Python_geodatasets_geoda.tampa1",
        "HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+EMPL16+OCC_MAN+OCC_OFF1", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)
upgrade("Python_geodatasets_geoda.milwaukee1",
        "HSG_VAL~TOT_POP+POV_POP+WHITE_+BLACK_+PCTBLACK+EMPL16+OCC_MAN", "OLS",
        "spdata.boston (hedonique census-tract)", SMALL_AREA_ANALOGY_NOTE)

# --- hedonic-style price/rating (airbnb) ---
upgrade("Python_geodatasets_geoda.airbnb",
        "price_pp~poverty+crowded+without_hs+unemployed+income_pc+num_crimes+room_type", "OLS",
        "libpysal.Baltimore / spdata.boston (hedonique)",
        "CANDIDAT PAR ANALOGIE -- non verifie. price_pp est un prix explique par la "
        "composition socioeconomique du secteur (pauvrete, criminalite, niveau d'etudes, "
        "revenu) -- meme structure hedonique que Baltimore/Boston (prix ~ caracteristiques "
        "+ composition socioeconomique du voisinage), domaine substantiellement comparable.")

# --- SDOH / health outcome ~ socioeconomic composition ---
SDOH_ANALOGY_NOTE_TMPL = (
    "CANDIDAT PAR ANALOGIE -- non verifie. Analogie structurelle avec geoda.us_sdoh (bon "
    "candidat, YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime) : indicateur de sante "
    "publique au niveau secteur explique par des determinants sociaux (pauvrete, education, "
    "chomage, revenu), domaine substantiellement identique (sante publique et determinants "
    "sociaux). {extra}"
)
upgrade("Python_geodatasets_geoda.chicago_health",
        "LungCancer~PerCInc14+Pov14+NoHS14+Unemp14+VlntCrRt", "OLS/GWR",
        "geoda.us_sdoh (SDOH)", SDOH_ANALOGY_NOTE_TMPL.format(extra="Meme ville (Chicago) que us_sdoh."))
upgrade("Python_geodatasets_geoda.health_indicators",
        "LungCancer~Below_evel+Unemp_ment+NoHig_loma+PerCa_come+Dependency+Crowd_sing", "OLS/GWR",
        "geoda.us_sdoh (SDOH)", SDOH_ANALOGY_NOTE_TMPL.format(extra=""))
upgrade("Python_geodatasets_geoda.health",
        "ratio~tractmhir+Diversity+Whitealon+BlackorA", "OLS",
        "geoda.us_sdoh (SDOH)",
        SDOH_ANALOGY_NOTE_TMPL.format(extra="Confiance plus faible : semantique exacte de "
        "'ratio' et des variables le_agg_q*/le_racea_* (esperance de vie par quartile/race) "
        "reste ambigue sans documentation source -- a confirmer avant usage."))

# --- unemployment/inequality ~ demographic composition ---
UNEMP_ANALOGY_NOTE = (
    "CANDIDAT PAR ANALOGIE -- non verifie. Analogie structurelle avec geoda.police "
    "(POL~TAX+TRANS+INC+CRIME+UNEMP+OWNER+COLLEGE+WHITE+OUT) et geoda.us_sdoh : taux de "
    "chomage/pauvrete au niveau secteur explique par la composition demographique, "
    "educative et raciale -- domaine substantiellement identique (indicateur socioeconomique "
    "explique par composition de quartier)."
)
upgrade("Python_geodatasets_geoda.nyc_neighborhoods",
        "UEMPRATE~poptot+hispanic+african+onlyhighsc+onlybachel+withpubass+medianinco", "OLS",
        "geoda.police / geoda.us_sdoh", UNEMP_ANALOGY_NOTE)
upgrade("Python_libpysal_NYC_Socio-Demographics",
        "UNEMP_RATE~poptot+hispanic+african+onlyhighsc+onlybachel+withpubass+medianage", "OLS",
        "geoda.police / geoda.us_sdoh",
        UNEMP_ANALOGY_NOTE + " NOTE ADDITIONNELLE : ce dataset partage un schema quasi "
        "identique (memes noms de colonnes Y et X) avec Python_geodatasets_geoda."
        "nyc_neighborhoods -- probable quasi-doublon intra-Python (memes donnees NYC sous "
        "deux packages), a verifier separement de la question d'analogie.")

upgrade("Python_geodatasets_geoda.phoenix_acs",
        "inc~white_rt+black_rt+hisp_rt+pop_dens+fem_nh_rt", "OLS",
        "geoda.us_sdoh / geoda.police", UNEMP_ANALOGY_NOTE)

upgrade("Python_geodatasets_geoda.nyc",
        "rent2008~forhis08+forwh08+hhsiz08+pubast90+kids2008", "OLS",
        "spdata.boston / geoda.us_sdoh",
        "CANDIDAT PAR ANALOGIE -- non verifie. Loyer de secteur explique par composition "
        "demographique -- structure hedonique/SDOH comparable a Boston/us_sdoh. NOTE "
        "ADDITIONNELLE (hors perimetre formule) : ce dataset presente le meme pattern de "
        "colonnes suffixees par annee (rent2002/2005/2008, kids2000..2008, hhsiz1990..08) "
        "que Python_geodatasets_geoda.chile_labor -- possible structure spatio-temporelle "
        "en format large non detectee, a verifier separement (Tache 2).")

# --- US county election ~ census demographics (Elections) ---
upgrade("Python_libpysal_Elections",
        "pct_gop_16~AGE775214+SEX255214+RHI125214+EDU685213+INC110213+PVY020213", "GWR/OLS",
        "R_GWmodel_USelect_USelect2004",
        "CANDIDAT PAR ANALOGIE -- non verifie. Meme domaine que USelect2004 (bon candidat, "
        "winner~unemploy+pctcoled+PEROVER65+pcturban+WHITE, GWR) : resultat electoral par "
        "comte US explique par des variables demographiques du recensement (age, sexe, race, "
        "education, revenu, pauvrete) -- ici les variables sont les codes US Census "
        "QuickFacts (RHI=race/hispanic, EDU=education, INC=revenu, PVY=pauvrete).")

# --- soil/geochemistry heavy metal regressions (gstat/ade4 family) ---
upgrade("R_gstat_jura_jura.pred",
        "log(Zn)~Landuse+Rock", "OLS",
        "R_gstat_meuse.all_meuse.all",
        "CANDIDAT PAR ANALOGIE -- non verifie (n'annule pas le statut principal : la methode "
        "publiee documentee reste le krigeage/cokrigeage, Goovaerts 1997). Meme domaine que "
        "meuse.all (bon candidat, log(zinc)~sqrt(dist)) : concentration en metal lourd "
        "expliquee par des covariables categorielles reelles du jeu (occupation du sol, "
        "geologie), disponible en complement de l'approche kriging officielle.")
upgrade("R_gstat_jura_jura.val",
        "log(Zn)~Landuse+Rock", "OLS",
        "R_gstat_meuse.all_meuse.all",
        "CANDIDAT PAR ANALOGIE -- non verifie (n'annule pas le statut principal : krigeage/"
        "cokrigeage, Goovaerts 1997, reste la methode publiee). Meme raisonnement que "
        "R_gstat_jura_jura.pred (jeu complementaire de validation).")
upgrade("R_ade4_tintoodiel_tintoodiel",
        "log(Zn)~SiO2+Al2O3+CaO+MgO+mud", "OLS",
        "R_gstat_meuse.all_meuse.all",
        "CANDIDAT PAR ANALOGIE -- non verifie. Meme domaine substantiel que meuse.all (bon "
        "candidat) : pollution en metaux lourds de sediments (estuaire Tinto-Odiel, Espagne) "
        "expliquee par la composition geochimique -- contrairement aux 17 autres jeux ade4 "
        "(ordination multivariee sans cible unique), celui-ci a une cible Y claire (metaux "
        "lourds) et des covariables geochimiques explicites, structure compatible avec une "
        "regression classique plutot qu'une ordination.")

# --- soil profile chemistry ~ elevation (oxford) ---
upgrade("R_gstat_oxford_oxford",
        "PH1~ELEV+LIME1", "GWR/OLS",
        "R_agridat_gartner.corn_gartner.corn",
        "CANDIDAT PAR ANALOGIE -- non verifie. Propriete de profil de sol expliquee par "
        "l'elevation et le chaulage -- meme logique geomorphologique que gartner.corn (bon "
        "candidat, yield~elevation, GWR) ou l'elevation est la covariable geomorphologique "
        "primaire d'une propriete agro-pedologique.")

# --- hedonic real estate (properties) ---
upgrade("R_spData_properties_properties",
        "price~size+age+dist_metro", "OLS",
        "Python_libpysal_Baltimore / spdata.boston / R_spData_house_house",
        "CANDIDAT PAR ANALOGIE -- non verifie. Structure hedonique directe (prix ~ surface, "
        "age, distance au metro) analogue a Baltimore/Boston/house (bons candidats hedoniques) "
        "-- ici les covariables sont deja les propres colonnes du jeu, pas besoin de les "
        "deviner, seule la mise en forme canonique manquait.")

# --- irishdata (ade4 exception) ---
upgrade("R_ade4_irishdata_irishdata",
        "sales~cow+other+pig+sheep+T0.10+T10.50+Tup50+town.pop", "OLS",
        "R_agridat_wallace.iowaland_wallace.iowaland",
        "CANDIDAT PAR ANALOGIE -- non verifie. Contrairement aux autres jeux ade4 (ordination "
        "multivariee sans cible unique), irishdata a une cible Y claire (ventes/consommation "
        "par comte) et des covariables socioeconomiques/agricoles explicites (tranches de "
        "revenu, cheptel, population urbaine) -- structure comparable a wallace.iowaland (bon "
        "candidat, valeur economique rurale ~ composition agricole).")

# --- world (Preston curve, literature-level, not a banque-internal analogy) ---
UPGRADES["R_spData_world_world"] = dict(
    status="candidat_par_analogie",
    formula="lifeExp~log(gdpPercap)",
    method="OLS (courbe de Preston)",
    evidence="analogie",
    source="Preston S.H. (1975), The changing relation between mortality and level of economic development, Population Studies 29(2):231-248",
    homolog=FINDINGS["R_spData_world_world"].get("homolog"),
    note=(
        "CANDIDAT PAR ANALOGIE -- non verifie sur ce jeu precis. Il ne s'agit pas d'une "
        "analogie avec un autre dataset de la banque, mais d'une relation canonique tres "
        "documentee dans la litterature demographique/econometrique (courbe de Preston, "
        "esperance de vie ~ log(PIB par habitant)) directement applicable a ce type de "
        "donnees pays (memes variables : lifeExp, gdpPercap). Non confirme specifiquement "
        "pour la version rnaturalearth/spData::world de ces variables."
    ),
)

# ---------------------------------------------------------------------
# Confirmed "no plausible analogy" -- keep status, append explicit note
# ---------------------------------------------------------------------

NO_ANALOGY_REVIEWED = [
    # geoda: PCTIME/business-establishment schema, no comparable domain in bons candidats
    "Python_geodatasets_geoda.charleston2", "Python_geodatasets_geoda.hickory2",
    "Python_geodatasets_geoda.lansing2",
    # tautological / already well-explained
    "Python_geodatasets_geoda.chicago_commpop", "Python_geodatasets_geoda.nepal",
    "Python_geodatasets_naturalearth.cities",
    "R_spDataLarge_pol_pres15_pol_pres15", "R_spData_nz_nz",
    "R_sp_meuse.grid_meuse.grid", "R_sp_meuse.grid_ll_meuse.grid_ll",
    # a_verifier already resolved / too thin / non comparable domain
    "Python_geodatasets_spdata.wheat", "Python_geodatasets_geoda.cincinnati",
    "R_spatstat.data_nbfires_nbfires",
    # ade4 -- confirmed ordination-only structure (16 remaining, 2 exceptions handled above)
    "R_ade4_atlas_atlas", "R_ade4_atya_atya", "R_ade4_avijons_avijons",
    "R_ade4_buech_buech", "R_ade4_butterfly_butterfly", "R_ade4_doubs_doubs",
    "R_ade4_elec88_elec88", "R_ade4_julliot_julliot", "R_ade4_jv73_jv73",
    "R_ade4_kcponds_kcponds", "R_ade4_macon_macon", "R_ade4_mafragh_mafragh",
    "R_ade4_pcw_pcw", "R_ade4_sarcelles_sarcelles", "R_ade4_t3012_t3012",
    "R_ade4_vegtf_vegtf", "R_ade4_zealand_zealand",
]

NO_ANALOGY_REASON = {
    "Python_geodatasets_geoda.charleston2": "PCTIME/etablissements d'entreprise par secteur -- aucun bon candidat de la banque ne couvre ce domaine (economie des etablissements/emploi sectoriel).",
    "Python_geodatasets_geoda.hickory2": "PCTIME/etablissements d'entreprise par secteur -- aucun bon candidat de la banque ne couvre ce domaine.",
    "Python_geodatasets_geoda.lansing2": "PCTIME/etablissements d'entreprise par secteur -- aucun bon candidat de la banque ne couvre ce domaine.",
    "Python_geodatasets_geoda.chicago_commpop": "Seule covariable X disponible (POP2000) est la version decalee de Y (POP2010) -- regression tautologique, pas de covariable substantielle.",
    "Python_geodatasets_geoda.nepal": "Le constat initial (variables invoquees absentes du fichier reel) est respecte par prudence ; ne pas reproposer une formule sur les memes bases sans revalidation independante.",
    "Python_geodatasets_naturalearth.cities": "Les X disponibles (scalerank, labelrank, min_zoom) sont des metadonnees de rendu cartographique, pas des covariables substantielles.",
    "R_spDataLarge_pol_pres15_pol_pres15": "Aucune covariable demographique independante disponible -- seules d'autres tallies electorales administratives (entitled_to_vote, voting_papers) sont presentes, regression circulaire.",
    "R_spData_nz_nz": "Seulement 2 covariables tres generiques (Land_area, Island) pour 16 observations -- base trop mince pour une analogie substantielle credible.",
    "R_sp_meuse.grid_meuse.grid": "Grille de prediction (covariables uniquement, pas de Y observe) -- pas un jeu de regression autonome par construction.",
    "R_sp_meuse.grid_ll_meuse.grid_ll": "Grille de prediction (covariables uniquement, pas de Y observe) -- pas un jeu de regression autonome par construction.",
    "Python_geodatasets_spdata.wheat": "Une seule covariable (lat1) ; le format covariance spatiale documente (Christensen & Eidsvik 2024) reste la reference, pas de regression covariable-riche alternative credible.",
    "Python_geodatasets_geoda.cincinnati": "Formule GWR deja documentee (WHITE~AGE_0_5+...) -- probleme de preuve (URL 404), pas d'absence de formule ; pas de nouvelle analogie necessaire.",
    "R_spatstat.data_nbfires_nbfires": "Taille de feu (continue, pas un comptage) expliquee par cause/type/origine -- aucun bon candidat de la banque ne couvre le risque incendie ; analogie aux modeles de comptage de maladies jugee trop superficielle (domaines non comparables).",
    "R_ade4_atlas_atlas": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique (composants multiples), pas de cible unique exploitable.",
    "R_ade4_atya_atya": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_avijons_avijons": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_buech_buech": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_butterfly_butterfly": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_doubs_doubs": "Confirme utile seulement pour ACP/RDA (pcaiv) -- pas de cible Y unique exploitable pour une regression classique.",
    "R_ade4_elec88_elec88": "Parts de vote par candidat (Mitterand/Le Pen en Y, autres candidats en X) -- donnees compositionnelles sommant a 100%, colinearite structurelle qui invalide une regression covariable classique.",
    "R_ade4_julliot_julliot": "Y = abondances de 7 especes d'arbres, aucune covariable environnementale identifiee -- table d'abondance ecologique typique ade4, pas de regression a cible unique exploitable.",
    "R_ade4_jv73_jv73": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_kcponds_kcponds": "Regression limnologique plausible en interne (chla~TP notamment) mais aucun bon candidat de la banque ne couvre les ecosystemes lacustres/etangs -- analogie externe jugee trop faible sans reference comparable dans la banque.",
    "R_ade4_macon_macon": "Colonnes anonymes a une lettre (a, b, c...w) sans documentation du sens reel des variables (degustation de vin, Foire de Macon 1985) -- impossible de juger la coherence substantielle d'une formule.",
    "R_ade4_mafragh_mafragh": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_pcw_pcw": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_sarcelles_sarcelles": "Y et X sont tous deux des comptages mensuels d'oiseaux (juste des mois differents) -- serie temporelle/mesures repetees, pas une structure de regression covariable classique.",
    "R_ade4_t3012_t3012": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_vegtf_vegtf": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
    "R_ade4_zealand_zealand": "Y/X non identifiables par le LLM -- structure de liste multivariee ade4 typique.",
}


def apply_no_analogy_notes():
    for did in NO_ANALOGY_REVIEWED:
        f = FINDINGS[did]
        reason = NO_ANALOGY_REASON.get(did, "")
        extra = f" Raison : {reason}" if reason else ""
        f["note"] = (f.get("note") or "n/a")
        if f["note"] in ("n/a", None):
            f["note"] = ""
        f["note"] = (f["note"] + NO_ANALOGY_SUFFIX + extra).strip()


def main():
    changed = []

    for did, upd in UPGRADES.items():
        if did not in FINDINGS:
            raise KeyError(did)
        FINDINGS[did].update(upd)
        changed.append(did)

    apply_no_analogy_notes()
    changed.extend(NO_ANALOGY_REVIEWED)

    print(f"Upgraded to candidat_par_analogie: {len(UPGRADES)}")
    print(f"Reviewed, no analogy (note appended): {len(NO_ANALOGY_REVIEWED)}")
    print(f"Total fiches to rewrite: {len(changed)}")

    errors = []
    for did in changed:
        path = PKG_DIR / f"{did}.md"
        try:
            apply_findings.process(path, FINDINGS[did])
        except Exception as exc:  # noqa: BLE001
            errors.append((did, str(exc)))

    print(f"OK: {len(changed) - len(errors)}/{len(changed)}")
    if errors:
        print("ERRORS:")
        for did, msg in errors:
            print(f"  {did}: {msg}")


if __name__ == "__main__":
    main()
