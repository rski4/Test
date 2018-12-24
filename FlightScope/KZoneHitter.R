require(ggplot2)


KZoneHitter = function(df = bp, player = "Ski ", hit = FALSE) {
  k.zone = data.frame(
    x1 = rep(c(-.95,-.95+(1.9/3),-.95+2*(1.9/3)), each = 3),
    x2 = rep(c(-.95+(1.9/3),-.95+2*(1.9/3),.95), each = 3),
    y1 = rep(c(1.6,1.6+1.9/3,1.6+2*1.9/3), 3),
    y2 = rep(c(1.6+1.9/3,1.6+2*1.9/3,3.5), 3),
    z = factor(c(7, 4, 1, 8, 5, 2, 9, 6, 3))
  )
  
  df$hit.flag = with(df, ifelse(is.na(hit.ball.speed), "Not Hit", "Hit"))
  
  if(hit)
         ggplot() + ggtitle(as.character(player)) +
           xlim(-1.5, 1.5) + xlab("") +
           ylim(1, 4.5) + ylab("") +
           geom_rect(data = k.zone,
                     aes(xmin = x1, xmax = x2, ymin = y2, ymax = y1), 
                     color = "grey20", fill = "white") +
           geom_point(data = df[which(df$batter == player),], aes(x = px, y = pz, color = hit.ball.speed, size = hit.ball.launch.v)) +
           scale_color_gradient(low="blue", high="red", name = "Exit Velo") +
           scale_size(range = c(1,6), name = "Launch Angle") +
           theme(legend.text = element_text(size = 14),
                 title = element_text(size = 18, face = "bold"))
  else
         ggplot() + ggtitle(as.character(player)) +
           xlim(-1.5, 1.5) + xlab("") +
           ylim(1, 4.5) + ylab("") +
           geom_rect(data = k.zone,
                     aes(xmin = x1, xmax = x2, ymin = y2, ymax = y1), 
                     color = "grey20", fill = "white") +
           geom_point(data = df[which(df$batter == player),], aes(x = px, y = pz, color = hit.flag), size = 4) +
           scale_color_manual(values = c("Hit" = "red", "Not Hit" = "black"),
                              name = "") +
           theme(legend.text = element_text(size = 14),
                 title = element_text(size = 18, face = "bold"))
  }

