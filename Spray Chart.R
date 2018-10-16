require(RCurl)
require(plyr)
require(stringr)
require(ggplot2)
require(data.table)

spray.chart = function(batID) {
  
  lf = c("lf", "left field", "left center")
  cf = c("cf", "center field")
  rf = c("rf", "right field", "right center")
  b1 = c("1b", "first base")
  b2 = c("2b", "second", "second base", "right side")
  ss = c("ss", "shortstop", "short stop", "left side")
  b3 = c("3b", "third", "third base")
  
  hit.location = function(df) {
    df[,"hit.loc"] = ""
    
    row.lf = grep(paste(lf, collapse = "|"), df$hit_location)
    df[row.lf,"hit.loc"]="lf"
    
    row.cf = grep(paste(cf, collapse = "|"), df$hit_location)
    df[row.cf,"hit.loc"]="cf"
    
    row.rf = grep(paste(rf, collapse = "|"), df$hit_location)
    df[row.rf,"hit.loc"]="rf"
    
    row.b1 = grep(paste(b1, collapse = "|"), df$hit_location)
    df[row.b1,"hit.loc"]="b1"
    
    row.b2 = grep(paste(b2, collapse = "|"), df$hit_location)
    df[row.b2,"hit.loc"]="b2"
    
    row.ss = grep(paste(ss, collapse = "|"), df$hit_location)
    df[row.ss,"hit.loc"]="ss"
    
    row.b3 = grep(paste(b3, collapse = "|"), df$hit_location)
    df[row.b3,"hit.loc"]="b3"
    
    return(as.data.frame(df));
  }
  
  play = hit.location(play)
  play$hit_flag = with(play, ifelse(event_type_int >19 & event_type_int < 24, 1, 0))
  play$single_flag = with(play, ifelse(event_type_int == 20, 1, 0))
  play$double_flag = with(play, ifelse(event_type_int == 21, 1, 0))
  play$triple_flag = with(play, ifelse(event_type_int == 22, 1, 0))
  play$hr_flag = with(play, ifelse(event_type_int == 23, 1, 0))
  
  df = subset(play, batterID == batID) 
  
  df.freq = data.frame(table(df$hit.loc))
  colnames(df.freq)[1] = "loc" 
  
  df.ba = ddply(df, .(hit.loc), summarise,
                Hits = sum(hit_flag),
                Single = sum(single_flag),
                Double = sum(double_flag),
                Triple = sum(triple_flag),
                HR = sum(hr_flag),
                BIP = length(hit_flag))
  df.ba$BABIP = with(df.ba, round(Hits/BIP,digits = 3))
  df.ba$SLG = with(df.ba, round((Single + 2*Double + 3*Triple + 4*HR)/BIP, digits = 3))
  df.ba$Slash = with(df.ba, ifelse(hit.loc == "lf"|hit.loc == "cf"|hit.loc == "rf"
                                   ,paste(BABIP,SLG,sep = "/"),BABIP))
  colnames(df.ba)[1] = "loc"

  df.freq = merge(df.freq,df.ba[,c("loc", "Slash")], by = "loc")
  
  lf.plot = data.frame(loc = rep("lf", times = 4),
                       x = c(0,50,75,50),
                       y = c(100,50,75,150),
                       x.1 = rep(37.5, times = 4),
                       y.1 = rep(100, times = 4))
  cf.plot = data.frame(loc = rep("cf", times = 5),
                       x = c(75,100,125,150,50),
                       y = c(75,100,75,150,150),
                       x.1 = rep(100, times = 5),
                       y.1 = rep(125, times = 5))
  rf.plot = data.frame(loc = rep("rf", times = 4),
                       x = c(125,150,200,150),
                       y = c(75,50,100,150),
                       x.1 = rep(162.5, times = 4),
                       y.1 = rep(100, times = 4))
  b3.plot = data.frame(loc = rep("b3", times = 3),
                       x = c(50,100,62.5),
                       y = c(50,0,62.5),
                       x.1 = rep(50, times = 3),
                       y.1 = rep(31.25, times = 3))
  ss.plot = data.frame(loc = rep("ss", times = 3),
                       x = c(62.5,100,100),
                       y = c(62.5,0,100),
                       x.1 = rep(81.25, times = 3),
                       y.1 = rep(60, times = 3))
  b2.plot = data.frame(loc = rep("b2", times = 3),
                       x = c(100,137.5,100),
                       y = c(0,62.5,100),
                       x.1 = rep(118.75),
                       y.1 = rep(60, times = 3))
  b1.plot = data.frame(loc = rep("b1", times = 3),
                       x = c(100,150,137.5),
                       y = c(0,50,62.5),
                       x.1 = rep(150, times = 3),
                       y.1 = rep(31.25, times = 3))
  
  field = rbindlist(list(lf.plot,cf.plot,rf.plot,b3.plot,ss.plot,b2.plot,b1.plot))
  
  df.spray = merge(field,df.freq, by = "loc")
  
  ggplot(df.spray, aes(x = x, y = y, label = Slash)) +
    xlim(0,200) +
    ylim(0,150) +
    geom_polygon(aes(x=x, y=y, fill = as.factor(Freq), group = loc), color = "black") +
    scale_fill_brewer(palette = "Reds", name = "Freq") +
    theme(legend.position = "bottom", panel.background = element_blank(),
          axis.line = element_blank(), axis.ticks = element_blank(), 
          axis.title = element_blank(),axis.text = element_blank()) +
    coord_fixed() +
    geom_label(aes(x = x.1, y = y.1), 
               fontface = "bold")
}
