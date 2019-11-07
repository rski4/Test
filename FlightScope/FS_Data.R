library(tidyverse)
library(data.table)

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/flightscopeVar.R")))
eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/ConvertSci.R")))
eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/ConvertFeet.R")))


# Import Scrimmage Data
scrim.1 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Game/Results-Export-Scientific-9-11.csv"), col.names = paste("col", 1:77, sep = "."))
scrim.2 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Game/Results-Export-Scientific-9-7-1.csv"), col.names = paste("col", 1:77, sep = "."))
scrim.3 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Game/Results-Export-Scientific-9-7-2.csv"), col.names = paste("col", 1:77, sep = "."))

scrim.1 <- flightscopeVar(scrim.1)
scrim.2 <- flightscopeVar(scrim.2)
scrim.3 <- flightscopeVar(scrim.3)

scrim <- rbindlist(list(scrim.1, scrim.2, scrim.3))
scrim <- ConvertSci(scrim)

scrim$sess.type <- "Scrimmage"

# Import Bullpen Data
bpen.1 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/Bullpen.01.22.2019.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.2 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_01_26.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.3 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_01_26_2.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.4 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_01_26_3.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.5 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_01_29.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.6 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019-02-02.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.7 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_02_09.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.8 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_02_16.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.9 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_10_23.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.10 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_2019_10_30.csv"), col.names = paste("col", 1:77, sep = "."))
bpen.11 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Bullpen/BPen_11_06_2019.csv"), col.names = paste("col", 1:77, sep = "."))

bpen.8 <- flightscopeVar(bpen.8)
bpen.8 <- ConvertFeet(bpen.8)

bpen.9 <- flightscopeVar(bpen.9)
bpen.9 <- ConvertSci(bpen.9)

bpen.10 <- flightscopeVar(bpen.10)
bpen.10 <- ConvertSci(bpen.10)

bpen.11 <- flightscopeVar(bpen.11)
bpen.11 <- ConvertSci(bpen.11)



bpen <- rbindlist(list(bpen.1, bpen.2, bpen.3, bpen.4, bpen.5, bpen.6, bpen.7, bpen.8))

bpen <- flightscopeVar(bpen)

bpen$pitch.type[is.na(bpen$pitch.type)] <- "No Type"

bpen$sess.type <- "Bullpen"

bpen <- bpen %>% 
  mutate(
    pitch.break.h = pitch.approach.h/12,
    pitch.break.v = pitch.break.v/12
  )


# Import Live Data

live.1 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_05_sci.csv"), col.names = paste("col", 1:77, sep = "."))
live.2 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_12_sci.csv"), col.names = paste("col", 1:77, sep = "."))
live.3 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_19_sci.csv"), col.names = paste("col", 1:77, sep = "."))
live.4 <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/Live/Live_2019_02_25_sci.csv"), col.names = paste("col", 1:77, sep = "."))

live <- data.frame(rbindlist(list(live.1, live.2, live.3, live.4)))

live <- flightscopeVar(live)

live <- ConvertSci(live)

live$pitch.call <- sub("^$", "No Outcome", live$pitch.call)

live$sess.type <- "Live"

# All Data

df <- rbindlist(list(scrim, live, bpen))

df$pitch.type <- df$pitch.type %>% 
  gsub("Cutter", "Fastball", .) %>%
  gsub("Sinker", "Fastball", .) %>% 
  gsub("Undefined", "No Type", .) %>% 
  gsub("Splitter", "Fastball", .) %>% 
  gsub("^$", "No Type", .) %>% 
  gsub("Four Seam Fastball", "Fastball", .) %>% 
  gsub("Two Seam Fastball", "Fastball", .)
  
  

