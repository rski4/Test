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

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/LiveLeaderboards.R")))

ui <- navbarPage("Coe Statcast",
                 
                 selected = "Hitter Leaderboard",
                 
                 tabPanel("Hitter Leaderboard", 
                          tabsetPanel(tabPanel("Hit Balls", 
                                               dataTableOutput("HitBallLeaderLive")),
                                      tabPanel("Plate Discipline",
                                               dataTableOutput("PlateDisciplineLeaderLive")))),
                 
                 tabPanel("Pitcher Leaderboard", 
                          tabsetPanel(tabPanel("Hit Balls", 
                                               dataTableOutput("PitchHitBallLeaderLive")),
                                      tabPanel("Plate Discipline",
                                               dataTableOutput("PitchPlateDisciplineLeaderLive")))),
                 
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
                                               fluidRow(column(4, pickerInput(
                                                 inputId = "PitchTypeLiveHit",
                                                 label = "Pitch Type",
                                                 choices = unique(live$pitch.type),
                                                 selected = unique(live$pitch.type),
                                                 multiple = TRUE)),
                                                 column(4, pickerInput(
                                                   inputId = "PitcherHandLiveBat",
                                                   label = "Pitcher Hand",
                                                   choices = c("L", "R"),
                                                   selected = c("L", "R"),
                                                   multiple = TRUE)),
                                                 column(4, pickerInput(inputId = "HitDateLive",
                                                                       label = "Date",
                                                                       choices = as.character(unique(as.Date(live$date))),
                                                                       selected = as.character(unique(as.Date(live$date))),
                                                                       multiple = TRUE))),
                                       mainPanel(
                                         tabsetPanel(
                                           tabPanel("Dashboard", 
                                                    div(br(),fluidRow(tabsetPanel(tabPanel("Plate Discipline",
                                                                                           column(12, tableOutput("PlateDisciplineIndLive"))),
                                                                                  tabPanel("Hit Balls",
                                                                                           column(12, tableOutput("HitBallTableIndLive")))),
                                                                 column(6, plotlyOutput("HitKZoneDashLive", width = "600px", height = "700px")),
                                                                 column(6, plotlyOutput("HitBallProfileDashLive", width = "600px", height = "700px"))), style = 'width:1400px;')),
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
                                                                 fluidRow(column(4, pickerInput(
                                                                   inputId = "PitchTypeLive",
                                                                   label = "Pitch Type",
                                                                   choices = unique(live$pitch.type),
                                                                   selected = unique(live$pitch.type),
                                                                   multiple = TRUE)),
                                                                   column(4, pickerInput(
                                                                     inputId = "HitterHandLivePitch",
                                                                     label = "Hitter Hand",
                                                                     choices = c("L", "R"),
                                                                     selected = c("L", "R"),
                                                                     multiple = TRUE)),
                                                                   column(4, pickerInput(inputId = "PitchDateLive",
                                                                                            label = "Date",
                                                                                            choices = as.character(unique(as.Date(live$date))),
                                                                                            selected = as.character(unique(as.Date(live$date))),
                                                                                            multiple = TRUE))),
                                                         tabsetPanel(
                                                           tabPanel("Dashboard",
                                                             div(fluidRow(column(12, tableOutput("PitchTableLive")),
                                                                          column(12, plotlyOutput("PitchDashKZoneLive", width = "550px", height = "500px"))),
                                                                 br(),
                                                                 br(),
                                                                 fluidRow(column(6, plotlyOutput("PitchDashSpinAxisVeloCirLive", height = "500px", width = "700px")),
                                                                          column(6, plotlyOutput("PitchDashSpinAxisSpinCirLive", height = "500px", width = "700px"))), style = 'width:1400px;')),
                                                           tabPanel("K Zone", checkboxInput("KZonePitcherLiveSpeed","Velo", value = FALSE),
                                                                    plotlyOutput("KZoneLivePitch", width = "650px", height = "800px")),
                                                           tabPanel("Movement", div(br(),fluidRow(column(5,plotlyOutput("MovementLivePFX", width = "700px", height = "700px")),
                                                                                           column(5,offset = 1, plotlyOutput("MovementLive", width = "700px", height = "700px"))), style = 'width:1400px;')),
                                                           tabPanel("Release",
                                                                    div(br(),fluidRow(column(4, plotlyOutput("ReleaseLive", width = "600px", height = "600px")),
                                                                                      column(4, offset = 1, plotlyOutput("ExtensionLive", width = "600px", height = "600px"))), 
                                                                        br(),fluidRow(column(12, plotlyOutput("PitchRelease3DLive", width = "900px", height = "600px"))), style = 'width:1400px;'))
                                                         )
                                                       ))),
                            tabPanel("Bullpen", mainPanel(fluidPage(selectInput("player.pitch.bpen", h3("Pitcher"), 
                                                                      choices = unique(bpen$pitcher), selected = "Drew Schmit"),
                                                                    fluidRow(column(6, pickerInput(
                                                                      inputId = "PitchTypeBPen",
                                                                      label = "Pitch Type",
                                                                      choices = unique(bpen$pitch.type),
                                                                      selected = unique(bpen$pitch.type),
                                                                      multiple = TRUE)),
                                                                      column(6, pickerInput(inputId = "PitchDateBPen",
                                                                                               label = "Date",
                                                                                               choices = as.character(unique(as.Date(bpen$date))),
                                                                                               selected = as.character(unique(as.Date(bpen$date))),
                                                                                               multiple = TRUE))),
                                                            tabsetPanel(
                                                              tabPanel("Dashboard",
                                                                       div(fluidRow(column(12, tableOutput("PitchTableBPen")),
                                                                                column(12, plotlyOutput("PitchDashKZoneBPen", width = "550px", height = "500px"))),
                                                                           br(),
                                                                           br(),
                                                                           fluidRow(column(6, plotlyOutput("PitchDashSpinAxisVeloCirBPen", height = "500px", width = "700px")),
                                                                                    column(6, plotlyOutput("PitchDashSpinAxisSpinCirBPen", height = "500px", width = "700px"))), style = 'width:1400px;')),
                                                              tabPanel("K Zone", 
                                                                checkboxInput("KZonePitcherBPenSpeed","Velo", value = FALSE),
                                                                       plotlyOutput("KZoneBPenPitch", width = "650px", height = "800px")),
                                                              tabPanel("Movement",
                                                                       div(fluidRow(column(5,plotlyOutput("MovementBPenPFX", width = "600px", height = "600px")),
                                                                                column(5,offset = 1, plotlyOutput("MovementBPen", width = "600px", height = "600px"))), style = 'width:1400px;')),
                                                              tabPanel("Release",
                                                                       div(br(),fluidRow(column(4, plotlyOutput("ReleaseBPen", width = "600px", height = "600px")),
                                                                                         column(4, offset = 1, plotlyOutput("ExtensionBPen", width = "600px", height = "600px"))), 
                                                                           br(),fluidRow(column(12, plotlyOutput("PitchRelease3DBPen", width = "900px", height = "600px"))), style = 'width:1400px;'))
                                                            )
                                                          )
                                                          ))
                            )
                 
                 )



