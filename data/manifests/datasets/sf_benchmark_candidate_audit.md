# SF Benchmark Candidate Audit

- RDS inspected: 377
- Package-ready already: 31
- Non-ready with 4/4 local evidence: 19
- Non-ready with 3/4 local evidence: 35

## Priority Candidates

| Dataset | Level | N | Y | X count | Missing / blockers |
|---|---|---:|---|---:|---|
| `paper_waste_site` | 4_of_4 | 727 | `elas` | 26 |  |
| `paper_wald_test` | 4_of_4 | 1428 | `change` | 17 |  |
| `paper_teles_decapod_biodiversity_brazil` | 4_of_4 | 160 | `SR` | 33 |  |
| `paper_spruce_bark_beetle` | 4_of_4 | 1731 | `trapcounts` | 7 |  |
| `paper_rocky_mountain_tree_growth` | 4_of_4 | 771 | `mean_ring_width_mm` | 8 |  |
| `paper_rocha_agricultural_technology_brazil` | 4_of_4 | 5507 | `SOY` | 33 |  |
| `paper_possum_body_size` | 4_of_4 | 588 | `CBL` | 18 |  |
| `paper_pm25_aqs_state_25_2016_monitor_covariates` | 4_of_4 | 18 | `pm25_mean_2016` | 10 |  |
| `paper_pallid_bat` | 4_of_4 | 182 | `centroid_size` | 3 |  |
| `paper_o3_aqs_state_25_2016_monitor_covariates` | 4_of_4 | 16 | `o3_mean_2016` | 10 |  |
| `paper_no2_aqs_state_25_2016_monitor_covariates` | 4_of_4 | 10 | `no2_mean_2016` | 10 |  |
| `paper_metacomnet` | 4_of_4 | 9594 | `Number` | 12 |  |
| `paper_medicago` | 4_of_4 | 8297 | `richness` | 14 |  |
| `paper_marrot_spatial_autocorrelation_fitness` | 4_of_4 | 229 | `Number_of_fledglings` | 3 |  |
| `paper_mammals_sr_pd` | 4_of_4 | 17151 | `SR` | 25 |  |
| `paper_florida_crash_gsvcm` | 4_of_4 | 11249 | `Offcrsh` | 6 |  |
| `paper_ethiopia_clusters` | 4_of_4 | 7 | `RR` | 4 |  |
| `paper_cluster_detection` | 4_of_4 | 616 | `y_response_simulated` | 1 |  |
| `paper_biomass_rainforest` | 4_of_4 | 1335 | `AGB_mean` | 7 |  |
| `R_spData_properties_properties` | 3_of_4 | 1000 | `price` | 3 | estimator_evidence_missing |
| `R_spData_house_house` | 3_of_4 | 25357 | `price` | 14 | estimator_evidence_missing |
| `R_spData_baltimore_baltimore` | 3_of_4 | 211 | `PRICE` | 9 | estimator_evidence_missing |
| `R_spatstat.data_nbfires_nbfires` | 3_of_4 | 7108 | `fnl.size` | 6 | estimator_evidence_missing |
| `R_SpatialEpi_pennLC_sf_pennLC_sf` | 3_of_4 | 1072 | `cases` | 5 | estimator_evidence_missing |
| `R_spaMM_Leuca_Leuca` | 3_of_4 | 156 | `fec_div` | 5 | estimator_evidence_missing |
| `R_spaMM_blackcap_blackcap` | 3_of_4 | 14 | `migStatus` | 1 | estimator_evidence_missing |
| `R_sp_meuse.grid_meuse.grid` | 3_of_4 | 3103 | `dist` | 4 | estimator_evidence_missing |
| `R_sp_meuse.grid_ll_meuse.grid_ll` | 3_of_4 | 3103 | `dist` | 4 | estimator_evidence_missing |
| `R_sfdep_guerry_nb_guerry_nb` | 3_of_4 | 85 | `crime_pers` | 12 | estimator_evidence_missing |
| `R_mgwrsar_mydatasf_mydatasf` | 3_of_4 | 1403 | `price` | 3 | estimator_evidence_missing |
| `R_mgwrsar_mydata_mydata` | 3_of_4 | 1000 | `Y_mgwrsar_0_kc_kv` | 15 | estimator_evidence_missing |
| `R_gstat_jura_jura.val` | 3_of_4 | 100 | `Cd` | 8 | estimator_evidence_missing |
| `R_gstat_DE_RB_2005_DE_RB_2005` | 3_of_4 | 23230 | `PM10` | 5 | estimator_evidence_missing |
| `R_agridat_wallace.iowaland_wallace.iowaland` | 3_of_4 | 99 | `fedval` | 4 | estimator_evidence_missing |
| `R_agridat_gartner.corn_gartner.corn` | 3_of_4 | 4949 | `mass` | 4 | estimator_evidence_missing |
| `paper_trillium_presence_background` | 3_of_4 | 13557 | `presence` | 6 | response_y_missing_or_not_regression_usable |
| `paper_regulatory_convergence` | 3_of_4 | 2972 | `net_bcbs` | 2261 | response_y_missing_or_not_regression_usable |
| `paper_maipo` | 3_of_4 | 7713 | `croptype` | 52 | response_y_missing_or_not_regression_usable |
| `paper_ethiopia_whitetailed_swallow_sdm` | 3_of_4 | 810 | `pa` | 5 | response_y_missing_or_not_regression_usable |
| `paper_ethiopia_bushcrow_sdm` | 3_of_4 | 4826 | `pa` | 5 | response_y_missing_or_not_regression_usable |
| `paper_eberg` | 3_of_4 | 3670 | `TAXGRSC` | 13 | response_y_missing_or_not_regression_usable |
| `paper_crane` | 3_of_4 | 12630 | `mark` | 4 | response_y_missing_or_not_regression_usable |
| `paper_coral_stylaster` | 3_of_4 | 448 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_solenosmilia` | 3_of_4 | 828 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_primnoa` | 3_of_4 | 232 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_paragorgia` | 3_of_4 | 406 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_madrepora` | 3_of_4 | 496 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_leiopathes` | 3_of_4 | 378 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_isididae` | 3_of_4 | 1036 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_goniocorella` | 3_of_4 | 1290 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_errina` | 3_of_4 | 472 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_enallopsammia` | 3_of_4 | 598 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_corallium` | 3_of_4 | 196 | `pa` | 12 | response_y_missing_or_not_regression_usable |
| `paper_coral_bathypathes` | 3_of_4 | 390 | `pa` | 14 | response_y_missing_or_not_regression_usable |
