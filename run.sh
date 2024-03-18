#!/bin/bash
#
# Bash script to run all the paper analyses
# Alternatively:
# - open the "replication-paper.Rproj" in Rstudio, and "knit" the README.Rmd

cd programs

for arg in $(ls *.R)
do
R CMD BATCH $arg
done
