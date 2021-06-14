# Environment Clear
rm(list = ls(all.names = TRUE))
ls(all.names = TRUE)

# Load package
library(MethylMix)
library(doParallel)

# Define target_organ
target_organ_1 <- "breast"
target_organ_2 <- "Breast"
cancer_tissuename <- "Breast Invasive Carcinoma"
cancer_tissue_directryname <- gsub(" ", "_", cancer_tissuename)
cancerSite <- "BRCA"

# Change setting of timeout
options(timeout = 86400)

# Functions
make_folder <- function(folder_name) {
  if (file.exists(folder_name) == FALSE) {
    dir.create(folder_name)
  }
}

# Define target_organ
setwd("/Volumes/G_DRIVEmobile/Methylation_Analysis")
make_folder("MethylMix")
setwd("MethylMix")
make_folder(target_organ_2)
setwd(target_organ_2)
targetDirectory <- paste0("/Volumes/G_DRIVEmobile/Methylation_Analysis/MethylMix", 
  target_organ_2, "/")

# Execute parallel processing
cores <- getOption("mc.cores", detectCores())
cl <- makeCluster(cores, type = "FORK")
registerDoParallel(cl)

# methylation
# -------------------------------------------------------------------------
# Downloading methylation data
METdirectories <- Download_DNAmethylation(cancerSite, targetDirectory)
# Execute garbage collection
invisible(replicate(20, gc()))

# Processing methylation data
METProcessedData <- Preprocess_DNAmethylation(cancerSite, METdirectories)
# Execute garbage collection
invisible(replicate(20, gc()))

# Saving methylation processed data
saveRDS(METProcessedData, file = paste0(targetDirectory, "MET_", cancerSite, 
  "_Processed.rds"))
# Execute garbage collection
invisible(replicate(20, gc()))

# gene expression
# -------------------------------------------------------------------------
# Downloading gene expression data
GEdirectories <- Download_GeneExpression(cancerSite, targetDirectory)
# Execute garbage collection
invisible(replicate(20, gc()))

# Processing gene expression data
GEProcessedData <- Preprocess_GeneExpression(cancerSite, GEdirectories)
# Execute garbage collection
invisible(replicate(20, gc()))

# Saving gene expression processed data
saveRDS(GEProcessedData, file = paste0(targetDirectory, "GE_", cancerSite, 
  "_Processed.rds"))
# Execute garbage collection
invisible(replicate(20, gc()))

# Clustering probes to genes methylation data
# -------------------------------------------------------------------------
METProcessedData <- readRDS(paste0(targetDirectory, "MET_", cancerSite, 
  "_Processed.rds"))
res <- ClusterProbes(METProcessedData[[1]], METProcessedData[[2]])
# Execute garbage collection
invisible(replicate(20, gc()))

# Putting everything together in one file
# -------------------------------------------------------------------------
toSave <- list(METcancer = res[[1]], METnormal = res[[2]], GEcancer = GEProcessedData[[1]], 
  GEnormal = GEProcessedData[[2]], ProbeMapping = res$ProbeMapping)
saveRDS(toSave, file = paste0(targetDirectory, "data_", cancerSite, ".rds"))
stopCluster(cl)

traceback()

