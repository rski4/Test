library(RCurl)
library(data.table)


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
                   "Contact Out" = '#DAA520',
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


PitchKZoneLive <- function(df = live, player = "Andrew Schmit", Velo = FALSE){
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
                text = hover.text.live,
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
    plot_ly(symbols = pitch.symbols,
            colors = outcome.color) %>% 
      add_segments(data = k.zone, x = ~x1, xend = ~x2, y = ~y1, yend = ~y2, 
                   color = I("black"), showlegend = FALSE) %>% 
      add_segments(data = nine.box, x = ~x1, xend = ~x2, y = ~y1, yend = ~y2,
                   color = I("grey80"), showlegend = FALSE) %>% 
      add_trace(data = filter(df, pitcher == player),
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
      add_trace(data = filter(df, pitcher == player),
                x = ~px, y = ~pz,
                type = 'scatter', mode = 'markers',
                color = ~pitch.call,
                #symbol = ~pitch.type,
                marker = list(size = 8, 
                              opacity = 0.6),
                text = hover.text.live,
                hoverinfo = 'text') %>%
      add_trace(data = filter(df, pitcher == player),
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
}

PitchReleaseLive <- function(df = live, player = "Andrew Schmit") {
  plot_ly(data = filter(df, pitcher == player),
          x = ~pitch.release.side, y = ~pitch.release.height,
          type = "scatter", mode = "markers",
          marker = list(size = 10, opacity = 0.6),
          text = hover.text.live,
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

PitchMovementPitchViewLive <- function(df = live, player = "Andrew Schmit") {
  plot_ly(data = filter(df, pitcher == player),
          x = ~pitch.break.h, y = ~pitch.break.ind.v,
          type = 'scatter', mode = 'markers',
          marker = list(size = 10,
                        opacity = 0.75),
          text = hover.text.live,
          symbol = ~pitch.type, symbols = pitch.symbols) %>% 
    layout(xaxis = list(title = "Horizontal Break (in)"),
           yaxis = list(title = "Vertical Break (in)"),
           title = "Pitcher View Movement")
}

PitchMovementBatViewLive <- function(df = live, player = "Andrew Schmit") {
  plot_ly(data = filter(df, pitcher == player),
          x = ~pfxx, y = ~pfxz,
          type = 'scatter', mode = 'markers',
          marker = list(size = 10,
                        opacity = 0.75),
          text = hover.text.live,
          symbol = ~pitch.type, symbols = pitch.symbols) %>% 
    layout(xaxis = list(title = "Horizontal Break last 40ft (in)"),
           yaxis = list(title = "Vertical Break last 40ft (in)"),
           title = "Hitter View Movement")
}

PitchDashSpinAxisVeloCirLive <- function(df = live, player = "Andrew Schmit"){
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
                text = hover.text.live,
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

PitchDashSpinAxisSpinCirLive <- function(df = live, player = "Andrew Schmit"){
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
                text = hover.text.live,
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

PitchTableLive <- function(df = live, player = "Andrew Schmit") {
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
                     Swing.K.Pct = length(pitch.call[pitch.call=='Swinging Strike'])/length(pitch.call),
                     Contact.Pct = length(pitch.call[pitch.call=='Single'])/length(pitch.call),
                     Med.Velo = median(pitch.speed, na.rm = TRUE),
                     Med.Break.V = median(pitch.break.ind.v, na.rm = TRUE),
                     Med.Break.H = median(pitch.break.h, na.rm = TRUE),
                     Med.Spin.Rate = median(pitch.spin, na.rm = TRUE),
                     Med.Spin.Axis = median(pitch.spin.axis, na.rm = TRUE),
                     Med.Exit.Velo = median(hit.ball.speed, na.rm = TRUE),
                     No.Pitch = length(no)
    )
  
  t1 <- t(pitch.table)
  
  colnames(t1) <- t1[1,]
  
  t1 <- t1[-1,]
  
  t2 <- rownames_to_column(data.frame(t1), "Metric")
  
  return(t2)
}


PitchExtensionLive <- function(df = live, player = "Andrew Schmit") {
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
              type = "scatter", mode = "markers",
              marker = list(size = 10,
                            opacity = 0.75,
                            line = list(color = "#000000",
                                        width = 1)),
              text = hover.text.live,
              hoverinfo = 'text',
              symbol = ~pitch.type) %>% 
    layout(xaxis = list(title = "Pitch Release Side (ft)",
                        range = c(-6,6),
                        zeroline = FALSE),
           yaxis = list(title = "Pitch Release Extension (ft)",
                        range = c(-0.8,9),
                        zeroline = FALSE),
           title = paste(as.character(player),"Extension", sep = " "))
}

for(i in 1:nrow(live)) {
  if(live$pitch.type[i] %in% c("Curveball", "Slider")) {
    live$pitch.type.simp[i] = "Breaking Ball"
  } else if (live$pitch.type[i] %in% c("Fastball", "Cutter", "Sinker", "Splitter")){
    live$pitch.type.simp[i] = "Fastball"
  } else if (live$pitch.type[i] == "Changeup"){
    live$pitch.type.simp[i] = "Changeup"
  } else {live$pitch.type.simp[i] = "No Type"}
}

pitch.symbols.simp <- c("Fastball" = 'circle',
                        "Breaking Ball" = 'diamond', 
                        "Changeup" = 'square',
                        "No Type" = 'cross')

PitchRelease3DLive <- function(df = live, player = "Andrew Schmit") {
  pitch.rubber.3d <- data.frame(
    x = c(-1, -1, 1, 1, -1),
    y = c(-.5, 0, 0, -.5, -.5),
    z = c(0, 0, 0, 0, 0))
  
  plot_ly(symbols = pitch.symbols.simp,
          colors = outcome.color) %>%
    add_trace(data = pitch.rubber.3d,
              x = ~x, y = ~y, z = ~z,
              type = 'scatter3d', mode = 'lines',
              color = I("black"), showlegend = FALSE) %>%
    add_markers(data = filter(df, pitcher == player),
                x = ~pitch.release.side, y = ~pitch.extension, z = ~pitch.release.height,
                marker = list(size = 7,
                              opacity = 0.75,
                              color = "#FFFFFF",
                              line = list(color = "#000000",
                                          width = 2)),
                symbol = ~pitch.type.simp,
                text = hover.text.live, hoverinfo = 'text') %>%
    add_markers(data = filter(df, pitcher == player),
                x = ~pitch.release.side, y = ~pitch.extension, z = ~pitch.release.height,
                marker = list(size = 5,
                              opacity = 0.75),
                color = ~pitch.call,
                text = hover.text.live, hoverinfo = 'text') %>%
    add_markers(data = filter(df, pitcher == player),
                x = ~pitch.release.side, y = ~pitch.extension, z = ~pitch.release.height,
                marker = list(size = 7,
                              opacity = 0.75,
                              line = list(color = "#000000",
                                          width = 2)),
                color = ~pitch.call,
                symbol = ~pitch.type.simp,
                showlegend = FALSE) %>%
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
