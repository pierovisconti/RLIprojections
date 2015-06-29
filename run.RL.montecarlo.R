##################################################
### Defining treatments ##########################
##################################################

#reads variables from arguments#####
eval(parse(text=commandArgs(TRUE)))#
####################################

setwd('/plx/userexternal/pviscont')
#filename# nb: INPUT FILES must be csv WITH header, FOLDERS without trailing '/'
ESH.IN     <- 'summaryAOOLifestylenodisp.csv'
EOO.IN     <- 'summaryEOOB1nodisp.csv'
TREATMENT    <- 'lifestyle' ## eg: 'baseline'
SUBTREATMENT <- 'nodisp' ## eg: 'maxdisp'
NUM.ITERATIONS <- 1

DENSITY.IN <- 'density_table.csv'
GENLEN.IN  <- 'gl_red_list_10.csv'
IN.SEP     <- ','
IN.FOLDER  <- paste(getwd(),'input',sep='/')

#input years in csv (columns x to the end)
inputyears <- c(1970,1980,1990,2000,2010,2020,2030,2040,2050)

SAVE.EOO   <- FALSE 
SAVE.AOO   <- FALSE 
SAVE.POP   <- FALSE 

OUT.NAME   <- paste(TREATMENT,SUBTREATMENT,sep='_')
OUT.FOLDER <- paste(getwd(),TREATMENT,SUBTREATMENT,sep='/')

dir.create(OUT.FOLDER,recursive=TRUE)

#ratio of ESH/AOO
if(exists('AOOADJ'))  {ESHtoAOOuse <- TRUE
                       ESHtoAOO <- AOOADJ} else {ESHtoAOO <- NA}
#ratio of provided_density/used_density
if(exists('DENSADJ')) {DENSADJuse <- TRUE
                       DENSADJ <- DENSADJ} else {DENSADJ <- NA}


##sets output name for montecarlo runs##
OUT.NAME   <- paste(TREATMENT,SUBTREATMENT,ITER,sep='_')

#############
#run callall#
#############
print('')
print(paste('Montecarlo run:    ',ITER))
print(paste('AOO adjustmnent:   ',AOOADJ))
print(paste('Density adjustment:',DENSADJ))
source('callall.R')
print('')

#############
#  The End  #
#############
