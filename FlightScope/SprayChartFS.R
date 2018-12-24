require(ggplot2)

SprayChartFS = function(df = bp, player = "Ski ", exit.velo = FALSE, launch.angle = FALSE) {
  df$hc.x = with(df, ifelse(hit.ball.launch.h > 0, 
                            sinpi(abs(hit.ball.launch.h)/180)*hit.carry.dist,
                            -sinpi(abs(hit.ball.launch.h)/180)*hit.carry.dist))
  df$hc.y = with(df, cospi(abs(hit.ball.launch.h)/180)*hit.carry.dist)
 
  if(exit.velo & launch.angle)
    ggplot() +
    xlim(-240,240) + ylim(0,385) +
    geom_segment(aes(x = 0, xend = -236, y = 0, yend = 236)) +
    geom_segment(aes(x = 0, xend = 226, y = 0, yend = 226)) +
    geom_curve(aes(x = -236, xend = 226, y = 236, yend = 226), curvature = -.60) +
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_blank(),
          title = element_text(size = 18, face = "bold"),
          legend.position = "bottom") +
    xlab("") + ylab("") + ggtitle(as.character(player)) +
    geom_point(data = df[which(df$batter == player),], aes(x = hc.x, y = hc.y, color = hit.ball.speed, size = hit.ball.launch.v)) +
    scale_color_gradient(low="blue", high="red", name = "Exit Velo") +
    scale_size(range = c(1,6), name = "Launch Angle")
  
  else if (launch.angle)
    ggplot() +
    xlim(-240,240) + ylim(0,385) +
    geom_segment(aes(x = 0, xend = -236, y = 0, yend = 236)) +
    geom_segment(aes(x = 0, xend = 226, y = 0, yend = 226)) +
    geom_curve(aes(x = -236, xend = 226, y = 236, yend = 226), curvature = -.60) +
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_blank(),
          title = element_text(size = 18, face = "bold"),
          legend.position = "bottom") +
    xlab("") + ylab("") + ggtitle(as.character(player)) +
    geom_point(data = df[which(df$batter == player),], aes(x = hc.x, y = hc.y, size = hit.ball.launch.v)) +
    scale_size(range = c(1,6), name = "Launch Angle")
  
  else if(exit.velo)
    ggplot() +
    xlim(-240,240) + ylim(0,385) +
    geom_segment(aes(x = 0, xend = -236, y = 0, yend = 236)) +
    geom_segment(aes(x = 0, xend = 226, y = 0, yend = 226)) +
    geom_curve(aes(x = -236, xend = 226, y = 236, yend = 226), curvature = -.60) +
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_blank(),
          title = element_text(size = 18, face = "bold"),
          legend.position = "bottom") +
    xlab("") + ylab("") + ggtitle(as.character(player)) +
    geom_point(data = df[which(df$batter == player),], aes(x = hc.x, y = hc.y, color = hit.ball.speed), size = 3) +
    scale_color_gradient(low="blue", high="red", name = "Exit Velo")
  
  else
    ggplot() +
    xlim(-240,240) + ylim(0,385) +
    geom_segment(aes(x = 0, xend = -236, y = 0, yend = 236)) +
    geom_segment(aes(x = 0, xend = 226, y = 0, yend = 226)) +
    geom_curve(aes(x = -236, xend = 226, y = 236, yend = 226), curvature = -.60) +
    theme(axis.line=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_blank(),
          title = element_text(size = 18, face = "bold")) +
    xlab("") + ylab("") + ggtitle(as.character(player)) +
    geom_point(data = df[which(df$batter == player),], aes(x = hc.x, y = hc.y), size = 3)

}

