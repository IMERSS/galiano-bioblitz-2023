library(tidyverse)

# Source dependencies

source("scripts/utils.R")

# Read and summary

originalSummary <- read.csv("tabular_data/Galiano_Tracheophyta_review_summary_reviewed_2024-10-07-assigned_revised.csv")
filteredSummary <- read.csv("tabular_data/Galiano_Island_vascular_plant_records_consolidated-assigned-taxa.csv")

records <- read.csv("tabular_data/Galiano_Island_vascular_plant_records_consolidated-prepared.csv")

summary <- inner_join(x = originalSummary, y = filteredSummary, by = join_by(ID == id))

# Subset historic, confirmed and new records

new <- summary %>% filter(str_detect(Reporting.Status, "new"))
confirmed <- summary %>% filter(Reporting.Status == "confirmed")
reported <- summary %>% filter(Reporting.Status == "reported")
observed <- summary %>% filter(Observation == 'observed') 
