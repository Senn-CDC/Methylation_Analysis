# Environment Clear
rm(list = ls(all.names = TRUE))
ls(all.names = TRUE)

# Load package
library(tidyverse)
library(magrittr)
library(openxlsx)

# Define target_organ
target_organ_1 <- "breast"
target_organ_2 <- "Breast"
cancer_tissuename <- "Breast Invasive Carcinoma"
cancer_tissue_directryname <- gsub(" ", "_", cancer_tissuename)

# Functions
make_folder <- function(folder_name) {
  if (file.exists(folder_name) == FALSE) {
    dir.create(folder_name)
  }
}

# Load data
setwd("/Volumes/G_DRIVEmobile/After_JC_Marcos/Breast/Data_Sets/Cell_2015")
df_cell <- read.xlsx("s1_table.xlsx", sheet = "Suppl. Table 1", startRow = 3)
df_cell_ilcsubtype <- read.xlsx("s8_table.xlsx", sheet = "Suppl. Table 8", 
  startRow = 4) %>%
  select(., c(2:4)) %>%
  mutate(., Sample.ID = gsub("\\.", "-", .$Sample.ID)) %>%
  filter(., Dataset == "TCGA")
setwd("/Volumes/G_DRIVEmobile/After_JC_Marcos/Breast/Data_Sets/TNBC_PLOS_ONE")
df_tnbcsubtype <- read.xlsx("S3_table.xlsx", sheet = "TCGA", startRow = 2)

# Identify duplicate Case.ID of df_cell
if (nrow(df_cell[duplicated(df_cell$Case.ID), ]) != 0) {
  quit(save = "ask")
}

# Join df_cell and subtype
df_cell_ilcsubtype %<>%
  inner_join(df_cell, ., by = c(Case.ID = "Sample.ID"))
df_cell_tnbcsubtype <- rename(df_tnbcsubtype, HER2_PATH_CALL2 = 45) %>%
  inner_join(df_cell, ., by = c(Case.ID = "BARCODE"))

# Define saving directory
setwd("/Volumes/G_DRIVEmobile/After_JC_Marcos/Breast/Data_Sets/Meta_Sample_Data")
make_folder("Breast_ELMER_Cell_TNBC")
setwd("Breast_ELMER_Cell_TNBC")

# Save tabels
write.table(df_cell, "cell_2015_metadata.txt", sep = "\t", append = FALSE, 
  quote = FALSE, row.names = FALSE)
write.table(df_cell_ilcsubtype, "cell_2015_ilc_metadata.txt", sep = "\t", 
  append = FALSE, quote = FALSE, row.names = FALSE)
write.table(df_cell_tnbcsubtype, "cell_2015_tnbc_metadata.txt", sep = "\t", 
  append = FALSE, quote = FALSE, row.names = FALSE)

traceback()

