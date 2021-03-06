library(RCurl)
library(tidyverse)
library(plotly)
library(data.table)

bpen.1 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/Bullpen.01.22.2019.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.2 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_01_26.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.3 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_01_26_2.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.4 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_01_26_3.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.5 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_01_29.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.6 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019-02-02.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.7 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_02_09.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.8 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_02_16.csv"), col.names = paste("col", 1:77, sep = "."))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/ConvertFeet.R")))

bpen.8 <- flightscopeVar(bpen.8)
bpen.8 <- ConvertFeet(bpen.8)

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/flightscopeVar.R")))

bpen <- rbindlist(list(bpen.1, bpen.2, bpen.3, bpen.4, bpen.5, bpen.6, bpen.7, bpen.8))

bpen <- flightscopeVar(bpen)

bpen$pitch.type <- sub("^$", "No Type", bpen$pitch.type)
bpen$pitch.type <- sub("Undefined", "No Type", bpen$pitch.type)
bpen$pitch.type[is.na(bpen$pitch.type)] <- "No Type"
bpen$pitch.type <- sub("Four Seam Fastball", "Fastball", bpen$pitch.type)
bpen$pitch.type <- sub("Two Seam Fastball", "Fastball", bpen$pitch.type)

pitch.symbols <- c("Fastball" = 'circle',
                   "Curveball" = 'triangle-up', 
                   "Changeup" = 'square', 
                   "Cutter" = 'x',
                   "Slider" = 'diamond',
                   "Sinker" = 'triangle-down',
                   "Splitter" = 'star',
                   "No Type" = 'cross')

text.bpen = ~paste("Type:", pitch.type,
                   "<br>Velo:", pitch.speed,
                   "<br>Spin Rate:", pitch.spin,
                   "<br>Spin Axis:", pitch.spin.axis,
                   "<br>V. Break:", pitch.break.ind.v,
                   "<br>H. Break:", pitch.break.h)

