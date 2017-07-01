setwd("~/Git_projects/BikeData")
rm(list = ls())
source("getWebData.r")
source("analysisFunctions.r")

bikeDF <- getWebData("20170625")

# some test variables
espaAsemat <- c("012", "047", "014", "011", "018", "009", "024", "022", "019")

allStations <- colnames(bikeDF)[1:148]

meansByStation <- stationMeans(bikeDF)

humanReadableObservationTimes <- paste(substring(rownames(bikeDF), 10, 11), ":", substring(rownames(bikeDF), 12, 13), sep="")

#draw_plot_animate(espaAsemat)

stations <- getBasicStationInfo()

draw_plot_animate(bikeDF, allStations)