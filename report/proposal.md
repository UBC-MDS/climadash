# Proposal

## Motivation and Purpose

ADD TEXT HERE

## Description of the Data

To create the dashboard, we will be using 80-years of weather data collected from stations from various major Canadian cities. The data was collected at daily intervals where the mean temperature and total percipitation (including both rain and snow) was recorded. Since not all stations in each city had full data, the source had pieced together the data using various stations around the cities with the data provided from the Government of Canada. The data starts from the 1940's and ends at the end of 2019. Majority of the missing data is within the 1940's to the 1960's, as such this time period will be omitted from the dashboard for sake of clarity as it is extremely difficult to forecast weather in such a long period of time. From the 1960's on the data has few missing points, however these can be easily interpolated as the time intervals are not large enough to cause concern.

The fact that the data is provided on a daily basis is extremely valuable as it lets us determine trends for larger time intervals. It will give us the oppritunity to look at monthly, yearly, and even seasonal trends. Though there are only two real feautres, mean temperature and total percipitation, the daily format allows for flexible analysis and extrapolation. The data is not in the cleanest format as it is raw, it would be better to pivot it longer such that instead of having columns for each city we have columns for mean temperature, total percipitation, and city for the sake of plotting.

## Research Questions and Usage Scenarios

ADD TEXT HERE