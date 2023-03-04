# Reflection for Milestone 2
Mar 3, 2023

### What we have implemented
In milestone2, we implemented the core widgets in the side bar, and the 4 reactive plots, as designed in the initial dashboard sketch.

- The slider allows the user to focus on the climate data within chosen range of years.

- User could choose to focus on one city's data or compare data for multiple cities, all controlled by the cities drop-down menu.

- The radio button allow users to examine temperature data or precipitation data.

- All the plots are automatically updated when the user change their selection in any of the widget.

- The color schemes are coherent throughout the dashboard, however we are working on improving it (more on the next section)

There were several improvements made during the implementation:

- In the "select cities" drop down menu, we originally plan to have "Canada" as an option to display averaged climate data across all cities, however, due to the geographically distant nature of the cities location we decide to keep the cities separated. Default values also added so that the user will not land on blank pages.

- In the Annual average plot with trend line, loess curve was used as the trend line. The initial plan was to add a slider that allows the user to control the value of the span parameter in Loess method, however, considering that our target audience might not have the technical background to understand and adjust the span parameter to a proper value, we set the span to 1/10 of the total range to ensure the smoothness and clarity of the trend line.

### Current limitations & Future improvements
- We still need to add interactivity within the plots, for example, when hovering over each plots, tooltips should show the exact values.

- We need to adjust the dashboard size and the plot sizes so that the entire dashboard fit in one screen. Currently users with a smaller screen might need to scroll down in order to see the entire page.

- We are planning to move plot legend such that it doesn't interfere with the plot sizes. One idea is to change the cities dropdown menu into a multiple selection list, and color code the list to match the graphs. This way, the selection list in the side bar can serve as the legend for the plots.

- If more than 4 cities are selected, the bar plot for montly average could contain too much information. We need to find a better way to present this information, prehaps by changing the bar plots to line graphs.

- Alternatively we could add a map of Canada to showing key climate metrics associated with each city.

- We still want to add more colors and graphics to make the app more visually appealing. Some ideas are: use colors that are representative of each city, and add map of Canada to show the location of each city.
