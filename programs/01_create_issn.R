# Standard header
source(file.path(rprojroot::find_rstudio_root_file(),"pathconfig.R"),echo=FALSE)
source(file.path(basepath,"global-libraries.R"),echo=FALSE)
source(file.path(programs,"libraries.R"), echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)


# Each journal has a ISSN
if (!file.exists(issns.file)) {
issns <- data.frame(matrix(ncol=2,nrow=13))
names(issns) <- c("journal","issn")
tmp.date <- c("2000-01-01")
issns[1,] <- c("American Economic Journal: Applied Economics","1945-7790")
issns[2,] <- c("American Economic Journal: Economic Policy","1945-774X")
issns[3,] <- c("American Economic Journal: Macroeconomics", "1945-7715")
issns[4,] <- c("American Economic Journal: Microeconomics", "1945-7685")
issns[5,] <- c("The American Economic Review","1944-7981")
issns[6,] <- c("The American Economic Review","0002-8282")  # print ISSN is needed!
issns[7,] <- c("Journal of Economic Literature","2328-8175")
issns[8,] <- c("Journal of Economic Perspectives","1944-7965")
issns[9,] <- c("American Economic Review: Insights","2640-2068")
issns[10,] <- c("The Quarterly Journal of Economics","0033-5533") # use the print ISSN (OUP). Online ISSN: 1531-4650
issns[11,] <- c("The Review of Economic Studies","0034-6527") # use the print ISSN (OUP). Online ISSN: 1467-937X
issns[12,] <- c("Journal of Political Economy","0022-3808") # online: E-ISSN: 1537-534X
issns[13,] <- c("The Economic Journal Oxford","0013-0133") # Online ISSN 1468-0297 


issns$lastdate <- tmp.date
saveRDS(issns, file= issns.file)
}