#!/usr/bin/Rscript
#  sex_obj.R Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 03.05.2018

## This file is meant to be run in the root directory.

## Investigate a relationship between sex and objectification.
require(ordinal)
require(ggplot2)
source('R/lib.R')

#Read in the data
df <- read.csv('./data/fem_obj_proc.csv')

## See if count of objectification predicts gender
#For now, no plot
toplot <- function(target, desc) {
    NULL
}

test <- function(target) {
    ord <- as.factor(match(df$Sex, c('Female', 'Mixed', "Male")))
    fit <- clm(ord ~ I(sqrt(target)))
    summary(fit)
}

#Run over all things
run_test(name = 'sex_by_count', test = test, toplot = toplot)

## See if frequency of objectification predicts gender
#For now, no plot
toplot <- function(target, desc) {
    NULL
}

test <- function(target) {
    ord <- as.factor(match(df$Sex, c('Female', 'Mixed', "Male")))
    target <- as.character(target > 0)
    fit <- clm(ord ~ target)
    summary(fit)
}

#Run over all things
run_test(name = 'sex_by_freq', test = test, toplot = toplot)
