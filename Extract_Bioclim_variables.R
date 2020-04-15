## for extracting Bioclim variables and elevation values from spatial coordinates of Arabidopsis 1001 genome accessions

# used to extract Bioclim variables for accessions described in James et al. 2018 Plant Cell & Environ 41(7): 1524-1538)

library(sp)
library(raster)
library(dismo)
library(rgdal)
library(gtools)
library(rasterVis)
library(maptools)
library(rgeos)

## prepare accession data to project onto map
# a dataset (WRLDacc_forBioclim) with 932 accessions without Bioclim variables
# this dataframe has simple spatial coordinates as lat and long
WRLDacc_forBioclim<-read.csv('LHY SNP WRLD dataset for Bioclim.csv',header=TRUE)


# first subset to get 3 columns
WRLDlocs<-subset(WRLDacc_forBioclim,select=c("country","long","lat"))


# and then just the longitude and latitude numbers
coordinates(WRLDlocs)<-c("long","lat")

# test plot of non-spatial data points
# plot(WRLDlocs)


## to make the data explicitly spatial
# define the geographical projection : PROJ.4 description at http://www.spatialreference.org/

crs.geo<-CRS("+proj=longlat +ellps=WGS84 +datum=WGS84") # geographical, datum WGS84

# proj4string(WRLDlocs)<-crs.geo
proj4string(WRLDlocs)<-crs.geo

# define latitude and longitude for the world map
newextW<-c(-125,140,15,70)

## This example extracts the BIO1 variable and the elevation variable and adds the data as new columns to the original dataset

# load Bioclimatic variables (e.g. bio 2.5m) from https://worldclim.org/data/worldclim21.html
# save .bil files locally on computer
# make sure the header .hdr files are are stored together with the .bil files
# https://stackoverflow.com/questions/34074126/raster-package-in-r-not-recognizing-a-bil-file

## e.g. defining the bioclimatic raster layers:
## BIO1 Annual Mean Temperature
BIO1_tAmeanT<-raster('bio1.bil')

# make sure file is read, should return TRUE
# file.exists('bio1.bil')

