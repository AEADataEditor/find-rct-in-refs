# Standard header
source(file.path(rprojroot::find_rstudio_root_file(),"pathconfig.R"),echo=FALSE)
source(file.path(basepath,"global-libraries.R"),echo=FALSE)
source(file.path(programs,"libraries.R"), echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)


# Each journal has a ISSN
if (!file.exists(issns.file)) {
# read mapping of names and ISSN
  issns <- read_csv(issns.csv)
  # initialize date
  tmp.date <- c("2000-01-01")
  issns$lastdate <- tmp.date
saveRDS(issns, file= issns.file)
}