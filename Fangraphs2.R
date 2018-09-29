library(shiny)
library(DT)
library(shinythemes)
library(shinyWidgets)

ui <- navbarPage("IIAC Fangraphs",
  
  setBackgroundColor(rgb(178,34,34,200, maxColorValue = 255)),
  
  tabPanel("Home",
           textOutput("Blog")
           ),
      
  navbarMenu("Batting",
             tabPanel("Standard"),
             tabPanel("Advanced", dataTableOutput("Batting.Stats"))
             ),
  
  navbarMenu("Pitching",
             tabPanel("Standard"),
             tabPanel("Advanced")
             ),
  
  navbarMenu("Team",
             tabPanel("Standard"),
             tabPanel("Advanced"),
             tabPanel("Spray Charts"),
             tabPanel("Base Runners"),
             tabPanel("Out"),
             tabPanel("Count")
             ),
  
  navbarMenu("IIAC",
             tabPanel("Run Expectancy", tableOutput("Run.Expectancy")),
             tabPanel("Run Values", tableOutput("Run.Expectancy.Event")),
             tabPanel("Inning"),
             tabPanel("Win Probability"),
             tabPanel("Park Factors")
             ),
  
  navbarMenu("Player",
             tabPanel("Spray Charts"),
             tabPanel("Base Runners"),
             tabPanel("Out"),
             tabPanel("Count")
             ),
  
  tabPanel("Glossary")
)


server <- function(input, output) {
  output$Blog = renderText({print("Blog will go here")})
  
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
 
}

shinyApp(ui = ui, server = server)