BIO1_tAmeanT.W<-crop(BIO1_tAmeanT,newextW)
WRLDacc_forBioclim$BIO1<-extract(BIO1_tAmeanT.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO2 Annual Mean Diurnal Range
# BIO2_tmeanDR<-raster('/Users/Allan/Extract_Bioclim_variables/bio2.bil')
# BIO2_tmeanDR.W<-crop(BIO2_tmeanDR,newextW)
# WRLDacc_forBioclim$BIO2<-extract(BIO2_tmeanDR.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO3 Isothermality
# BIO3_IsoT<-raster('/Users/Allan/Extract_Bioclim_variables/bio3.bil')
# BIO3_IsoT.W<-crop(BIO3_IsoT,newextW)
# WRLDacc_forBioclim$BIO3<-extract(BIO3_IsoT.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO4 Temperature Seasonality
# BIO4_tSeason<-raster('/Users/Allan/Extract_Bioclim_variables/bio4.bil')
# BIO4_tSeason.W<-crop(BIO4_tSeason,newextW)
# WRLDacc_forBioclim$BIO4<-extract(BIO4_tSeason.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO5 Max Temperature of Warmest Month
# BIO5_tmaxWarmM<-raster('/Users/Allan/Extract_Bioclim_variables/bio5.bil')
# BIO5_tmaxWarmM.W<-crop(BIO5_tmaxWarmM,newextW)
# WRLDacc_forBioclim$BIO5<-extract(BIO5_tmaxWarmM.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO6 Min Temperature of Coldest Month
# BIO6_tminColdM<-raster('/Users/Allan/Extract_Bioclim_variables/bio6.bil')
# BIO6_tminColdM.W<-crop(BIO6_tminColdM,newextW)
# WRLDacc_forBioclim$BIO6<-extract(BIO6_tminColdM.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO7 Annual Temperature Range
# BIO7_tAR<-raster('/Users/Allan/Extract_Bioclim_variables/bio7.bil')
# BIO7_tAR.W<-crop(BIO7_tAR,newextW)
# WRLDacc_forBioclim$BIO7<-extract(BIO7_tAR.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO8 Mean Temperature of Wettest Quarter
# BIO8_tmeanWetQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio8.bil')
# BIO8_tmeanWetQ.W<-crop(BIO8_tmeanWetQ,newextW)
# WRLDacc_forBioclim$BIO8<-extract(BIO8_tmeanWetQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO9 Mean Temperature of Driest Quarter
# BIO9_tmeanDryQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio9.bil')
# BIO9_tmeanDryQ.W<-crop(BIO9_tmeanDryQ,newextW)
# WRLDacc_forBioclim$BIO9<-extract(BIO9_tmeanDryQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO10 Mean Temperature of Warmest Quarter
# BIO10_tmeanWarmQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio10.bil')
# BIO10_tmeanWarmQ.W<-crop(BIO10_tmeanWarmQ,newextW)
# WRLDacc_forBioclim$BIO10<-extract(BIO10_tmeanWarmQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO11 Mean Temperature of Coldest Quarter
# BIO11_tmeanColdQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio11.bil')
# BIO11_tmeanColdQ.W<-crop(BIO11_tmeanColdQ,newextW)
# WRLDacc_forBioclim$BIO11<-extract(BIO11_tmeanColdQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO12 Annual Precipitation
# BIO12_annP<-raster('/Users/Allan/Extract_Bioclim_variables/bio12.bil')
# BIO12_annP.W<-crop(BIO12_annP,newextW)
# WRLDacc_forBioclim$BIO12<-extract(BIO12_annP.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO13 Precipitation of Wettest Quarter
# BIO13_pWetQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio13.bil')
# BIO13_pWetQ.W<-crop(BIO13_pWetQ,newextW)
# WRLDacc_forBioclim$BIO13<-extract(BIO13_pWetQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO14 Precipitation of Driest Month
# BIO14_pDryQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio14.bil')
# BIO14_pDryQ.W<-crop(BIO14_pDryQ,newextW)
# WRLDacc_forBioclim$BIO14<-extract(BIO14_pDryQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO15 Precipitation Seasonality
# BIO15_pSeason<-raster('/Users/Allan/Extract_Bioclim_variables/bio15.bil')
# BIO15_pSeason.W<-crop(BIO15_pSeason,newextW)
# WRLDacc_forBioclim$BIO15<-extract(BIO15_pSeason.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO16 Precipitation of Wettest Quarter
# BIO16_pWetQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio16.bil')
# BIO16_pWetQ.W<-crop(BIO16_pWetQ,newextW)
# WRLDacc_forBioclim$BIO16<-extract(BIO16_pWetQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO17 Precipitation of Driest Quarter
# BIO17_pDryQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio17.bil')
# BIO17_pDryQ.W<-crop(BIO17_pDryQ,newextW)
# WRLDacc_forBioclim$BIO17<-extract(BIO17_pDryQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO18 Precipitation of Warmest Quarter
# BIO18_pWarmQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio18.bil')
# BIO18_pWarmQ.W<-crop(BIO18_pWarmQ,newextW)
# WRLDacc_forBioclim$BIO18<-extract(BIO18_pWarmQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## BIO19 Precipitation of Coldest Quarter
# BIO19_pColdQ<-raster('/Users/Allan/Extract_Bioclim_variables/bio19.bil')
# BIO19_pColdQ.W<-crop(BIO19_pColdQ,newextW)
# WRLDacc_forBioclim$BIO19<-extract(BIO19_pColdQ.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

## and for elevation
# https://pakillo.github.io/R-GIS-tutorial/#elevation

elevation<-getData("worldclim",var="alt",res=2.5,)

# after https://pakillo.github.io/R-GIS-tutorial/#elevation
# crop based on map boundaries defined in newextW

elevation.W<-crop(elevation,newextW)
WRLDacc_forBioclim$elevation<-extract(elevation.W,WRLDlocs,method='simple',buffer=5000,fun=mean)

write.csv(WRLDacc_forBioclim,"WRLDacc_BioClim.csv",row.names=FALSE)
