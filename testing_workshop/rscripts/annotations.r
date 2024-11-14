#####################
## Load R packages ##
#####################

required.libraries <- c(#"ChIPseeker",
                        "data.table",
                        "tidyverse",
                        "optparse",
                        "TxDb.Hsapiens.UCSC.hg38.knownGene")

for (lib in required.libraries) {
  suppressPackageStartupMessages(library(lib, character.only=TRUE, quietly = T))
}

####################
## Read arguments ##
####################

option_list = list(
  
  make_option(c("-p", "--peak_file"), type = "character", default = NULL,
              help = "Path to the file with info on peak files. (Mandatory) ", metavar = "character"),
  
  make_option(c("-o", "--output_folder"), type = "character", default = NULL,
              help = "Output folder. (Mandatory) ", metavar = "character"),
  
  make_option(c("-t", "--analysis_title"), type = "character", default = "peak_annotation",
              help = "Analysis title. (Mandatory) ", metavar = "character")
  
);

message("; Reading arguments from command line.")
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

#############
## Options ##
#############

options(stringsAsFactors = FALSE)

########################
## Set variable names ##
########################

peak.file      <- opt$peak_file
output.folder  <- opt$output_folder
analysis.title <- opt$analysis_title

## Syntax
# Rscript R-scripts/annotate_regions.R \
# -p cutntag_RESULTS_2021_02_26/peak_calling_summary/peak_files_info.tsv
# -o cutntag_RESULTS_2021_02_26/peak_calling_summary/annotation
# -t peak_annotation

## Debug
peak.file         <- "data/peak_files_info.tsv"
output.folder     <- "out/peak_annotation"

#############################
## Create output directory ##
#############################
message("; Creating output directory.")
dir.create(output.folder, showWarnings = F, recursive = T)

txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

##########################
## Getting sample names ##
##########################
message("; Getting samples names.")

sample_peak_info <- fread(peak.file, header = TRUE)

filtered_sample_peak_info <- vector("list", nrow(sample_peak_info))

# for (i in 1:nrow(sample_peak_info)) {
#     entry <- sample_peak_info[i, ]
#     file_name <- entry$peak_file_path
#     n_rows <- length(count.fields(file_name, sep = "\t"))
#     
#     if (n_rows == 1) {
#         
#         peak_df <- fread(file_name, header = FALSE, sep = "\t")
#         
#         if (str_detect(peak_df$V1, "chrUn") == FALSE) {
#            
#             filtered_sample_peak_info[[i]] <- entry  
#         }
#         
#     } else {
#     
#         filtered_sample_peak_info[[i]] <- entry   
#     }
# }

for (i in 1:nrow(sample_peak_info)) {
  entry <- sample_peak_info[i, ]
  file_name <- entry$peak_file_path
  n_rows <- length(count.fields(file_name, sep = "\t"))
  
  if (n_rows != 1) {
    
    filtered_sample_peak_info[[i]] <- entry   
  }
}

filtered_sample_peak_info <- do.call("rbind", filtered_sample_peak_info)

sample_peak_info <- filtered_sample_peak_info %>%
  arrange(peak_type, TF, treatment)

beds  <- sample_peak_info$peak_file_path
# print(beds)
names <- basename(beds)
# print(names)
tfs <- sample_peak_info$full_sample_name
# tfs   <- paste(sample_peak_info$sample, sample_peak_info$peak_type, sep = "_")
# print(tfs)
names(beds) <- tfs

message("; Annotating peaks for full set of peaks.")
# print(beds)
peakAnnoList <- lapply(beds, annotatePeak, TxDb = txdb, tssRegion = c(-3000, 3000),
                       verbose = FALSE)

saveRDS(peakAnnoList, file.path(output.folder, paste0(analysis.title, "_chipseeker.RDS")))

pdf(file.path(output.folder, paste0(analysis.title, "_chipseeker.pdf")))
print(plotAnnoBar(peakAnnoList))
null <- dev.off()

# peakAnnoList <- unlist(peakAnnoList)
# print(peakAnnoList)

####################################
## Annotation for groups of peaks ##
####################################

## Creating output directory:
group.out.dir <- file.path(output.folder, "group_annotation")
dir.create(group.out.dir, showWarnings = F, recursive = T)

## Extracting unique peak types, which will be my groups:
unique_groups <- unique(sample_peak_info$peak_type)

message("; Annotating peaks for each peak type.")
for (type in unique_groups) {
  
  group_peak_info <- sample_peak_info %>%
    filter(peak_type == type) %>%
    arrange(TF, treatment)
  
  # print(group_peak_info)
  
  beds  <- group_peak_info$peak_file_path
  # print(beds)
  names <- basename(beds)
  # print(names)
  tfs <- group_peak_info$full_sample_name
  # tfs   <- paste(group_peak_info$sample, sample_peak_info$peak_type, sep = "_")
  # print(tfs)
  names(beds) <- tfs
  
  message("; Annotating peaks for ", type, ".")
  # print(beds)
  peakAnnoList <- lapply(beds, annotatePeak, TxDb = txdb, tssRegion = c(-3000, 3000),
                         verbose = FALSE)
  
  saveRDS(peakAnnoList, file.path(group.out.dir, paste0(analysis.title, "_", type, "_chipseeker.RDS")))
  
  pdf(file.path(group.out.dir, paste0(analysis.title, "_", type, "_chipseeker.pdf")))
  print(plotAnnoBar(peakAnnoList))
  null <- dev.off()
}

message("; Peaks annotated.")
###################
## End of script ##
###################