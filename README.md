## Analysing usage of [HSL City bikes](https://www.hsl.fi/kaupunkipyorat)

Availability data from [http://dev.hsl.fi/tmp/citybikes/](http://dev.hsl.fi/tmp/citybikes/)

**Points of interest:**
* Visualizing availability rates
  * System wide - _Peak hours / dates?_
    * Effect of day of the week
    * Effect of the weather?
  * Per station - _Best/worst time of the day to get a bike at your favourite stations?_
  * Per area - _No bikes around central railway station at 9am?_
* Also reversely: analysing demand

## Sample results

Bike availability at "Uimastadion" bike station on 25.06.2017. Observations:
* People coming in for a morning swim around 8:00. And leaving around 10?
* More people coming between 12-16 for the afternoon sun?
* But also people leaving during 12-16 (notice the _"zigzag"_)
* Everybody leaving at 16?
* Only two arrivals after 16! (Around 17:20 and 19:00)

![uimastation_26-06-17.png](https://github.com/juhapekkamoilanen/citybike-data-analysis/blob/master/uimastation_26-06-17.png)

## Instructions for running the r scripts

* Clone project
* Open and execute main.r
* Wait aroung 5-10 min for loading data from HSL
* Look at the plots created!

This function will draw a plot for each station every 2 seconds:
```
draw_plot_animate <- function(DF, stationIds) {
  for (i in stationIds) {
    draw_plot(DF, idFormat(i))
    Sys.sleep(2)
  }
}
```

Change the date on line 6 at `main.r`:
```
bikeDF <- getWebData("20170625")
```
