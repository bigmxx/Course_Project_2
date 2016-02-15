# setwd("D:/R/Exploratory Data Analysis/Week4/Course Project 2")
# setwd("D:/R/")

## Read file with data
NEI <- readRDS("./Exploratory_Data_Analysis/Week4/Course_Project_2/summarySCC_PM25.rds")

## Calculate total PM25 emission in Baltimore City only for each year and convert it to data frame

df <- with(subset(NEI, fips =="24510"), aggregate(Emissions, by = list(year = year, type = type), FUN = sum, na.rm = T))

png(filename = "./Exploratory_Data_Analysis/Week4/Course_Project_2/plot3.png", height = 640, width = 640)

## Prepare plot3
library(ggplot2)
g <- ggplot(df, aes(year, x))
g <- g + geom_point(aes(color = type), size = 4) +
         labs(title = expression(paste("Total PM", ""[2.5], " emission in Baltimore City by type")), font.main = 2)
g + labs(x = "Years", y = expression(paste("Total PM", ""[2.5], " (tons)"))) + 
    facet_grid(.~type) + geom_line(aes(color = type)) +
    theme(plot.title = element_text(family = "Times", size = rel(1.5), face = 2), 
          axis.title.x = element_text(family = "Courier", size = rel(1)),
          axis.title.y = element_text(family = "Courier", size = rel(1))
          )

## Saving to file
# dev.copy(png, file="plot3.png", height=640, width=640)
dev.off()




