#!/usr/bin/Rscript
#  outliers.R Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 03.30.2018

## There is an outlier in F2, let's see if it influences any results

df <- read.csv('./data/fem_obj_proc.csv')
df$Year <- as.factor(df$Year)

#Fit with outlier
target <- df[,'F2']
fit_yes <- glm(target ~ Sex + Genre + Year, quasipoisson, data = df)

#Fit without outlier
df <- df[-which.max(df$F2),]
target <- df[,'F2']
fit_no <- glm(target ~ Sex + Genre + Year, quasipoisson, data = df)

capture.output(summary(fit_no), 
               file = './output/mult_count_F2_no_outlier.txt')
