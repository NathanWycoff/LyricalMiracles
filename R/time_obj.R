#!/usr/bin/Rscript
#  time_obj.R Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 03.05.2018

## Determine a relationship between time and objectification
require(ggplot2)
source('R/lib.R')

#Read in the data
df <- read.csv('./data/fem_obj_proc.csv')

## See if count changes over time.
toplot <- function(target, desc) {
    plotdf <- data.frame(target = target, Year = df$Year)
    aggdf <- aggregate(plotdf$target, by = list(plotdf$Year), mean)
    colnames(aggdf) <- c('Year', 'target')
    p <- ggplot(aggdf, aes(y = target, x = Year)) + 
        geom_line() + ggtitle(paste(desc, "by Year")) +
        xlab('Genre') + ylab('Objectification Count')

    print(p)
}

#For now, no test
test <- function(target) {
    'nothing yet'
}

#Do the tests!
run_test(name = 'count_by_year', test = test, toplot = toplot)
