#!/usr/bin/Rscript
#  genre_obj.R Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 02.12.2018

## This file is meant to be run in the root directory.

## Research Q1: Is Objectification more prevalent in Pop or Country?
require(ggplot2)
source('R/lib.R')

#Read in data
df <- read.csv('./data/fem_obj_proc.csv')

### Analyze on a counting scale
#Make a boxplot
toplot <- function(target, desc) {
    plotdf <- data.frame(Genre = df$Genre, target = target)
    p <- ggplot(plotdf, aes(x = Genre, y = target)) +
            geom_boxplot() + ggtitle(paste(desc, "by Genre")) +
            xlab('Genre') + ylab('Objectification Count')
    print(p)
    return(NULL)
}

#Onduct a wilcox test
test <- function(target) {
    wilcox.test(target[df$Genre=='Pop'], 
                          target[df$Genre=='Country'])
}

#Run over all things
run_test(name = 'count_by_genre', test = test, toplot = toplot)

### Analyze on a yes/no scale
toplot <- function(target, desc) {
    plotdf <- data.frame(Genre = df$Genre, target = as.numeric(target > 0))
    p <- ggplot(plotdf, aes(x = Genre, y = target)) +
        geom_bar(stat = 'identity') + ggtitle(paste(desc, "by Genre")) +
        xlab('Genre') + ylab('Objectification Frequency')
    print(p)
}

test <- function(target) {
    chisq.test(table(target > 0, df$Genre))
}

#Run over all things
run_test(name = 'freq_by_genre', test = test, toplot = toplot)
