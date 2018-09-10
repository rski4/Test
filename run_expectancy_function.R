# RUNS EXPECTANCY FUNCTION
library(plyr)

runs.expectancy <- function(data){
  data$batter_dest[is.na(data$batter_dest)] <- 0
  data$runner_on_1st_dest[is.na(data$runner_on_1st_dest)] <- 0
  data$runner_on_2nd_dest[is.na(data$runner_on_2nd_dest)] <- 0
  data$runner_on_3rd_dest[is.na(data$runner_on_3rd_dest)] <- 0
  
  ### RUNS TO END OF INNING CALC ###
  data$RUNS <- with(data, vis_score + home_score)
  data$GAME_ID <- with(data, paste(date, start, visiting_team, home_team, sep=""))
  data$HALF.INNING <- with(data, paste(GAME_ID, inning, top_or_bot, sep=""))
  
  data$RUNS.SCORED <- with(data, as.numeric(batter_dest == 4) + 
                             as.numeric(runner_on_1st_dest == 4) +
                             as.numeric(runner_on_2nd_dest == 4) +
                             as.numeric(runner_on_3rd_dest == 4))
  RUNS.SCORED.INNING <- aggregate(data$RUNS.SCORED, list(HALF.INNING=data$HALF.INNING), sum)
  RUNS.SCORED.START <- aggregate(data$RUNS,
                                 list(HALF.INNING=data$HALF.INNING), "[", 1)
  
  MAX <- data.frame(HALF.INNING=RUNS.SCORED.START$HALF.INNING)
  MAX$x <- RUNS.SCORED.INNING$x + RUNS.SCORED.START$x
  data <- merge(data, MAX)
  N <- ncol(data)
  names(data)[N] <- "MAX.RUNS"
  
  data$RUNS.ROI <- with(data, MAX.RUNS - RUNS)
  
  ### CALCULATING THE MATRIX ###
  
  RUNNER1 <- ifelse(as.character(data[ , "first_runner"]) == "", 0, 1)
  RUNNER2 <- ifelse(as.character(data[ , "second_runner"]) == "", 0, 1)
  RUNNER3 <- ifelse(as.character(data[ , "third_runner"]) == "", 0, 1)
  
  data$STATE <- get.state(RUNNER1, RUNNER2, RUNNER3, data$outs)
  NRUNNER1 <- with(data, as.numeric(runner_on_1st_dest == 1 | 
                                      batter_dest == 1))
  NRUNNER2 <- with(data, as.numeric(runner_on_1st_dest == 2 |
                                      runner_on_2nd_dest == 2 |
                                      batter_dest == 2))
  NRUNNER3 <- with(data, as.numeric(runner_on_1st_dest == 3 |
                                      runner_on_2nd_dest == 3 |
                                      runner_on_3rd_dest == 3 |
                                      batter_dest == 3))
  
  data$NOUTS <- with(data, outs + outs_on_play)
  data$NEW.STATE <- get.state(NRUNNER1, NRUNNER2, NRUNNER3, data$NOUTS)
  
  data <- subset(data, (STATE != NEW.STATE) | (RUNS.SCORED > 0))
  
  data.outs <- ddply(data, .(HALF.INNING), summarize,
                     Outs.Inning=sum(outs_on_play))
  data <- merge(data, data.outs)
  dataC <- subset(data, Outs.Inning == 3)
  
  RUNS <- with(dataC, aggregate(RUNS.ROI, list(STATE), mean))
  RUNS$Outs <- substr(RUNS$Group, 5, 5)
  RUNS <- RUNS[order(RUNS$Outs), ]
  
  RUNS.out <- matrix(round(RUNS$x, 2), 8, 3)
  dimnames(RUNS.out)[[2]] <- c("0 outs", "1 out", "2 outs")
  dimnames(RUNS.out)[[1]] <- c("000", "001", "010", "011","100", "101", 
                               "110", "111")
  RUNS.out
}

get.state <- function(runner1, runner2, runner3, outs){
  runners <- paste(runner1, runner2, runner3, sep="")
  paste(runners, outs)
}


