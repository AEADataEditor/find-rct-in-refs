---
title: "Obtaining lists of articles that cite RCTs"
author: "Lars Vilhuber"
date: "2024-03-18"
output: 
  html_document: 
    keep_md: yes
editor_options: 
  chunk_output_type: console
---



## Overview

## Sources

- CrossRef



## Instructions
This file, when executed, will

- download a list of articles for top journals from CrossRef
- Filter those articles by whether they cite RCTs or not
- Save the output as CSV

The program will check for prior files, and will NOT download new data if those files are present. Thus, to get a fresh run, 

- delete ` /home/rstudio/data/crossref/issns.Rds ` if you want to re-start the whole process (which stores the last query date, and is updated at the end of this process)
- delete ` `doi.file.Rds` ` if you want to update to re-query CrossRef (um, this might not yet work)

## Data locations


Temporary data is in

> /home/rstudio/data/interwrk

and can (should) be deleted after completion.

## In-scope journals

We look at all major econ journals, identified here by ISSN.


```r
source(file.path(programs,"01_create_issn.R"), echo= TRUE)
```

```
## 
## > source(file.path(rprojroot::find_rstudio_root_file(), 
## +     "pathconfig.R"), echo = FALSE)
## 
## > source(file.path(basepath, "global-libraries.R"), 
## +     echo = FALSE)
## 
## > source(file.path(programs, "libraries.R"), echo = FALSE)
```

```
## Skipping install of 'openalexR' from a github remote, the SHA1 (558581c6) has not changed since last install.
##   Use `force = TRUE` to force installation
```

```
## 
## > source(file.path(programs, "config.R"), echo = FALSE)
## 
## > if (!file.exists(issns.file)) {
## +     issns <- read_csv(issns.csv)
## +     tmp.date <- c("2000-01-01")
## +     issns$lastdate <- tmp.date
## +     saveRDS( .... [TRUNCATED]
```

## Getting all articles

Now read DOI for all later dates. This is safe to re-run, it will only get newer records when re-run. A full pull with 24 years of data may take `690.044 sec` (example run).


```r
source(file.path(programs,"02_get_articles_cr.R"), echo= TRUE)
```

```
## 
## > source(file.path(rprojroot::find_rstudio_root_file(), 
## +     "pathconfig.R"), echo = FALSE)
## 
## > source(file.path(basepath, "global-libraries.R"), 
## +     echo = FALSE)
## 
## > source(file.path(programs, "libraries.R"), echo = FALSE)
```

```
## Skipping install of 'openalexR' from a github remote, the SHA1 (558581c6) has not changed since last install.
##   Use `force = TRUE` to force installation
```

```
## 
## > source(file.path(programs, "config.R"), echo = FALSE)
## 
## > if (file.exists(issns.file) & !file.exists(doi.file.Rds)) {
## +     issns <- readRDS(file = issns.file)
## +     new.df <- NA
## +     tic("Pull of records" .... [TRUNCATED] 
## 
## > new.df <- readRDS(file.path(interwrk, "new.Rds"))
```

We read **18301** article records for **16** journals. 

## Filtering out irrelevant articles

We filter out editorials, technical publications (which all have DOIs):


```r
source(file.path(programs,"03_filter_articles.R"),echo=TRUE)
```

```
## 
## > source(file.path(rprojroot::find_rstudio_root_file(), 
## +     "pathconfig.R"), echo = FALSE)
## 
## > source(file.path(basepath, "global-libraries.R"), 
## +     echo = FALSE)
## 
## > source(file.path(programs, "libraries.R"), echo = FALSE)
```

```
## Skipping install of 'openalexR' from a github remote, the SHA1 (558581c6) has not changed since last install.
##   Use `force = TRUE` to force installation
```

```
## 
## > source(file.path(programs, "config.R"), echo = FALSE)
## 
## > new.df <- readRDS(file.path(interwrk, "new.Rds"))
## 
## > filtered.df <- new.df %>% filter(!is.null(author)) %>% 
## +     filter(title != "Front Matter") %>% filter(!str_detect(title, 
## +     "Volume")) %>% fi .... [TRUNCATED] 
## 
## > nrow(filtered.df)
## [1] 17305
## 
## > nrow(filtered.df %>% distinct(doi))
## [1] 17305
## 
## > saveRDS(filtered.df, file = doi.file.Rds)
```


This leaves us with **17305** article records for **16** journals. 

## Assessing the references

Now let's focus on the references that CrossRef provides:


```r
source(file.path(programs,"04_inspect_refs.R"),echo=TRUE)
```

```
## 
## > source(file.path(rprojroot::find_rstudio_root_file(), 
## +     "pathconfig.R"), echo = FALSE)
## 
## > source(file.path(basepath, "global-libraries.R"), 
## +     echo = FALSE)
## 
## > source(file.path(programs, "libraries.R"), echo = FALSE)
```

```
## Skipping install of 'openalexR' from a github remote, the SHA1 (558581c6) has not changed since last install.
##   Use `force = TRUE` to force installation
```

```
## 
## > source(file.path(programs, "config.R"), echo = FALSE)
## 
## > refs.df <- readRDS(file = doi.file.Rds) %>% select(doi, 
## +     reference) %>% tidyr::unnest(cols = c(reference), names_sep = "_") %>% 
## +     rename( .... [TRUNCATED]
```

```
## Joining with `by = join_by(doi)`
```


Of the 532740 references listed, 

- 41 point to RCTs at the AEA Registry in the structured references
- 36 point to RCTs in the unstructured (unparsed) references
- 20 have a weird reference that does not resolve (in the `journal.title` field)

Overall, we find 54 articles that have an actionable link to AEA RCT DOIs. An additional 3 have a URL in the references that points to `sociascienceregistry.org`.



## System info


```r
Sys.info()
```

```
##                                                        sysname 
##                                                        "Linux" 
##                                                        release 
##                                 "5.14.21-150500.55.52-default" 
##                                                        version 
## "#1 SMP PREEMPT_DYNAMIC Tue Mar 5 16:53:41 UTC 2024 (a62851f)" 
##                                                       nodename 
##                                                 "6133ac8b42ae" 
##                                                        machine 
##                                                       "x86_64" 
##                                                          login 
##                                                      "unknown" 
##                                                           user 
##                                                      "rstudio" 
##                                                 effective_user 
##                                                      "rstudio"
```
