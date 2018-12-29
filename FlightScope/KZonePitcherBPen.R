require(ggplot2)

KZonePitcherBPen = function(df = bp, player = "Leroy Jenkins (#99)", speed = FALSE, pitch.type = FALSE){
  k.zone = data.frame(
    x1 = rep(c(-.95,-.95+(1.9/3),-.95+2*(1.9/3)), each = 3),
    x2 = rep(c(-.95+(1.9/3),-.95+2*(1.9/3),.95), each = 3),
    y1 = rep(c(1.6,1.6+1.9/3,1.6+2*1.9/3), 3),
    y2 = rep(c(1.6+1.9/3,1.6+2*1.9/3,3.5), 3),
    z = factor(c(7, 4, 1, 8, 5, 2, 9, 6, 3))
  )
  
  df$pitch.type = "FB"
  
  if(speed & pitch.type)
    ggplot() + ggtitle(as.character(player), subtitle = "Hitter View") +
    xlim(-3, 3) + xlab("") +
    ylim(0, 6) + ylab("") +
    geom_point(data = df[which(df$pitcher == player),], aes(x = px, y = pz, shape = pitch.type, color = pitch.speed), size = 3) +
    geom_rect(data = k.zone,
              aes(xmin = x1, xmax = x2, ymin = y2, ymax = y1), 
              color = "grey20", fill = "white", alpha = .001) +
    scale_color_continuous(low = "red", high = "red4") +
    labs(color = "Speed", shape = "Pitch Type") +
    theme(title = element_text(size = 18, face = "bold"),
          plot.background=element_blank(),
          panel.border = element_rect(colour = "black", fill=NA),
          legend.key = element_blank(),
          legend.text = element_text(size = 14))
  
  else if(speed)
    ggplot() + ggtitle(as.character(player), subtitle = "Hitter View") +
    xlim(-3, 3) + xlab("") +
    ylim(0, 6) + ylab("") +
    geom_point(data = df[which(df$pitcher == player),], aes(x = px, y = pz, color = pitch.speed), size = 3) +
    geom_rect(data = k.zone,
              aes(xmin = x1, xmax = x2, ymin = y2, ymax = y1), 
              color = "grey20", fill = "white", alpha = .001) +
    scale_color_continuous(low = "red", high = "red4") +
    labs(color = "Speed") +
    theme(title = element_text(size = 18, face = "bold"),
          plot.background=element_blank(),
          panel.border = element_rect(colour = "black", fill=NA),
          legend.key = element_blank(),
          legend.text = element_text(size = 14))
  
  else if(pitch.type)
    ggplot() + ggtitle(as.character(player), subtitle = "Hitter View") +
    xlim(-3, 3) + xlab("") +
    ylim(0, 6) + ylab("") +
    geom_point(data = df[which(df$pitcher == player),], aes(x = px, y = pz, shape = pitch.type), size = 3) +
    geom_rect(data = k.zone,
              aes(xmin = x1, xmax = x2, ymin = y2, ymax = y1), 
              color = "grey20", fill = "white", alpha = .001) +
    labs(shape = "Pitch Type") +
    theme(title = element_text(size = 18, face = "bold"),
          plot.background=element_blank(),
          panel.border = element_rect(colour = "black", fill=NA),
          legend.key = element_blank(),
          legend.text = element_text(size = 14))
  
  else
    ggplot() + ggtitle(as.character(player), subtitle = "Hitter View") +
    xlim(-3, 3) + xlab("") +
    ylim(0, 6) + ylab("") +
    geom_point(data = df[which(df$pitcher == player),], aes(x = px, y = pz), size = 3) +
    geom_rect(data = k.zone,
              aes(xmin = x1, xmax = x2, ymin = y2, ymax = y1), 
              color = "grey20", fill = "white", alpha = .001) +
    scale_color_continuous(low = "red", high = "red4") +
    labs(color = "Speed", shape = "Pitch Type") +
    theme(title = element_text(size = 18, face = "bold"),
          plot.background = element_blank(),
          panel.border = element_rect(colour = "black", fill=NA))
  
}
