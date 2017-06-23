library(jsonlite)

# Cleaned up static station information
stationsJSON <- fromJSON("https://raw.githubusercontent.com/juhapekkamoilanen/citybike-data-analysis/master/stations.json")
stations <- citybike$stationsJSON
colnames(stations)

stations

# Sample of availability data from HSL
sampleJSON <- fromJSON("http://dev.hsl.fi/tmp/citybikes/stations_20170623T085201Z")
sample <- sampleJSON$result

# Interesting parameters: station name and available bikes
id_and_name <- c(sample$name)
avl <- c(sample$avl_bikes)
availability_datetime_x_station <- t(avl)

rownames(availability_datetime_x_station) <- "2017-06-23 08:52:01"
colnames(availability_datetime_x_station) <- t(id_and_name)

# Show table
availability_datetime_x_station

# Note: all times in UTC
