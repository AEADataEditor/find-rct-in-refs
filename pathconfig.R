# ###########################
# CONFIG: define paths and filenames for later reference
# ###########################

# Change the basepath depending on your system

basepath <- rprojroot::find_rstudio_root_file()

# Main directories
dataloc     <- file.path(basepath, "data")
interwrk    <- file.path(basepath, "data","interwrk")
crossrefloc <- file.path(basepath,"data","crossref")
openalexloc <- file.path(basepath,"data","openalex")
auxilloc    <- file.path(basepath,"data","auxiliary")
datagen     <- file.path(basepath,"data","generated")


programs <- file.path(basepath,"programs")

for ( dir in list(dataloc,interwrk,crossrefloc,openalexloc,datagen)){
	if (file.exists(dir)){
	} else {
	dir.create(file.path(dir))
	}
}

