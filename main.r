setwd("~/Git_projects/BikeData")
rm(list = ls())
source("getWebData.r")
source("analysisFunctions.r")

BikeDf2706 <- getWebData("20170627")
BikeDf2806 <- getWebData("20170628")

allStations <- colnames(BikeDf2706)[1:148]

humanReadableObservationTimes <- paste(substring(rownames(BikeDf2706), 10, 11), ":", substring(rownames(BikeDf2706), 12, 13), sep="")

stations <- getBasicStationInfo()

# Tuesday 27.6.
hourlyAvgs <- stationMeansHourly(BikeDf2706)
hourlyMaxs <- stationMaxsHourly(BikeDf2706)
hourlyMins <- stationMinsHourly(BikeDf2706)

linePlotAvailabilityAnimate(hourlyMins, hourlyMaxs, hourlyAvgs, c("078"))

# Wednesday 28.6.
hourlyAvgs2 <- stationMeansHourly(BikeDf2806)
hourlyMaxs2 <- stationMaxsHourly(BikeDf2806)
hourlyMins2 <- stationMinsHourly(BikeDf2806)

linePlotAvailabilityAnimate(hourlyMins2, hourlyMaxs2, hourlyAvgs2, c("078"))
