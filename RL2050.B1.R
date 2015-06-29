##RED LIST for criterion B1
B1_AOO_interp_rl <- BASE_AOO_interp
for(B1.rownum in seq(1,nrow(B1_AOO_interp_rl))) {

    ### REMOVE ###
    B1.taxid <- B1_AOO_interp_rl[B1.rownum,1] #this should be removed!
    if(!is.element(B1.taxid,BASE_EOO[,1])) {B1.noEOO <- TRUE} else {B1.noEOO <- FALSE} #this should be removed!
    ### REMOVE ###

    for(B1.colnum in seq(2,ncol(B1_AOO_interp_rl))) {

    ### REMOVE ###  
    if(B1.noEOO) {B1_AOO_interp_rl[B1.rownum,B1.colnum] <- NA} else { #this should be removed!
    ### REMOVE ###

      B1.EOO <- BASE_EOO_interp[BASE_EOO_interp[,1]==B1.taxid,B1.colnum]
           
    if(B1.colnum < 12) {B1.BoolWindow <- B1.colnum-2} else {B1.BoolWindow <- 10}
           ##sets BoolDecline to 1 if there has been decline - Decline is true or false in each decade as a constant
           ##decline is defined as at least 1% decline. 
           if(BASE_EOO_interp[B1.rownum,B1.colnum-B1.BoolWindow] == 0 |
              BASE_AOO_interp[B1.rownum,B1.colnum-B1.BoolWindow] == 0) {B1.BoolDecline <- FALSE} else {
           if(BASE_EOO_interp[B1.rownum,B1.colnum]/BASE_EOO_interp[B1.rownum,B1.colnum-B1.BoolWindow] <= 0.99 |
  BASE_AOO_interp[B1.rownum,B1.colnum]/BASE_AOO_interp[B1.rownum,B1.colnum-B1.BoolWindow] <= 0.99 ) {B1.BoolDecline <- TRUE} else {B1.BoolDecline <- FALSE}}

           if(!B1.BoolDecline) {                                                   #These apply if there has been no decline
           if(B1.EOO     <= 0) {B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 5} else { #IE:  B1.BoolDecline is FALSE
           if(B1.EOO  < 20000) {B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 1} else { #IE: !B1.BoolDecline is TRUE
                                B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 0}}}      #
        
           if(B1.BoolDecline)  {                                                   #These apply if there has been decline
           if(B1.EOO    <= 0)  {B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 5} else { #IE: B1.BoolDecline is TRUE
           if(B1.EOO   < 100)  {B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 4} else { #
           if(B1.EOO  < 5000)  {B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 3} else { #
           if(B1.EOO < 20000)  {B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 2} else { #
           if(B1.EOO < 30000)  {B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 1} else { #
                                B1_AOO_interp_rl[B1.rownum,B1.colnum] <- 0}}}}}}   #
           rm(B1.EOO)
           rm(B1.BoolDecline)
        } #this should be removed!
        rm(B1.colnum)
    }
    rm(B1.noEOO) #this should be facultative
    rm(B1.rownum)
    rm(B1.taxid) #this should be facultative
}

#B1_AOO_interp_rl <- as.data.frame(B1_AOO_interp_rl)
#B1_AOO_interp_rl <- merge(taxonomy[,1:2],B1_AOO_interp_rl)
#B1_AOO_interp_rl <- as.matrix(B1_AOO_interp_rl)

