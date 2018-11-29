library(shiny)
library(DT)
library(shinythemes)
library(shinyWidgets)
require(RCurl)
require(ggplot2)
require(data.table)

# Testing with a comment

ui <- navbarPage("IIAC Fangraphs",
                 
                 setBackgroundColor(rgb(178,34,34,200, maxColorValue = 255)),
                 
                 selected = "Home",
                 
                 tabPanel("Home",
                          fluidPage(
                            titlePanel("Blog"),
                            
                            fluidRow(
                              column(12,includeHTML("IIACBatChange.html"))))
                 ),
                 
                 navbarMenu("Batting",
                            tabPanel("Standard", dataTableOutput("Batting.Stats.Standard")),
                            tabPanel("Advanced", dataTableOutput("Batting.Stats.Advanced"))
                 ),
                 
                 navbarMenu("Pitching",
                            tabPanel("Standard", dataTableOutput("Pitching.Stats.Standard")),
                            tabPanel("Advanced", dataTableOutput("Pitching.Stats.Advanced")) 
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
                            tabPanel("Count", fluidRow(plotOutput("Count.Runs.Created")), 
                                     fluidRow(plotOutput("Count.Triple.Slash")), align = "center"),
                            tabPanel("Win Probability"),
                            tabPanel("Park Factors")
                 ),
                 
                 navbarMenu("Player",
                            tabPanel("Spray Charts", textInput("batterID", h3("Batter ID"), 
                                                               value = "Enter batterID"),
                                     plotOutput("Player.Spray.Chart")),
                            tabPanel("Base Runners"),
                            tabPanel("Out"),
                            tabPanel("Count")
                 ),
                 
                 tabPanel("Glossary")
)
