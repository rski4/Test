library(shiny)
library(plyr)
library(DT)
library(ggplot2)
library(ggforce)
library(RCurl)
library(tidyverse)
library(plotly)
library(data.table)
library(shinyWidgets)

ui <- navbarPage("Coe Statcast",
                 
                 selected = "Hitter Leaderboard",
                 
                 tabPanel("Hitter Leaderboard", 
                          dataTableOutput("HitLeader", width = "80%")),
                 
                 tabPanel("Pitcher Leaderboard"),
                 
                 navbarMenu("Hitters",
                            tabPanel("Game",
                                     fluidPage(selectInput("batter", h3("Hitter"), 
                                                           choices = list("Ski" = "Ski ", "Nolan" = "Nolan ",
                                                                          "Cam" = "Cam ", "Jordan" = "Jordan ",
                                                                          "Luke" = "Luke ", "Kevin" = "Kevin ",
                                                                          "Jared White" = "Colton White"), selected = "Ski "),
                                       mainPanel(
                                         tabsetPanel(
                                           tabPanel("Spray Chart"),
                                           tabPanel("K Zone"),
                                           tabPanel("Batted Balls")
                                         )
                                       )
                                     )),
                            tabPanel("Live",
                                     fluidPage(selectInput("batter", h3("Hitter"), 
                                                                     choices = list("Ski" = "Ski ", "Nolan" = "Nolan ",
                                                                                    "Cam" = "Cam ", "Jordan" = "Jordan ",
                                                                                    "Luke" = "Luke ", "Kevin" = "Kevin ",
                                                                                    "Jared White" = "Colton White"), selected = "Ski "),
                                       mainPanel(
                                         tabsetPanel(
                                           tabPanel("Spray Chart"),
                                           tabPanel("K Zone"),
                                           tabPanel("Batted Balls")
                                         )
                                       )
                                     )),
                            tabPanel("BP",
                                       mainPanel(fluidPage(selectInput("hitter", h3("Hitter"), 
                                                                       choices = list("Ski" = "Ski ", "Nolan" = "Nolan ",
                                                                                      "Cam" = "Cam ", "Jordan" = "Jordan ",
                                                                                      "Luke" = "Luke ", "Kevin" = "Kevin ",
                                                                                      "Jared White" = "Colton White"), selected = "Ski "),
                                         tabsetPanel(
                                           tabPanel("Spray Chart", checkboxInput("SprayChartCheckEVBP","Exit Velo",
                                                                                 value = FALSE),
                                                    checkboxInput("SprayChartCheckLABP","Launch Angle",
                                                                  value = FALSE),
                                                    plotOutput("SprayChartBP", width = "100%")),
                                           tabPanel("K Zone", checkboxInput("KZoneHitCheckBP", "Hit Balls", value = FALSE),
                                                    plotlyOutput("KZoneBP", width = "650px", height = "800px")),
                                           tabPanel("Batted Balls",
                                                    div(fluidRow(column(12,plotlyOutput("BatBallProfileBP", width = "600px", height = "800px")),
                                                    column(5, plotOutput("EVvLABP", width = "100%", height = "100%")),
                                                    column(5, offset = 2, plotOutput("LAvLDBP", width = "100%", height = "100%"))), style = 'width:1000px;')
                                                    )
                                         )
                                       )
                                     ))),
                 
                 navbarMenu("Pitchers", 
                            tabPanel("Game", mainPanel(fluidPage(selectInput("player.pitch", h3("Pitcher"), 
                                                                   choices = list("Andrew Schmit" = "Andrew Schmit",
                                                                                  "AJ Reuter" = "AJ Reuter",
                                                                                  "Jeffrey Anders" = "Jeffrey Anders",
                                                                                  "Lucas Robbins" = "Lucas Robbins",
                                                                                  "Tyrell Johnson" = "Tyrell Johnson",
                                                                                  "Ryan Baranowski" = "Ryan Baranowski",
                                                                                  "Hunter Collachia" = "Hunter Collachia"), selected = "Ryan Baranowski"),
                                                         tabsetPanel(
                                                           tabPanel("K Zone"),
                                                           tabPanel("Pitch Selection"),
                                                           tabPanel("Movement"),
                                                           tabPanel("Release")
                                                         )
                                                       ))),
                            tabPanel("Live", mainPanel(fluidPage(selectInput("player.pitch", h3("Pitcher"), 
                                                                   choices = list("Andrew Schmit" = "Andrew Schmit",
                                                                                  "AJ Reuter" = "AJ Reuter",
                                                                                  "Jeffrey Anders" = "Jeffrey Anders",
                                                                                  "Lucas Robbins" = "Lucas Robbins",
                                                                                  "Tyrell Johnson" = "Tyrell Johnson",
                                                                                  "Ryan Baranowski" = "Ryan Baranowski",
                                                                                  "Hunter Collachia" = "Hunter Collachia"), selected = "Ryan Baranowski"),
                                                         tabsetPanel(
                                                           tabPanel("K Zone"),
                                                           tabPanel("Pitch Selection"),
                                                           tabPanel("Movement"),
                                                           tabPanel("Release")
                                                         )
                                                       ))),
                            tabPanel("Bullpen", mainPanel(fluidPage(selectInput("player.pitch.bpen", h3("Pitcher"), 
                                                                      choices = list("Andrew Schmit" = "Andrew Schmit",
                                                                                     "AJ Reuter" = "AJ Reuter",
                                                                                     "Jeffrey Anders" = "Jeffrey Anders",
                                                                                     "Lucas Robbins" = "Lucas Robbins",
                                                                                     "Tyrell Johnson" = "Tyrell Johnson",
                                                                                     "Ryan Baranowski" = "Ryan Baranowski",
                                                                                     "Hunter Collachia" = "Hunter Collachia"), selected = "Ryan Baranowski"),
                                                            tabsetPanel(
                                                              tabPanel("Dashboard", pickerInput(
                                                                inputId = "PitchType",
                                                                label = "Pitch Type",
                                                                choices = c("Fastball", "Curveball", "Cutter", "Changeup", "Slider", "No Type"),
                                                                selected = c("Fastball", "Curveball", "Cutter", "Changeup", "Slider", "No Type"),
                                                                multiple = TRUE),
                                                                       div(fluidRow(column(6, plotlyOutput("PitchDashVeloSpinSeqBPen", width = "100%", height = "600")),
                                                                                column(6, plotlyOutput("PitchDashKZoneBPen", width = "450px", height = "600px"))),
                                                                           fluidRow(column(6, plotlyOutput("PitchDashSpinAxisVeloCirBPen", height = "700px", width = "700px")),
                                                                                    column(6, plotlyOutput("PitchDashSpinAxisSpinCirBPen", height = "700px", width = "700px"))), style = 'width:1400px;')),
                                                              tabPanel("K Zone", checkboxInput("KZonePitcherBPenSpeed","Speed",
                                                                                              value = FALSE),
                                                                       checkboxInput("KZonePitcherBPenType","Pitch Type",
                                                                                     value = FALSE),
                                                                       plotlyOutput("KZoneBPenPitch", width = "650px", height = "800px")),
                                                              tabPanel("Movement",
                                                                       fluidRow(column(5,plotlyOutput("MovementBPenPFX", width = "100%", height = "100%")),
                                                                                column(5,offset = 2, plotlyOutput("MovementBPen", width = "100%", height = "100%")))),
                                                              tabPanel("Release",
                                                                       plotlyOutput("ReleaseBPen"))
                                                            )
                                                          )
                                                          ))
                            )
                 
                 )

