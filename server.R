library(shiny)
library(DT)
library(shinythemes)
library(shinyWidgets)
require(RCurl)
require(ggplot2)
require(data.table)

server <- function(input, output) {
  output$Blog = renderText({print("Blog will go here")})
  
  ind.bat = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/IIAC%20Bat%20Ind.csv"))
  rv.player = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/IIAC%20Bat%20Ind%20Advanced.csv"))
  rv.event = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/Run%20Value%20Event.csv"))
  base.out.re = read.table(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/Base%20Out%20Run%20Expectancy.txt"), 
                           header = TRUE, sep = "", dec = ".",
                           colClasses = c("character", "numeric", "numeric", "numeric"))
  
  play17 = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/events2017.csv"))
  play17$Year = 2017
  play18 = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/events2018.csv"))
  play18$Year = 2018
  play=rbind(play17, play18)
  
  eval(parse(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/Spray%20Chart.R")))
  pitch.adv = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/IIACpitching.adv.csv"))
  ind.pitch = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/IIACIndPitching.csv"))
  bat.adv = read.csv(text = getURL("https://raw.githubusercontent.com/rski4/Test/master/hittingIIAC.csv"))
  
  
  output$Batting.Stats.Standard <- renderDataTable(
    ind.bat[order(ind.bat$year, decreasing = TRUE),],
    filter = 'top',
    rownames = FALSE,
    options = list(pageLength = 50, autoWidth = TRUE)
  )
  
  output$Batting.Stats.Advanced <- renderDataTable(
    bat.adv[order(bat.adv$year, decreasing = TRUE),],
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
  
  output$Player.Spray.Chart <- renderPlot({
    spray.chart(input$'batterID')})
  
  
  count <- read.csv(text=getURL("https://raw.githubusercontent.com/rski4/Test/master/League%20Count%20Analysis.txt"), sep=" ")
  
  count <- as.data.frame(count)
  count$Obp <- with(count, round((Walk + Hit) / N, 3))
  
  triple.slash <- count[,c("count","BA", "Obp", "Slg")]
  triple.slash.gg <- melt(count[,c('count','BA','Obp','Slg')],id.vars = 1)
  
  output$Count.Runs.Created <- renderPlot({
    ggplot(data = count, aes(x = count, y = RC.AB)) +
      geom_col(fill = "firebrick") +
      ggtitle("Runs Created \nper Opportunity") +
      theme(plot.title = element_text(face = "bold", size = 18),
            axis.text = element_text(face = "bold", size = 12),
            axis.title = element_text(face = "bold", size = 14))
  })
  
  output$Count.Triple.Slash <- renderPlot({
    ggplot(data = triple.slash.gg, aes(x = count, y = value)) +
      geom_col(aes(fill = variable), position = "dodge") +
      ggtitle("Avg/Obp/Slg\nby Count") +
      theme(plot.title = element_text(face = "bold", size = 18),
            axis.text = element_text(face = "bold", size = 12),
            axis.title = element_text(face = "bold", size = 14))
  })
  output$Pitching.Stats.Standard <- renderDataTable(
    ind.pitch[order(ind.pitch$year, decreasing = TRUE),],
    filter = 'top',
    rownames = FALSE,
    options = list(pageLength = 50, autoWidth = TRUE)
  )
  
  output$Pitching.Stats.Advanced <- renderDataTable(
    pitch.adv[order(pitch.adv$year, decreasing = TRUE),],
    filter = 'top',
    rownames = FALSE,
    options = list(pageLength = 50, autoWidth = TRUE)
  )
}
