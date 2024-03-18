# Flatten data and filter articles


source(file.path(rprojroot::find_rstudio_root_file(),"pathconfig.R"),echo=FALSE)
source(file.path(basepath,"global-libraries.R"),echo=FALSE)
source(file.path(programs,"libraries.R"), echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)





# filters
new.df <- readRDS(file.path(interwrk,"new.Rds")) 
new.df %>%
  filter(!is.null(author)) %>%
  filter(title!="Front Matter") %>%
  filter(!str_detect(title,"Volume")) %>%
  filter(!str_detect(title,"Forthcoming")) %>%
  # filter(title!="Editor's Note") %>%
  # More robust
  filter(str_sub(doi, start= -1)!="i")-> filtered.df
nrow(filtered.df)
nrow(filtered.df %>% distinct(doi))
saveRDS(filtered.df, file=  doi.file.Rds)

