library(ggplot2)
library(RCurl)
library(tidyverse)
library(plotly)
library(grid)

PitchDashSpinAxisVeloCirBPen <- function(df = bp) {
  py <- plot_ly(df, x = ~no, alpha = 0.5, symbol = ~pitch.type, 
                color = I('black'), marker = list(size = 10),
                text = ~paste("Pitch No:", no,
                              "<br>Type:", pitch.type,
                              "<br>Velo:", pitch.speed,
                              "<br>Spin Rate:", pitch.spin,
                              "<br>Spin Axis:", pitch.spin.axis))
  subplot(
    add_markers(py, y = ~pitch.speed, hoverinfo = 'text') %>% 
      layout(yaxis = list(title = "Velocity")),
    add_markers(py, y = ~pitch.spin, showlegend = F, hoverinfo = 'text + y') %>% 
      layout(yaxis = list(title = "Spin Rate")),
    add_markers(py, y = ~pitch.spin.axis, showlegend = F, hoverinfo = 'text + y') %>% 
      layout(yaxis = list(title = "Spin Axis",
                          tickvals = c(0, 90, 180, 270))),
    nrows = 3, shareX = TRUE, titleY = TRUE
  ) %>% 
    layout(xaxis = list(title = "Pitch Number"))
  
}

PitchDashSpinAxisVeloCirBPen <- function(df = bp) {
  py <- plot_ly(df, x = ~no, alpha = 0.5, symbol = ~pitch.type, 
                color = I('black'), marker = list(size = 10),
                text = ~paste("Pitch No:", no,
                              "<br>Type:", pitch.type,
                              "<br>Velo:", pitch.speed,
                              "<br>Spin Rate:", pitch.spin,
                              "<br>Spin Axis:", pitch.spin.axis))
  subplot(
    add_markers(py, y = ~pitch.speed, hoverinfo = 'text') %>% 
      layout(yaxis = list(title = "Velocity")),
    add_markers(py, y = ~pitch.spin, showlegend = F, hoverinfo = 'text + y') %>% 
      layout(yaxis = list(title = "Spin Rate")),
    add_markers(py, y = ~pitch.spin.axis, showlegend = F, hoverinfo = 'text + y') %>% 
      layout(yaxis = list(title = "Spin Axis",
                          tickvals = c(0, 90, 180, 270))),
    nrows = 3, shareX = TRUE, titleY = TRUE
  ) %>% 
    layout(xaxis = list(title = "Pitch Number"))
  
}

PitchDashSpinAxisVeloCirBPen <- function(df = bp){
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
  
  
  gg <- ggplot() +
    geom_polygon(data = velo90, aes(x,y), fill = "red") +
    geom_polygon(data = velo80, aes(x,y), fill = "green3") +
    geom_polygon(data = velo70, aes(x,y), fill = "peachpuff") +
    geom_polygon(data = velo60, aes(x,y), fill = "plum3") +
    geom_segment(aes(x = 0, xend = 0, y = 100, yend = -100), color = "black", alpha = 1/2) +
    geom_segment(aes(x = -100, xend = 100, y = 0, yend = 0), color = "black", alpha = 1/2) +
    geom_segment(aes(x = -70, xend = 70, y = 70, yend = -70), color = "grey20", alpha = 1/3, linetype = "dashed") +
    geom_segment(aes(x = 70, xend = -70, y = 70, yend = -70), color = "grey20", alpha = 1/3, linetype = "dashed") +
    annotate(geom="text", x=0, y=105, label= expression(paste("0",degree,"")), color="grey20", size = 5) +
    annotate(geom="text", x=110, y=0, label= expression(paste("90",degree,"")), color="grey20", size = 5) +
    annotate(geom="text", x=0, y=-105, label= expression(paste("180",degree,"")), color="grey20", size = 5) +
    annotate(geom="text", x=-110, y=0, label= expression(paste("270",degree,"")), color="grey20", size = 5) +
    geom_point(data = df, 
               aes(x = spin.circ.x, y = spin.circ.y, 
                              shape = pitch.type,
                              text = paste("Velocity:", pitch.speed,
                                           "<br> Spin Rate:", pitch.spin,
                                           "<br> Spin Axis:", pitch.spin.axis,
                                           "<br> V Break:", pitch.break.ind.v,
                                           "<br> H Break:", -pitch.break.h)), 
               size = 4, alpha = 1/2) +
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          panel.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          plot.background = element_blank())
  
  ggplotly(gg, tooltip = c("text")) %>%
  add_annotations(x=0, y=105,
                    xref = "x", yref = "y",
                    text = "0", 
                    font = list(color = '#333333', 
                                size = 14),
                    showarrow = F) %>% 
    add_annotations(x=110, y=0,
                    xref = "x", yref = "y",
                    text = "90", 
                    font = list(color = '#333333', 
                                size = 14),
                    showarrow = F) %>% 
    add_annotations(x=0, y=-105,
                    xref = "x", yref = "y",
                    text = "180", 
                    font = list(color = '#333333', 
                                size = 14),
                    showarrow = F) %>% 
    add_annotations(x=-110, y=0,
                    xref = "x", yref = "y",
                    text = "270", 
                    font = list(color = '#333333', 
                                size = 14),
                    showarrow = F) %>%
    add_annotations(x=-100, y=100,
                    xref = "x", yref = "y",
                    text = "100-90 MPH", 
                    font = list(color = 'red',
                                size = 16),
                    showarrow = F) %>%
    add_annotations(x=-100, y=90,
                    xref = "x", yref = "y",
                    text = "90-80 MPH", 
                    font = list(color = '#00CD00',
                                size = 16),
                    showarrow = F) %>%
    add_annotations(x=-100, y=80,
                    xref = "x", yref = "y",
                    text = "80-70 MPH", 
                    font = list(color = '#FFDAB9',
                                size = 16),
                    showarrow = F) %>%
    add_annotations(x=-100, y=70,
                    xref = "x", yref = "y",
                    text = "<70 MPH", 
                    font = list(color = '#CD96CD',
                                size = 16),
                    showarrow = F) %>%
    layout(title = "Spin Axis and Velocity")
  
}

