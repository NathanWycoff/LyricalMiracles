#!/usr/bin/Rscript
#  data_processing.R Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 02.12.2018

## Process the raw data. This file is intended to be run in the root directory.

df <- read.csv('./data/fem_obj_raw.csv')

# Rename the objectification type columns
colnames(df)[16:ncol(df)] <- 
    c(paste('O', as.character(1:5), sep = ''), paste('F', as.character(1:5), sep = ''))

#The format this was stored in produced a bunch of NA rows; get rid of them
df <- df[complete.cases(df),]

#Confirm that 'O' columns are simply an indicator as to whether the corresponding F column is nonzero
actual_o_cols <- df[,16:20]
implied_o_cols <- as.data.frame(lapply(df[,21:ncol(df)], function(i) as.numeric(i > 0)))
sum(!(actual_o_cols == implied_o_cols))
## Looks good! 

#Collapse the year into one var
df$Year <- as.character((2012:2016)[apply(df[,10:14], 1, which.max)])

#Get rid of some redundant columns
df <- df[,-(10:14)]#Years
df <- df[,-(11:15)]#Indicators

#Create a unified "objectification index"
df$OI <- rowSums(df[,(11:15)])

#Consolidate music genre into 1 column
df$Genre <- c('Pop', 'Country')[apply(df[,c(8,9)], 1, which.max)]
df <- df[,-c(8,9)]

#Sometimes, we might be interested in the square roots of counts.
df$sOI <- sqrt(df$OI)

#Code sex
df$Sex <- c('Female', 'Mixed', 'Male')[((1 - df$Female) + df$Male) + 1]
df$Female <- df$Male <- NULL

#Store the data as a csv
write.csv(df, './data/fem_obj_proc.csv', row.names = FALSE)
