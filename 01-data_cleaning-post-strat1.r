#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Rohan Alexander and Sam Caetano [CHANGE THIS TO YOUR NAME!!!!]
# Data: 22 October 2020
# Contact: rohan.alexander@utoronto.ca [PROBABLY CHANGE THIS ALSO!!!!]
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data.
#setwd("C:/Users/Sammi-Jo/Desktop/PS3")
raw_data <- read_dta("usa_00001.dta")


# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
reduced_data <- 
  raw_data %>% 
  select(#region,
         #stateicp,
         sex, 
         age, 
         race)#, 
         #hispan,
         #marst, 
         #bpl,
         #citizen,
         #educd,
         #labforce,
         #labforce)
         


#### What's next? ####

## Here I am only splitting cells by age, but you 
## can use other variables to split by changing
## count(age) to count(age, sex, ....)

reduced_data <- 
  reduced_data %>%
  count(age, sex, race) %>%
  group_by(age, sex, race) 

reduced_data <- 
  reduced_data %>% 
  filter(age != "less than 1 year old") %>%
  filter(age != "90 (90+ in 1980 and 1990)")

reduced_data$age <- as.integer(reduced_data$age)

reduced_data$race<-revalue(reduced_data$race, c("american indian or alaska native"="Some other race"))
reduced_data$race<-revalue(reduced_data$race, c("black/african american/negro"="Black, or African American"))
reduced_data$race<-revalue(reduced_data$race, c("chinese"="Asian/Pacific Islander"))
reduced_data$race<-revalue(reduced_data$race, c("japanese"="Asian/Pacific Islander"))
reduced_data$race<-revalue(reduced_data$race, c("other asian or pacific islander"="Asian/Pacific Islander"))
reduced_data$race<-revalue(reduced_data$race, c("other race, nec"="Some other race"))
reduced_data$race<-revalue(reduced_data$race, c("three or more major races"="Some other race"))
reduced_data$race<-revalue(reduced_data$race, c("two major races"="Some other race"))
reduced_data$race <- revalue(reduced_data$race, c("white" = "AA_White")) 

reduced_data$sex<-revalue(reduced_data$sex, c("male"="Male"))
reduced_data$sex<-revalue(reduced_data$sex, c("female"="Female"))


names(reduced_data)[1]<-"gender"
names(reduced_data)[3]<-"race_ethnicity"

reduced_data <- 
  reduced_data %>%
  filter(age >17) %>%
  group_by(age)%>%
  count()




# Saving the census data as a csv file in my
# working directory
write_csv(reduced_data, "census_data.csv")



         