PitchDashVeloSpinSeqBPen <- function(df = bpen, player = "Andrew Schmit") {
  py <- plot_ly(data = filter(df, pitcher == player), 
                x = ~no, symbol = ~pitch.type, 
                marker = list(size = 10,
                              opacity = 0.75,
                              color = '#696969'),
                text = ~paste("Pitch No:", no,
                              "<br>Type:", pitch.type,
                              "<br>Velo:", pitch.speed,
                              "<br>Spin Rate:", pitch.spin,
                              "<br>Spin Axis:", pitch.spin.axis,
                              "<br>V. Break:", pitch.break.ind.v,
                              "<br>H. Break:", pitch.break.h),
                symbols = pitch.symbols)
  subplot(
    add_markers(py, y = ~pitch.speed, hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>% 
      layout(yaxis = list(title = "Velocity")),
    add_markers(py, y = ~pitch.spin, showlegend = F, hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>% 
      layout(yaxis = list(title = "Spin Rate")),
    add_markers(py, y = ~pitch.spin.axis, showlegend = F, hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>% 
      layout(yaxis = list(title = "Spin Axis",
                          tickvals = c(0, 90, 180, 270))),
    nrows = 3, shareX = TRUE, titleY = TRUE
  ) %>% 
    layout(xaxis = list(title = "Pitch Number",
                        dtick = 1),
           title = as.character(player))
  
}

PitchKZoneBPen <- function(df = bpen, player = "Andrew Schmit", Velo = FALSE){
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
  
  if (Velo){
    plot_ly(colors = c("red", "firebrick4"),
            symbols = pitch.symbols) %>%  
      add_segments(data = k.zone, x = ~x1, xend = ~x2, y = ~y1, yend = ~y2, 
                   color = I("black"), showlegend = FALSE) %>% 
      add_segments(data = nine.box, x = ~x1, xend = ~x2, y = ~y1, yend = ~y2,
                   color = I("grey80"), showlegend = FALSE) %>% 
      add_trace(data = filter(df, pitcher == player),
                x = ~px, y = ~pz,
                type = 'scatter', mode = 'markers', 
                color = ~pitch.speed, 
                symbol = ~pitch.type, 
                marker = list(size = 10, opacity = 0.75),
                text = text.bpen,
                hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>%
      layout(xaxis = list(title = "",
                          zeroline = FALSE,
                          range = c(-3,3)),
             yaxis = list(title = "",
                          zeroline = FALSE,
                          range = c(0,6.5)),
             title = as.character(player)) %>% 
      colorbar(title = "Velo")
  }
  
  else {
    plot_ly(symbols = pitch.symbols) %>%  
      add_segments(data = k.zone, x = ~x1, xend = ~x2, y = ~y1, yend = ~y2, 
                   color = I("black"), showlegend = FALSE) %>% 
      add_segments(data = nine.box, x = ~x1, xend = ~x2, y = ~y1, yend = ~y2,
                   color = I("grey80"), showlegend = FALSE) %>% 
      add_trace(data = filter(df, pitcher == player),
                x = ~px, y = ~pz,
                type = 'scatter', mode = 'markers',
                symbol = ~pitch.type, 
                marker = list(size = 10, opacity = 0.75),
                text = text.bpen,
                hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>%
      layout(xaxis = list(title = "",
                          zeroline = FALSE,
                          range = c(-3,3)),
             yaxis = list(title = "",
                          zeroline = FALSE,
                          range = c(0,6.5)),
             title = as.character(player))
  }
}

PitchReleaseBPen <- function(df = bpen, player = "Andrew Schmit") {
  plot_ly(data = filter(df, pitcher == player),
          x = ~pitch.release.side, y = ~pitch.release.height,
          type = "scatter", mode = "markers",
          marker = list(size = 10, opacity = 0.6),
          text = text.bpen,
          hoverinfo = 'text', hoverlabel = list(bgcolor = 'white'),
          symbol = ~pitch.type, symbols = pitch.symbols) %>% 
    layout(xaxis = list(title = "Pitch Release Side (ft)",
                        range = c(-4,4),
                        zeroline = FALSE),
           yaxis = list(title = "Pitch Release Height (ft)",
                        range = c(0,7),
                        zeroline = FALSE),
           title = paste(as.character(player),"Release", sep = " "))
}

PitchMovementPitchViewBPen <- function(df = bpen, player = "Andrew Schmit") {
  plot_ly(data = filter(df, pitcher == player),
          x = ~pitch.break.h, y = ~pitch.break.ind.v,
          type = 'scatter', mode = 'markers',
          marker = list(size = 10,
                        opacity = 0.75),
          text = text.bpen,
          symbol = ~pitch.type, symbols = pitch.symbols) %>% 
    layout(xaxis = list(title = "Horizontal Break (in)"),
           yaxis = list(title = "Vertical Break (in)"),
           title = "Pitcher View Movement")
}

PitchMovementBatViewBPen <- function(df = bpen, player = "Andrew Schmit") {
  plot_ly(data = filter(df, pitcher == player),
          x = ~pfxx, y = ~pfxz,
          type = 'scatter', mode = 'markers',
          marker = list(size = 10,
                        opacity = 0.75),
          text = ~paste("Type:", pitch.type,
                        "<br>Velo:", pitch.speed,
                        "<br>Spin Rate:", pitch.spin,
                        "<br>Spin Axis:", pitch.spin.axis,
                        "<br>V. Break:", pitch.break.ind.v,
                        "<br>H. Break:", pitch.break.h),
          symbol = ~pitch.type, symbols = pitch.symbols) %>% 
    layout(xaxis = list(title = "Horizontal Break last 40ft (in)"),
           yaxis = list(title = "Vertical Break last 40ft (in)"),
           title = "Hitter View Movement")
}
              
PitchDashSpinAxisVeloCirBPen <- function(df = bpen, player = "Andrew Schmit"){
  df <- df %>% mutate(spin.circ.x = -pitch.speed*cospi((pitch.spin.axis+90)/180), 
                          spin.circ.y = pitch.speed*sinpi((pitch.spin.axis+90)/180))
  
  circleFun <- function(center=c(0,0), diameter=100, npoints=100, start=0, end=2, filled=TRUE){
    tt <- seq(start*pi, end*pi, length.out=npoints)
    df1 <- data.frame(
      x = center[1] + diameter / 2 * cos(tt),
      y = center[2] + diameter / 2 * sin(tt)
    )
    if(filled==TRUE) { #add a point at the center so the whole 'pie slice' is filled
      df1 <- rbind(df1, center)
    }
    return(df1)
  }
  
  velo90 <- circleFun(c(0,0), diameter = 200, npoints = 100, start = 0, end = 2, filled = TRUE)
  velo80 <- circleFun(c(0,0), diameter = 180, npoints = 100, start = 0, end = 2, filled = TRUE)
  velo70 <- circleFun(c(0,0), diameter = 160, npoints = 100, start = 0, end = 2, filled = TRUE)
  velo60 <- circleFun(c(0,0), diameter = 140, npoints = 100, start = 0, end = 2, filled = TRUE)
  
  plot_ly(data = filter(df, pitcher == player),
          symbols = pitch.symbols) %>% 
    add_polygons(data = velo90,
                 x = ~x, y = ~y, fillcolor = '#CD2626',
                 line = list(color = '#CD2626'),
                 name = "100-90 MPH") %>%
    add_polygons(data = velo80,
                 x = ~x, y = ~y, fillcolor = '#00CD00',
                 line = list(color = '#00CD00'),
                 name = "90-80 MPH") %>%
    add_polygons(data = velo70,
                 x = ~x, y = ~y, fillcolor = '#FFDAB9',
                 line = list(color = '#FFDAB9'),
                 name = "80-70 MPH") %>%
    add_polygons(data = velo60,
                 x = ~x, y = ~y, fillcolor = '#B0E0E6',
                 line = list(color = '#B0E0E6'),
                 name = "70-60 MPH") %>%
    add_segments(x = -71, xend = 71, y = 71, yend = -71,
                 showlegend = FALSE,
                 line = list(color = '#B0B0B0',
                             dash = 'dash'), hoverinfo = "none") %>%
    add_segments(x = -71, xend = 71, y = -71, yend = 71,
                 showlegend = FALSE,
                 line = list(color = '#B0B0B0',
                             dash = 'dash'), hoverinfo = "none") %>%
    add_segments(x = 0, xend = 0, y = 100, yend = -100,
                 showlegend = FALSE,
                 line = list(color = '#333333'), hoverinfo = "none") %>%
    add_segments(x = -100, xend = 100, y = 0, yend = 0,
                 showlegend = FALSE,
                 line = list(color = '#333333'), hoverinfo = "none") %>%
    add_markers(data = filter(df, pitcher == player),
                x = ~spin.circ.x, y = ~spin.circ.y, symbol = ~pitch.type,
                marker = list(size = 10,
                              opacity = 0.65,
                              color = 'black'),
                text = text.bpen,
                hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>%
    add_annotations(text = "0˚", 
                    x = 0, y = 105,
                    font = list(size = 16),
                    showarrow = FALSE) %>% 
    add_annotations(text = "90˚", 
                    x = 110, y = 0,
                    font = list(size = 16),
                    showarrow = FALSE) %>%
    add_annotations(text = "180˚", 
                    x = 0, y = -105,
                    font = list(size = 16),
                    showarrow = FALSE) %>%
    add_annotations(text = "270˚", 
                    x = -110, y = 0,
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
           title = "Velo and Spin Axis")
  
}
      
PitchDashSpinAxisSpinCirBPen <- function(df = bpen, player = "Andrew Schmit"){
  df <- df %>% mutate(spin.circ.x = -pitch.spin*cospi((pitch.spin.axis+90)/180), 
                          spin.circ.y = pitch.spin*sinpi((pitch.spin.axis+90)/180))
  
  circleFun <- function(center=c(0,0), diameter=100, npoints=100, start=0, end=2, filled=TRUE){
    tt <- seq(start*pi, end*pi, length.out=npoints)
    df1 <- data.frame(
      x = center[1] + diameter / 2 * cos(tt),
      y = center[2] + diameter / 2 * sin(tt)
    )
    if(filled==TRUE) { #add a point at the center so the whole 'pie slice' is filled
      df1 <- rbind(df1, center)
    }
    return(df1)
  }
  
  spin2200 <- circleFun(c(0,0), diameter = 4400, npoints = 1000, start = 0, end = 2, filled = TRUE)
  spin2000 <- circleFun(c(0,0), diameter = 4000, npoints = 1000, start = 0, end = 2, filled = TRUE)
  spin1800 <- circleFun(c(0,0), diameter = 3600, npoints = 1000, start = 0, end = 2, filled = TRUE)
  spin1600 <- circleFun(c(0,0), diameter = 3200, npoints = 1000, start = 0, end = 2, filled = TRUE)
  spin1400 <- circleFun(c(0,0), diameter = 2800, npoints = 1000, start = 0, end = 2, filled = TRUE)
  spin1200 <- circleFun(c(0,0), diameter = 2400, npoints = 1000, start = 0, end = 2, filled = TRUE)
  
  
  plot_ly(data = filter(df, pitcher == player),
          symbols = pitch.symbols) %>% 
    add_polygons(data = spin2200,
                 x = ~x, y = ~y, fillcolor = '#CD2626',
                 line = list(color = '#CD2626'),
                 name = "2200 - 2000 rpm") %>%
    add_polygons(data = spin2000,
                 x = ~x, y = ~y, fillcolor = '#00CD00',
                 line = list(color = '#00CD00'),
                 name = "2000 - 1800 rpm") %>%
    add_polygons(data = spin1800,
                 x = ~x, y = ~y, fillcolor = '#FFDAB9',
                 line = list(color = '#FFDAB9'),
                 name = "1800 - 1600 rpm") %>%
    add_polygons(data = spin1600,
                 x = ~x, y = ~y, fillcolor = '#B0E0E6',
                 line = list(color = '#B0E0E6'),
                 name = "1600 - 1400 rpm") %>%
    add_polygons(data = spin1400,
                 x = ~x, y = ~y, fillcolor = '#CD661D',
                 line = list(color = '#CD661D'),
                 name = "1400 - 1200 rpm") %>%
    add_polygons(data = spin1200,
                 x = ~x, y = ~y, fillcolor = '#EE9572',
                 line = list(color = '#EE9572'),
                 name = "< 1200 rpm") %>%
    add_segments(x = -1550, xend = 1550, y = 1550, yend = -1550,
                 showlegend = FALSE,
                 line = list(color = '#696969',
                             dash = 'dash'), hoverinfo = "none") %>%
    add_segments(x = -1550, xend = 1550, y = -1550, yend = 1550,
                 showlegend = FALSE,
                 line = list(color = '#696969',
                             dash = 'dash'), hoverinfo = "none") %>%
    add_segments(x = 0, xend = 0, y = 2200, yend = -2200,
                 showlegend = FALSE,
                 line = list(color = '#333333'), hoverinfo = "none") %>%
    add_segments(x = -2200, xend = 2200, y = 0, yend = 0,
                 showlegend = FALSE,
                 line = list(color = '#333333'), hoverinfo = "none") %>%
    add_markers(data = filter(df, pitcher == player),
                x = ~spin.circ.x, y = ~spin.circ.y, symbol = ~pitch.type,
                marker = list(size = 10,
                              opacity = 0.65,
                              color = 'black'),
                text = text.bpen,
                hoverinfo = 'text', hoverlabel = list(bgcolor = 'white')) %>%
    add_annotations(text = "0˚", 
                    x = 0, y = 2300,
                    font = list(size = 16),
                    showarrow = FALSE) %>% 
    add_annotations(text = "90˚", 
                    x = 2400, y = 0,
                    font = list(size = 16),
                    showarrow = FALSE) %>%
    add_annotations(text = "180˚", 
                    x = 0, y = -2300,
                    font = list(size = 16),
                    showarrow = FALSE) %>%
    add_annotations(text = "270˚", 
                    x = -2400, y = 0,
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
           title = "Spin Rate and Spin Axis")  
}

PitchTableBPen <- function(df = bpen, player = "Andrew Schmit") {
  df <- df %>% 
    dplyr::mutate(in.zone = ifelse(pz <= 3.5 & 
                                     pz >= 1.6 & 
                                     px >= -0.95 & 
                                     px <= 0.95, 1, 0))
  
  pitch.table <- df %>% 
    filter(pitcher == player) %>% 
    dplyr::filter(!is.na(in.zone)) %>% 
    dplyr::group_by(pitch.type) %>% 
    dplyr::summarise(Zone.Pct = mean(in.zone, na.rm = TRUE),
                     Med.Velo = median(pitch.speed, na.rm = TRUE),
                     Med.Break.V = median(pitch.break.ind.v, na.rm = TRUE),
                     Med.Break.H = median(pitch.break.h, na.rm = TRUE),
                     Med.Spin.Rate = median(pitch.spin, na.rm = TRUE),
                     Med.Spin.Axis = median(pitch.spin.axis, na.rm = TRUE),
                     No.Pitch = length(no)
    )
  
  
  
  return(pitch.table)
}

PitchExtensionBPen <- function(df = bpen, player = "Andrew Schmit"){
  pitch.rubber <- data.frame(
    x = c(-1, -1, 1, 1),
    x1 = c(-1, 1, 1, -1),
    y = c(-.5, 0, 0, -.5),
    y1 = c(0, 0, -.5, -.5))
  
  plot_ly(symbols = pitch.symbols) %>%
    add_segments(data = pitch.rubber,
                 x = ~x, xend = ~x1, y = ~y, yend = ~y1,
                 color = I("grey50"), showlegend = FALSE) %>% 
    add_trace(data = filter(df, pitcher == player),
              x = ~pitch.release.side, y = ~pitch.extension,
              type = 'scatter', mode = 'markers',
              marker = list(size = 10,
                            opacity = 0.75,
                            line = list(color = "#000000",
                                        width = 1)),
              symbol = ~pitch.type,
              text = text.bpen,
              hoverinfo = 'text') %>%
    layout(xaxis = list(range = c(-6,6),
                        zeroline = FALSE,
                        title = "Pitch Release Side"),
           yaxis = list(range = c(-0.8,9),
                        zeroline = FALSE,
                        title = "Pitch Extension"),
           title = paste(as.character(player),"Extension", sep = " "))
}

for(i in 1:nrow(bpen)) {
  if(bpen$pitch.type[i] %in% c("Curveball", "Slider")) {
    bpen$pitch.type.simp[i] = "Breaking Ball"
  } else if (bpen$pitch.type[i] %in% c("Fastball", "Cutter", "Sinker", "Splitter")){
    bpen$pitch.type.simp[i] = "Fastball"
  } else if (bpen$pitch.type[i] == "Changeup"){
    bpen$pitch.type.simp[i] = "Changeup"
  } else {bpen$pitch.type.simp[i] = "No Type"}
}

pitch.symbols.simp <- c("Fastball" = 'circle',
                        "Breaking Ball" = 'diamond', 
                        "Changeup" = 'square',
                        "No Type" = 'cross')

PitchRelease3DBPen <- function(df = bpen, player = "Andrew Schmit") {
  pitch.rubber.3d <- data.frame(
    x = c(-1, -1, 1, 1, -1),
    y = c(-.5, 0, 0, -.5, -.5),
    z = c(0, 0, 0, 0, 0))
  
  plot_ly(symbols = pitch.symbols.simp) %>%
    add_trace(data = pitch.rubber.3d,
              x = ~x, y = ~y, z = ~z,
              type = 'scatter3d', mode = 'lines',
              color = I("black"), showlegend = FALSE) %>%
    add_markers(data = filter(df, pitcher == player),
                x = ~pitch.release.side, y = ~pitch.extension, z = ~pitch.release.height,
                marker = list(size = 5,
                              opacity = 0.75,
                              line = list(color = "#000000",
                                          width = 1)),
                symbol = ~pitch.type.simp,
                text = text.bpen, hoverinfo = 'text') %>%
    layout(scene = list(xaxis = list(range = c(-6,6),
                                     zeroline = FALSE,
                                     title = "Pitch Release Side"),
                        yaxis = list(range = c(-0.8,9),
                                     zeroline = FALSE,
                                     title = "Pitch Extension"),
                        zaxis = list(range = c(0,7),
                                     zeroline = FALSE,
                                     title = "Pitch Height")))
}
