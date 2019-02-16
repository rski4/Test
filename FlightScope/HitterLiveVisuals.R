library(RCurl)
library(data.table)

live.1 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_05.csv"), col.names = paste("col", 1:77, sep = "."))
live.1$col.2 <- as.Date(live.1$col.2, "%m/%d/%y")
live.2 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_02_12_2019.csv"), col.names = paste("col", 1:77, sep = "."))

live <- data.frame(rbindlist(list(live.1, live.2)))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/flightscopeVar.R")))

live <- flightscopeVar(live)

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/ConvertFeet.R")))

live <- ConvertFeet(live)

live$pitch.type <- sub("^$", "No Type", live$pitch.type)

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
                   "Swinging Strikeout" = '#8B0000')

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
              color = ~pitch.call,
              symbol = ~pitch.type,
              marker = list(size = 10, 
                            opacity = 0.75),
              text = ~paste("<br>Exit Velo:", hit.ball.speed,
                            "<br>Launch Angle:", hit.ball.launch.v,
                            "<br>Direction:", hit.ball.launch.h,
                            "<br>Carry:", hit.carry.dist,
                            "<br>Pitch Speed:", pitch.speed,
                            "<br>Pitch Type:", pitch.type,
                            "<br>Outcome:", pitch.call),
              hoverinfo = 'text') %>%
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
              text = ~paste("<br>Exit Velo:", hit.ball.speed,
                            "<br>Launch Angle:", hit.ball.launch.v,
                            "<br>Direction:", hit.ball.launch.h,
                            "<br>Carry:", hit.carry.dist,
                            "<br>Pitch Speed:", pitch.speed,
                            "<br>Pitch Type:", pitch.type,
                            "<br>Outcome:", pitch.call),
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
          text = ~paste("<br>Exit Velo:", hit.ball.speed,
                        "<br>Launch Angle:", hit.ball.launch.v,
                        "<br>Direction:", hit.ball.launch.h,
                        "<br>Carry:", hit.carry.dist,
                        "<br>Pitch Speed:", pitch.speed,
                        "<br>Pitch Type:", pitch.type,
                        "<br>Outcome:", pitch.call),
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
          text = ~paste("<br>Exit Velo:", hit.ball.speed,
                        "<br>Launch Angle:", hit.ball.launch.v,
                        "<br>Direction:", hit.ball.launch.h,
                        "<br>Carry:", hit.carry.dist,
                        "<br>Pitch Speed:", pitch.speed,
                        "<br>Pitch Type:", pitch.type,
                        "<br>Outcome:", pitch.call),
          hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>% 
    layout(xaxis = list(title = "Launch Direction",
                        range = c(-35,35)),
           yaxis = list(title = "Launch Angle"))
}

