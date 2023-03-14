# =================================================================== #
# ------------------------------IMPORTS------------------------------ #
# =================================================================== #
library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(plotly)
options(shiny.autoreload = TRUE)


# =================================================================== #
# --------------------------DATA PROCESSING-------------------------- #
# =================================================================== #
temp_df <- read.csv('https://raw.githubusercontent.com/UBC-MDS/climadash/main/data/processed/temperature_data.csv', header=TRUE)
percip_df <- read.csv('https://raw.githubusercontent.com/UBC-MDS/climadash/main/data/processed/percipitation_data.csv', header=TRUE)

temp_df$LOCAL_DATE <- ymd(temp_df$LOCAL_DATE)
temp_df$year <- year(temp_df$LOCAL_DATE)
temp_df$month <- month(temp_df$LOCAL_DATE)
temp_df$value <- temp_df$MEAN_TEMP_C
temp_df$month_name <- month.abb[temp_df$month]

percip_df$LOCAL_DATE <- ymd(percip_df$LOCAL_DATE)
percip_df$year <- year(percip_df$LOCAL_DATE)
percip_df$month <- month(percip_df$LOCAL_DATE)
percip_df$value <- percip_df$TOTAL_PERCIP_mm
percip_df$month_name <- month.abb[percip_df$month]

year_range <- unique(temp_df$year)
year_start <- min(year_range)
cities <- unique(temp_df$CITY)
options <- c('Temperature (C)', 'Precipitation (mm)')


# =================================================================== #
# ------------------------------SHINY UI----------------------------- #
# =================================================================== #
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  titlePanel('Climate Metrics in Canada'),
  
  fluidRow(
    column(2,
           sliderInput("range", "Year Range:", 
                       min = 1940, max = 2019,
                       value = c(1940, 2019), step = 5,
                       sep = ""),
           uiOutput("cities"),
           radioButtons('option', 'Select Metric', options)),
    column(5,
           plotlyOutput("line_plot"),
           plotlyOutput("line_plot2")),
    column(5,
           plotlyOutput("month_averages"),
           plotlyOutput("diff_plot"))
  )
)


# =================================================================== #
# ------------------------------SHINY SERVER------------------------- #
# =================================================================== #
server <- function(input, output, session) {
  thematic::thematic_shiny()
  
  # ======Get Data for Reactivity====== #
  filtered_data <- reactive({
    if (input$option =='Temperature (C)'){
      temp_df |> 
        dplyr::filter(year >= input$range[1] & year <= input$range[2]) |>
        dplyr::filter(CITY %in% input$cities)
      } else{
    percip_df |> 
        dplyr::filter(year >= input$range[1] & year <= input$range[2]) |>
        dplyr::filter(CITY %in% input$cities)
    }
  })
  
  # ======Server Side of City Input====== #
  output$cities <- renderUI({
    selectInput("cities", 
                "Select Cities", 
                cities, 
                multiple = TRUE, 
                selected = c('VANCOUVER', 'TORONTO'))
  })
  
  # ======Plot 1 - Annual Average Line Plot====== #
  output$line_plot <- renderPlotly({
    plot1_data <- filtered_data() |> 
      group_by(year, CITY) |> 
      summarise(year_avg = mean(value), .groups = 'drop')
    
    plot_1 <- ggplot(plot1_data) +
      aes(x = year,
          y = year_avg,
          color = CITY) +
      geom_line() + xlim(input$range[1], input$range[2]) +
      labs(x = "Year", 
           y = paste("Annaul Average", input$option)) +
      ggtitle(paste("Annual Average", 
                    input$option)) +
      theme(text = element_text(size=12),
            plot.title = element_text(face = "bold"),
            axis.title = element_text(face = "bold"),
            legend.position="none",
            axis.text.x = element_text(angle = 90))
  })
  
  # ======Plot 2 - Average Monthly Bar Plot====== #
  output$month_averages <- renderPlotly({
    plot2_data <- filtered_data() |>
      group_by(month_name, CITY) |>
      summarise(month = mean(month),
                mean=mean(value)) |>
      arrange(month)
    
  plot_2 <- ggplot(plot2_data) +
    aes(x=reorder(month_name, month), 
        y=mean, 
        fill=CITY) +
    geom_col(stat="identity", color="white", position=position_dodge()) +
    # scale_y_continuous(breaks = seq(-30, 40, by = 5))+
    theme(panel.grid.major.y = element_line(color = "grey",
                                            size = 0.5,
                                            linetype = 2))+ 
    ggtitle(paste0("Monthly Average of ", 
                   input$option)) +
    xlab("Month") + 
    ylab(paste("Average Monthly",
               input$option))+
    theme(text = element_text(size=12),
          plot.title = element_text(face = "bold"),
          axis.title = element_text(face = "bold"),
          axis.text.x = element_text(angle = 90))
    
  })
  
  # ======Plot 3 - Annual Average Line Plot with Trendline====== #
  output$line_plot2 <- renderPlotly({
    plot3_data <- filtered_data() |> 
      group_by(year, CITY) |> 
      summarise(year_avg = mean(value), .groups = 'drop')
  
    plot_3 <- ggplot(plot3_data) +
    aes(x = year,
        y = year_avg,
        color = CITY) +
    geom_point() + 
    geom_smooth(se = TRUE, span = (input$range[2] - input$range[1])/10) +
    xlim(input$range[1], input$range[2]) +
    labs(x = "Year", 
         y = paste("Annaul Average", input$option)) +
    ggtitle(paste("Annual Average", 
                  input$option,
                  "Trends")) +
    theme(text = element_text(size=12),
          plot.title = element_text(face = "bold"),
          axis.title = element_text(face = "bold"),
          legend.position="none",
          axis.text.x = element_text(angle = 90))
  })
  
  # ======Plot 4 - Yearly Maximum Difference Line Plot====== #
  output$diff_plot <- renderPlotly({
    plot4_data <- filtered_data() |> 
      group_by(year, CITY) |> 
      summarise(max_diff = max(value)-min(value), .groups = 'drop')
    
    plot_4 <-ggplot(plot4_data) +
      aes(x = year,
          y = max_diff,
          color = CITY) +
      geom_line() +
      xlim(input$range[1], input$range[2]) +
      labs(x = "Year", y = paste("Max Difference in", input$option)) +
      ggtitle(paste("Difference Between Max and Min", 
                    input$option)) +
      theme(text = element_text(size=12),
            plot.title = element_text(face = "bold"),
            axis.title = element_text(face = "bold"),
            legend.position="none",
            axis.text.x = element_text(angle = 90))
  })
  
}

# =================================================================== #
# ------------------------------SHINY RUN---------------------------- #
# =================================================================== #
shinyApp(ui = ui, server = server)
