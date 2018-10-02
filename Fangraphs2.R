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
             tabPanel("Run Values", fluidRow(
               tableOutput("Run.Expectancy.Event"), align = "center"),
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


server <- function(input, output) {
  output$Blog = renderText({print("Blog will go here")})
  
  ind.bat = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/IIAC%20Bat%20Ind.csv"))
  rv.player = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/IIAC%20Bat%20Ind%20Advanced.csv"))
  rv.event = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/Run%20Value%20Event.csv"))
  base.out.re = read.table(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/Base%20Out%20Run%20Expectancy.txt"), 
                           header = TRUE, sep = "", dec = ".",
                           colClasses = c("character", "numeric", "numeric", "numeric"))
  
  
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
    options = list(pageLength = 50, autoWidth = TRUE)
  )
  
  output$Run.Expectancy.Event <- renderTable({
    rv.event  }, 
    hover = TRUE,
    spacing = 'l'
  )
  
  output$Run.Expectancy <- renderTable({
    base.out.re[order(base.out.re$outs_0, decreasing = FALSE),]},
    hover = TRUE,
    spacing = 'l'
    )
}

shinyApp(ui = ui, server = server)
