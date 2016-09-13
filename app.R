#This makes an interactive table to display the cognitive 
library(shiny)
library(rsconnect)
library(etable)
library(tables)
long <- read.csv("long.csv", header=TRUE)
ui <- fluidPage(
  title="Cognitive and Neuropsychatric Data",
  sidebarPanel(
      checkboxGroupInput('columns', label=h3("Factors of Interest:"), 
                         c("Exposure"="Exposure", "Concussion"="Concussion", "Primary Position"="Position"), 
                         selected=list("Concussion","Exposure")),
      selectInput("value", "Choose a graph metric:", choices=c("Mean + SD"=1,"Number of Subjects in Strata"=2), selected =1)
      ),
  mainPanel(
    tags$head( 
        tags$style( HTML('#mytable table {border-collapse:collapse; } 
                             #mytable table th { transform: rotate(-45deg)}'
                                ))),
    tableOutput("mytable")
    
  ))

server <- function(input, output){
x<-reactive(input$value)
  

output$mytable <- renderTable({
    if(x()==1){
    fun_value<-etable::mean_sd_cell
    }else{fun_value <-etable::n_cell}
  Tab <- tabular.ade(x_vars='RawScore', rows='Test', cols=input$columns, cnames=input$columns, data=long, FUN=fun_value)
  xtable(Tab)
  

})
} 
shinyApp(ui = ui, server = server)
