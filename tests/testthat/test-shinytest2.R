library(shinytest2)

test_that("{shinytest2} recording: map_value_test", {
  app <- AppDriver$new(variant = platform_variant(), name = "map_value_test", height = 764, 
      width = 1139)
  app$expect_values(output = "map")
})



test_that("{shinytest2} recording: slider_test", {
  app <- AppDriver$new(name = "slider_test", height = 764, width = 1139)
  app$set_inputs(range = c(1985, 2019))
  app$expect_values(output = "line_plot")
})



# test_that("{shinytest2} recording: global_test", {
#   app <- AppDriver$new(name = "global_test", height = 764, width = 1139)
#   app$set_inputs(option = "Precipitation (mm)")
#   app$set_inputs(cities = "EDMONTON")
#   app$set_inputs(range = c(1960, 2000))
#   app$expect_values()
# })



#test_that("{shinytest2} recording: radio_button_test", {
#  app <- AppDriver$new(name = "radio_button_test", height = 764, width = 1139)
#  app$set_inputs(option = "Precipitation (mm)")
#  app$set_inputs(range = c(1940, 1990))
#  app$expect_values(output = "line_plot2")
#})



test_that("{shinytest2} recording: ratio_button_test_2", {
  app <- AppDriver$new(name = "ratio_button_test_2", height = 764, width = 1139)
  app$set_inputs(option = "Precipitation (mm)")
  app$set_inputs(range = c(1945, 2019))
  app$expect_values(output = "line_plot")
})

