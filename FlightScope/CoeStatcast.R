require(shiny)
require(plyr)
require(DT)
require(ggplot2)
require(ggforce)
require(RCurl)
library(tidyverse)
library(plotly)
library(grid)
library(dplyr)

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
                                                    fluidRow(column(12,plotlyOutput("BatBallProfileBP", width = "600px", height = "800px")),
                                                    column(5, plotOutput("EVvLABP", width = "100%", height = "100%")),
                                                    column(5, offset = 2, plotOutput("LAvLDBP", width = "100%", height = "100%")))
                                                    )
                                         )
                                       )
                                     ))),
                 
                 navbarMenu("Pitchers", 
                            tabPanel("Game", fluidPage(selectInput("player.pitch", h3("Pitcher"), 
                                                                             choices = list("Leroy Jenkins (#99)" = "Leroy Jenkins (#99)"), selected = "Leroy Jenkins (#99)"),
                                                       mainPanel(
                                                         tabsetPanel(
                                                           tabPanel("K Zone"),
                                                           tabPanel("Pitch Selection"),
                                                           tabPanel("Movement"),
                                                           tabPanel("Release")
                                                         )
                                                       ))),
                            tabPanel("Live", fluidPage(selectInput("player.pitch", h3("Pitcher"), 
                                                                   choices = list("Leroy Jenkins (#99)" = "Leroy Jenkins (#99)"), selected = "Leroy Jenkins (#99)"),
                                                       mainPanel(
                                                         tabsetPanel(
                                                           tabPanel("K Zone"),
                                                           tabPanel("Pitch Selection"),
                                                           tabPanel("Movement"),
                                                           tabPanel("Release")
                                                         )
                                                       ))),
                            tabPanel("Bullpen", fluidPage(selectInput("player.pitch", h3("Pitcher"), 
                                                                      choices = list("Leroy Jenkins (#99)" = "Leroy Jenkins (#99)"), selected = "Leroy Jenkins (#99)"),
                                                          mainPanel(
                                                            tabsetPanel(
                                                              tabPanel("Dashboard", checkboxGroupInput("PitchDashBPenPitchType", 
                                                                                                       label = h3("Pitch Type"),
                                                                                                       choices = list("FB" = "FB",
                                                                                                                      "CB" = "CB",
                                                                                                                      "CU" = "CU",
                                                                                                                      "CH" = "CH",
                                                                                                                      "SL" = "SL"),
                                                                                                       selected = c("FB","CB","CU","CH","SL")),
                                                                       div(fluidRow(column(6,plotOutput("PitchDashVeloSpinBPen", width = "100%", height = "600")),
                                                                                column(6, plotlyOutput("PitchDashKZoneBPen", width = "450px", height = "600px"))),style = 'width:1400px;')),
                                                              tabPanel("K Zone", checkboxInput("KZonePitcherBPenSpeed","Speed",
                                                                                              value = FALSE),
                                                                       checkboxInput("KZonePitcherBPenType","Pitch Type",
                                                                                     value = FALSE),
                                                                       plotlyOutput("KZoneBPenPitch", width = "650px", height = "800px")),
                                                              tabPanel("Movement",
                                                                       fluidRow(column(5,plotOutput("MovementBPenPFX", width = "100%", height = "100%")),
                                                                                column(5,offset = 2, plotOutput("MovementBPen", width = "100%", height = "100%")))),
                                                              tabPanel("Release",
                                                                       plotOutput("ReleaseBPen"))
                                                            )
                                                          ))))
                 
                 )

bp <- read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/BP/BP_Session.csv"), col.names = paste("col", 1:77, sep = "."))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/flightscopeVar.R")))

bp <- flightscopeVar(bp)

bp$pitch.type <- "FB"

server <- function(input, output) {
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/SprayChartFS.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/KZoneHitterBP.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/HitBallProfileBP.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/KZonePitcherBPen.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/PitcherDashBPen.R")))
  
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
                                 geom_point(data = subset(bp, batter == input$'hitter'), aes(x = hit.ball.speed, y = hit.ball.launch.v), size = 3) +
                                 xlab("Exit Velo") +
                                 ylab("Launch Angle") +
                                 theme(axis.text = element_text(size = 14),
                                       axis.title = element_text(size = 16, face = "bold")), height = 500, width = 500)
  
  output$LAvLDBP <- renderPlot(ggplot() +
                                 geom_point(data = subset(bp, batter == input$'hitter'), aes(x = hit.ball.launch.h, y = hit.ball.launch.v), size = 3) +
                                 xlab("Launch Direction") +
                                 ylab("Launch Angle") +
                                 theme(axis.text = element_text(size = 14),
                                       axis.title = element_text(size = 16, face = "bold")), height = 500, width = 500)
  
  output$KZoneBPenPitch <- renderPlotly({KZonePitcherBPen(player = input$'player.pitch', speed = input$'KZonePitcherBPenSpeed', pitch.type = input$'KZonePitcherBPenType')})
  
  output$MovementBPenPFX <- renderPlot(ggplot() +
                                      ggtitle("Pitcher View") +
                                      xlab("Horizontal Break last 40ft") + ylab("Vertical Break last 40ft") +
                                      geom_point(data = subset(bp, pitcher == input$'player.pitch'), aes(x = pfxx, y = pfxz), size = 4) +
                                      theme(axis.text = element_text(size = 14),
                                            axis.title = element_text(size = 16, face = "bold"),
                                            title = element_text(size = 18, face = "bold")), height = 500, width = 500)
  
  output$MovementBPen <- renderPlot(ggplot() +
                                      ggtitle("Hitter View") +
                                      xlab("Horizontal Break") + ylab("Vertical Break") +
                                      geom_point(data = subset(bp, pitcher == input$'player.pitch'), aes(x = pitch.break.h, y = pitch.break.ind.v), size = 4) +
                                      theme(axis.text = element_text(size = 14),
                                            axis.title = element_text(size = 16, face = "bold"),
                                            title = element_text(size = 18, face = "bold")), height = 500, width = 500)
  
  output$ReleaseBPen <- renderPlot(ggplot() +
                                     xlim(-3,3) +
                                     ylim(0, 7) +
                                     xlab("Release Side") + ylab("Release Height") +
                                     ggtitle("Release") +
                                     geom_point(data = bp, aes(x = pitch.release.side, y = pitch.release.height), size = 4) +
                                     theme(axis.text = element_text(size = 14),
                                           axis.title = element_text(size = 16, face = "bold"),
                                           title = element_text(size = 18, face = "bold")), height = 500, width = 500)
  
  output$PitchDashVeloSpinBPen <- renderPlot({grid.draw(rbind(ggplotGrob(velo.bullpen(df = filter(bp, pitcher == input$'player.pitch', pitch.type == input$'PitchDashBPenPitchType'))), 
                                                             ggplotGrob(spin.bullpen(df = filter(bp, pitcher == input$'player.pitch', pitch.type == input$'PitchDashBPenPitchType'))), 
                                                             ggplotGrob(spin.axis.bullpen(df = filter(bp, pitcher == input$'player.pitch', pitch.type == input$'PitchDashBPenPitchType'))), 
                                                             size = "last"))})
  
  output$PitchDashKZoneBPen <- renderPlotly(KZonePitcherBPen(df = filter(bp, pitch.type == input$'PitchDashBPenPitchType'), player = input$'player.pitch'))
  
}

shinyApp(ui = ui, server = server)
