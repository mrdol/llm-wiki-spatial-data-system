library(sf)
d<-readRDS('data/final_datasets/sf/paper_harbour_porpoise_response.rds')
raw<-read.csv('data/raw/papers/DataCite_2019_HarbourPorpoiseResponsesTo_10_1098_rsos_190/Graham_BOWL_cMMMP_Porpoise_responses_to_construction_data_2019-05-01.csv')
for(obj in list(raw,st_drop_geometry(d))){for(h in c(24,12)){x<-obj[obj$turbine!='D11' & !is.na(obj[[paste0('base',h)]]) & obj[[paste0('base',h)]]>0 & !is.na(obj[[paste0('dph',h)]]),]; cat('rows',nrow(obj),'hour',h,'filtered',nrow(x),'groups',length(unique(paste(x$location,x$pod))),'\n')}}
cat('lme4 installed',requireNamespace('lme4',quietly=TRUE),'\n')
d<-readRDS('data/final_datasets/sf/paper_no2_aqs_state_25_2016_monitor_covariates.rds');print(table(d$measurement_column));print(sapply(st_drop_geometry(d)[c('nlcd_developed','nlcd_forest','nlcd_agriculture','nlcd_water','nlcd_land_cover_code')],function(x)length(unique(x))))
