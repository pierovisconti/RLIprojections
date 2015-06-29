##RED LIST for criterion B2
B2_AOO_interp_rl <- BASE_AOO_interp
for(B2.rownum in seq(1,nrow(B2_AOO_interp_rl)))
{
  for(B2.colnum in seq(2,ncol(B2_AOO_interp_rl)))
  {
    B2.AOO <- BASE_AOO_interp[B2.rownum,B2.colnum]

    ##sets BoolWindow and adapts it - decline is defined as net decline since the previous decade
    if(B2.colnum < 12) {B2.BoolWindow <- B2.colnum-2} else {B2.BoolWindow <- 10}
    ##sets BoolDecline to 1 if there has been decline - Decline is true or false in each decade as a constant
    if(BASE_EOO_interp[B2.rownum,B2.colnum-B2.BoolWindow] == 0 |
       BASE_AOO_interp[B2.rownum,B2.colnum-B2.BoolWindow] == 0) {B2.BoolDecline <- FALSE} else {
           if(BASE_EOO_interp[B2.rownum,B2.colnum]/BASE_EOO_interp[B2.rownum,B2.colnum-B2.BoolWindow] <= 0.99 |
                BASE_AOO_interp[B2.rownum,B2.colnum]/BASE_AOO_interp[B2.rownum,B2.colnum-B2.BoolWindow] <= 0.99 ) {B2.BoolDecline <- TRUE} else {B2.BoolDecline <- FALSE}}

    if(!B2.BoolDecline) {                                                   #These apply if there is no decline
    if(B2.AOO     == 0) {B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 5} else { #IE: B2.BoolDecline is FALSE
    if(B2.AOO   < 2000) {B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 1} else { #IE: !B2.BoolDecline is TRUE
                         B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 0}}}      #
    
    if(B2.BoolDecline) {                                             #These apply if there has been decline
    if(B2.AOO    == 0) {B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 5} else { #IE: B2.BoolDecline is TRUE
    if(B2.AOO    < 10) {B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 4} else { #
    if(B2.AOO   < 500) {B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 3} else { #
    if(B2.AOO  < 2000) {B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 2} else { #
    if(B2.AOO  < 3000) {B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 1} else { #
                        B2_AOO_interp_rl[B2.rownum,B2.colnum] <- 0}}}}}}   #
    rm(B2.BoolDecline)
    rm(B2.AOO)
    rm(B2.colnum)
  }
  rm(B2.rownum)
}
#B2_AOO_interp_rl <- as.data.frame(B2_AOO_interp_rl)
#B2_AOO_interp_rl <- merge(taxonomy[,1:2],B2_AOO_interp_rl)
#B2_AOO_interp_rl <- as.matrix(B2_AOO_interp_rl)

#sparse rli
#GO_rl_sparse <- NULL
#for(rownum in seq(1,nrow(GO_interp_rl)))
#{
#  for(colnum in seq(3,(2+totalyears))
#  {
#    ROW <- c(GO_interp_rl[rownum,1:2],colnames(GO_interp_rl)[colnum],GO_interp_rl[rownum,colnum])
#    GO_rl_sparse <- rbind(GO_rl_sparse,ROW)
#  }
#}
#colnames(GO_rl_sparse) <- c("taxid","order","year","rl")
#rownames(GO_rl_sparse) <- NULL
#GO_rl_sparse <- as.data.frame(transform(GO_rl_sparse,order=as.character(order),year=as.numeric(as.character(year)),rl=as#.numeric(as.character(rl))))

#mx <- matrix(rnorm(100,1:100),10,10)
#vec <- c(t(mx))


#export tables
#write.table(BASE_interp,file="/data/daniele/RL2050/projections/TECHNO.AOO.interp.2.csv",sep=",",row.names=F)
#write.table(BASE_interp_rl,file="/data/daniele/RL2050/projections/TECHNO.B2.rl.2.csv",sep=",",row.names=F)


#rm(BASE)
#rm(GO)
#rm(OS)
#rm(TG)
#rm(BASE_interp)
#rm(GO_interp)
#rm(OS_interp)
#rm(TG_interp)
#rm(BASE_interp_rl)
#rm(GO_interp_rl)
#rm(OS_interp_rl)
#rm(TG_interp_rl)
#rm(allyears)
#rm(inputyears)
#rm(totalyears)

#BASE.AOO.rl <- read.csv("/data/daniele/RL2050/projections/BASE.AOO.interp.csv")
#colnames(BASE.AOO) <- c('taxid',seq(1970,2050))


#BASE.B2.linear.rl <- read.csv("/data/daniele/RL2050/projections/BASE.B2.rl.csv")
#colnames(BASE.B2.linear.rl) <- c('taxid','order',seq(1970,2050))



