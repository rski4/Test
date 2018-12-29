require(shiny)
require(plyr)
require(DT)
require(ggplot2)
require(ggforce)
require(RCurl)

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
                                                    plotOutput("KZoneBP", width = "100%")),
                                           tabPanel("Batted Balls",
                                                    fluidRow(column(12,plotOutput("BatBallProfileBP", width = "100%", height = "100%")),
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
                                                              tabPanel("K Zone", checkboxInput("KZonePitcherBPenSpeed","Speed",
                                                                                              value = FALSE),
                                                                       checkboxInput("KZonePitcherBPenType","Pitch Type",
                                                                                     value = FALSE),
                                                                       plotOutput("KZoneBPenPitch")),
                                                              tabPanel("Movement",
                                                                       fluidRow(column(5,plotOutput("MovementBPenPFX", width = "100%", height = "100%")),
                                                                                column(5,offset = 2, plotOutput("MovementBPen", width = "100%", height = "100%")))),
                                                              tabPanel("Release",
                                                                       plotOutput("ReleaseBPen"))
                                                            )
                                                          ))))
                 
                 )

bp = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/BP/BP_Session.csv"), col.names = paste("col", 1:77, sep = "."))

eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/flightscopeVar.R")))

bp = flightscopeVar(bp)

server <- function(input, output) {
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/SprayChartFS.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/KZoneHitter.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/HitBallProfile.R")))
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/FlightScope/KZonePitcherBPen.R")))
  
  hit.leader = ddply(bp, .(batter), summarise,
                     Max.Exit.Velo = format(round(max(hit.ball.speed, na.rm = TRUE), 2), nsmall = 2),
                     Exit.Velo.Avg = format(round(mean(hit.ball.speed, na.rm = TRUE), 2), nsmall = 2),
                     Launch.Angle.Avg = format(round(mean(hit.ball.launch.v, na.rm = TRUE), 2), nsmall = 2),
                     Max.Carry = format(round(max(hit.carry.dist, na.rm = TRUE), 2), nsmall = 2),
                     Carry.Avg = format(round(mean(hit.carry.dist, na.rm = TRUE), 2), nsmall = 2))
  
  output$HitLeader <- renderDataTable(
    hit.leader[order(hit.leader$Max.Exit.Velo, decreasing = TRUE),],
    filter = 'top',
    rownames = FALSE,
    options = list(autoWidth = TRUE)
  )
  
  output$SprayChartBP <- renderPlot({SprayChartFS(player = input$'hitter', exit.velo = input$'SprayChartCheckEVBP', launch.angle = input$'SprayChartCheckLABP')}, height = 600, width = 600)
  
  output$KZoneBP <- renderPlot({KZoneHitter(player = input$'hitter', hit = input$'KZoneHitCheckBP')}, height = 600, width = 500)
  
  output$BatBallProfileBP <- renderPlot({HitBallProfile(player = input$'hitter')}, height = 800, width = 500)
  
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
  
  output$KZoneBPenPitch <- renderPlot({KZonePitcherBPen(player = input$'player.pitch', speed = input$'KZonePitcherBPenSpeed', pitch.type = input$'KZonePitcherBPenType')}, height = 800, width = 700)
  
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
  
}

shinyApp(ui = ui, server = server)
