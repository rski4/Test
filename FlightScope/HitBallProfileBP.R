library(ggplot2)
library(tidyverse)
library(plotly)

HitBallProfile = function(df = bp, player = "Ski "){
  df$evla.x = with(df, cospi(abs(hit.ball.launch.v/180))*hit.ball.speed)
  df$evla.y = with(df, ifelse(hit.ball.launch.v > 0,
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

 gg <- ggplot() + 
  xlim(0,110) + ylim(-100,100) +
  geom_polygon(data = ev90, aes(x,y), color = "grey88", fill = "red") +
  geom_polygon(data = ev80, aes(x,y), color = "grey88", fill = "green3") +
  geom_polygon(data = ev70, aes(x,y), color = "grey88", fill = "peachpuff") +
  geom_polygon(data = ev60, aes(x,y), color = "grey88", fill = "plum3") +
  geom_polygon(data = ev50, aes(x,y), color = "grey88", fill = "lightsteelblue1") +
  geom_segment(aes(x = 0, xend = 100, y = 0, yend = 0), color = "grey50") +
  geom_segment(aes(x = 0, xend = 70, y = 0, yend = 70), color = "grey50") +
  geom_segment(aes(x = 0, xend = 86, y = 0, yend = 86*tanpi(30/180)), color = "grey50") +
  geom_segment(aes(x = 0, xend = 98, y = 0, yend = 98*tanpi(10/180)), color = "grey50") +
  annotate(geom="text", x=82, y=73, label="45 deg", color="grey20", size = 5) +
  annotate(geom="text", x=91, y=53, label="30", color="grey20", size = 5) +
  annotate(geom="text", x=103, y=18, label="10", color="grey20", size = 5) +
  geom_point(data = filter(df, batter == player), 
             aes(x = evla.x, y = evla.y,
                 text = paste("Exit Velo:", hit.ball.speed,
                              "<br> Launch Angle:", hit.ball.launch.v,
                              "<br> Carry:", hit.carry.dist),
                 alpha = 1/2),
             size = 4) +
  scale_y_continuous(breaks = c(100,90,80,70,60,-60,-70,-80,-90,-100), 
                     labels = c("100 MPH", "90 MPH","80 MPH", "70 MPH", "60 MPH", 
                                "60 MPH", "70 MPH", "80 MPH", "90 MPH", "100 MPH")) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(size = 14),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.background = element_blank())
 
 ggplotly(gg, tooltip = c("text"))
 
}

