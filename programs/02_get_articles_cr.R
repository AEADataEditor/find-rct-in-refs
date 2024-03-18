# Getting in-scope articles
# Code derived from another project
# NOTE: THIS REQUIRES R 4.2.0 and newer packages!
#

source(file.path(rprojroot::find_rstudio_root_file(),"pathconfig.R"),echo=FALSE)
source(file.path(basepath,"global-libraries.R"),echo=FALSE)
source(file.path(programs,"libraries.R"), echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)


if (file.exists(issns.file) & !file.exists(doi.file.Rds) ) {
  issns <- readRDS(file = issns.file)
  new.df <- NA
  tic("Pull of records")
  for ( x in 1:nrow(issns) ) {
    message(paste0("Processing ",issns[x,"journal"]," (",issns[x,"issn"],")"))
    tic(paste0("Pull for ",issns[x,"journal"]," (",issns[x,"issn"],")"))
    new <- cr_journals(issn=issns[x,"issn"], works=TRUE,
                       filter=c(from_pub_date=as.character(issns[x,"lastdate"])),
                       select=c("DOI","title","published-print","volume","issue","container-title","author","reference"),
                       .progress="text",
                       cursor = "*")
    toc()
    if ( x == 1 ) {
      new.df <- as.data.frame(new$data)
      new.df$issn = as.character(issns[x,"issn"])
      # update date on ISSN file
      issns[x,"lastdate"] <- format(Sys.Date(),"%Y-%d-%m")
    } else {
      tmp.df <- as.data.frame(new$data)
      if ( nrow(tmp.df) > 0 ) {
        tmp.df$issn = as.character(issns[x,"issn"])
        new.df <- bind_rows(new.df,tmp.df)
        issns[x,"lastdate"] <- format(Sys.Date(),"%Y-%d-%m")
      } else {
        warning(paste0("Did not find records for ISSN=",issns[x,"issn"]))
      }
      rm(tmp.df)
    }
  }
  toc()
  # filters
  saveRDS(new.df, file=  file.path(interwrk,"new.Rds"))
  rm(new)
  # also update the ISSN file
  issns %>% saveRDS(file = issns.file)
  print(issns)
}
# read back
new.df <- readRDS(file.path(interwrk,"new.Rds")) 






