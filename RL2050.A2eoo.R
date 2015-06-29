##RED LIST for criterion A2
A2_AOO_interp_rl <- BASE_EOO_interp
for(A2.rownum in seq(1,nrow(A2_AOO_interp_rl))) {
  A2.taxid <- as.integer(A2_AOO_interp_rl[A2.rownum,1])
    if(is.element(A2.taxid,genlentable$taxid)) {A2.genlen <- genlentable[genlentable$taxid==A2.taxid,"genlen"]} else {A2.genlen <- NULL}
    for(A2.colnum in seq(2,ncol(A2_AOO_interp_rl))) {
        if(is.null(A2.genlen))                                                      {A2_AOO_interp_rl[A2.rownum,A2.colnum] <- NA} else {
        if(A2.colnum < A2.genlen+2)                                                    {A2.genl <- A2.colnum-2} else {A2.genl <- A2.genlen}
        if(A2.colnum == 2)                                                          {A2_AOO_interp_rl[A2.rownum,A2.colnum] <- NA} else {

        if(BASE_AOO_interp[A2.rownum,A2.colnum-1] == 0) {A2_AOO_interp_rl[A2.rownum,A2.colnum] <- 5} else{
        if(BASE_AOO_interp[A2.rownum,A2.colnum]/BASE_AOO_interp[A2.rownum,A2.colnum-A2.genl] == 0)    {A2_AOO_interp_rl[A2.rownum,A2.colnum] <- 5} else {
        if(BASE_AOO_interp[A2.rownum,A2.colnum]/BASE_AOO_interp[A2.rownum,A2.colnum-A2.genl] <= 0.2)  {A2_AOO_interp_rl[A2.rownum,A2.colnum] <- 4} else {
        if(BASE_AOO_interp[A2.rownum,A2.colnum]/BASE_AOO_interp[A2.rownum,A2.colnum-A2.genl] <= 0.5)  {A2_AOO_interp_rl[A2.rownum,A2.colnum] <- 3} else {
        if(BASE_AOO_interp[A2.rownum,A2.colnum]/BASE_AOO_interp[A2.rownum,A2.colnum-A2.genl] <= 0.7)  {A2_AOO_interp_rl[A2.rownum,A2.colnum] <- 2} else {
        if(BASE_AOO_interp[A2.rownum,A2.colnum]/BASE_AOO_interp[A2.rownum,A2.colnum-A2.genl] <= 0.8)  {A2_AOO_interp_rl[A2.rownum,A2.colnum] <- 1} else {
                           A2_AOO_interp_rl[A2.rownum,A2.colnum] <- 0}}}}}}}}
    if(exists("A2.genl")) {rm(A2.genl)}
        }
    rm(A2.colnum)
    rm(A2.genlen)
    rm(A2.taxid)
    }
rm(A2.rownum)
#A2_AOO_interp_rl <- as.data.frame(A2_AOO_interp_rl)
#A2_AOO_interp_rl <- merge(taxonomy[,1:2],A2_AOO_interp_rl)
#A2_AOO_interp_rl <- as.matrix(A2_AOO_interp_rl)
