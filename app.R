# Imports
library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)

# Importing Dataframes
temp_df <- read.csv('https://raw.githubusercontent.com/UBC-MDS/climadash/main/data/processed/temperature_data.csv', header=TRUE)
percip_df <- read.csv('https://raw.githubusercontent.com/UBC-MDS/climadash/main/data/processed/percipitation_data.csv', header=TRUE)

temp_df$LOCAL_DATE <- ymd(temp_df$LOCAL_DATE)
temp_df$year <- year(temp_df$LOCAL_DATE)
temp_df$month <- month(temp_df$LOCAL_DATE)

percip_df$LOCAL_DATE <- ymd(percip_df$LOCAL_DATE)
percip_df$year <- year(percip_df$LOCAL_DATE)
percip_df$month <- month(percip_df$LOCAL_DATE)

year_range <- unique(temp_df$year)
year_start <- min(year_range)
year_start <- min(year_range)
cities <- unique(temp_df$CITY)
options <- c('Temperature', 'Percipitation')

# UI
ui <- fluidPage(
  titlePanel('Climate Metrics in Canada'),
  sidebarLayout(
    sidebarPanel(
      uiOutput("yStart"), 
      uiOutput("yEnd"), 
      # dateRangeInput(
      #   'time_range', 
      #   'Select the Year Interval', 
      #   start = min(year_range), 
      #   end = max(year_range),
      #   startview = "decade",
      #   format="yyyy"),
      uiOutput("cities"),
      radioButtons('option', 'Select Metric', options)
    ),
    mainPanel(
      plotOutput("line_plot")
    )
  )
)

# SERVER
server <- function(input, output, session) {
  output$yStart <- renderUI({
    selectInput("year_start", "Select Year Start", year_range, selected = min(year_range))
  })
  output$yEnd <- renderUI({
    selectInput("year_end", "Select Year End", year_range, selected = max(year_range))
  })
  output$cities <- renderUI({
    selectInput("cities", "Select Cities", cities, multiple = TRUE)
  })
  output$line_plot <- renderPlot({
    ggplot(temp_df |> 
             # filter(LOCAL_DATE > input$yStart & LOCAL_DATE < input$yEnd) |> 
             filter(CITY %in% input$cities)
           ) +
      aes(x = LOCAL_DATE,
          # y = MEAN_TEMP_.C.,
          y = MEAN_TEMP_C,
          color = CITY) +
      geom_line()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
