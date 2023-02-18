# Proposal

## Motivation and Purpose

Our role: Climate Data Scientist Group

Target audience: Canadian environmental government administrators

Climate change has been a controversial topic when it comes to government policy making. We proivde clear evidence on the climate change trend for Canadian government administrators as well as to inform the general public, we created the `climadash` dashboard to help visualize the complicated time-series climate data grouped by different regions. We will focus on temperature and precipiaion data now and allow flexible interaction with the graphs for the users to derive various conclusions, such as outlier data with min/max plot, and monthly average with rolling average charts.  

## Description of the Data

To create the dashboard, we will be using 80-years of weather data collected from stations from various major Canadian cities. The data was collected at daily intervals where the mean temperature and total percipitation (including both rain and snow) was recorded. Since not all stations in each city had full data, the source had pieced together the data using various stations around the cities with the data provided from the Government of Canada. The data starts from the 1940's and ends at the end of 2019. Majority of the missing data is within the 1940's to the 1960's, as such this time period will be omitted from the dashboard for sake of clarity as it is extremely difficult to forecast weather in such a long period of time. From the 1960's on the data has few missing points, however these can be easily interpolated as the time intervals are not large enough to cause concern.

The fact that the data is provided on a daily basis is extremely valuable as it lets us determine trends for larger time intervals. It will give us the oppritunity to look at monthly, yearly, and even seasonal trends. Though there are only two real feautres, mean temperature and total percipitation, the daily format allows for flexible analysis and extrapolation. The data is not in the cleanest format as it is raw, it would be better to pivot it longer such that instead of having columns for each city we have columns for mean temperature, total percipitation, and city for the sake of plotting.

## Research Questions and Usage Scenarios

"Emily", a 25-year-old university student living in Ottawa, Canada. She is focused on her studies and does not have much time to keep up with current events. Although Emily has heard about climate change, she does not fully understand what it is, why it is important, or how it affects her daily life.

Emily's lack of understanding about climate change is not uncommon. She has never been exposed to the facts about the dynamic climate changes happening in Canada and its provinces. She does not know that the average annual temperature in Canada has increased by 1.7°C since 1948, and that this trend is projected to continue. She is also unaware that the average annual precipitation has increased by 12% since the 1950s, leading to more extreme weather events like floods and droughts.

As Emily navigates through this dashboard, she might be initially overwhelmed by the amount of information. She sees a map of Canada and realizes that each province has its unique climate change dynamic. She wonders how the weather can be so different from one place to another.

### Research Questions

- Have the annual average tempretures in Canada, as a whole, and for each province been steady over the past years?
- Have the annual average precipitation in Canada, as a whole, and for each province been steady over the past years?
- Have the temprature dynamic patterns in difference provinces been different or similar?
- Have the pericipitation dynamic patterns in difference provinces been different or similar?
- Which provinces have eperienced more serious climate changes? 