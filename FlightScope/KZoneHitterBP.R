library(ggplot2)
library(tidyverse)
library(plotly)

KZoneHitter <- function(df = bp, player = "Ski ", exit.velo = FALSE) {
  k.zone <- data.frame(
    x1 = rep(c(-.95,-.95+(1.9/3),-.95+2*(1.9/3)), each = 3),
    x2 = rep(c(-.95+(1.9/3),-.95+2*(1.9/3),.95), each = 3),
    y1 = rep(c(1.6,1.6+1.9/3,1.6+2*1.9/3), 3),
    y2 = rep(c(1.6+1.9/3,1.6+2*1.9/3,3.5), 3),
    z = factor(c(7, 4, 1, 8, 5, 2, 9, 6, 3))
  )
  
  df$hit.flag <- with(df, ifelse(is.na(hit.ball.speed), "Not Hit", "Hit"))
  
  gg <- ggplot() + ggtitle(as.character(player)) +
    xlim(-1.5, 1.5) + xlab("") +
    ylim(1, 4.5) + ylab("") +
    geom_rect(data = k.zone,
              aes(xmin = x1, xmax = x2, ymin = y2, ymax = y1), 
              color = "grey20", fill = "white") +
    theme(legend.text = element_text(size = 14),
          title = element_text(size = 18, face = "bold"))
  
  if(exit.velo) {
    gg1 <- gg + 
      geom_point(data = filter(df, batter == player), 
                 aes(x = -pitch.k.zone.offset, y = pitch.k.zone.height, 
                     color = hit.ball.speed, 
                     text = paste("Exit Velo:", hit.ball.speed,
                                  "<br> Launch Angle:", hit.ball.launch.v,
                                  "<br> Pitch Velo:", pitch.speed)),
                 size = 4, alpha = 1/2) +
      scale_color_gradient(low="blue", high="red", name = "Exit Velo") 
  } 
  
  else {
    gg1 <- gg +
      geom_point(data = filter(df, batter == player), 
                 aes(x = -pitch.k.zone.offset, y = pitch.k.zone.height, 
                     color = hit.flag, 
                     text = paste("Exit Velo:", hit.ball.speed,
                                  "<br> Launch Angle:", hit.ball.launch.v,
                                  "<br> Pitch Velo:", pitch.speed)), 
                 size = 4, alpha = 1/2) + 
      scale_color_manual(values = c("Hit" = "red", "Not Hit" = "black"),name = "")
  }
  
  ggplotly(gg1, tooltip = c("text"))
  
}
