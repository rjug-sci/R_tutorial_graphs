### Graphs for Publication

![Langauge](https://img.shields.io/badge/Language-R-brightgreen)

This project will outline how to manipulate data and have neat graphs for publication

### Motivation

The motivation behind this project was to create an easy template for those in the science community not familiar with R and wanting a quick and easy solution to creating publication ready illustrations.

### Prerequisites
This tutorial assumes that the user has preinstalled R or R-studio. Please refer to proper documentation on the R-studio website.
https://rstudio.com/products/rstudio/download/

### Setup

Specify the working directory in which you will be working in.

```R

setwd("/Users/folderlocation")
getwd()

```

Begin with installing the prerequisite libraries for data manipulation, style and graph creation.

```R

install.packages("ggsci")
install.packages("dplyr")
install.packages("readxl")
install.packages("ggplot2")

```

Initialise your libraries

```R

library(ggsci)
library(dplyr)
library(readxl)
library(ggplot2)

```

### Data Import

Open your dataset and generate some basic statistics such as the mean, sd and frequency of values.
Calling your dataset by name "data2" will show all the values stored in that variable.

```R

data <- read_excel("~Filelocation.xlsx", 
                    sheet = "sheet1")
```

### Alternative method for data import
R can take a number of files including and not limited to txt, csv, tsv. 

```R
data <- read.csv("data.csv")

```

### Data Manipulation
Get summary statistics about the dataset using  the dplyr package.

```R
data2 <- ddply(data, c("Cells", "Gene"), summarise,
               N    = length(Expression),
               mean = mean(Expression),
               sd   = sd(Expression),
               se   = sd / sqrt(N))
data2

```

Separate data into factors and specify the order in which your factors will show up on the graph.

```R

data3$Cells <- factor(data2$Cells,
                        levels = c("MCF7","BT-20","SkBr3","ZR-75-1"))
```

### Graph Creation

Call the size of the canvas for the visual device

```R

par(mar=c(3,4,3,1) + 0.1)
par(oma=c(3,4,3,3))
par(mfcol=c(2, 2))

```

The code bellow will initialise and save a graph in a minimalist style and will use the standard colour scheme from "Nature" Publications. Other themes may be specified through the ggsci package. All features of the chart may be modified such as font, font size, background colour, line width etc. The visual device may also be specified either vector formats such as png/pdf or image formats such as bitmap/jpeg.

```R

png("Figure_name_1.png", width=2000, height=2000, res=400)
p <- ggplot(data3, aes(fill = Cells, y=mean, x=Gene))
p <- p + geom_bar(position="dodge", stat="identity")
p <- p + geom_errorbar(aes(ymin = mean-sd, ymax = mean+sd), color="black", width=0.25, position=position_dodge(0.9))
p <- p + scale_fill_npg()
p <- p + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
               panel.background = element_blank())
p <- p + labs(x="X-axis_label", y="Y-axis_label")
p <- p + labs(title="chart_label", tag="figure_label") +
  theme(plot.title=element_text(hjust = .5,vjust=2)) +
  theme(plot.title=element_text(size= 10,lineheight=.9, face="bold", colour="black"))
p <- p + theme(axis.title.x = element_text(size=10, lineheight=.9,face="bold",color="black",vjust=-0.35),
               axis.title.y = element_text(size=10, lineheight=.9,face="bold",color="black",hjust=0.5,vjust=-0))
p <- p + theme(strip.text.x = element_text(size = 12),
               strip.text.y = element_text(size = 12))
p <- p + theme(axis.line.x = element_line(color="black", size = 0.5),
               axis.line.y = element_line(color="black", size = 0.5))
p <- p + theme(axis.ticks.length = unit(.5,))
p <- p + coord_cartesian(ylim = c(0,8))
p <- p + scale_y_continuous(breaks=seq(0,8,0.2))
p
dev.off()
```

### Output

This will generate a graph such as the one below.


![Bar chart](https://github.com/rjug-sci/R_tutorial_graphs/blob/master/sample_image/Figure_1.png)