server <- function(input, output) {
  
  #### Hitter Leaderboard ####
  
  output$HitBallLeaderLive <- renderDataTable({arrange(HitBallLeaderLive(df = live), desc(EVmed))},
    filter = 'top',
    rownames = FALSE,
    options = list(autoWidth = TRUE,
                   pageLength = 25))
  
  output$PlateDisciplineLeaderLive <- renderDataTable({arrange(PlateDisciplineLeaderLive(df = live), desc(zSwPct))},
                                                      filter = 'top',
                                                      rownames = FALSE,
                                                      options = list(autoWidth = TRUE,
                                                                     pageLength = 25))
  
  #### Pitcher Leaderboard ####
  
  output$PitchHitBallLeaderLive <- renderDataTable({arrange(PitchHitBallLeaderLive(df = live), EVmed)},
                                              filter = 'top',
                                              rownames = FALSE,
                                              options = list(autoWidth = TRUE,
                                                             pageLength = 25))
  
  output$PitchPlateDisciplineLeaderLive <- renderDataTable({arrange(PitchPlateDisciplineLeaderLive(df = live), desc(oSwPct))},
                                                      filter = 'top',
                                                      rownames = FALSE,
                                                      options = list(autoWidth = TRUE,
                                                                     pageLength = 25))
  
  #### Hitter BP ####
  output$SprayChartBP <- renderPlot({SprayChartFS(player = input$'hitter.input.bp', exit.velo = input$'SprayChartCheckEVBP', launch.angle = input$'SprayChartCheckLABP')}, height = 600, width = 600)
  
  output$HitKZoneBP <- renderPlotly({HitKZoneBP(df = bp, player = input$'hitter.input.bp')})
  
  output$HitBallProfileBP <- renderPlotly({HitBallProfileBP(df = bp, player = input$'hitter.input.bp')})
  
  output$HitEVLABP <- renderPlotly({HitEVLABP(df = bp, player = input$'hitter.input.bp')})
  
  output$HitLALHBP <- renderPlotly({HitLALHBP(df = bp, player = input$'hitter.input.bp')})
  
  #### Pitcher BPen ####
  
  output$KZoneBPenPitch <- renderPlotly({PitchKZoneBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                    as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                        player = input$'player.pitch.bpen',
                                                        Velo = input$'KZonePitcherBPenSpeed')})
  
  output$MovementBPenPFX <- renderPlotly({PitchMovementBatViewBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                               as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                                   player = input$'player.pitch.bpen')})
  
  output$MovementBPen <- renderPlotly(PitchMovementPitchViewBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                             as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                                 player = input$'player.pitch.bpen'))
  
  output$ReleaseBPen <- renderPlotly(PitchReleaseBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                  as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                      player = input$'player.pitch.bpen'))
  
  output$ExtensionBPen <- renderPlotly(PitchExtensionBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                      as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                          player = input$'player.pitch.bpen'))
  
  output$PitchRelease3DBPen <- renderPlotly(PitchRelease3DBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                           as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                               player = input$'player.pitch.bpen'))
  
  output$PitchTableBPen <- renderTable({PitchTableBPen(df = filter(bpen, as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                       player = input$'player.pitch.bpen')})
  
  output$PitchDashKZoneBPen <- renderPlotly(PitchKZoneBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                       as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                           player = input$'player.pitch.bpen'))

  output$PitchDashSpinAxisVeloCirBPen <- renderPlotly(PitchDashSpinAxisVeloCirBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                                               as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                                                   player = input$'player.pitch.bpen'))
  
  output$PitchDashSpinAxisSpinCirBPen <- renderPlotly(PitchDashSpinAxisSpinCirBPen(df = filter(bpen, pitch.type %in% input$'PitchTypeBPen', 
                                                                                               as.character(as.Date(date)) %in% input$'PitchDateBPen'), 
                                                                                   player = input$'player.pitch.bpen'))
  
  #### Hitter Live ####
  
  output$PlateDisciplineIndLive <- renderTable({PlateDisciplineIndLive(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit',
                                                                                   as.character(as.Date(date)) %in% input$'HitDateLive',
                                                                                   pitcher.hand %in% input$'PitcherHandLiveBat'), 
                                                                          player = input$'hitter.live')}, 
                                               caption = "<b> <span style='color:#000000'> Plate Discipline </b>",
                                               caption.placement = getOption("xtable.caption.placement", "top"))
  
  output$HitBallTableIndLive <- renderTable({HitBallTableIndLive(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit',
                                                                                as.character(as.Date(date)) %in% input$'HitDateLive',
                                                                                pitcher.hand %in% input$'PitcherHandLiveBat'), 
                                                                    player = input$'hitter.live')},
                                            caption = "<b> <span style='color:#000000'> Hit Balls </b>",
                                            caption.placement = getOption("xtable.caption.placement", "top"))
  
  output$HitKZoneDashLive <- renderPlotly({HitKZoneLive(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit', 
                                                                    as.character(as.Date(date)) %in% input$'HitDateLive',
                                                                    pitcher.hand %in% input$'PitcherHandLiveBat'), 
                                                        player = input$'hitter.live')})
  
  output$HitBallProfileDashLive <- renderPlotly({HitBallProfileLive(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit', 
                                                                                as.character(as.Date(date)) %in% input$'HitDateLive',
                                                                                pitcher.hand %in% input$'PitcherHandLiveBat'), 
                                                                player = input$'hitter.live')})
  
  output$SprayChartLive <- renderPlot({SprayChartFS(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit', 
                                                                as.character(as.Date(date)) %in% input$'HitDateLive',
                                                                pitcher.hand %in% input$'PitcherHandLiveBat'),
                                                    player = input$'hitter.live', exit.velo = input$'SprayChartCheckEVLive', launch.angle = input$'SprayChartCheckLALive')}, height = 600, width = 600)
  
  output$HitKZoneLive <- renderPlotly({HitKZoneLive(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit', 
                                                                as.character(as.Date(date)) %in% input$'HitDateLive',
                                                                pitcher.hand %in% input$'PitcherHandLiveBat'), 
                                                    player = input$'hitter.live')})
  
  output$HitBallProfileLive <- renderPlotly({HitBallProfileLive(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit', 
                                                                            as.character(as.Date(date)) %in% input$'HitDateLive',
                                                                            pitcher.hand %in% input$'PitcherHandLiveBat'), 
                                                                player = input$'hitter.live')})
  
  output$HitEVLALive <- renderPlotly({HitEVLALive(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit', 
                                                              as.character(as.Date(date)) %in% input$'HitDateLive',
                                                              pitcher.hand %in% input$'PitcherHandLiveBat'),
                                                  player = input$'hitter.live')})
  
  output$HitLALHLive <- renderPlotly({HitLALHLive(df = filter(live, pitch.type %in% input$'PitchTypeLiveHit', 
                                                              as.character(as.Date(date)) %in% input$'HitDateLive',
                                                              pitcher.hand %in% input$'PitcherHandLiveBat'), 
                                                  player = input$'hitter.live')})
  
  #### Pitcher Live ####
  
  output$PitchTableLive <- renderTable({PitchTableLive(df = filter(live, as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                   batter.hand %in% input$'HitterHandLivePitch'), 
                                                       player = input$'player.pitch.live')})
  
  output$PitchDashKZoneLive <- renderPlotly(PitchKZoneLive(df = filter(live, pitch.type %in% input$'PitchTypeLive',
                                                                       as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                       batter.hand %in% input$'HitterHandLivePitch'), 
                                                           player = input$'player.pitch.live'))
  
  output$PitchDashSpinAxisVeloCirLive <- renderPlotly(PitchDashSpinAxisVeloCirLive(df = filter(live, pitch.type %in% input$'PitchTypeLive',
                                                                                               as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                                               batter.hand %in% input$'HitterHandLivePitch'), 
                                                                                   player = input$'player.pitch.live'))
  
  output$PitchDashSpinAxisSpinCirLive <- renderPlotly(PitchDashSpinAxisSpinCirLive(df = filter(live, pitch.type %in% input$'PitchTypeLive',
                                                                                               as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                                               batter.hand %in% input$'HitterHandLivePitch'), 
                                                                                   player = input$'player.pitch.live'))
  
  output$KZoneLivePitch <- renderPlotly({PitchKZoneLive(df = filter(live, pitch.type %in% input$'PitchTypeLive', 
                                                                    as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                    batter.hand %in% input$'HitterHandLivePitch'), 
                                                        player = input$'player.pitch.live',
                                                        Velo = input$'KZonePitcherLiveSpeed')})
  
  output$MovementLivePFX <- renderPlotly({PitchMovementBatViewLive(df = filter(live, pitch.type %in% input$'PitchTypeLive', 
                                                                               as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                               batter.hand %in% input$'HitterHandLivePitch'), 
                                                                   player = input$'player.pitch.live')})
  
  output$MovementLive <- renderPlotly(PitchMovementPitchViewLive(df = filter(live, pitch.type %in% input$'PitchTypeLive', 
                                                                             as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                             batter.hand %in% input$'HitterHandLivePitch'), 
                                                                 player = input$'player.pitch.live'))
  
  output$ReleaseLive <- renderPlotly(PitchReleaseLive(df = filter(live, pitch.type %in% input$'PitchTypeLive', 
                                                                  as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                             batter.hand %in% input$'HitterHandLivePitch'), 
                                                                 player = input$'player.pitch.live'))
  
  output$ExtensionLive <- renderPlotly(PitchExtensionLive(df = filter(live, pitch.type %in% input$'PitchTypeLive', 
                                                                  as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                  batter.hand %in% input$'HitterHandLivePitch'), 
                                                      player = input$'player.pitch.live'))
  
  output$PitchRelease3DLive <- renderPlotly(PitchRelease3DLive(df = filter(live, pitch.type %in% input$'PitchTypeLive', 
                                                                  as.character(as.Date(date)) %in% input$'PitchDateLive',
                                                                  batter.hand %in% input$'HitterHandLivePitch'), 
                                                      player = input$'player.pitch.live'))
}

shinyApp(ui = ui, server = server)
