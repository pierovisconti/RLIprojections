##################################################
### Defining treatments ##########################
##################################################

###
###################################################################3CORRECTIONS MADE BY PIERO SCRIPTS DANIELE. ################################################################

#- FUNCTIONS THAT READ IN INPUT PARAMETERS AND CALL SCRIPTS FOR APPLYING RED LIST CRITERIA AND RETURN RL STATUS FOR ALL YEARS IN THE DATASET

############## THIS USES SPLINEFUN TO INTERPOLATE ##############

#filename# nb: INPUT FILES must be csv WITH header, FOLDERS without trailing '/'
#ESH.IN     <- 'AOOtest.csv'
#EOO.IN     <- 'EOOtest.csv'
#DENSITY.IN <- 'Density.csv'
#GENLEN.IN  <- 'GenLenTest.csv'

#IN.SEP     <- ','
#IN.FOLDER  <- '/home/piero/RL2050/input'

#OUT.NAME   <- 'lifestyle_test'
#OUT.FOLDER <- '/home/piero/RL2050/output'
#SAVE.EOO   <- TRUE
#SAVE.AOO   <- TRUE
#SAVE.POP   <- TRUE

#ratio of ESH/AOO
#ESHtoAOOuse <- FALSE
#if(ESHtoAOOuse) {ESHtoAOO <- 0.25} else {ESHtoAOO <- NA}

#ratio of provided_density/used_density
#DENSADJuse <- FALSE
#if(DENSADJuse) {DENSADJ <- 0.1} else {DENSADJ <- NA}

#input years in csv (columns x to the end)
#inputyears <- c(1970,1980,1990,2000,2010,2020,2030,2040,2050)

##################################################
### Printing treatments ##########################
##################################################
if(ESHtoAOOuse) {print(paste('ESH to AOO ratio is set to',ESHtoAOO))} else{print('ESH to AOO ratio is set to 1')} 
if(DENSADJuse) {print(paste('provided_density to used_density ratio is set to',DENSADJ))} else{print('provided_density to used_density ratio is set to 1')}

##################################################
### Base data ####################################
##################################################
print('Loading Base Data')

BASE_ESH <- read.csv(paste(IN.FOLDER,'/',ESH.IN,sep=''),sep=IN.SEP)
BASE_ESH <- BASE_ESH[sort.list(BASE_ESH[,1]),]
BASE_EOO <- read.csv(paste(IN.FOLDER,'/',EOO.IN,sep=''),sep=IN.SEP)
BASE_EOO <- BASE_EOO[sort.list(BASE_EOO[,1]),]

print(ncol(BASE_ESH))
print(ncol(BASE_EOO))
#taxonomy    <- read.csv('/home/daniele/R/RL2050/csv/taxonomy.csv') ## REMOVE
#genlentable <- read.csv('/home/daniele/R/RL2050/csv/gl_red_list_10.csv')
genlentable <- read.csv(paste(IN.FOLDER,'/',GENLEN.IN,sep=''),sep=IN.SEP)
for(rownumber in 1:nrow(genlentable)) {if(genlentable[rownumber,2]*3>10) genlentable[rownumber,2] <- (genlentable[rownumber,2]*3) else genlentable[rownumber,2] <- 10} #corrects genlentable to 10 or 3*genlen
rm(rownumber)
densitytable <- read.csv(paste(IN.FOLDER,'/',DENSITY.IN,sep=''),sep=IN.SEP)


allyears   <- seq((min(inputyears)),(max(inputyears)))
totalyears <- max(inputyears)-min(inputyears)+1

####################
## ERROR messages ##
####################
if(nrow(BASE_EOO)!=nrow(BASE_ESH)) {stop('ERROR: EOO and ESH files have different number of species!')}

if(ncol(BASE_EOO)!=ncol(BASE_ESH)) {stop('ERROR: EOO and ESH files have different number of years!')}

if(!identical(BASE_EOO[,1],BASE_ESH[,1])) {stop('ERROR: EOO and ESH species are not the same!')}

if((ncol(BASE_EOO)-1)!=length(inputyears)) {stop('ERROR: Number of years in input files does not match "inputyears" vector')}

##################################################
### Density treatment ############################
##################################################
print('Defining density treatment')

if(DENSADJuse) {densitytable <- as.data.frame(cbind(densitytable[,1],densitytable[,2]*DENSADJ))}

###################################################
### ESH to AOO ratio ##############################
###################################################
print('Calculating AOO from ESH and ESH-AOO ratio')
if(ESHtoAOOuse) {BASE_AOO <- cbind(BASE_ESH[,1],BASE_ESH[,2:ncol(BASE_ESH)]*ESHtoAOO)} else {BASE_AOO <- BASE_ESH}

