# =================================================================== #
# ------------------------------IMPORTS------------------------------ #
# =================================================================== #
library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(plotly)
library(leaflet)

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
temp_df <- temp_df |> 
  mutate(CITY = case_when(
  CITY =="QUEBEC" ~ "QUEBEC CITY",
  TRUE ~ CITY))
       

percip_df$LOCAL_DATE <- ymd(percip_df$LOCAL_DATE)
percip_df$year <- year(percip_df$LOCAL_DATE)
percip_df$month <- month(percip_df$LOCAL_DATE)
percip_df$value <- percip_df$TOTAL_PERCIP_mm
percip_df$month_name <- month.abb[percip_df$month]
percip_df <- percip_df |> 
  mutate(CITY = case_when(
    CITY =="QUEBEC" ~ "QUEBEC CITY",
    TRUE ~ CITY))

year_range <- unique(temp_df$year)
year_start <- min(year_range)
cities <- unique(temp_df$CITY)
options <- c('Temperature (C)', 'Precipitation (mm)')

geo_data <- data.frame(
  CITY = c("CALGARY", "EDMONTON", "HALIFAX", "MONCTON", "MONTREAL", "OTTAWA", "QUEBEC CITY",
           "SASKATOON", "STJOHNS", "TORONTO", "VANCOUVER", "WHITEHORSE", "WINNIPEG"),
  citylat = c(51.0447, 53.5444, 44.6488, 46.0878, 45.5017, 45.4215, 46.8139, 52.1332,
              47.5615, 43.6532, 49.2827, 60.7212, 49.8951),
  citylon = c(-114.0719, -113.4909, -63.5752, -64.7782, -73.5673, -75.6972, -71.2080,
              -106.6700, -52.7126, -79.3832, -123.1207, -135.0568, -97.1384)
)

# =================================================================== #
# ------------------------------SHINY UI----------------------------- #
# =================================================================== #
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  titlePanel('Climate Metrics in Canada'),
  
  fluidRow(
    column(3,
           sliderInput("range", "Year Range:", 
                       min = 1940, max = 2019,
                       value = c(1940, 2019), step = 5,
                       sep = ""),
           uiOutput("cities_dropdown"),
           radioButtons('option', 'Select Metric', options),
           selectInput("dataset", "Choose a dataset:", choices = c("tempreture", "precipitation")),
           downloadButton("downloadData", "Download"),
          
           leafletOutput("map")          
           ),
    
    
    column(4,
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
  output$cities_dropdown <- renderUI({
    selectInput("cities", 
                "Select Cities", 
                cities, 
                multiple = TRUE, 
                selected = c('VANCOUVER', 'TORONTO'))
  })
  
  # ======Server Side of Download Button====== #

  data <- reactive({
    if (input$dataset == "tempreture") {
      temp_df
    } else if (input$dataset == "precipitation") {
      percip_df
    }
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data(), file, row.names = FALSE)
    }
  )
   
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
  
  # ======================= Map Plot ========================== #
  map_data <- reactive({
    if (input$option =='Temperature (C)'){
      temp_df |> 
        dplyr::filter(year >= input$range[1] & year <= input$range[2]) 
    } else{
      percip_df |> 
        dplyr::filter(year >= input$range[1] & year <= input$range[2])
    }
  })
  
  # Define the renderPlotly() function
  output$map <- renderLeaflet({
    
    map_data_final <- map_data()|> group_by(CITY) |>
      summarise(city_yavg = mean(value),
                city_ymax = max(value),
                city_ymin = min(value)) |> 
      left_join(geo_data, by = "CITY")
    
    if (input$option =='Temperature (C)'){
      pal <- colorNumeric(palette = "RdBu", 
                          domain = map_data_final$city_yavg,
                          reverse = TRUE)
    } else{
      pal <- colorNumeric(palette = "viridis", 
                          domain = map_data_final$city_yavg)
    }
    
    map_plot <- leaflet(data = map_data_final) |> 
      addTiles() |>
      addCircleMarkers(lng = ~citylon, # ~ to refer to the column in map_data_final
                       lat = ~citylat,
                       radius = 9,
                       fillColor = ~pal(city_yavg), 
                       fillOpacity = 1,
                       stroke = TRUE,
                       color = "grey",
                       weight = 2,
                       label = ~paste(CITY),
                       labelOptions = labelOptions(noHide = TRUE, direction = "top", opacity = 0.8),
                       popup = ~paste(CITY, "from", input$range[1], "to", input$range[2], "<br>",
                                      "Average", input$option, "=", round(city_yavg, 2), "<br>",
                                      "Max", input$option,"=", round(city_ymax, 2), "<br>",
                                      "Min", input$option, "=", round(city_ymin, 2), "<br>"
                       ),
                       popupOptions = popupOptions(noHide = FALSE, direction = "auto")
      ) |>
      addLegend(pal = pal,
                values = ~ city_yavg,
                title = paste("Average <br>",input$option),
                position = "bottomleft") |> 
      setView(lng = -96.7898, lat = 46, zoom = 2)
  })
}
# =================================================================== #
# ------------------------------SHINY RUN---------------------------- #
# =================================================================== #
shinyApp(ui = ui, server = server)
