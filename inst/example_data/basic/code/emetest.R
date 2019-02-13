# install the package
# only run once
# devtools::install_github("Exp-Micro-Ecol-Hub/emeScheme", ref = "v0.8", build_opts = c("--no-resave-data"))

# load the library
library(emeScheme)

# open the user manual
vignette("user_manual", "emeScheme")
#browseVignettes("emeScheme")

# open a clean metadata spreadsheet in xl
# only run once
#enter_new_metadata()

# open a metadata spreadsheet in xl, containing the basic example entries
# only run once
#enter_new_metadata(keepData = TRUE)

# create a folder in the working directory with the basic example project
# only run once
#make_example("basic")

# validate the basic example
validate("emeScheme.xlsx", path="data/archiving_data", report = "html")
