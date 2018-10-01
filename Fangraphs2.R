library(shiny)
library(DT)
library(shinythemes)
library(shinyWidgets)
require(RCurl)

ui <- navbarPage("IIAC Fangraphs",
  
  setBackgroundColor(rgb(178,34,34,200, maxColorValue = 255)),
  
  selected = "Home",
  
  tabPanel("Home",
           tags$h1("Blog"),
           tags$p("Blog will go here")
           ),
      
  navbarMenu("Batting",
             tabPanel("Standard", dataTableOutput("Batting.Stats.Standard")),
             tabPanel("Advanced", dataTableOutput("Batting.Stats.Advanced"))
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
             tabPanel("Run Expectancy", fluidRow(
                      tableOutput("Run.Expectancy"), align = "center"),
                      tags$head(tags$style("table {background-color: ghostwhite; }", media="screen", type="text/css"))
                      ),
             tabPanel("Run Values", tableOutput("Run.Expectancy.Event"),
                      tags$head(tags$style("table {background-color: ghostwhite; }", media="screen", type="text/css"))),
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


ind.bat = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/IIAC%20Bat%20Ind.csv"))

server <- function(input, output) {
  output$Blog = renderText({print("Blog will go here")})
  
  output$Batting.Stats.Standard <- renderDataTable(
    ind.bat[order(ind.bat$year, decreasing = TRUE),],
    filter = 'top',
    rownames = FALSE,
    options = list(pageLength = 50, autoWidth = TRUE)
  )
  
  output$Batting.Stats.Advanced <- renderDataTable(
    rv.player[order(rv.player$Runs.Created, decreasing = TRUE),],
    filter = 'top',
    rownames = FALSE,
    options = list(autoWidth = TRUE)
  )
  
  output$Run.Expectancy.Event <- renderTable({
    rv  }, 
    hover = TRUE,
    spacing = 'l'
  )
  
  output$Run.Expectancy <- renderTable({
    base.out.re[order(base.out.re$`0 outs`, decreasing = FALSE),]},
    hover = TRUE,
    spacing = 'l'
    )
}

shinyApp(ui = ui, server = server)
