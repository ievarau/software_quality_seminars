#####################
## Load R packages ##
#####################

required.libraries <- c("optparse",
                        "knitr")

for (lib in required.libraries) {
    suppressPackageStartupMessages(library(lib, character.only = TRUE, quietly = T))
}

####################
## Read arguments ##
####################
option_list = list(
    make_option(c("-i", "--input_dir"), type = "character", default = NULL, 
                help = "Input directory. (Mandatory) ", metavar = "character"),  
    
    make_option(c("-o", "--output_dir"), type = "character", default = NULL, 
                help = "Output directory. (Mandatory) ", metavar = "character"),
    make_option(c("-r", "--report_template"), type = "character", default = NULL, 
                help = "Absolute path to the report tamplate. (Mandatory)", metavar = "character")
);
message("; Reading arguments from command line")
opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

########################
## Set variable names ##
########################

INPUT_DIR  <- opt$input_dir
OUTPUT_DIR <- opt$output_dir
report.template.file   <- opt$report_template

###############################
## Creating output directory ##
###############################

message("; Creating output directory.")

dir.create(OUTPUT_DIR, showWarnings = F, recursive = T)

#################################################
## Generate a list of files with their aliases ##
#################################################

message("; Generating a list of input files for the report.")

alias.to.files <- list()

## Adding variables to aliases:
alias.to.files[["--core_motif--"]] <- file.path(INPUT_DIR, "example_data/core_0.txt")
alias.to.files[["--cobinder_motif--"]] <- file.path(INPUT_DIR, "example_data/cobinder_0.txt")

alias.to.files[["--conservation_file--"]] <- file.path(INPUT_DIR, "example_data/CTCF_conservation.tsv")
alias.to.files[["--random_conservation_file--"]] <- file.path(INPUT_DIR, "example_data/CTCF_conservation_random.tsv")

##############################
## Copy the report template ##
##############################

message("; Creating a copy of the template to fill in.")

report.to.fill.file <- file.path(INPUT_DIR, paste0("example_report_from_template_", Sys.Date(), ".tmp.Rmd"))

## Copy template and read copy
file.copy(
    from = report.template.file,
    to   = report.to.fill.file)

report.to.fill <- readLines(report.to.fill.file, warn = FALSE)

#####################
## Fill the report ##
#####################

message("; Filling in the report.")

for (alias.n in names(alias.to.files)) {

    message("; Adding content to the HTML report:\n",
        paste0(alias.to.files[[alias.n]], collapse = ","))

    report.to.fill <- gsub(
        report.to.fill,
        pattern = alias.n,
        replacement = paste0(alias.to.files[[alias.n]], collapse = ","),
        ignore.case = T, perl = T)

}

report.ready.file <- file.path(OUTPUT_DIR, paste0("example_report_from_template_", Sys.Date(), ".Rmd"))
writeLines(report.to.fill, report.ready.file)
file.remove(report.to.fill.file)

##########################
## Generate html report ##
##########################

message("; Knitting the report.")
rmarkdown::render(report.ready.file)

###############################################
## Deleting directories with cache and files ##
###############################################

unlink(file.path(OUTPUT_DIR, paste0("example_report_from_template_", Sys.Date(), "_cache")),
        recursive = TRUE)
unlink(file.path(OUTPUT_DIR, paste0("example_report_from_template_", Sys.Date(), "_files")),
        recursive = TRUE)
