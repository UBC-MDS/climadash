# Imports
library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)

# Importing Dataframes
temp_df <- read.csv('https://raw.githubusercontent.com/UBC-MDS/climadash/main/data/processed/temperature_data.csv', header=TRUE)
percip_df <- read.csv('https://raw.githubusercontent.com/UBC-MDS/climadash/main/data/processed/percipitation_data.csv', header=TRUE)

temp_df$LOCAL_DATE <- ymd(temp_df$LOCAL_DATE)
percip_df$LOCAL_DATE <- ymd(percip_df$LOCAL_DATE)

cities <- unique(temp_df$CITY)
options <- c('Temperature', 'Percipitation')

# UI
ui <- fluidPage(
  titlePanel('Climate Metrics in Canada'),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput('time_range', 'Select the Time Interval'),
      selectInput('cities', 'Select City', cities, multiple = TRUE),
      radioButtons('option', 'Select Metric', options)
    ),
    mainPanel(
      plotOutput("line_plot")
    )
  )
)

# SERVER
server <- function(input, output, session) {
  output$line_plot <- renderPlot({
    ggplot(temp_df |> filter(LOCAL_DATE > "2000-01-01" & LOCAL_DATE <"2010-01-01")) +
      aes(x = LOCAL_DATE,
          y = MEAN_TEMP_.C.,
          color = CITY) +
      geom_line()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
