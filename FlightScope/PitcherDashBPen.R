library(ggplot2)
library(RCurl)
library(tidyverse)
library(plotly)
library(grid)

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


  