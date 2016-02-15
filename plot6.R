# # setwd("D:/R/Exploratory Data Analysis/Week4/Course Project 2")
# setwd("D:/R/")
library(sqldf)
library(ggplot2)

## Read file with data
NEI <- readRDS("./Exploratory_Data_Analysis/Week4/Course_Project_2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory_Data_Analysis/Week4/Course_Project_2/Source_Classification_Code.rds")

# Emissions from motor vehicle sources from 1999-2008 in Baltimore City

NEI0 <- subset(NEI, fips %in% c("24510", "06037"))

# Used join from respective files to get raw data in one shot
SCC.motor <- sqldf("select * from SCC s INNER JOIN NEI0 n ON n.SCC = s.SCC where s.[Short.Name] LIKE '%vehicle%'")

## Calculate total PM25 emission from coal combustion-related sources changes from 1999-2008
df <- with(SCC.motor, aggregate(Emissions, by = list(year = year, fips = fips), FUN = sum, na.rm = T))
colnames(df) <- c("Year", "fips", "Emissions")

# Generate the graph in the same directory as the source code
## Saving to file
png(filename = "./Exploratory_Data_Analysis/Week4/Course_Project_2/plot6.png", height = 640, width = 640)

## Prepare plot4
g <- ggplot(df, aes(as.factor(Year), Emissions, fill = fips))

g <- g +    
  geom_bar(stat="identity", position = "dodge", 
           # aes(fill = ifelse(Emissions < mean(Emissions), "grey", rgb(16,206,248, maxColorValue=255)))
           ) + 
  # scale_fill_brewer(palette = "Set2") +
  ggtitle(paste("Total Emissions of Motor Vehicle Sources\nLos Angeles County, California vs. Baltimore City, Maryland")) + 
  xlab('Years') + 
  ylab(expression(paste('PM', ''[2.5], ' (in tons)'))) + 
  geom_text(aes(label = round(Emissions, digits = 0)), position=position_dodge(width=0.9), vjust=-0.5) + 
  # geom_text(aes(label=paste(Value, "%")), position=position_dodge(width=0.9), vjust=-0.25)
  theme(plot.title = element_text(family = "Times", size = rel(1.5), face = "bold"),
        axis.title.x = element_text(family = "Courier", size = rel(1.3), face = "bold", color = "cadetblue", vjust = -.35),
        axis.title.y = element_text(family = "Courier", size = rel(1.3), face = "bold", color = "blue", vjust = .35),
        legend.position = c(.9, .9)#,
  )
g + scale_fill_manual(name = expression("PM" [2.5]), labels = c("Los Angeles County", "Baltimore City, MD"), values = c("peachpuff", "royalblue") )

dev.off()


