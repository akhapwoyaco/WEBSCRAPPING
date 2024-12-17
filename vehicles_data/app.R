library(shiny)
library(tidyverse)
library(pander)
library(broom)
#
# import datya
#
all_vehicles_data <- read_csv('vehicles_data_202412141810.csv')
#
ui <- fluidPage(
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)