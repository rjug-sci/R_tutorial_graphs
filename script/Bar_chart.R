#load libraries
library(readxl)
library(plyr)
library(reshape2)
library(tidyverse)
library(ggsci)
library(ggpubr)
library(grid)
library(gridExtra)
library(ggsignif)

#Set working directory, useful for knowing where your files will be saved.
setwd("/Users/Documents/Publication_graphs")
getwd()


#Import dataset using readxl package
library(readxl)
data1 <- read_excel("~/Documents/Publication_graphs/data/Sample_dataset.xlsx", 
                    sheet = "Sheet1")

#Check imported data
data1

#Generate summary statistics using dplyr package and create new data variable
data2 <- ddply(data1, c("Cells", "Gene"), summarise,
               N    = length(Expression),
               mean = mean(Expression),
               sd   = sd(Expression),
               se   = sd / sqrt(N))

#Check data summary and allocate to new variable for manipulation
data2
data3 <- data2
data3$Cells <- factor(data2$Cells,
                        levels = c("MCF7","BT-20","SkBr3","ZR-75-1"))


#Generate canvas size
par(mar=c(3,4,3,1) + 0.1)
par(oma=c(3,4,3,3))
par(mfcol=c(2, 2))

#Initiate PNG visual device, manipulate resolution and height/width of image
png("Figure_1.png", width=2000, height=2000, res=400)
#Use ggplot to input data into graph
p <- ggplot(data3, aes(fill = Cells, y=mean, x=Gene))
#Select geom_bar method for barchart 
p <- p + geom_bar(position="dodge", stat="identity")
#Import summary statistics to geneate error bars/confidence intervals if specified
p <- p + geom_errorbar(aes(ymin = mean-sd, ymax = mean+sd), color="black", width=0.25, position=position_dodge(0.9))
#This method selects the nature journals colour scheme
p <- p + scale_fill_npg()
#Make sure background is blank and only shows axis lines for x and y
p <- p + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
               panel.background = element_blank())
#Specify axis labels
p <- p + labs(x="GENES", y="EXPRESSION")
#Specify chart title and chart label, this part can be omitted
p <- p + labs(title="Chart title", tag="A") +
  p <- p + labs() +
#Specify text size/font on title section   
  theme(plot.title=element_text(hjust = .5,vjust=2)) +
  theme(plot.title=element_text(size= 10,lineheight=.9, face="bold", colour="black"))
#Specify X and Y axis line size, width and colour
p <- p + theme(axis.title.x = element_text(size=10, lineheight=.9,face="bold",color="black",vjust=-0.35),
               axis.title.y = element_text(size=10, lineheight=.9,face="bold",color="black",hjust=0.5,vjust=-0))
p <- p + theme(strip.text.x = element_text(size = 12),
               strip.text.y = element_text(size = 12))
p <- p + theme(axis.line.x = element_line(color="black", size = 0.5),
               axis.line.y = element_line(color="black", size = 0.5))
p <- p + theme(axis.ticks.length = unit(.5,))
#Specify Y axis limit
p <- p + coord_cartesian(ylim = c(0,5))
#Specify Y axis intervals 
p <- p + scale_y_continuous(breaks=seq(0,5,0.2))

#Initate chart and close visual device. File will save in working directory
p
dev.off()