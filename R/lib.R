#!/usr/bin/Rscript
#  lib.R Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 03.05.2018

#' Run a given test on all types of objectivity, as well as overall objectivity
#' @param name A string describing this kind of test, used to name the files so no funny business (e.g. '/').
#' @param test A function which conducts a hypothesis test and returns something to be printed. Accepts a vector input, the target to conduct the hypothesis test on.
#' @param toplot A function which produces a plot to save, accepts a vector target to plot, and a character description of target.
#' @return Nothing; used for its side effects of creating files containing test results and plots.
run_test <- function(name, test, toplot) {
    #Plot the overall image
    png(paste('./images/overall_', name, '.png', sep = ''))
    toplot(target = df$OI, desc = "Overall Objectification")
    dev.off()

    #Do the overall test
    capture.output(print(test(df$OI)), 
                   file = paste('./output/overall_', name, '.txt', sep = ''))

    #for each individual one
    for (i in 1:5) {
        #Get the appropriate column
        target <- df[, paste('F', i, sep = '')]

        #Make a plot
        png(paste('./images/F', i, '_', name, '.png', sep = ''))
        toplot(target = target, desc = paste("Type", i, "Objectification"))
        dev.off()

        #Do a test
        capture.output(print(test(target)),
                   file = paste("./output/F", i, "_", name, ".txt", sep = ""))
    }
}
