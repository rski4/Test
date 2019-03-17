library(RCurl)
library(data.table)

live.1 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_05_sci.csv"), col.names = paste("col", 1:77, sep = "."))
live.2 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_12_sci.csv"), col.names = paste("col", 1:77, sep = "."))
live.3 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_19_sci.csv"), col.names = paste("col", 1:77, sep = "."))
live.4 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_25_sci.csv"), col.names = paste("col", 1:77, sep = "."))

live <- data.frame(rbindlist(list(live.1, live.2, live.3, live.4)))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/flightscopeVar.R")))

live <- flightscopeVar(live)

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/ConvertFeet.R")))
eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/ConvertSci.R")))

live <- ConvertSci(live)


live$pitch.type <- sub("^$", "No Type", live$pitch.type)
live$pitch.type <- sub("Undefined", "No Type", live$pitch.type)
live$pitch.call <- sub("^$", "No Outcome", live$pitch.call)
live$pitch.type <- sub("Four Seam Fastball", "Fastball", live$pitch.type)
live$pitch.type <- sub("Two Seam Fastball", "Fastball", live$pitch.type)
live$batter <- sub("Tyrell Johnson", "TJ Johnson", live$batter)

pitch.symbols <- c("Fastball" = 'circle',
                   "Curveball" = 'triangle-up', 
                   "Changeup" = 'square', 
                   "Cutter" = 'x',
                   "Slider" = 'diamond',
                   "Sinker" = 'triangle-down',
                   "Splitter" = 'star',
                   "No Type" = 'cross')

outcome.color <- c("Called Strike" = '#CD0000',
                   "Ball" = '#7EC0EE',
                   "Foul Ball" = '#A2CD5A',
                   "Single" = '#008B45',
                   "Swinging Strike" = '#8B0000',
                   "Hit by Pitch" = '#A1A1A1',
                   "Called Strikeout" = '#CD0000',
                   "Swinging Strikeout" = '#8B0000',
                   "Contact Out" = '#FFD39B',
                   "No Outcome" = '#E3E3E3')

hover.text.live <- ~paste("<br>Exit Velo:", hit.ball.speed,
                          "<br>Launch Angle:", hit.ball.launch.v,
                          "<br>Direction:", hit.ball.launch.h,
                          "<br>Carry:", hit.carry.dist,
                          "<br>Pitcher:", pitcher,
                          "<br>Pitcher Hand:", pitcher.hand,
                          "<br>Pitch Speed:", pitch.speed,
                          "<br>Pitch Type:", pitch.type,
                          "<br>Outcome:", pitch.call)

HitKZoneLive <- function(df = live, player = "Nolan Arp") {
  k.zone <- data.frame(
    x1 = c(rep(-.95, 3), 0.95),
    x2 = c(0.95, -0.95, 0.95, 0.95),
    y1 = c(1.6, 1.6, 3.5, 3.5),
    y2 = c(1.6, 3.5, 3.5, 1.6))
  nine.box <- data.frame(
    x1 = c(rep(-.95,2), -.95/3, .95/3),
    x2 = c(rep(.95, 2), -.95/3, .95/3),
    y1 = c(1.6 + (3.5-1.6)/3, 1.6 + (3.5-1.6)*2/3, rep(3.5, 2)),
    y2 = c(1.6 + (3.5-1.6)/3, 1.6 + (3.5-1.6)*2/3, rep(1.6, 2)))
  
  plot_ly(symbols = pitch.symbols,
          colors = outcome.color) %>% 
    add_segments(data = k.zone, x = ~x1, xend = ~x2, y = ~y1, yend = ~y2, 
                 color = I("black"), showlegend = FALSE) %>% 
    add_segments(data = nine.box, x = ~x1, xend = ~x2, y = ~y1, yend = ~y2,
                 color = I("grey80"), showlegend = FALSE) %>% 
    add_trace(data = filter(df, batter == player),
              x = ~px, y = ~pz,
              type = 'scatter', mode = 'markers',
              #color = ~pitch.call,
              symbol = ~pitch.type,
              marker = list(size = 10, 
                            opacity = 0.5,
                            line = list(color = '#000000',
                                        width = 2),
                            color = '#FFFFFF'),
              text = hover.text.live,
              hoverinfo = 'text') %>%
    add_trace(data = filter(df, batter == player),
              x = ~px, y = ~pz,
              type = 'scatter', mode = 'markers',
              color = ~pitch.call,
              #symbol = ~pitch.type,
              marker = list(size = 8, 
                            opacity = 0.6),
              text = hover.text.live,
              hoverinfo = 'text') %>%
    add_trace(data = filter(df, batter == player),
              x = ~px, y = ~pz,
              type = 'scatter', mode = 'markers',
              color = ~pitch.call,
              symbol = ~pitch.type,
              marker = list(size = 10, 
                            opacity = 0.75,
                            line = list(color = '#000000',
                                        width = 2)),
              text = hover.text.live,
              hoverinfo = 'text',
              showlegend = FALSE) %>%
    layout(xaxis = list(title = "",
                        zeroline = FALSE,
                        range = c(-3,3)),
           yaxis = list(title = "",
                        zeroline = FALSE,
                        range = c(0,6.5)),
           title = as.character(player))
  
}

