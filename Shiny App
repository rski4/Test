library(shiny)
library(DT)
library(shinythemes)
library(shinyWidgets)

ui <- fluidPage(
  
  titlePanel("IIAC Fangraphs"),
  
  setBackgroundColor(rgb(178,34,34,200, maxColorValue = 255)),
  
  mainPanel(
      tabsetPanel(
        tabPanel("Hitters", dataTableOutput("Batting.Stats")),
        tabPanel("Run Values", tableOutput("Run.Expectancy.Event")),
        tabPanel("Run Expectancy", tableOutput("Run.Expectancy")),
        tabPanel("Play by Play", fluid = TRUE,
                 sidebarLayout(
                   
                   sidebarPanel(
                     checkboxGroupInput("Year", 
                                        "Year", 
                                        c("2017" = 2017, "2018" = 2018),
                                        selected = c("2017", "2018"))
                   ),
                   mainPanel(dataTableOutput("Play.by.Play"))
                   )
                 )
        # tabPanel("RV Base", fluid = TRUE,
        #          sidebarLayout(
        #            sidebarPanel(
        #              textInput("Batter", label = "Batter Name")
        #            ),
        #            mainPanel(plotOutput("Run.Value.Base"))
        #          )
        #          )
        )
      )
  )
  

server <- function(input, output) {
  output$Batting.Stats <- renderDataTable(
    rv.player[order(rv.player$Runs.Created, decreasing = TRUE),],
    filter = 'top',
    rownames = FALSE,
    options = list(autoWidth = TRUE)
  )
  
   
  
  output$Run.Expectancy.Event <- renderTable({
    rv
  })
  
  output$Run.Expectancy <- renderTable({
    runs.out
  })
  
  output$Play.by.Play <- renderDataTable(
    play[play$Year==input$Year,],
    rownames = FALSE
  )
  
  # output$Run.Value.Base <- renderPlot(
  #   
  # )
  
}

shinyApp(ui = ui, server = server)
