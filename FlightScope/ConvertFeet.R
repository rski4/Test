
ConvertFeet <- function(df){
  char.var <- c('pitch.release.height', 
                'pitch.release.side',
                'pitch.extension',
                'pitch.k.zone.height',
                'pitch.k.zone.offset',
                'hit.carry.dist',
                'x0',
                'y0',
                'z0',
                'px',
                'pz')
  for (i in char.var) {
    df[,i] <- sapply(strsplit(as.character(df[,i]), "'|\""),
                 function(x){ifelse(is.na(x[2]) == TRUE,
                                    round(as.numeric(x[1]), digits = 2),
                                    ifelse(x[1] >= 0,
                                           round(as.numeric(x[1]) + as.numeric(x[2])/12, digits = 2),
                                           round(as.numeric(x[1]) - as.numeric(x[2])/12, digits = 2)))})
                                    
  }
  return(df)
}
