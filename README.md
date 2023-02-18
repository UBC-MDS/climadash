# climadash

R-shiny Dashboard for Canadian Climate Change

## Collaborators
Vikram Grewal, Kelly Wu, Xinru Lu, Mehdi Naji

## Description

This dashboard aim to show the Canadian climate change over eighty years. The dashboard contains a landing page that shows visualization of several key metrics for Canadian weather data from 1940 - 2020. 

To show the general trend over years, two plots are presented: the line plot with **three** lines (for annual average, maximum and minimum) and a scatter plot of annual average with rolling average, with a slider that allows users to adjust the window size of the rolling average and the smoothness of trendline. These two plots are alined vertically to allow easier comparison. Color coding will be used to distinguish the three lines.

To show the temperature distribution by month, a bar plot for monthly averages over years is presented. Color coding will be used to distinguish negative and positive values.

To tell the story about extreme weathers, a line plot for the annual maximum temperature difference is presented. 

In the menu, the user can use three widgets to customize the information displayed in the dashboard. From the dropdown, users can select to see the data for entire Canada or only certain province or territory. From the year filter, users can zoom in and out to examine the trend during specific range of years. From the radio buttons, users can choose to view the data for temperature, or precipitation. 

Tooltip will be used in all plots so that users can easily check the actual x-axis and y-axis values when hovering over the plots.

Here is a sketch of the dashboard.

![](img/Dashboard_Sketch_Climate.png)

## Contributing

Interested in contributing? Check out the contributing guidelines. Please note that this project is released with a Code of Conduct. By contributing to this project, you agree to abide by its terms.

## License

`climadash` was created by Vikram Grewal, Kelly Wu, Xinru Lu and Mehdi Naji. 
It is licensed under the terms of the MIT license.


