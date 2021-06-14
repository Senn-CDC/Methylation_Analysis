# Environment Clear
rm(list = ls(all.names = TRUE))
ls(all.names = TRUE)

setwd("/Volumes/G_DRIVEmobile/After_JC_Marcos/Breast/Data_Sets")
file_exists <- file.exists("Cell_2015")
if (file_exists == FALSE) {
  dir.create("Cell_2015")
}
setwd("Cell_2015")

# Download files
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc1.pdf"
download.file(curl, "s2_document.pdf")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc2.xlsx"
download.file(curl, "s1_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc3.xlsx"
download.file(curl, "s2_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc4.xlsx"
download.file(curl, "s3_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc5.xlsx"
download.file(curl, "s4_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc6.xlsx"
download.file(curl, "s5_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc7.xlsx"
download.file(curl, "s6_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc8.xlsx"
download.file(curl, "s7_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc9.xlsx"
download.file(curl, "s8_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc10.xlsx"
download.file(curl, "s9_table.xlsx")
curl <- "https://ars.els-cdn.com/content/image/1-s2.0-S0092867415011952-mmc11.pdf"
download.file(curl, "Comprehensive Molecular Portraits of Invasive Lobular Breast Cancer.pdf")

traceback()