###################################################
### Interpolating AOO and EOO #####################
###################################################
#interpolates EOO
print('Interpolating EOO')
BASE_EOO_interp <- NULL
for(EOO.rownum in 1:nrow(BASE_EOO)) {
    EOO.spline.f <- splinefun(inputyears,BASE_EOO[EOO.rownum,2:ncol(BASE_EOO)],method='monoH.FC')
    EOO.new_line <- c(BASE_EOO[EOO.rownum,1],
                      list(x=allyears, y=EOO.spline.f(allyears))$y)
    BASE_EOO_interp <- rbind(BASE_EOO_interp,EOO.new_line)}
rm(EOO.spline.f)
rm(EOO.rownum)
rm(EOO.new_line)
colnames(BASE_EOO_interp) <- c("taxid",allyears)
#interpolates AOO
print('Interpolating AOO')
BASE_AOO_interp <- NULL
for(AOO.rownum in 1:nrow(BASE_AOO)) {
  AOO.spline.f <- splinefun(inputyears,BASE_AOO[AOO.rownum,2:ncol(BASE_AOO)],method='monoH.FC')
  AOO.new_line <- c(BASE_AOO[AOO.rownum,1],
                    list(x=allyears, y=AOO.spline.f(allyears))$y)
  BASE_AOO_interp <- rbind(BASE_AOO_interp,AOO.new_line)}
rm(AOO.spline.f)
rm(AOO.rownum)
rm(AOO.new_line)
colnames(BASE_AOO_interp) <- c("taxid",allyears)

##TRANSFORMS AOO Km2 to Number
print('Calculating population size from AOO and densitytable')
BASE_NUM_interp <- BASE_AOO_interp
for(NUM.rownum in seq(1,nrow(BASE_NUM_interp))) {
    NUM.taxid <- BASE_NUM_interp[NUM.rownum,1]
    if(is.element(NUM.taxid,densitytable[,1])) {NUM.density <- densitytable[densitytable[,1]==NUM.taxid,2]} else {NUM.density <- NA}

    for(NUM.colnum in seq(2,ncol(BASE_NUM_interp))) {
        BASE_NUM_interp[NUM.rownum,NUM.colnum] <- BASE_NUM_interp[NUM.rownum,NUM.colnum]*NUM.density
        }
    rm(NUM.taxid)
    rm(NUM.density)
}
rm(NUM.rownum)
rm(NUM.colnum)

######################
#saving EOO, AOO, pop#
######################
if(SAVE.EOO) {
print('Writing EOO table')
write.table(BASE_EOO_interp,file=paste(OUT.FOLDER,'/','EOO.csv',sep=''),sep=",",row.names=F,na='')}

if(SAVE.AOO) {
print('Writing AOO table')
write.table(BASE_AOO_interp,file=paste(OUT.FOLDER,'/','AOO.csv',sep=''),sep=",",row.names=F,na='')}

if(SAVE.POP) {
print('Writing population size table')
write.table(BASE_NUM_interp,file=paste(OUT.FOLDER,'/','population.size.csv',sep=''),sep=",",row.names=F,na='')}

#######################
#Informing RL criteria#
#######################

print('Applying crit. A2aoo')
source('RL2050.A2aoo.R')
write.table(A2_AOO_interp_rl,file=paste(OUT.FOLDER,'/',OUT.NAME,'.A2aoo.rl.csv',sep=''),sep=",",row.names=F,na='')

print('Applying crit. A2eoo')
source('RL2050.A2eoo.R')
write.table(A2_AOO_interp_rl,file=paste(OUT.FOLDER,'/',OUT.NAME,'.A2eoo.rl.csv',sep=''),sep=",",row.names=F,na='')


print('Applying crit. B1')
source('RL2050.B1.R')
write.table(B1_AOO_interp_rl,file=paste(OUT.FOLDER,'/',OUT.NAME,'.B1.rl.csv',sep=''),sep=",",row.names=F,na='')

print('Applying crit. B2')
source('RL2050.B2.R')
write.table(B2_AOO_interp_rl,file=paste(OUT.FOLDER,'/',OUT.NAME,'.B2.rl.csv',sep=''),sep=",",row.names=F,na='')

print('Applying crit. C1')
source('RL2050.C1.R')
write.table(C1_NUM_interp_rl,file=paste(OUT.FOLDER,'/',OUT.NAME,'.C1.rl.csv',sep=''),sep=",",row.names=F,na='')

print('Applying crit. D1')
source('RL2050.D1.R')
write.table(D1_NUM_interp_rl,file=paste(OUT.FOLDER,'/',OUT.NAME,'.D1.rl.csv',sep=''),sep=",",row.names=F,na='')

###################
## Final Cleanup ##
###################

#deletes all elements NOT in the specified vector
#rm(list=setdiff(c('ESH.IN','EOO.IN','DENSITY.IN','GENLEN.IN','IN.SEP','IN.FOLDER','OUT.NAME','OUT.FOLDER','SAVE.EOO','SAVE.AOO','SAVE.POP','ESHtoAOOuse','ESHtoAOO','DENSADJuse','DENSADJ','inputyears'),ls()))

#############
#  The End  #
#############