PitchDashSpinAxisSpinCirBPen <- function(df = bp){
  df <- df %>% mutate(spin.circ.rpm.x = -pitch.spin*cospi((pitch.spin.axis+90)/180), 
                      spin.circ.rpm.y = pitch.spin*sinpi((pitch.spin.axis+90)/180))
  
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
  
  rpm1800 = circleFun(c(0,0), diameter = 3600, npoints = 1000, start = 0, end = 2, filled = TRUE)
  rpm1700 = circleFun(c(0,0), diameter = 3400, npoints = 1000, start = 0, end = 2, filled = TRUE)
  rpm1600 = circleFun(c(0,0), diameter = 3200, npoints = 1000, start = 0, end = 2, filled = TRUE)
  rpm1500 = circleFun(c(0,0), diameter = 3000, npoints = 1000, start = 0, end = 2, filled = TRUE)
  
  
  gg <- ggplot() +
    geom_polygon(data = rpm1800, aes(x,y), fill = "red") +
    geom_polygon(data = rpm1700, aes(x,y), fill = "green3") +
    geom_polygon(data = rpm1600, aes(x,y), fill = "peachpuff") +
    geom_polygon(data = rpm1500, aes(x,y), fill = "plum3") +
    geom_segment(aes(x = 0, xend = 0, y = 1800, yend = -1800), color = "black", alpha = 1/2) +
    geom_segment(aes(x = -1800, xend = 1800, y = 0, yend = 0), color = "black", alpha = 1/2) +
    geom_segment(aes(x = -1250, xend = 1250, y = 1250, yend = -1250), color = "grey20", alpha = 1/3, linetype = "dashed") +
    geom_segment(aes(x = 1250, xend = -1250, y = 1250, yend = -1250), color = "grey20", alpha = 1/3, linetype = "dashed") +
    geom_point(data = df, 
               aes(x = spin.circ.rpm.x, y = spin.circ.rpm.y,
                   shape = pitch.type,
                   text = paste("Velocity:", pitch.speed,
                                           "<br> Spin Rate:", pitch.spin,
                                           "<br> Spin Axis:", pitch.spin.axis,
                                           "<br> V Break:", pitch.break.ind.v,
                                           "<br> H Break:", -pitch.break.h)), 
               size = 4, alpha = 1/2) +
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          panel.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          plot.background = element_blank())
  
  ggplotly(gg, tooltip = c("text")) %>% 
    add_annotations(x=0, y=1900,
                    xref = "x", yref = "y",
                    text = "0", 
                    font = list(color = '#333333', 
                                size = 14),
                    showarrow = F) %>% 
    add_annotations(x=1900, y=0,
                    xref = "x", yref = "y",
                    text = "90", 
                    font = list(color = '#333333', 
                                size = 14),
                    showarrow = F) %>% 
    add_annotations(x=0, y=-1900,
                    xref = "x", yref = "y",
                    text = "180", 
                    font = list(color = '#333333', 
                                size = 14),
                    showarrow = F) %>% 
    add_annotations(x=-1900, y=0,
                    xref = "x", yref = "y",
                    text = "270", 
                    font = list(color = '#333333', 
                                size = 14),
                    showarrow = F) %>%
    add_annotations(x=-1600, y=1900,
                    xref = "x", yref = "y",
                    text = "1800-1700 rpm", 
                    font = list(color = 'red',
                                size = 16),
                    showarrow = F) %>%
    add_annotations(x=-1600, y=1700,
                    xref = "x", yref = "y",
                    text = "1700-1600 rpm", 
                    font = list(color = '#00CD00',
                                size = 16),
                    showarrow = F) %>%
    add_annotations(x=-1600, y=1500,
                    xref = "x", yref = "y",
                    text = "1600-1500 rpm", 
                    font = list(color = '#FFDAB9',
                                size = 16),
                    showarrow = F) %>%
    add_annotations(x=-1600, y=1300,
                    xref = "x", yref = "y",
                    text = "<1500 rpm", 
                    font = list(color = '#CD96CD',
                                size = 16),
                    showarrow = F) %>%
    layout(title = "Spin Axis and Spin Rate")
  
}
