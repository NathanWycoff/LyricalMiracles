#!/usr/bin/Rscript
#  some_stats.R Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 02.12.2018

require(ggplot2)
require(mds.methods)

## Do some statistics on the data processed by data_processing.R
df <- read.csv('./data/fem_obj_proc.csv')

## Research Q1: Is Objectification more prevalent in Pop or Country?
#Overall Objectification on the continuous scale
png('./images/overall_obj_by_genre.png')
p <- ggplot(df, aes(x = Genre, y = OI)) +
        geom_boxplot() + ggtitle("Overall Objectification by Genre") +
        xlab('Genre') + ylab('Objectification Count')
p
capture.output(t.test(df$sOI[df$Genre=='Pop'], df$sOI[df$Genre=='Country']),
               file = 'overall_t_test.txt')
dev.off()

#for each individual one, continuous scale
for (i in 1:5) {
    to_plot <- df[,c('Genre', paste('F', i, sep = ''))]
    colnames(to_plot) <- c('Genre', 'ObjFreq')
    png(paste('./images/obj_type', i, '_by_genre.png', sep = ''))
    p <- ggplot(to_plot, aes(x = Genre, y = ObjFreq)) +
            geom_boxplot() + ggtitle(paste("Objectification of Type", i, "by Genre")) + 
            xlab('Genre') + ylab('Objectification Count')
    p
    dev.off()
    capture.output(wilcox.test(to_plot$ObjFreq[df$Genre=='Pop'], 
                          to_plot$ObjFreq[df$Genre=='Country']),
                   file = paste("./output/t_test_F", i, ".txt", sep = ""))
}

#Overall Objectification on the discrete scale
png('./images/overall_obj_by_genre_ind.png')
to_plot <- df[,c('Genre', 'sOI')]
to_plot$sOI_Ind <- as.numeric(to_plot$sOI > 0)
p <- ggplot(to_plot, aes(x = Genre, y = sOI_Ind)) +
    geom_bar(stat = 'identity')
p
capture.output(chisq.test(table(to_plot$sOI_Ind, to_plot$Genre)),
               file = paste("./output/chsq_test_overall"))
dev.off()

#for each individual one, discrete scale
for (i in 1:5) {
    to_plot <- df[,c('Genre', paste('F', i, sep = ''))]
    colnames(to_plot) <- c('Genre', 'ObjFreq')
    to_plot$sOI_Ind <- as.numeric(to_plot[,'ObjFreq'] > 0)
    png(paste('./images/obj_type', i, '_by_genre.png', sep = ''))
    p <- ggplot(to_plot, aes(x = Genre, y = sOI_Ind)) +
        geom_bar(stat = 'identity')
    p
    dev.off()
    capture.output(chisq.test(table(to_plot$sOI_Ind, to_plot$Genre)),
                   file = paste("./output/chsq_test_F", i, ".txt", sep = ""))
}

## Make an MDS viz of artists and Studios
#Aggregate position in objectification space
