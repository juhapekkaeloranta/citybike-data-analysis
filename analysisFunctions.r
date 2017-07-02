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
          col='blue')
}

draw_plot_animate <- function(DF, stationIds) {
  for (i in stationIds) {
    draw_plot(DF, idFormat(i))
    Sys.sleep(2)
  }
}

### calculations ###

columnMax <- function(df) {
  result <- matrix(ncol=NCOL(df), nrow=1)
  for (j in 1:NCOL(df)) {
    result[1,j] <- max(df[,j])
  }
  return(result)
}

columnMin <- function(df) {
  result <- matrix(ncol=NCOL(df), nrow=1)
  for (j in 1:NCOL(df)) {
    result[1,j] <- min(df[,j])
  }
  return(result)
}


stationMeansHourly <- function(df) {
  resultDf <- as.data.frame(matrix(ncol=NCOL(df), nrow=0))
  for (i in 0:23) {
    hourlyDfSubset <- df[df$hour==i,]
    indexOfNextRow <- nrow(resultDf) + 1
    resultDf[indexOfNextRow, ] <- t(colMeans(hourlyDfSubset, na.rm = FALSE, dims = 1))
    rownames(resultDf)[indexOfNextRow] <- i+2
  }
  colnames(resultDf) <- colnames(df)
  return(resultDf)
}

stationMaxsHourly <- function(df) {
  resultDf <- as.data.frame(matrix(ncol=NCOL(df), nrow=0))
  for (i in 0:23) {
    hourlyDfSubset <- df[df$hour==i,]
    indexOfNextRow <- nrow(resultDf) + 1
    #resultDf[indexOfNextRow, ] <- t(colMeans(hourlyDfSubset, na.rm = FALSE, dims = 1))
    resultDf[indexOfNextRow, ] <- columnMax(hourlyDfSubset)
    rownames(resultDf)[indexOfNextRow] <- i+2
  }
  colnames(resultDf) <- colnames(df)
  return(resultDf)
}

stationMinsHourly <- function(df) {
  resultDf <- as.data.frame(matrix(ncol=NCOL(df), nrow=0))
  for (i in 0:23) {
    hourlyDfSubset <- df[df$hour==i,]
    indexOfNextRow <- nrow(resultDf) + 1
    #resultDf[indexOfNextRow, ] <- t(colMeans(hourlyDfSubset, na.rm = FALSE, dims = 1))
    resultDf[indexOfNextRow, ] <- columnMin(hourlyDfSubset)
    rownames(resultDf)[indexOfNextRow] <- i+2
  }
  colnames(resultDf) <- colnames(df)
  return(resultDf)
}

stationDailyBasicStatistics <- function(df) {
  resultDf <- as.data.frame(matrix(ncol=NCOL(df), nrow=0))
  resultDf[1,] <- colMeans(df, na.rm = FALSE, dims = 1)
  rownames(resultDf)[1] <- "Mean"
  resultDf[2,] <- columnMax(df)
  rownames(resultDf)[2] <- "Max"
  return(resultDf)
}

linePlotAvailability <- function(mins, maxs, means, stationId) {
  stationName <- stations[stations$stationId==stationId,]$name
  y_len <- max(maxs[,stationId]+1)
  plot(NULL, main=stationName,
       xlim=c(2,25), ylim=c(0,y_len),
       #xlim=c(0,23), ylim=c(0,40),
       xlab="Hour", ylab="Bikes available",
       lab=c(24, y_len/5, 5), yaxs="i", bg="red")
  lines(rownames(mins), mins[,stationId], col="#dc0450")
  lines(rownames(means), means[,stationId], col="#0079c8", lwd=3)
  lines(rownames(maxs), maxs[,stationId], col="#64be1e")
}

linePlotAvailabilityAnimate <- function(mins, maxs, means, stations) {
  for (station in stations) {
    linePlotAvailability(mins, maxs, means, station)
    Sys.sleep(2)
  }
}
