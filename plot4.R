# setwd("D:/R/Exploratory Data Analysis/Week4/Course Project 2")
setwd("D:/R/")
library(sqldf)
library(ggplot2)

## Read file with data
NEI <- readRDS("./Exploratory_Data_Analysis/Week4/Course_Project_2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory_Data_Analysis/Week4/Course_Project_2/Source_Classification_Code.rds")

# Coal combustion related sources
SCC.coal <- sqldf("select * from SCC where [Short.Name] LIKE '%Coal%'")

# Merge two data sets
merge <- merge(x = NEI, y = SCC.coal, by='SCC')

## Calculate total PM25 emission from coal combustion-related sources changes from 1999-2008
df <- with(merge, aggregate(Emissions, by = list(year = year), FUN = sum, na.rm = T))
colnames(df) <- c("Year", "Emissions")

# Generate the graph in the same directory as the source code
png(filename = "./Exploratory_Data_Analysis/Week4/Course_Project_2/plot4.png", height = 640, width = 640)

## Prepare plot4
g <- ggplot(df, aes(Year, Emissions/1000))

g + geom_line(col = "blue") + geom_point(size = 2, col = "magenta") + 
  ggtitle(expression(paste('Total Emissions of PM'[2.5],' from coal combustion-related sources'))) + 
  xlab('Years') + 
  ylab(expression(paste('PM', ''[2.5], ' in kilotons'))) + 
  geom_text(aes(label = round(Emissions/1000, digits = 2), size = 2, hjust = .5, vjust = 1.5)) + 
  theme(legend.position = 'none', 
        plot.title = element_text(family = "Times", size = rel(1.5), face = "bold"),
        axis.title.x = element_text(family = "Courier", size = rel(1.3), face = "bold"),
        axis.title.y = element_text(family = "Courier", size = rel(1.3), face = "bold")
  )

## Saving to file
# dev.copy(png, file = "./Exploratory_Data_Analysis/Week4/Course_Project_2/plot4.png", height=640, width=640)
dev.off()




