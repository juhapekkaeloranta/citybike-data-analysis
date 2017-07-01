library(jsonlite)

# generic helpers
idFormat <- function(intId) {
  stringId <- as.character(intId)
  while(nchar(stringId) < 3) {
    stringId <- paste("0", stringId, sep = "")
  }
  return(stringId)
}

### station info ###

getBasicStationInfo <- function() {
  stationsJSON <- fromJSON("https://raw.githubusercontent.com/juhapekkamoilanen/citybike-data-analysis/master/stations.json")
  return(stationsJSON$stations)
}

### plotting functions ###

# draw one 
draw_plot <- function(DF, stationID) {
  matr <- as.matrix(t(DF[stationID]))
  stationName <- stations[stations$stationId==stationID,]$name
  barplot(matr, main=stationName, 
          xlab="Time of day", ylab="bikes available",
          names.arg=humanReadableObservationTimes,
          col='blue')
}

draw_plot_animate <- function(DF, stationIds) {
  for (i in stationIds) {
    draw_plot(DF, idFormat(i))
    Sys.sleep(2)
  }
}

### calculations ###

stationMeans <- function(df) {
  means <- data.frame(t(colMeans(df, na.rm = FALSE, dims = 1)))
  colnames(means) <- colnames(df)
  return(means)
}

