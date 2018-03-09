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

#Do an ANOVA to see if any year was sig diff from others
test <- function(target) {
    summary(lm(target ~ I(as.factor(df$Year))))
}

#Do the tests!
run_test(name = 'count_by_year', test = test, toplot = toplot)

## See if frequency changes over time.
toplot <- function(target, desc) {
    plotdf <- data.frame(target = as.numeric(target > 0), Year = df$Year)
    aggdf <- aggregate(plotdf$target, by = list(plotdf$Year), mean)
    colnames(aggdf) <- c('Year', 'target')
    p <- ggplot(aggdf, aes(y = target, x = Year)) + 
        geom_line() + ggtitle(paste(desc, "by Year")) +
        xlab('Genre') + ylab('Objectification Frequency') + ylim(0, 1)

    print(p)
}

#For now, no test
test <- function(target) {
    'nothing yet'
}

#Do the tests!
run_test(name = 'freq_by_year', test = test, toplot = toplot)
