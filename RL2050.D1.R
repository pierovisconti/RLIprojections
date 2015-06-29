##RED LIST for criterion D1
D1_NUM_interp_rl <- BASE_NUM_interp
for(D1.rownum in seq(1,nrow(D1_NUM_interp_rl)))
{
  for(D1.colnum in seq(2,ncol(D1_NUM_interp_rl))) {
      D1.NUM <- BASE_NUM_interp[D1.rownum,D1.colnum]
      if(is.na(D1.NUM)) {D1_NUM_interp_rl[D1.rownum,D1.colnum] <- NA} else {
      if(D1.NUM   == 0) {D1_NUM_interp_rl[D1.rownum,D1.colnum] <-  5} else {
      if(D1.NUM   < 50) {D1_NUM_interp_rl[D1.rownum,D1.colnum] <-  4} else {
      if(D1.NUM  < 250) {D1_NUM_interp_rl[D1.rownum,D1.colnum] <-  3} else {
      if(D1.NUM < 1000) {D1_NUM_interp_rl[D1.rownum,D1.colnum] <-  2} else {
      if(D1.NUM < 1500) {D1_NUM_interp_rl[D1.rownum,D1.colnum] <-  1} else {
                         D1_NUM_interp_rl[D1.rownum,D1.colnum] <-  0}}}}}}
      rm(D1.NUM)
      rm(D1.colnum)
      }
rm(D1.rownum)
}
#D1_NUM_interp_rl <- as.data.frame(D1_NUM_interp_rl)
#D1_NUM_interp_rl <- merge(taxonomy[,1:2],D1_NUM_interp_rl)
#D1_NUM_interp_rl <- as.matrix(D1_NUM_interp_rl)

#end
