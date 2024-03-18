# Focus on references


source(file.path(rprojroot::find_rstudio_root_file(),"pathconfig.R"),echo=FALSE)
source(file.path(basepath,"global-libraries.R"),echo=FALSE)
source(file.path(programs,"libraries.R"), echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)



filtered.df <- readRDS(file=  doi.file.Rds)

refs.df <- filtered.df %>%
  select(doi,reference) %>%
  tidyr::unnest(cols = c(reference),names_sep = "_") %>%
  rename(reference_doi = reference_DOI)  %>% 
  # find rct references
  mutate(has_rct_in_refs = if_else(is.na(reference_doi),
                                    FALSE,str_detect(reference_doi,"rct")),
         has_rct_in_citations = if_else(is.na(reference_unstructured),
                                        FALSE,str_detect(reference_unstructured,fixed("rct"))),
         # this is a quirk as of 2024-03-18
         has_rct_broken_ref = if_else(is.na(reference_journal.title),
                                            FALSE,str_detect(reference_journal.title,
                                                             fixed("10.1257/rct.")
                                             )),
         has_ssr_link = if_else(is.na(reference_unstructured),
                                FALSE,str_detect(reference_unstructured,
                                                 fixed("socialscienceregistry.org")
                                )),
         has_rct_ref = has_rct_in_refs | has_rct_in_citations) %>%
  # re-attach journal name and year
  left_join(filtered.df %>% 
              select(doi,container.title,published.print)) %>% 
  mutate(year=substr(published.print,1,4)) %>%
  group_by(container.title)


refs.df %>% saveRDS(file=  refs.file.Rds)
write_csv(refs.df,file=refs.file.csv)
