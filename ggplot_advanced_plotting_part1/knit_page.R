#####################
## Load R packages ##
#####################

required.libraries <- c("knitr",
                        "optparse")

for (lib in required.libraries) {
  suppressPackageStartupMessages(library(lib, character.only = TRUE, quietly = T))
}

####################
## Read arguments ##
####################
option_list = list(
  
  make_option(c("-i", "--input_rmd"), type = "character", default = NULL, 
              help = "Input .Rmd file that needs to be knitted. (Mandatory) ", metavar = "character")
  
);
message("; Reading arguments from command line")
opt_parser = OptionParser(option_list = option_list);
opt        = parse_args(opt_parser);

########################
## Set variable names ##
########################

input.rmd <- opt$input_rmd

#######################
## Knitting the page ##
#######################

message("; Knitting: ", input.rmd)
rmarkdown::render(input.rmd)

# knitr::render_jekyll(input.rmd)

###################
## End of script ##
###################