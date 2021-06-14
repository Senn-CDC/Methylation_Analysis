# Environment Clear
rm(list = ls(all.names = TRUE))
ls(all.names = TRUE)

# Load package
library(tidyverse)
library(ELMER)
library(MultiAssayExperiment)

# Define target_organ
target_organ_1 <- "breast"
target_organ_2 <- "Breast"
cancer_tissuename <- "Breast Invasive Carcinoma"
cancer_tissue_directryname <- gsub(" ", "_", cancer_tissuename)
disease <- "BRCA"
genome <- "hg38"

# Functions
make_folder <- function(folder_name) {
  if (file.exists(folder_name) == FALSE) {
    dir.create(folder_name)
  }
}

# Define parameters
basedir <- "/Volumes/G_DRIVEmobile/Methylation_Analysis/ELMER/Data"
disease <- tolower(disease)
diseasedir <- file.path(basedir, toupper(disease))
setwd(diseasedir)
make_folder("mae")
mae_dir <- file.path(diseasedir, "mae")
dir_meta <- "/Volumes/G_DRIVEmobile/Methylation_Analysis/Data_Sets/Meta_Sample_Data/Breast_ELMER_Cell_TNBC"

# This step is to select HM450K/EPIC probes, which locate far from
# TSS (at least 2Kb away) These probes are called distal probes
distal_probes <- get.feature.probe(feature = NULL, genome = genome, met.platform = "450K")

mae <- createMAE(exp = paste0(diseasedir, "/", "BRCA_RNA_hg38.rda"), met = paste0(diseasedir, 
  "/", "BRCA_meth_hg38.rda"), met.platform = "450K", genome = genome, 
  linearize.exp = TRUE, filter.probes = distal_probes, met.na.cut = 0.2, 
  save = FALSE, TCGA = TRUE)
# Remove FFPE samples from the analysis
mae <- mae[, !mae$is_ffpe]

# Get molecular subytpe information from cell paper and more metadata
# (purity etc...)
setwd(dir_meta)
file <- "cell_2015_metadata.txt"
subtypes <- read.table(file, header = TRUE, sep = "\t", quote = "")
# Revise sample_ID
subtypes$sample <- substr(subtypes$Methylation, 1, 16)
# Merge mae_table and subtype_table
meta_data <- merge(colData(mae), subtypes, by = "sample", all.x = TRUE)
meta_data <- meta_data[match(colData(mae)$sample, meta_data$sample), ]
meta_data <- S4Vectors::DataFrame(meta_data)
rownames(meta_data) <- meta_data$sample
stopifnot(all(meta_data$patient == colData(mae)$patient))
colData(mae) <- meta_data
setwd(mae_dir)
save(mae, file = "cell_2015_mae_BRCA_hg38_450K_no_ffpe.rda")

# Get molecular subytpe information from cell paper and more metadata
# (purity etc...)
setwd(dir_meta)
file <- "cell_2015_ilc_metadata.txt"
subtypes <- read.table(file, header = TRUE, sep = "\t", quote = "")
# Revise sample_ID
subtypes$sample <- substr(subtypes$Methylation, 1, 16)
# Merge mae_table and subtype_table
meta_data <- merge(colData(mae), subtypes, by = "sample", all.x = TRUE)
meta_data <- meta_data[match(colData(mae)$sample, meta_data$sample), ]
meta_data <- S4Vectors::DataFrame(meta_data)
rownames(meta_data) <- meta_data$sample
stopifnot(all(meta_data$patient == colData(mae)$patient))
colData(mae) <- meta_data
setwd(mae_dir)
save(mae, file = "cell_2015_ilc_mae_BRCA_hg38_450K_no_ffpe.rda")

# Get molecular subytpe information from cell paper and more metadata
# (purity etc...)
setwd(dir_meta)
file <- "cell_2015_tnbc_metadata.txt"
subtypes <- read.table(file, header = TRUE, sep = "\t", quote = "")
# Revise sample_ID
subtypes$sample <- substr(subtypes$Methylation, 1, 16)
# Merge mae_table and subtype_table
meta_data <- merge(colData(mae), subtypes, by = "sample", all.x = TRUE)
meta_data <- meta_data[match(colData(mae)$sample, meta_data$sample), ]
meta_data <- S4Vectors::DataFrame(meta_data)
rownames(meta_data) <- meta_data$sample
stopifnot(all(meta_data$patient == colData(mae)$patient))
colData(mae) <- meta_data
setwd(mae_dir)
save(mae, file = "cell_2015_tnbc_mae_BRCA_hg38_450K_no_ffpe.rda")

traceback()

