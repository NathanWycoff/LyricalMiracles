#!/usr/bin/Rscript
#  bayes_anls.R Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 03.13.2018

## A fully bayesian analysis of the data
require(ggplot2)
source('R/lib.R')

#Read in the data
df <- read.csv('./data/fem_obj_proc.csv')
df$Year <- as.factor(df$Year)

targets <- c('F1', 'F2', 'F3', 'F4', 'F5')
df$TotalObj <- rowSums(df[,targets])
targets <- c(targets, 'TotalObj')

# Do an anlysis of the count data.
for (tar in targets) {
    target <- df[,tar]
    fit <- glm(target ~ Sex + Genre + Year, quasipoisson, data = df)
    capture.output(print(summary(fit)),
                   file = paste('./output/mult_count_', tar, '.txt', sep = ''))
}

# Do an analysis of the data from a frequency (all or nothing) perspective.
for (tar in targets) {
    target <- df[,tar]
    fit <- glm(I(target > 0) ~ Sex + Genre + Year, family = binomial, data = df)
    capture.output(print(summary(fit)),
                   file = paste('./output/mult_pres_', tar, '.txt', sep = ''))
}
