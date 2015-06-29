##RED LIST for criterion C1
C1_NUM_interp_rl <- BASE_NUM_interp
for(C1.rownum in seq(1,nrow(C1_NUM_interp_rl)))
{
  C1.taxid <- as.integer(C1_NUM_interp_rl[C1.rownum,1])
  if(exists("C1.genlen")) {rm(C1.genlen)}
  if(is.element(C1.taxid,genlentable$taxid)) {C1.genlen <- genlentable[genlentable$taxid==C1.taxid,"genlen"]}
  if(exists("C1.genlen")) {if(C1.genlen==10) {C1.genlen <- 3} else {C1.genlen <- C1.genlen/3}}

  for(C1.colnum in seq(2,ncol(C1_NUM_interp_rl)))
  {
   C1.NUM <- BASE_NUM_interp[C1.rownum,C1.colnum]
   #if there is no generation length
   if(!exists("C1.genlen")) {C1_NUM_interp_rl[C1.rownum,C1.colnum] <- NA}
   #if there is generation length
   if(exists("C1.genlen")) {
      #Rules for column 2 (first year where no back evaluation is possible)
      if(C1.colnum==2) {
         if(is.na(C1.NUM)) {
            C1_NUM_interp_rl[C1.rownum,C1.colnum] <- NA} else {
            C1_NUM_interp_rl[C1.rownum,C1.colnum] <- 0}
            }
      #Rules for all other columns (where back evaluation is possible)
      if(C1.colnum>2) {
         if(is.na(C1.NUM)) {
            C1_NUM_interp_rl[C1.rownum,C1.colnum] <- NA} else {
            #LC
            if(C1.NUM >= 15000) {
               C1_NUM_interp_rl[C1.rownum,C1.colnum] <- 0} else {
               #NT
               if(C1.NUM < 15000) {
                  if(C1.colnum < max(c(C1.genlen*3,10))+2) {C1.genl <- C1.colnum-2} else {C1.genl <- max(c(C1.genlen*3,10))}
                  if(BASE_NUM_interp[C1.rownum,C1.colnum-C1.genl] > 0) {
                     if(C1.NUM/BASE_NUM_interp[C1.rownum,C1.colnum-C1.genl] <= 0.9) {
                        C1_NUM_interp_rl[C1.rownum,C1.colnum] <- 1} else {
                        C1_NUM_interp_rl[C1.rownum,C1.colnum] <- 0}}}
               #VU
               if(C1.NUM < 10000) {
                  if(C1.colnum < max(c(C1.genlen*3,10))+2) {C1.genl <- C1.colnum-2} else {C1.genl <- max(c(C1.genlen*3,10))}
                  if(BASE_NUM_interp[C1.rownum,C1.colnum-C1.genl] > 0) {
                     if(C1.NUM/BASE_NUM_interp[C1.rownum,C1.colnum-C1.genl] <= 0.9) {
                        C1_NUM_interp_rl[C1.rownum,C1.colnum] <- 2}}}
               #EN
               if(C1.NUM < 2500) {
                  if(C1.colnum < max(c(C1.genlen*2,5))+2) {C1.genl <- C1.colnum-2} else {C1.genl <- max(c(C1.genlen*2,5))}
                  if(BASE_NUM_interp[C1.rownum,C1.colnum-C1.genl] > 0) {
                     if(C1.NUM/BASE_NUM_interp[C1.rownum,C1.colnum-C1.genl] <= 0.8) {
                        C1_NUM_interp_rl[C1.rownum,C1.colnum] <- 3}}}
               #CR
               if(C1.NUM < 250) {
                  if(C1.colnum < max(c(C1.genlen,3))+2) {C1.genl <- C1.colnum-2} else {C1.genl <- max(c(C1.genlen,3))}
                  if(BASE_NUM_interp[C1.rownum,C1.colnum-C1.genl] > 0) {
                     if(C1.NUM/BASE_NUM_interp[C1.rownum,C1.colnum-C1.genl] <= 0.75) {
                        C1_NUM_interp_rl[C1.rownum,C1.colnum] <- 4}}}
               #EX
               if(C1.NUM <=  0) {C1_NUM_interp_rl[C1.rownum,C1.colnum] <- 5}} #closes LC loop
}}}
rm(C1.NUM)
}
rm(C1.taxid)
rm(C1.rownum)
if(exists('C1.genlen')) {rm(C1.genlen)}
}

#C1_NUM_interp_rl <- as.data.frame(C1_NUM_interp_rl)
#C1_NUM_interp_rl <- merge(taxonomy[,1:2],C1_NUM_interp_rl)
#C1_NUM_interp_rl <- as.matrix(C1_NUM_interp_rl)

#end
