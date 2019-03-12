library(RCurl)
library(data.table)
library(tidyverse)

PlateDisciplineLeaderLive <- function(df = live) {
  live <- live %>% 
    dplyr::mutate(in.zone = ifelse(pz <= 3.5 & 
                                     pz >= 1.6 & 
                                     px >= -0.95 & 
                                     px <= 0.95, 1, 0),
                  swing.flag = ifelse(pitch.call %in% c("Swinging Strike",
                                                        "Swinging Strikeout",
                                                        "Single",
                                                        "Foul Ball",
                                                        "Double",
                                                        "Contact Out"), 1, 0),
                  contact.flag = ifelse(pitch.call %in% c("Single",
                                                          "Double",
                                                          "Contact Out"), 1, 0),
                  swing.strike.flag = ifelse(pitch.call %in% c("Swinging Strike",
                                                               "Swinging Strikeout",
                                                               "Foul Ball"), 1, 0))
  
  plate.discipline.leader <- live %>%
    dplyr::filter(!is.na(in.zone)) %>% 
    dplyr::group_by(batter) %>%
    dplyr::summarise(zSwPct = sum(swing.flag[in.zone == 1])/sum(in.zone[in.zone == 1]),
                     zContPct = sum(contact.flag[in.zone == 1])/sum(in.zone[in.zone == 1]),
                     in.zone.n = length(in.zone[in.zone == 1]),
                     oSwPct = sum(swing.flag[in.zone == 0])/length(in.zone[in.zone == 0]),
                     oContPct = sum(contact.flag[in.zone == 0])/length(in.zone[in.zone == 0]),
                     out.zone.n = length(in.zone[in.zone == 0]),
                     SwPct = sum(swing.flag)/length(in.zone),
                     ContPct = sum(contact.flag)/sum(swing.flag),
                     ZonePct = sum(in.zone)/length(in.zone),
                     SwStrPct = sum(swing.strike.flag)/length(in.zone),
                     total.pitches = length(in.zone))
  
  return(plate.discipline.leader)
  
}

PitchPlateDisciplineLeaderLive <- function(df = live) {
  live <- live %>% 
    dplyr::mutate(in.zone = ifelse(pz <= 3.5 & 
                                     pz >= 1.6 & 
                                     px >= -0.95 & 
                                     px <= 0.95, 1, 0),
                  swing.flag = ifelse(pitch.call %in% c("Swinging Strike",
                                                        "Swinging Strikeout",
                                                        "Single",
                                                        "Foul Ball",
                                                        "Double",
                                                        "Contact Out"), 1, 0),
                  contact.flag = ifelse(pitch.call %in% c("Single",
                                                          "Double",
                                                          "Contact Out"), 1, 0),
                  swing.strike.flag = ifelse(pitch.call %in% c("Swinging Strike",
                                                               "Swinging Strikeout",
                                                               "Foul Ball"), 1, 0))
  
  plate.discipline.leader <- live %>%
    dplyr::filter(!is.na(in.zone)) %>% 
    dplyr::group_by(pitcher) %>%
    dplyr::summarise(zSwPct = sum(swing.flag[in.zone == 1])/sum(in.zone[in.zone == 1]),
                     zContPct = sum(contact.flag[in.zone == 1])/sum(in.zone[in.zone == 1]),
                     in.zone.n = length(in.zone[in.zone == 1]),
                     oSwPct = sum(swing.flag[in.zone == 0])/length(in.zone[in.zone == 0]),
                     oContPct = sum(contact.flag[in.zone == 0])/length(in.zone[in.zone == 0]),
                     out.zone.n = length(in.zone[in.zone == 0]),
                     SwPct = sum(swing.flag)/length(in.zone),
                     ContPct = sum(contact.flag)/sum(swing.flag),
                     ZonePct = sum(in.zone)/length(in.zone),
                     SwStrPct = sum(swing.strike.flag)/length(in.zone),
                     total.pitches = length(in.zone))
  
  return(plate.discipline.leader)
  
}

HitBallLeaderLive <- function(df = live) {
  Hit.Ball.Leader <- df %>% 
    filter(!is.na(hit.ball.speed)) %>% 
    group_by(batter) %>% 
    summarise(N = length(hit.ball.speed),
              LAmed = median(hit.ball.launch.v, na.rm = TRUE),
              EVmax = max(hit.ball.speed, na.rm = TRUE),
              EVmed = median(hit.ball.speed, na.rm = TRUE),
              Carrymax = max(hit.carry.dist, na.rm = TRUE),
              Carrymed = median(hit.carry.dist, na.rm = TRUE),
              HardHitpct = length(hit.ball.speed[hit.ball.speed > 90])/length(hit.ball.speed),
              LDpct = length(hit.ball.speed[hit.ball.launch.v >= 10 & hit.ball.launch.v <= 25])/length(hit.ball.launch.v),
              FBpct = length(hit.ball.speed[hit.ball.launch.v > 25])/length(hit.ball.speed),
              GBpct = length(hit.ball.speed[hit.ball.launch.v < 10])/length(hit.ball.speed))
  
  return(Hit.Ball.Leader)
  
}

PitchHitBallLeaderLive <- function(df = live) {
  Hit.Ball.Leader <- df %>% 
    filter(!is.na(hit.ball.speed)) %>% 
    group_by(pitcher) %>% 
    summarise(N = length(hit.ball.speed),
              LAmed = median(hit.ball.launch.v, na.rm = TRUE),
              EVmax = max(hit.ball.speed, na.rm = TRUE),
              EVmed = median(hit.ball.speed, na.rm = TRUE),
              Carrymax = max(hit.carry.dist, na.rm = TRUE),
              Carrymed = median(hit.carry.dist, na.rm = TRUE),
              HardHitpct = length(hit.ball.speed[hit.ball.speed > 90])/length(hit.ball.speed),
              LDpct = length(hit.ball.speed[hit.ball.launch.v >= 10 & hit.ball.launch.v <= 25])/length(hit.ball.launch.v),
              FBpct = length(hit.ball.speed[hit.ball.launch.v > 25])/length(hit.ball.speed),
              GBpct = length(hit.ball.speed[hit.ball.launch.v < 10])/length(hit.ball.speed))
  
  return(Hit.Ball.Leader)
  
}


