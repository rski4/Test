require(RCurl)
require(plyr)
require(stringr)

#### Play by Play Data ####

play17 = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/events2017.csv"))
play17$Year = 2017
play18 = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/events2018.csv"))
play18$Year = 2018

play=rbind(play17, play18)


# Get Rid of NA #
play = play[!is.na(play$pitcher),]
play$runner_on_1st_dest[is.na(play$runner_on_1st_dest)]=0
play$runner_on_2nd_dest[is.na(play$runner_on_2nd_dest)]=0
play$runner_on_3rd_dest[is.na(play$runner_on_3rd_dest)]=0
play$batter_dest[is.na(play$batter_dest)]=0



#### Run Expectancy Matrix ####

# Game ID #
play$gameID=with(play, paste(date,start,home_team))

# Runs in Inning #
play$RUNS=with(play, home_score + vis_score)

# Half Inning Unique Identifier #
play$half.inning=with(play, paste(gameID,inning,batting_team))

# Runs Scored on each play #
play$runs.scored=with(play, as.numeric((batter_dest==4)) +
                          as.numeric((runner_on_1st_dest==4)) +
                          as.numeric((runner_on_2nd_dest==4)) +
                          as.numeric((runner_on_3rd_dest==4)))

# Replace NAs w/ 0 #
play$runs.scored[is.na(play$runs.scored)]=0

# Runs Scored in each half inning #
runs.scored.inning=aggregate(play$runs.scored,
                             list(half.inning=play$half.inning), sum)

# Runs at beginning of each half inning #
runs.scored.start=aggregate(play$RUNS,
                            list(half.inning=play$half.inning), "[",1)

# data frame with maximum runs scored
MAX= data.frame(half.inning=runs.scored.start$half.inning)
MAX$x=runs.scored.inning$x + runs.scored.start$x

play=merge(play,MAX)

N=ncol(play)

names(play)[N]="max.runs"

# Runs rest of inning #
play$run.roi = with(play, max.runs - RUNS)

# Runner states as binary 0,1 #
runner1=ifelse(as.character(play[,"first_runner"])=="",0,1)
runner2=ifelse(as.character(play[,"second_runner"])=="",0,1)
runner3=ifelse(as.character(play[,"third_runner"])=="",0,1)

# Find state #
get.state = function(runner1,runner2,runner3,outs){
  runners = paste(runner1, runner2, runner3, sep="")
  paste(runners,outs)
}

play$state = get.state(runner1, runner2, runner3, play$outs)

# Runner Out states after play #
nrunner1 = with(play, as.numeric(runner_on_1st_dest == 1 | batter_dest == 1))
nrunner2 = with(play, as.numeric(runner_on_1st_dest == 2 | runner_on_2nd_dest == 2 |
                                     batter_dest == 2))
nrunner3 = with(play, as.numeric(runner_on_1st_dest == 3 | runner_on_2nd_dest == 3 |
                                     runner_on_3rd_dest == 3 | batter_dest == 3))

nouts = with(play, outs + outs_on_play)

play$new.state = get.state(nrunner1,nrunner2,nrunner3,nouts)

play = subset(play, (state != new.state) | (runs.scored > 0))

# Take only half innings where 3 outs made #
data.outs = ddply(play, .(half.inning), summarize, 
                  outs.inning = sum(outs_on_play))
play = merge(play, data.outs)
playc = subset(play, outs.inning == 3)

# Average runs to end of inning by state #
runs=with(playc, aggregate(run.roi, list(state), mean))

runs$Outs = substr(runs$Group, 5, 5)
runs = runs[order(runs$Outs),]

runs.out = matrix(round(runs$x, 2), 8, 3)
dimnames(runs.out)[[2]] = c("0 outs", "1 out", "2 outs")
dimnames(runs.out)[[1]] = c("000","001","010","011","100","101","110","111")

base.out.re = as.data.frame(runs.out)
base.out.re$Base = rownames(base.out.re)
base.out.re = base.out.re[,c("Base", "0 outs", "1 out", "2 outs")]

#### Run Value of Events ####

# Add 3 outs which will have run value of 0 #
runs.potential = matrix(c(runs$x, rep(0,8)), 32, 1)
dimnames(runs.potential)[[1]] = c(runs$Group.1, "000 3", "001 3", 
                                  "010 3", "011 3", "100 3", "101 3",
                                  "110 3", "111 3")

# Find Run Expectancy before play #
play$runs.state = runs.potential[play$state,]

# Run Expectancy After #
play$new.state <- gsub(' 4', ' 3', play$new.state) #Get rid of 4
play$runs.new.state = runs.potential[play$new.state,]

# Run Value #
play$runs.value = with(play, runs.new.state - runs.state + runs.scored)

# Run Value by Event #
rv = ddply(play, .(event_type), summarise,
           Run.Value = mean(runs.value),
           N = length(runs.value))
rv

# Run Value for Player #

rv.player = ddply(play, .(batter, Year), summarise,
                  Runs.Created = round(sum(runs.value), digits = 2),
                  Runs.Start = round(mean(runs.state), digits = 2),
                  Runs.End = round(mean(runs.new.state), digits = 2),
                  Avg.Runs = round(mean(runs.scored), digits = 2),
                  N = length(runs.value))


player.team = as.data.frame(unique(play[c("batter_last_name", "batting_team")]))

teams.home = as.data.frame(unique(play["home_team"]))
colnames(teams.home) = "Team"
teams.away = as.data.frame(unique(play["visiting_team"]))
colnames(teams.away) = "Team"

teams = merge(teams.home, teams.away, all.x = T, all.y = T)
