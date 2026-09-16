source('code/r_catalog/build_sf_datasets_papers.R')
p <- 'data/final_datasets/sf/paper_harbour_porpoise_response.rds'
b <- 'data/interim/dataset_review_2026-09-09/paper_harbour_porpoise_response_before.rds'
if(!file.exists(b)) stopifnot(file.copy(p,b))
a<-convert_paper_dataset('harbour_porpoise_response')
stopifnot(nrow(a$sf)==722)
library(lme4)
d<-st_drop_geometry(a$sf);d$loc_pod<-paste(d$location,d$pod,sep='_')
results<-list()
for(h in c(24,12)) {
 x<-d[d$turbine!='D11' & !is.na(d[[paste0('base',h)]]) & d[[paste0('base',h)]]>0 & !is.na(d[[paste0('dph',h)]]),]
 x$zorder<-as.numeric(scale(x$piling_order));x$zvessels_1km<-as.numeric(scale(x$vessels24_1km));x$zvessels_500<-as.numeric(scale(x$vessels12_500m));x$zASS_SEL<-as.numeric(scale(x$Aud_SS_SEL))
 forms<-if(h==24) c(a='resp24_50~log(distance)*zorder+zvessels_1km+(1|loc_pod)',b='resp24_50~zASS_SEL*zorder+zvessels_1km+(1|loc_pod)') else c(c='resp12_50~log(distance)*zorder+ADD+zvessels_500+(1|loc_pod)')
 for(key in names(forms)){fit<-glmer(as.formula(forms[[key]]),data=x,family=binomial(link='probit'));results[[key]]<-list(n=nobs(fit),formula=forms[[key]],aic=AIC(fit),coefficients=fixef(fit));cat(key,nobs(fit),AIC(fit),'\n')}
}
jsonlite::write_json(results,'tmp/dataset_review_2026-09-09/harbour_replication.json',auto_unbox=TRUE,pretty=TRUE)
stopifnot(abs(results$a$aic-619.4)<.1,abs(results$b$aic-621)<.1,abs(results$c$aic-653.4)<.1)
