library(jsonlite)

# helpers
intToStringWithZeros <- function(varInt, varLength) {
  resultString <- as.character(varInt)
  while(nchar(resultString) < varLength) {
    resultString <- paste("0", resultString, sep="")
  }
  return(resultString)
}

idFormat <- function(intId) {
  return(intToStringWithZeros(intId, 3))
}

timeFormat <- function(intHH) {
  return(intToStringWithZeros(intHH, 2))
}

genTimeStringsFor24h <- function() {
  times <- c()
  for(h in 0:23) {
    for(m in 0:59) {
      times <- c(times, paste(timeFormat(h), timeFormat(m), sep = ""))
    }
  }
  return(times)
}

getTimeStampsForDate <- function(varDateYYYYMMDD) {
  
  # set of timestamps - TODO: whole day in a loop
  timesHHMM <- genTimeStringsFor24h()
  
  fullDateTimes <- sapply(timesHHMM, function(x) paste(varDateYYYYMMDD, "T", x, "01Z", sep = ""))
  return(fullDateTimes)
}

getHumanReadableTimes <- function(setOfTimeStamps) {
  # setOfTimeStamps format: c(YYYYMMDDTHHDDSSZ, ...)
  # = rownames from bikeDF
  hour <- substring(rownames(DF), 10, 11)
  minute <- substring(rownames(DF), 12, 13)
  return(paste(hour, ":", minute, sep=""))
}

#################################
### GET CITYBIKEDATA FROM HSL ###
#################################

### defining functions ###

getBasicStationInfo <- function() {
  stationsJSON <- fromJSON("https://raw.githubusercontent.com/juhapekkamoilanen/citybike-data-analysis/master/stations.json")
  return(stationsJSON$stations)
}
  
initDataFrameForBikedata <- function(stationsBasicData) {
  stationIDs <- stationsBasicData$stationId
  emptyDF <- as.data.frame(matrix(ncol=NROW(stationIDs), nrow=0))
  colnames(emptyDF) <- t(stationIDs)
  return(emptyDF)
}

getObservationData <- function(datetime_string) {
  # Note HSL times in UTC
  return(
    tryCatch({
      url <- paste("http://dev.hsl.fi/tmp/citybikes/stations_", datetime_string, sep = "")
      observation <- fromJSON(url)$result
      print("Fetched!")
      print(datetime_string)
      return(observation)
    }, error=function(e){
      print("Error: cannot find:")
      print(datetime_string)
      return(NA)
    })
  )
}

getAndSaveObservationDataByDates <- function(df, datetime_strings) {
  for (d in datetime_strings) {
    indexOfNextRow <- nrow(df) + 1
    observationData <- getObservationData(d)
    if (!is.na(observationData)) {
      df[indexOfNextRow, ] <- observationData$avl_bikes
      rownames(df)[indexOfNextRow] <- d
    }
  }
  return(df)
}

addTimeUnitColumns <- function(df) {
  df$year <- sapply(rownames(df), function(x) as.numeric(substr(x, 1, 4)))
  df$month <- sapply(rownames(df), function(x) as.numeric(substr(x, 5, 6)))
  df$day <- sapply(rownames(df), function(x) as.numeric(substr(x, 7, 8)))
  df$hour <- sapply(rownames(df), function(x) as.numeric(substr(x, 10, 11)))
  df$minute <- sapply(rownames(df), function(x) as.numeric(substr(x, 12, 13)))
  df$decMinute <- sapply(rownames(df), function(x) (as.numeric(substr(x, 12, 13)) %/% 10 + 1))
  return(df)
}

### execution ###

getWebData <- function(date) {
  stationsInfo <- getBasicStationInfo()
  bikeDF <- initDataFrameForBikedata(stationsInfo)
  bikeDF <- getAndSaveObservationDataByDates(bikeDF, getTimeStampsForDate(date))
  bikeDF <- addTimeUnitColumns(bikeDF)
  return(bikeDF)
}


