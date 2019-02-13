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

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/HitterBPVisuals.R")))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/SprayChartFS.R")))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/PitcherBPenVisuals.R")))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/HitterLiveVisuals.R")))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/PitcherLiveVisuals.R")))

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
                                     fluidPage(selectInput("hitter.live", h3("Hitter"), 
                                                                     choices = unique(live$batter), selected = "Nolan Arp"),
                                       mainPanel(
                                         tabsetPanel(
                                           tabPanel("Spray Chart", checkboxInput("SprayChartCheckEVLive","Exit Velo",
                                                                               value = FALSE),
                                                    checkboxInput("SprayChartCheckLALive","Launch Angle",
                                                                  value = FALSE),
                                                    plotOutput("SprayChartLive", width = "100%")),
                                           tabPanel("K Zone",
                                                    div(br(),
                                                        plotlyOutput("HitKZoneLive", width = "650px", height = "800px"))),
                                           tabPanel("Batted Balls",
                                           div(fluidRow(column(12, plotlyOutput("HitBallProfileLive", width = "600px", height = "800px")),
                                                        column(5, plotlyOutput("HitEVLALive", width = "500px", height = "500px")),
                                                        column(5, offset = 1, plotlyOutput("HitLALHLive", width = "500px", height = "500px"))), style = 'width:1000px;')
                                           )
                                         )
                                       )
                                     )),
                            tabPanel("BP",
                                       mainPanel(fluidPage(selectInput("hitter.input.bp", h3("Hitter"), 
                                                                       choices = unique(bp$batter), selected = "Ski "),
                                         tabsetPanel(
                                           tabPanel("Spray Chart", checkboxInput("SprayChartCheckEVBP","Exit Velo",
                                                                                 value = FALSE),
                                                    checkboxInput("SprayChartCheckLABP","Launch Angle",
                                                                  value = FALSE),
                                                    plotOutput("SprayChartBP", width = "100%")),
                                           tabPanel("K Zone",
                                                    div(br(),
                                                        plotlyOutput("HitKZoneBP", width = "650px", height = "800px"))),
                                           tabPanel("Batted Balls",
                                                    div(fluidRow(column(12, plotlyOutput("HitBallProfileBP", width = "600px", height = "800px")),
                                                    column(5, plotlyOutput("HitEVLABP", width = "500px", height = "500px")),
                                                    column(5, offset = 1, plotlyOutput("HitLALHBP", width = "500px", height = "500px"))), style = 'width:1000px;')
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
                            tabPanel("Live", mainPanel(fluidPage(selectInput("player.pitch.live", h3("Pitcher"), 
                                                                             choices = unique(live$pitcher), selected = "Andrew Schmit"),
                                                         tabsetPanel(
                                                           tabPanel("Dashboard", pickerInput(
                                                             inputId = "PitchTypeDashLive",
                                                             label = "Pitch Type",
                                                             choices = unique(live$pitch.type),
                                                             selected = unique(live$pitch.type),
                                                             multiple = TRUE),
                                                             div(fluidRow(column(12, tableOutput("PitchTableLive")),
                                                                          column(12, plotlyOutput("PitchDashKZoneLive", width = "550px", height = "500px"))),
                                                                 br(),
                                                                 br(),
                                                                 fluidRow(column(6, plotlyOutput("PitchDashSpinAxisVeloCirLive", height = "500px", width = "700px")),
                                                                          column(6, plotlyOutput("PitchDashSpinAxisSpinCirLive", height = "500px", width = "700px"))), style = 'width:1400px;')),
                                                           tabPanel("K Zone"),
                                                           tabPanel("Movement"),
                                                           tabPanel("Release")
                                                         )
                                                       ))),
                            tabPanel("Bullpen", mainPanel(fluidPage(selectInput("player.pitch.bpen", h3("Pitcher"), 
                                                                      choices = unique(bpen$pitcher), selected = "Ryan Baranowski"),
                                                            tabsetPanel(
                                                              tabPanel("Dashboard", pickerInput(
                                                                inputId = "PitchTypeDashBPen",
                                                                label = "Pitch Type",
                                                                choices = unique(bpen$pitch.type),
                                                                selected = unique(bpen$pitch.type),
                                                                multiple = TRUE),
                                                                       div(fluidRow(column(12, tableOutput("PitchTableBPen")),
                                                                                column(12, plotlyOutput("PitchDashKZoneBPen", width = "550px", height = "500px"))),
                                                                           br(),
                                                                           br(),
                                                                           fluidRow(column(6, plotlyOutput("PitchDashSpinAxisVeloCirBPen", height = "500px", width = "700px")),
                                                                                    column(6, plotlyOutput("PitchDashSpinAxisSpinCirBPen", height = "500px", width = "700px"))), style = 'width:1400px;')),
                                                              tabPanel("K Zone", pickerInput(
                                                                inputId = "PitchTypeKZoneBpen",
                                                                label = "Pitch Type",
                                                                choices = unique(bpen$pitch.type),
                                                                selected = unique(bpen$pitch.type),
                                                                multiple = TRUE),
                                                                checkboxInput("KZonePitcherBPenSpeed","Velo", value = FALSE),
                                                                       plotlyOutput("KZoneBPenPitch", width = "650px", height = "800px")),
                                                              tabPanel("Movement", pickerInput(
                                                                inputId = "PitchTypeMovementBPen",
                                                                label = "Pitch Type",
                                                                choices = unique(bpen$pitch.type),
                                                                selected = unique(bpen$pitch.type),
                                                                multiple = TRUE),
                                                                       div(fluidRow(column(5,plotlyOutput("MovementBPenPFX", width = "700px", height = "700px")),
                                                                                column(5,offset = 1, plotlyOutput("MovementBPen", width = "700px", height = "700px"))), style = 'width:1400px;')),
                                                              tabPanel("Release", pickerInput(
                                                                inputId = "PitchTypeReleaseBPen",
                                                                label = "Pitch Type",
                                                                choices = unique(bpen$pitch.type),
                                                                selected = unique(bpen$pitch.type),
                                                                multiple = TRUE),
                                                                       plotlyOutput("ReleaseBPen"))
                                                            )
                                                          )
                                                          ))
                            )
                 
                 )



server <- function(input, output) {
  
  
  
  hit.leader = ddply(live, .(batter), summarise,
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
  
  output$SprayChartBP <- renderPlot({SprayChartFS(player = input$'hitter.input.bp', exit.velo = input$'SprayChartCheckEVBP', launch.angle = input$'SprayChartCheckLABP')}, height = 600, width = 600)
  
  output$HitKZoneBP <- renderPlotly({HitKZoneBP(df = bp, player = input$'hitter.input.bp')})
  
  output$HitBallProfileBP <- renderPlotly({HitBallProfileBP(df = bp, player = input$'hitter.input.bp')})
  
  output$HitEVLABP <- renderPlotly({HitEVLABP(df = bp, player = input$'hitter.input.bp')})
  
  output$HitLALHBP <- renderPlotly({HitLALHBP(df = bp, player = input$'hitter.input.bp')})
  
  output$KZoneBPenPitch <- renderPlotly({PitchKZoneBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeKZoneBpen'), player = input$'player.pitch.bpen', Velo = input$'KZonePitcherBPenSpeed')})
  
  output$MovementBPenPFX <- renderPlotly({PitchMovementBatViewBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeMovementBPen'), player = input$'player.pitch.bpen')})
  
  output$MovementBPen <- renderPlotly(PitchMovementPitchViewBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeMovementBPen'), player = input$'player.pitch.bpen'))
  
  output$ReleaseBPen <- renderPlotly(PitchReleaseBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeReleaseBPen'), player = input$'player.pitch.bpen'))
  
  output$PitchTableBPen <- renderTable({PitchTableBPen(df = bpen, player = input$'player.pitch.bpen')})
  
  output$PitchDashKZoneBPen <- renderPlotly(PitchKZoneBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeDashBPen'), player = input$'player.pitch.bpen'))

  output$PitchDashSpinAxisVeloCirBPen <- renderPlotly(PitchDashSpinAxisVeloCirBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeDashBPen'), player = input$'player.pitch.bpen'))
  
  output$PitchDashSpinAxisSpinCirBPen <- renderPlotly(PitchDashSpinAxisSpinCirBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeDashBPen'), player = input$'player.pitch.bpen'))
  
  output$SprayChartLive <- renderPlot({SprayChartFS(df = live, player = input$'hitter.live', exit.velo = input$'SprayChartCheckEVLive', launch.angle = input$'SprayChartCheckLALive')}, height = 600, width = 600)
  
  output$HitKZoneLive <- renderPlotly({HitKZoneLive(df = live, player = input$'hitter.live')})
  
  output$HitBallProfileLive <- renderPlotly({HitBallProfileLive(df = live, player = input$'hitter.live')})
  
  output$HitEVLALive <- renderPlotly({HitEVLALive(df = live, player = input$'hitter.live')})
  
  output$HitLALHLive <- renderPlotly({HitLALHLive(df = live, player = input$'hitter.live')})
  
  output$PitchTableLive <- renderTable({PitchTableLive(df = live, player = input$'player.pitch.live')})
  
  output$PitchDashKZoneLive <- renderPlotly(PitchKZoneLive(df = filter(live, pitch.type %in% input$'PitchTypeDashLive'), player = input$'player.pitch.live'))
  
  output$PitchDashSpinAxisVeloCirLive <- renderPlotly(PitchDashSpinAxisVeloCirLive(df = filter(live, pitch.type %in% input$'PitchTypeDashLive'), player = input$'player.pitch.live'))
  
  output$PitchDashSpinAxisSpinCirLive <- renderPlotly(PitchDashSpinAxisSpinCirLive(df = filter(live, pitch.type %in% input$'PitchTypeDashLive'), player = input$'player.pitch.live'))
}

shinyApp(ui = ui, server = server)
