library(sf)
b <- 'data/raw/papers/DatasetFirst_10_6078_d15x4n/sites_extract'
for(z in c('Closed','Open')){d<-st_read(file.path(b,paste0(z,'Sites_Kh1_SLR1m_RGWorInund.shp')),quiet=TRUE);cat(z,'\n'); print(names(d)); print(head(sort(table(d$FID_DTSC_S),decreasing=TRUE),3));print(st_crs(d)$epsg);print(st_geometry_type(d)[1]); print(head(st_drop_geometry(d[d$FID_DTSC_S==-1,]),2))}
