## clean data for analysis portion of master_script from hw2
#necessary packages
library(haven)
library(stargazer)

#pull in data 
location <- "C:/Users/smcnair1/Desktop/MWF_HW2/data/ZA7500_v5-0-0.sav/ZA7500_v5-0-0.sav"
dataset <- read_sav(location)

#examine data 
names(dataset)

#remove _DE columns
dataset <- dataset[, !grepl('_DE', names(dataset))]

#remove incomplete questionnaires
dataset <- dataset[dataset$fmissings != 1, ]

#keep only the columns of interest
dataset <- dataset[, c("age", "v243_r", "v225", "c_abrv", "v72", "v80")]

#remove entries where education level question was refused and remove rows with NAs
dataset <- dataset[dataset$v243_r != 66, ]
dataset <- na.omit(dataset)

#rename columns, keep attributes

colnames(dataset) <- c("age", "education", "sex", "country", "child_suffers_mom", "job_scarcity")

#output data to rdata
saveRDS(dataset, "C:/Users/smcnair1/Desktop/MWF_FINAL/dynamic_analysis/data/dataset.rds")