HitBallProfileLive  <- function(df = live, player = "Nolan Arp"){
  df <- df %>% 
    mutate(
      evla.x = cospi(abs(hit.ball.launch.v/180))*hit.ball.speed,
      evla.y = ifelse(hit.ball.launch.v > 0,
                      sinpi(abs(hit.ball.launch.v/180))*hit.ball.speed,
                      -sinpi(abs(hit.ball.launch.v/180))*hit.ball.speed))
  
  circleFun <- function(center=c(0,0), diameter=100, npoints=100, start=0, end=2, filled=TRUE){
    tt <- seq(start*pi, end*pi, length.out=npoints)
    df <- data.frame(
      x = center[1] + diameter / 2 * cos(tt),
      y = center[2] + diameter / 2 * sin(tt)
    )
    if(filled==TRUE) { #add a point at the center so the whole 'pie slice' is filled
      df <- rbind(df, center)
    }
    return(df)
  }
  
  ev90 = circleFun(c(0,0), diameter = 200, npoints = 100, start = -.5, end = .5, filled = TRUE)
  ev80 = circleFun(c(0,0), diameter = 180, npoints = 100, start = -.5, end = .5, filled = TRUE)
  ev70 = circleFun(c(0,0), diameter = 160, npoints = 100, start = -.5, end = .5, filled = TRUE)
  ev60 = circleFun(c(0,0), diameter = 140, npoints = 100, start = -.5, end = .5, filled = TRUE)
  ev50 = circleFun(c(0,0), diameter = 120, npoints = 100, start = -.5, end = .5, filled = TRUE)
  
  plot_ly(data = filter(df, batter == player),
          symbols = pitch.symbols) %>% 
    add_polygons(data = ev90,
                 x = ~x, y = ~y, fillcolor = '#CD2626',
                 line = list(color = '#CD2626'),
                 name = "100-90 MPH") %>%
    add_polygons(data = ev80,
                 x = ~x, y = ~y, fillcolor = '#00CD00',
                 line = list(color = '#00CD00'),
                 name = "90-80 MPH") %>%
    add_polygons(data = ev70,
                 x = ~x, y = ~y, fillcolor = '#FFDAB9',
                 line = list(color = '#FFDAB9'),
                 name = "80-70 MPH") %>%
    add_polygons(data = ev60,
                 x = ~x, y = ~y, fillcolor = '#B0E0E6',
                 line = list(color = '#B0E0E6'),
                 name = "70-60 MPH") %>%
    add_segments(x = 0, xend = 100, y = 0, yend = 0,
                 showlegend = FALSE,
                 line = list(color = '#B0B0B0'), hoverinfo = "none") %>% 
    add_segments(x = 0, xend = 70, y = 0, yend = 70,
                 showlegend = FALSE,
                 line = list(color = '#B0B0B0'), hoverinfo = "none") %>% 
    add_segments(x = 0, xend = 86, y = 0, yend = 86*tanpi(30/180),
                 showlegend = FALSE,
                 line = list(color = '#B0B0B0'), hoverinfo = "none") %>%
    add_segments(x = 0, xend = 98, y = 0, yend = 98*tanpi(10/180),
                 showlegend = FALSE,
                 line = list(color = '#B0B0B0'), hoverinfo = "none") %>%
    add_trace(data = filter(df, batter == player),
              x = ~evla.x, y = ~evla.y,
              type = 'scatter', mode = 'markers',
              symbol = ~pitch.type,
              marker = list(size = 10,
                            opacity = 0.65,
                            color = 'black'),
              text = hover.text.live,
              hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>% 
    add_annotations(text = "0˚", 
                    x = 105, y = 0,
                    font = list(size = 16),
                    showarrow = FALSE) %>% 
    add_annotations(text = "45˚", 
                    x=75, y=73,
                    font = list(size = 16),
                    showarrow = FALSE) %>%
    add_annotations(text = "30˚", 
                    x=91, y=53,
                    font = list(size = 16),
                    showarrow = FALSE) %>%
    add_annotations(text = "10˚", 
                    x=103, y=18,
                    font = list(size = 16),
                    showarrow = FALSE) %>%
    layout(xaxis = list(zeroline = FALSE,
                        title = "",
                        showline = FALSE,
                        showticklabels = FALSE,
                        showgrid = FALSE),
           yaxis = list(zeroline = FALSE,
                        title = "",
                        showline = FALSE,
                        showticklabels = FALSE,
                        showgrid = FALSE),
           title = as.character(player))
  
}

HitEVLALive <- function(df = live, player = "Nolan Arp") {
  plot_ly(data = filter(df, batter == player),
          x = ~hit.ball.speed, y = ~hit.ball.launch.v,
          type = 'scatter', mode = 'markers',
          marker = list(size = 10,
                        opacity = 0.65,
                        color = 'black'),
          symbols = pitch.symbols, symbol = ~pitch.type,
          text = hover.text.live,
          hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>% 
    layout(xaxis = list(title = "Exit Velo"),
           yaxis = list(title = "Launch Angle"))
}

HitLALHLive <- function(df = live, player = "Nolan Arp") {
  plot_ly(data = filter(df, batter == player),
          x = ~hit.ball.launch.h, y = ~hit.ball.launch.v,
          type = 'scatter', mode = 'markers',
          marker = list(size = 10,
                        opacity = 0.65,
                        color = 'black'),
          symbols = pitch.symbols, symbol = ~pitch.type,
          text = hover.text.live,
          hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>% 
    layout(xaxis = list(title = "Launch Direction",
                        range = c(-35,35)),
           yaxis = list(title = "Launch Angle"))
}

PlateDisciplineIndLive <- function(df = live, player = "Nolan Arp") {
  df <- df %>% 
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
  plate.discipline.ind <- df %>%
    dplyr::filter(batter == player & !is.na(in.zone)) %>% 
    dplyr::group_by(pitch.type) %>% 
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
  
  t1 <- t(plate.discipline.ind)
  
  colnames(t1) <- t1[1,]
  
  t1 <- t1[-1,]
  
  t2 <- rownames_to_column(data.frame(t1), "Metric")
  
  return(t2)
}

HitBallTableIndLive <- function(df = live, player = "Nolan Arp") {
  Hit.Ball.Ind <- df %>% 
    filter(!is.na(hit.ball.speed) & batter == player) %>% 
    group_by(pitch.type) %>% 
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
  
  t1 <- t(Hit.Ball.Ind)
  
  colnames(t1) <- t1[1,]
  
  t1 <- t1[-1,]
  
  t2 <- rownames_to_column(data.frame(t1), "Metric")
  
  return(t2)
}

PitchInfoTableIndLive <- function(df = live, player = "Nolan Arp") {
  Pitch.Info.Ind <- df %>%
    dplyr::mutate(FB.flag = ifelse(pitch.type %in% c("Four Seam Fastball",
                                                     "Two Seam Fastball"), 1, 0),
                  BreakB.flag = ifelse(pitch.type %in% c("Slider",
                                                         "Curveball"), 1, 0))
                  
    
    dplyr::filter(batter == player & !is.na(pitch.type)) %>% 
    dplyr::group_by(pitch.type) %>% 
    dplyr::summarise(FB.pct = sum(FB.flag == 1)/length(pitch.type),
                     CH.pct = length(pitch.type == "Changeup")/length(pitch.type),
                     SL.pct = length(pitch.type == "Slider")/length(pitch.type),
                     CV.pct = length(pitch.type == "Curveball")/length(pitch.type),
                     BreakB.pct = sum(BreakB.flag == 1)/length(pitch.type))
  
  t1 <- t(Pitch.Info.Ind)
  
  colnames(t1) <- t1[1,]
  
  t1 <- t1[-1,]
  
  t2 <- rownames_to_column(data.frame(t1), "Metric")
  
  return(t2)
  
}
