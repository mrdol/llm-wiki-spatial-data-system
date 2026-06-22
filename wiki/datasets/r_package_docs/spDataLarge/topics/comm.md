Rdocumentation
powered by

Search all packages and functions
spDataLarge (version 2.2.0)

comm: Community matrix of the Mt. Mongón

Community matrix of the Mt. Mongón

Description

     A community matrix with species as columns and sites as rows.  The
     rownames correspond to the id which can be also found in
     [random_points]. Please note that in fact 100 sites have been
     visited but in 16 of them no species could be found (see again
     [random_points]). The data is used in the "Ecology" chapter in
     Geocomputation with R. See <https://r.geocompx.org/eco.html> for
     details.

Format

     A dataframe with 100 sites (rows) and 69 species (columns).
     Species presence is given in percentage points (between 0-100
     site). Due to overlapping cover between individual plants, the
     total cover per site can be >100%.

References

     Muenchow, J., Bräuning, A., Rodríguez, E.F. & von Wehrden, H.
     (2013): Predictive mapping of species richness and plant species'
     distributions of a Peruvian fog oasis along an altitudinal
     gradient.  Biotropica 45, 5, 557-566, doi: 10.1111/btp.12049.


Variables detected from installed object

Alon_meri: numeric ; missing=0 ; examples=0

Alst_line: numeric ; missing=0 ; examples=0

Alte_hali: numeric ; missing=0 ; examples=0

Alte_porr: numeric ; missing=0 ; examples=0

Anth_eccr: numeric ; missing=0 ; examples=0

Apod_ferr: numeric ; missing=0 ; examples=0

Atri_rotu: numeric ; missing=0 ; examples=0

Bacc_line: numeric ; missing=0 ; examples=0

Bego_acut: numeric ; missing=0 ; examples=0

Bego_spec: numeric ; missing=0 ; examples=0

Bowl_palm: numeric ; missing=0 ; examples=0

Brom_spec: numeric ; missing=0 ; examples=0

Caes_spin: numeric ; missing=0 ; examples=0

Cala_alba: numeric ; missing=0 ; examples=0

Calc_pinn: numeric ; missing=0 ; examples=0

Chen_peti: numeric ; missing=0 ; examples=0

Chio_bent: numeric ; missing=0 ; examples=0

Cicl_laci: numeric ; missing=0 ; examples=0

Cist_ling: numeric ; missing=0 ; examples=0.019, 0, 0.125

Cist_pani: numeric ; missing=0 ; examples=0.5

Comm_fasc: numeric ; missing=0 ; examples=0

Cras_conn: numeric ; missing=0 ; examples=0

Crem_parv: numeric ; missing=0 ; examples=0

Crot_alni: numeric ; missing=0 ; examples=0

Cycl_math: numeric ; missing=0 ; examples=0

Cycl_spec: numeric ; missing=0 ; examples=0

Drym_cord: numeric ; missing=0 ; examples=0

Erod_spec: numeric ; missing=0 ; examples=0

Euph_viri: numeric ; missing=0 ; examples=0

Exod_pros: numeric ; missing=0 ; examples=0

Fuer_chil: numeric ; missing=0 ; examples=0

Fuer_lime: numeric ; missing=0 ; examples=0.013, 0.006, 0

Haag_paca: numeric ; missing=0 ; examples=0

Hoff_pros: numeric ; missing=0 ; examples=0

Ipom_purp: numeric ; missing=0 ; examples=0

Ipom_spec: numeric ; missing=0 ; examples=0

Jalt_loma: numeric ; missing=0 ; examples=0

Lant_scab: numeric ; missing=0 ; examples=0

Lyci_lyci: numeric ; missing=0 ; examples=0

Ment_cord: numeric ; missing=0 ; examples=0

Nasa_uren: numeric ; missing=0 ; examples=0

Nico_pani: numeric ; missing=0 ; examples=0

Nico_spec: numeric ; missing=0 ; examples=0

Nola_humi: numeric ; missing=0 ; examples=0.013, 0.019, 0

Ophr_peru: numeric ; missing=0 ; examples=0

Oxal_corn: numeric ; missing=0 ; examples=0

Oxal_mega: numeric ; missing=0 ; examples=0

Oxal_spec: numeric ; missing=0 ; examples=0

Pala_spec: numeric ; missing=0 ; examples=0

Pari_debi: numeric ; missing=0 ; examples=0

Pele_matu: numeric ; missing=0 ; examples=0

Pepe_spec: numeric ; missing=0 ; examples=0

Phil_peru: numeric ; missing=0 ; examples=0

Pros_pall: numeric ; missing=0 ; examples=0

Puya_ferr: numeric ; missing=0 ; examples=0

Puya_spec: numeric ; missing=0 ; examples=0

Quin_brev: numeric ; missing=0 ; examples=0

Salv_spec: numeric ; missing=0 ; examples=0

Sene_trux: numeric ; missing=0 ; examples=0

Sicy_bade: numeric ; missing=0 ; examples=0

Sola_mont: numeric ; missing=0 ; examples=0, 0.125

Sola_mult: numeric ; missing=0 ; examples=0

Sola_peru: numeric ; missing=0 ; examples=0

Sola_phyl: numeric ; missing=0 ; examples=0, 0.031

Sonc_olea: numeric ; missing=0 ; examples=0

Tigr_gran: numeric ; missing=0 ; examples=0

Till_purp: numeric ; missing=0 ; examples=0

Trop_pelt: numeric ; missing=0 ; examples=0

unkn_Malv: numeric ; missing=0 ; examples=0

Examples
Run this code

     data("comm", package = "spDataLarge")

