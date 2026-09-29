library(sf)
library(jsonlite)
b <- 'data/raw/papers/DatasetFirst_10_6078_d15x4n/sites_extract'
a <- lapply(c('Closed','Open'),function(z) st_drop_geometry(st_read(file.path(b,paste0(z,'Sites_Kh1_SLR1m_RGWorInund.shp')),quiet=TRUE)))
for(i in 1:2){cat(c('Closed','Open')[i],nrow(a[[i]]),'unique FID',length(unique(a[[i]]$FID_DTSC_S)),'\n');print(table(a[[i]]$gridcode));print(head(a[[i]][,c('FID_DTSC_S','STATUS','LATITUDE','LONGITUDE')]))}
common <- intersect(a[[1]]$FID_DTSC_S,a[[2]]$FID_DTSC_S);cat('common IDs',length(common),'\n')
d<-readRDS('data/final_datasets/sf/paper_sfbay_contaminated_sites.rds'); print(table(d$is_open_case,d$gridcode));print(table(d$is_open_case));print(sapply(d,function(v)paste(class(v),collapse='/')))
d<-readRDS('data/final_datasets/sf/paper_li_energy_price_co2_china.rds');print(table(d$year));print(sapply(st_drop_geometry(d)[c('CO2','EP','POP','PGDP','INS','URB','RFDI','TEC','EDU','ENS')],function(v)sum(!is.finite(v)|v<=0)))
