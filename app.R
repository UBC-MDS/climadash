# Imports
library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)
options(shiny.autoreload = TRUE)


# Importing Dataframes
temp_df <- read.csv('https://raw.githubusercontent.com/UBC-MDS/climadash/main/data/processed/temperature_data.csv', header=TRUE)
percip_df <- read.csv('https://raw.githubusercontent.com/UBC-MDS/climadash/main/data/processed/percipitation_data.csv', header=TRUE)

temp_df$LOCAL_DATE <- ymd(temp_df$LOCAL_DATE)
temp_df$year <- year(temp_df$LOCAL_DATE)
temp_df$month <- month(temp_df$LOCAL_DATE)
temp_df$value <- temp_df$MEAN_TEMP_C

percip_df$LOCAL_DATE <- ymd(percip_df$LOCAL_DATE)
percip_df$year <- year(percip_df$LOCAL_DATE)
percip_df$month <- month(percip_df$LOCAL_DATE)
percip_df$value <- percip_df$TOTAL_PERCIP_mm

year_range <- unique(temp_df$year)
year_start <- min(year_range)
cities <- unique(temp_df$CITY)
options <- c('Temperature', 'Percipitation')

# UI
ui <- fluidPage(
  titlePanel('Climate Metrics in Canada'),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("range", "Select range of years:", 
                  min = 1940, max = 2019, 
                  value = c(1940, 2019), step = 5),
      uiOutput("cities"),
      radioButtons('option', 'Select Metric', options)
      ),
  
    mainPanel(
      plotOutput("line_plot"),
      plotOutput("line_plot2")
      
    )
  )
)


# SERVER
server <- function(input, output, session) {
  
  # get the data
  filtered_data <- reactive({
    if (input$option =='Temperature'){
      temp_df |> 
        dplyr::filter(year >= input$range[1] & year <= input$range[2]) |>
        dplyr::filter(CITY %in% input$cities)
      } else{
    percip_df |> 
        dplyr::filter(year >= input$range[1] & year <= input$range[2]) |>
        dplyr::filter(CITY %in% input$cities)
    }
  })
  
  
  output$cities <- renderUI({
    selectInput("cities", "Select Cities", cities, multiple = TRUE, selected = c('VANCOUVER', 'TORONTO'))
  })
  
  # Plot 1 - annual average line plot
  output$line_plot <- renderPlot({
    plot1 <- filtered_data()
    
    plot1 |> 
      group_by(year, CITY) |> 
      summarise(year_avg = mean(value), .groups = 'drop') |>
      ggplot(aes(x = year,
                 y = year_avg,
                 color = CITY)) +
      geom_line() + xlim(input$range[1], input$range[2])
  })
  
  # Plot 3 - annual average line plot with trendline
  output$line_plot2 <- renderPlot({
    plot3 <- filtered_data()
    
    plot3 |> 
      group_by(year, CITY) |> 
      summarise(year_avg = mean(value), .groups = 'drop') |>
      ggplot(aes(x = year,
                 y = year_avg,
                 color = CITY)) +
      geom_point() + 
      geom_smooth(se = TRUE, span = (input$range[2] - input$range[1])/10) +
      xlim(input$range[1], input$range[2]) +
      labs(x = "Year", y = paste("Annaul Average", input$option)) +
      ggtitle(paste("Scatter Plot with Trendline for Selected Cities' Annual Average", 
                    input$option, 
                    '\n (from', input$range[1], 'to', input$range[2], ')')) +
      theme(text = element_text(size=12),
            plot.title = element_text(face = "bold"),
            axis.title = element_text(face = "bold"),
            legend.title = element_text(face = "bold"))
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
