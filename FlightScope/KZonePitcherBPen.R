library(ggplot2)
library(tidyverse)
library(plotly)

KZonePitcherBPen = function(df = bp, player = "Leroy Jenkins (#99)", speed = FALSE, pitch.type = FALSE){
  k.zone = data.frame(
    x1 = rep(c(-.95,-.95+(1.9/3),-.95+2*(1.9/3)), each = 3),
    x2 = rep(c(-.95+(1.9/3),-.95+2*(1.9/3),.95), each = 3),
    y1 = rep(c(1.6,1.6+1.9/3,1.6+2*1.9/3), 3),
    y2 = rep(c(1.6+1.9/3,1.6+2*1.9/3,3.5), 3),
    z = factor(c(7, 4, 1, 8, 5, 2, 9, 6, 3))
  )
  
  df$pitch.type = "FB"
  
  gg <- ggplot() + 
    ggtitle(as.character(player), subtitle = "Hitter View") +
    xlim(-1.5, 1.5) + xlab("") +
    ylim(1, 4.5) + ylab("") +
    geom_rect(data = k.zone,
              aes(xmin = x1, xmax = x2, ymin = y2, ymax = y1), 
              color = "grey20", fill = "white") +
    theme(legend.text = element_text(size = 14),
          title = element_text(size = 18, face = "bold"))
  
  if(speed & pitch.type) {
    gg1 <- gg + 
      geom_point(data = filter(df, pitcher == player), 
                 aes(x = -pitch.k.zone.offset, y = pitch.k.zone.height, 
                     shape = pitch.type, color = pitch.speed,
                     text = paste("Velocity:", pitch.speed,
                                 "<br> Spin Rate:", pitch.spin,
                                 "<br> Spin Axis:", pitch.spin.axis,
                                 "<br> V Break:", pitch.break.ind.v,
                                 "<br> H Break:", -pitch.break.h)), 
                 size = 4, alpha = 1/2) +
      scale_color_continuous(low = "red", high = "red4") +
      labs(color = "Speed", shape = "Pitch Type")
  }
    
  else if(speed) {
    gg1 <- gg +
      geom_point(data = filter(df, pitcher == player), 
                 aes(x = -pitch.k.zone.offset, y = pitch.k.zone.height, 
                     color = pitch.speed,
                     text = paste("Velocity:", pitch.speed,
                                 "<br> Spin Rate:", pitch.spin,
                                 "<br> Spin Axis:", pitch.spin.axis,
                                 "<br> V Break:", pitch.break.ind.v,
                                 "<br> H Break:", -pitch.break.h)), 
                 size = 4, alpha = 1/2) +
      scale_color_continuous(low = "red", high = "red4") +
      labs(color = "Speed")
  }
  
  else if(pitch.type) {
    gg1 <- gg +
      geom_point(data = filter(df, pitcher == player), 
                 aes(x = -pitch.k.zone.offset, y = pitch.k.zone.height, 
                     shape = pitch.type,
                     text = paste("Velocity:", pitch.speed,
                                 "<br> Spin Rate:", pitch.spin,
                                 "<br> Spin Axis:", pitch.spin.axis,
                                 "<br> V Break:", pitch.break.ind.v,
                                 "<br> H Break:", -pitch.break.h)), 
                 size = 4, alpha = 1/2) +
      labs(shape = "Pitch Type")
  }
    
  
  else {
    gg1 <- gg +
      geom_point(data = filter(df, pitcher == player), 
                 aes(x = -pitch.k.zone.offset, y = pitch.k.zone.height,
                     text = paste("Velocity:", pitch.speed,
                                 "<br> Spin Rate:", pitch.spin,
                                 "<br> Spin Axis:", pitch.spin.axis,
                                 "<br> V Break:", pitch.break.ind.v,
                                 "<br> H Break:", -pitch.break.h)),
                 size = 4, alpha = 1/2)
  }
  
  ggplotly(gg1, tooltip = c("text"))
  
  }
