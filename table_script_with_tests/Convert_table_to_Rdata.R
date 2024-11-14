#####################
## Load R packages ##
#####################
required.libraries <- c("data.table",
                        "optparse",
                        "testthat")
for (lib in required.libraries) {
  if (!require(lib, character.only=TRUE)) {
    install.packages(lib)
    suppressPackageStartupMessages(library(lib, character.only=TRUE))
  }
}

source("functions.R")

## How to run: Rscript Convert_table_to_Rdata.R -t TSS_miRNA_FANTOM5_hg19.bed

####################
## Read arguments ##
####################
option_list = list(
  make_option(c("-t", "--table"), type="character", default=NULL, 
              help="Human genome version", metavar="character"))

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

input.file <- opt$table
message("; Input table: ", input.file)

##########
## Main ##
##########

output.file <- convert_file(input.file)

message("; Conversion ready: ", output.file)
