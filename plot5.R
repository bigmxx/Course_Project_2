# # setwd("D:/R/Exploratory Data Analysis/Week4/Course Project 2")
# setwd("D:/R/")
library(sqldf)
library(ggplot2)

## Read file with data
NEI <- readRDS("./Exploratory_Data_Analysis/Week4/Course_Project_2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory_Data_Analysis/Week4/Course_Project_2/Source_Classification_Code.rds")

# Emissions from motor vehicle sources from 1999-2008 in Baltimore City

NEI0 <- subset(NEI, fips =="24510")

# Used join from respective files to get raw data in one shot
SCC.motor <- sqldf("select * from SCC s INNER JOIN NEI0 n ON n.SCC = s.SCC where s.[Short.Name] LIKE '%vehicle%'")

## Calculate total PM25 emission from coal combustion-related sources changes from 1999-2008
df <- with(SCC.motor, aggregate(Emissions, by = list(year = year), FUN = sum, na.rm = T))
colnames(df) <- c("Year", "Emissions")

# Generate the graph in the same directory as the source code
## Saving to file
png(filename = "./Exploratory_Data_Analysis/Week4/Course_Project_2/plot5.png", height = 640, width = 640)

## Prepare plot4
g <- ggplot(df, aes(as.factor(Year), Emissions))

g <- g +    
  geom_bar(stat="identity", position = "identity", 
           aes(fill = ifelse(Emissions < mean(Emissions), "grey", rgb(16,206,248, maxColorValue=255)))) + 
  ggtitle(expression(paste("Total Emissions of PM"[2.5], " from motor vehicle sources in Baltimore City, MD"))) + 
  xlab('Years') + 
  ylab(expression(paste('PM', ''[2.5], ' in tons'))) + 
  geom_text(aes(label = round(Emissions, digits = 2), hjust = .5, vjust = 1.5)) + 
  theme(plot.title = element_text(family = "Times", size = rel(1.5), face = "bold"),
        axis.title.x = element_text(family = "Courier", size = rel(1.3), face = "bold", color = "cadetblue", vjust = -.35),
        axis.title.y = element_text(family = "Courier", size = rel(1.3), face = "bold", color = "blue", vjust = .35),
        legend.position = c(.8, .8)#,
  )
g + scale_fill_manual(name = "PM 25", labels = c("Above Avg", "Below Avg"), values = c("grey", "light blue") )

dev.off()

  
  