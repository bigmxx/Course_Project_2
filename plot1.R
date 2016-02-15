# setwd("D:/R/Exploratory Data Analysis/Week4/Course Project 2")
setwd("D:/R/")

## Read file with data
NEI <- readRDS("./Exploratory_Data_Analysis/Week4/Course_Project_2/summarySCC_PM25.rds")

## Calculate total PM25 emission from all sources for each year and convert it to data frame

NEI0 <- with(NEI, tapply(Emissions, year, sum, na.rm = T))
df <- data.frame(year = names(NEI0), sum = NEI0, row.names = NULL, stringsAsFactors = FALSE)
df$PM <- round(df[, 2]/1000, 2)

png(filename = "./Exploratory_Data_Analysis/Week4/Course_Project_2/plot1.png", height = 640, width = 640)

## Prepare plot
par(mar = c(5,6,4,1)) ## extra margin to accommodate tick labs

bp <- barplot(df$PM, names.arg = NULL,
              col = rainbow(20),
              main = expression(paste("Total PM", ""[2.5], " emission from all sources")),
              font.main = 2, cex.main = 2,
              ylim = c(0, 1.1 * max(df$PM)),
              xlab = "Year",
              ylab = expression(paste("PM", ""[2.5], " (in Kilotons)")),
              las = 1
              )
## Add text at top of bars
text(x = bp, y = df$PM, label = df$PM, pos = 3, cex = 0.8, col = "red")

## Saving to file
# dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()




