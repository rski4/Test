library(tidyverse)

ConvertSci <- function(df){
  df <- df %>% 
    mutate(pitch.speed = round(pitch.speed*2.23694, 3),
           pitch.release.height = round(pitch.release.height*3.28084, 3),
           pitch.release.side = round(pitch.release.side*3.28084, 3),
           pitch.extension = round(pitch.extension*3.28084, 3),
           pitch.break.v = round(pitch.break.v*3.28084, 3),
           pitch.break.ind.v = round(pitch.break.ind.v*3.28084, 3),
           pitch.break.h = round(pitch.break.h*3.28084, 3),
           pitch.k.zone.height = round(pitch.k.zone.height*3.28084, 3),
           pitch.k.zone.offset = round(pitch.k.zone.offset*3.28084, 3),
           pitch.zone.speed = round(pitch.zone.speed*2.23694, 3),
           hit.ball.speed = round(hit.ball.speed*2.23694, 3),
           hit.carry.dist = round(hit.carry.dist*3.28084, 3),
           pfxx = round(pfxx*3.28084, 3),
           pfxz = round(pfxz*3.28084, 3),
           x0 = round(x0*3.28084, 3),
           y0 = round(y0*3.28084, 3),
           z0 = round(z0*3.28084, 3),
           vx0 = round(vx0*3.28084, 3),
           vy0 = round(vy0*3.28084, 3),
           vz0 = round(vz0*3.28084, 3),
           ax = round(ax*3.28084, 3),
           ay = round(ay*3.28084, 3),
           az = round(az*3.28084, 3),
           px = round(px*3.28084, 3),
           pz = round(pz*3.28084, 3))
  
  return(df)
}