bp <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/BP/BP_Session.csv"), col.names = paste("col", 1:77, sep = "."))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/flightscopeVar.R")))

bp <- flightscopeVar(bp)

bp <- bp %>% mutate(
  pitch.type = ifelse(pitch.speed > 75, "FB", "CH")
)


server <- function(input, output) {
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/SprayChartFS.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/KZoneHitterBP.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/HitBallProfileBP.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/PitcherBPenVisuals.R")))
  
  hit.leader = ddply(bp, .(batter), summarise,
                     Max.Exit.Velo = format(round(max(hit.ball.speed, na.rm = TRUE), 2), nsmall = 2),
                     Exit.Velo.Avg = format(round(mean(hit.ball.speed, na.rm = TRUE), 2), nsmall = 2),
                     Launch.Angle.Avg = format(round(mean(hit.ball.launch.v, na.rm = TRUE), 2), nsmall = 2),
                     Max.Carry = format(round(max(hit.carry.dist, na.rm = TRUE), 2), nsmall = 2),
                     Carry.Avg = format(round(mean(hit.carry.dist, na.rm = TRUE), 2), nsmall = 2))
  
  output$HitLeader <- renderDataTable(
    arrange(hit.leader, desc(Max.Exit.Velo)),
    filter = 'top',
    rownames = FALSE,
    options = list(autoWidth = TRUE)
  )
  
  output$SprayChartBP <- renderPlot({SprayChartFS(player = input$'hitter', exit.velo = input$'SprayChartCheckEVBP', launch.angle = input$'SprayChartCheckLABP')}, height = 600, width = 600)
  
  output$KZoneBP <- renderPlotly({KZoneHitter(player = input$'hitter', exit.velo = input$'KZoneHitCheckBP')})
  
  output$BatBallProfileBP <- renderPlotly({HitBallProfile(player = input$'hitter')})
  
  output$EVvLABP <- renderPlot(ggplot() +
                                 geom_point(data = subset(bp, batter == input$'hitter'), 
                                            aes(x = hit.ball.speed, y = hit.ball.launch.v), 
                                            size = 4, alpha = 1/2) +
                                 xlab("Exit Velo") +
                                 ylab("Launch Angle") +
                                 theme(axis.text = element_text(size = 14),
                                       axis.title = element_text(size = 16, face = "bold")), 
                               height = 500, width = 500)
  
  output$LAvLDBP <- renderPlot(ggplot() +
                                 geom_point(data = subset(bp, batter == input$'hitter'), 
                                            aes(x = hit.ball.launch.h, y = hit.ball.launch.v), 
                                            size = 4, alpha = 1/2) +
                                 xlab("Launch Direction") +
                                 ylab("Launch Angle") +
                                 theme(axis.text = element_text(size = 14),
                                       axis.title = element_text(size = 16, face = "bold")), 
                               height = 500, width = 500)
  
  output$KZoneBPenPitch <- renderPlotly({PitchKZoneBPen(df = bpen, player = input$'player.pitch.bpen', Velo = input$'KZonePitcherBPenSpeed')})
  
  output$MovementBPenPFX <- renderPlotly({PitchMovementBatViewBPen(df = bpen, player = input$'player.pitch.bpen')})
  
  output$MovementBPen <- renderPlotly(PitchMovementPitchViewBPen(df = bpen, player = input$'player.pitch.bpen'))
  
  output$ReleaseBPen <- renderPlotly(PitchReleaseBPen(df = bpen, player = input$'player.pitch.bpen'))
  
  output$PitchDashVeloSpinSeqBPen <- renderPlotly({PitchDashVeloSpinSeqBPen(df = filter(bpen, pitch.type %in% input$'PitchType'), player = input$'player.pitch.bpen')})
  
  output$PitchDashKZoneBPen <- renderPlotly(PitchKZoneBPen(df = filter(bpen, pitch.type %in% input$'PitchType'), player = input$'player.pitch.bpen'))

  output$PitchDashSpinAxisVeloCirBPen <- renderPlotly(PitchDashSpinAxisVeloCirBPen(df = filter(bpen, pitcher == input$'player.pitch.bpen', pitch.type %in% input$'PitchType')))
  
  output$PitchDashSpinAxisSpinCirBPen <- renderPlotly(PitchDashSpinAxisSpinCirBPen(df = filter(bpen, pitcher == input$'player.pitch.bpen', pitch.type %in% input$'PitchType')))
  
}

shinyApp(ui = ui, server = server)
