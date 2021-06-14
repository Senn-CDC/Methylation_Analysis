# Environment Clear
rm(list = ls(all.names = TRUE))
ls(all.names = TRUE)

# Load package
library(TCGAbiolinks)
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

# Change setting of timeout
options(timeout = 86400)

# Define parameters
basedir <- "/Volumes/G_DRIVEmobile/Methylation_Analysis/ELMER/Data"
disease <- tolower(disease)
diseasedir <- file.path(basedir, toupper(disease))
dir_raw <- file.path(diseasedir, "Raw")
dir_meth <- file.path(dir_raw, "Meth")
dir_rna <- file.path(dir_raw, "RNA")
dir_clinic <- file.path(dir_raw, "Clinic")

# Define saving directory
setwd("/Volumes/G_DRIVEmobile/Methylation_Analysis/ELMER/Data")
make_folder(toupper(disease))

# Move gdc-client binary file
if (file.exists("gdc-client") == FALSE) {
  file.copy(from = "/Volumes/G_DRIVEmobile/Methylation_Analysis/gdc-client/gdc-client", 
    to = "gdc-client")
}

# Download clinical information
# -------------------------------------------------------------------------
# Define saving name
save_clinic_rda <- paste0(diseasedir, "/", toupper(disease), "_clinic.rda")
clinic <- GDCquery_clinic(project = paste0("TCGA-", toupper(disease)))

# Save file
save(clinic, file = save_clinic_rda)

# Download HM40K DNA methylation data for certain cancer types from TCGA website
# -------------------------------------------------------------------------
# Define saving name
save_meth_no_filter_rda <- paste0(diseasedir, "/", toupper(disease), "_meth_", 
  genome, "_no_filter.rda")
save_meth_filter_rda <- paste0(diseasedir, "/", toupper(disease), "_meth_", 
  genome, ".rda")

# Make query
query_meth <- GDCquery(project = paste0("TCGA-", toupper(disease)), data.category = "DNA Methylation", 
  platform = "Illumina Human Methylation 450")

# Downloaded file
GDCdownload(query_meth, directory = dir_meth, method = "client")

# Preparing to save output
met <- GDCprepare(query = query_meth, directory = dir_meth, save = TRUE, 
  save.filename = save_meth_no_filter_rda, remove.files.prepared = TRUE, 
  summarizedExperiment = TRUE)

# Remove probes that has more than 20% of its values as NA
met <- met[rowMeans(is.na(assay(met))) < 0.2, ]

# Save file
save(met, file = save_meth_filter_rda)

# Move gdc_manifest.txt
file.copy(from = paste0("/Volumes/G_DRIVEmobile/Methylation_Analysis/ELMER/Data", 
  "/", "gdc_manifest.txt"), to = paste0(diseasedir, "/", "gdc_manifest_meth.txt"))
file.remove(paste0("/Volumes/G_DRIVEmobile/Methylation_Analysis/ELMER/Data", 
  "/", "gdc_manifest.txt"))

# Download all RNAseq data for a certain cancer type from TCGA
# -------------------------------------------------------------------------
# Define saving name
save_rna_rda <- paste0(diseasedir, "/", toupper(disease), "_RNA_", genome, 
  ".rda")

# Make query
query_rna <- GDCquery(project = paste0("TCGA-", toupper(disease)), data.category = "Transcriptome Profiling", 
  data.type = "Gene Expression Quantification", workflow.type = "HTSeq - FPKM-UQ")

# Downloaded file
GDCdownload(query_rna, directory = dir_rna, method = "client")

# Preparing to save output
rna <- GDCprepare(query = query_rna, directory = dir_rna, save = TRUE, 
  save.filename = save_rna_rda, remove.files.prepared = TRUE, summarizedExperiment = TRUE)

# Save file
save(rna, file = save_rna_rda)

# Move gdc_manifest.txt
file.copy(from = paste0("/Volumes/G_DRIVEmobile/Methylation_Analysis/ELMER/Data", 
  "/", "gdc_manifest.txt"), to = paste0(diseasedir, "/", "gdc_manifest_rna.txt"))
file.remove(paste0("/Volumes/G_DRIVEmobile/Methylation_Analysis/ELMER/Data", 
  "/", "gdc_manifest.txt"))

traceback()

