setwd("~/Google Drive/Courses/8 IIAC Baseball Analytics")

library(xtable)
library(ggplot2)
library(plyr)

# Import IIAC Data
iiacbat=read.csv("IIAC Team Batting.csv")
iiacpitch=read.csv("IIAC Team Pitching.csv")
iiacteam=merge(iiacbat,iiacpitch,by=c("Team","year"))

# Win Percentage and Win/Loss ratio
iiacteam$Win.Pct=with(iiacteam, w/(w+l))
iiacteam$W.L=with(iiacteam, w/l)

# Run Ratio
iiacteam$RDrat=with(iiacteam, r/ra)

# Estimate Model
pyth=lm(log(W.L)~0+log(RDrat), iiacteam)
summary(pyth)

# Predict win Percent
iiacteam$E.Win.Pct=with(iiacteam, r^1.88/(r^1.88+ra^1.88))
iiacteam$Diff=with(iiacteam, (Win.Pct-E.Win.Pct)*100)

# Coe evaluation
Coe=subset(iiacteam, teamID.x=="COE")
xtable(Coe[,c("year","r","ra","Win.Pct","E.Win.Pct","Diff")])

colMeans(Coe[,c("r","ra","Win.Pct","E.Win.Pct","Diff")])

# Team by Team Evaluation
teams.avg=ddply(iiacteam, 
                .(teamID.x), summarize,
                RS=mean(r),
                RA=mean(ra),
                Win.Pct=mean(Win.Pct),
                E.Win.Pct=mean(E.Win.Pct),
                Diff=mean(Diff))

xtable(teams.avg)

# Visualize

ggplot(data=iiacteam, aes(x=r^1.88/(r^1.88+ra^1.88), y=Win.Pct))+
  geom_abline(slope=1,intercept=0)+
  geom_hline(yintercept = 0.5, linetype='dashed', alpha = .6)+
  geom_vline(xintercept = 0.5, linetype='dashed', alpha = .6)+
  geom_point(data = subset(iiacteam, teamID.x != "COE"),
             size = 3)+
  geom_point(data = subset(iiacteam, teamID.x == "COE"),
             color = 'firebrick', 
             shape = 17,
             size = 3)+
  labs(x="Pyth Predicted Win Pct", y="Actual Win Pct")

# Averages
with(iiacteam, mean(r)) #241.7
with(iiacteam, mean(ra)) #230.3
with(iiacteam, mean(G)) # 40.5

# Pyth Evaluated at Averages
(242^1.88/(242^1.88+230^1.88))*40
# 13 Runs for a win

