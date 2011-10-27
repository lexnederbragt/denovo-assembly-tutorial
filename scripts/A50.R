#!/usr/bin/env Rscript

# by Nick Loman

args<-commandArgs(TRUE)
print(args)

infile = args[1]
outfile = args[2]
title = args[3]

tbl<-read.table(infile)
labels = unique(tbl$V1)
labels<-as.vector(labels)

largest <- 0
for(label in labels[2:length(labels)]) {
  largest <- max(largest, length(subset(tbl, V1 == label)$V2))
}

doplot <- function() {
        plot(cumsum(subset(tbl, V1 == labels[1])$V2), xlim = c(0, largest), type="l", xlab="Contig Index", lwd=2, lty=1, ylab="Cumulative bases", main=title)
        i <- 2
        for(label in labels[2:length(labels)]) {
                lines(cumsum(subset(tbl, V1 == label)$V2), col = i, lwd=2, lty=i)
                i <- i + 1
        }
        legend("bottomright", labels, col = c(1: length(labels)), lty = c(1 : length(labels)))
}

pdf(paste(outfile, "pdf", sep="."))
doplot()
dev.off()

png(paste(outfile, "png", sep="."), type="cairo")
doplot()
dev.off()

