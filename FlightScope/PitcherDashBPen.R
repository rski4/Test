library(ggplot2)
library(RCurl)
library(tidyverse)
library(plotly)
library(grid)

bp = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/BP/BP_Session.csv"), col.names = paste("col", 1:77, sep = "."))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/flightscopeVar.R")))

bp = flightscopeVar(bp)

bp$pitch.type <- "FB"

# Velocity #

velo.bullpen <- function(df = bp) {
  ggplot() +
    geom_point(data = df, aes(x = no, y = pitch.speed, shape = pitch.type), size = 4, alpha = 2/3) +
    xlab("Pitch Number") + ylab("Velocity") + labs(shape = "Pitch Type")
    
}

spin.bullpen <- function(df = bp) {
  ggplot() +
    geom_point(data = df, aes(x = no, y = pitch.spin, shape = pitch.type), size = 4, alpha = 2/3) +
    xlab("Pitch Number") + ylab("Spin Rate") + labs(shape = "Pitch Type")
}

spin.axis.bullpen <- function(df = bp) {
  ggplot() +
    geom_point(data = df, aes(x = no, y = pitch.spin.axis, shape = pitch.type), size = 4, alpha = 2/3) +
    xlab("Pitch Number") + ylab("Spin Axis (degrees)") + labs(shape = "Pitch Type") +
    scale_y_continuous(breaks = c(90, 180, 270, 360))
}

spin.scatter.bullpen <- function(df = bp) {
  ggplot() +
    geom_point(data = df, aes(x = pitch.spin.axis, y = pitch.spin, shape = pitch.type), size = 4) +
    xlab("Spin Axis (degrees)") + ylab("Spin Rate") + labs(shape = "Pitch Type") +
    scale_x_continuous(breaks = c(90, 180, 270, 360))
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
    geom_point(data = df, aes(x = spin.circ.x, y = spin.circ.y,
                              text = paste("Velocity:", pitch.speed,
                                           "<br> Spin Rate:", pitch.spin,
                                           "<br> Spin Axis:", pitch.spin.axis,
                                           "<br> V Break:", pitch.break.ind.v,
                                           "<br> H Break:", -pitch.break.h)), size = 4, alpha = 2/3) +
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
    geom_point(data = df, aes(x = spin.circ.rpm.x, y = spin.circ.rpm.y,
                              text = paste("Velocity:", pitch.speed,
                                           "<br> Spin Rate:", pitch.spin,
                                           "<br> Spin Axis:", pitch.spin.axis,
                                           "<br> V Break:", pitch.break.ind.v,
                                           "<br> H Break:", -pitch.break.h)), size = 4, alpha = 2/3) +
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


  
