library(available)
library(usethis)
library(roxygen2)
use_github(protocol = "https", auth_token = "626f98f7c5aea3e802dd3f751c92b2c0476a5d61")

use_package_doc()
use_package("quadprog", type="Imports")
use_vignette("quantport_vignette")
use_readme_rmd()

dataset1 <- read.csv("/Users/thanhuwe8/Projects/R project/MVA_BL/dataset1.csv")
dataset1 <- dataset1[,-1]
use_data(dataset1)
