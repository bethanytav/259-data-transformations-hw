#PSYC 259 Homework 2 - Data Transformation
#For full credit, provide answers for at least 7/10

#List names of students collaborating with: none

### SETUP: RUN THIS BEFORE STARTING ----------

#Load packages
library(tidyverse)
#ds <- read_csv("data_raw/rolling_stone_500.csv")
df <- read_csv("data_raw/rolling_stone_500.csv")
 
### Question 1 ---------- 
#Use glimpse to check the type of "Year". 
#Then, convert it to a numeric, saving it back to 'ds'
#Use typeof to check that your conversion succeeded
#ANSWER
glimpse(df$Year)
df$Year <- as.numeric(df$Year)
typeof(df$Year)


### Question 2 ---------- 
# Using a dplyr function,
# change ds so that all of the variables are lowercase
#ANSWER
df <- rename_with(df,tolower)


### Question 3 ----------
# Use mutate to create a new variable in ds that has the decade of the year as a number
# For example, 1971 would become 1970, 2001 would become 2000
# Hint: read the documentation for ?floor
#ANSWER
df <- df %>%
  mutate(decade = (floor(year/10)*10))


### Question 4 ----------
# Sort the dataset by rank so that 1 is at the top
#ANSWER
df <- df %>%
  arrange(rank)


### Question 5 ----------
# Use filter and select to create a new tibble called 'top10'
# That just has the artists and songs for the top 10 songs
#ANSWER
top_10 <- df %>%
  filter(rank<11) %>%
  select(artist,song)


### Question 6 ----------
# Use summarize to find the earliest, most recent, and average release year
# of all songs on the full list. Save it to a new tibble called "ds_sum"
#ANSWER
ds_sum <- df %>%
  summarize(earliest = min(year,na.rm=TRUE),
            most_recent = max(year,na.rm=TRUE),
            average = round(mean(year,na.rm=TRUE),0)
  )


### Question 7 ----------
# Use filter to find out the artists/song titles for the earliest, most 
# recent, and average-ist years in the data set (the values obtained in Q6). 
# Use one filter command only, and sort the responses by year
#ANSWER
df2 <- df %>%
  filter(year %in% c(ds_sum$earliest,ds_sum$most_recent,ds_sum$average)) %>%
  select(year,artist,song) %>%
  arrange(year)


### Question 8 ---------- 
# There's and error here. The oldest song "Brass in Pocket"
# is from 1979! Use mutate and ifelse to fix the error, 
# recalculate decade, and then
# recalculate the responses from Questions 6-7 to
# find the correct oldest, averag-ist, and most recent songs
#ANSWER
df_fixed <- df %>%
  mutate(
    year = ifelse(year==1879, 1979,year), #fixing year error
    decade = (floor(year/10)*10)) #recalculate decade

ds_sum_fixed <- df_fixed %>%
  summarize(earliest = min(year,na.rm=TRUE), #year summaries
            most_recent = max(year,na.rm=TRUE),
            average = round(mean(year,na.rm=TRUE),0))

df_fixed2 <- df_fixed %>%
  filter(year %in% c(ds_sum_fixed$earliest,ds_sum_fixed$most_recent,ds_sum_fixed$average)) %>%
  select(year,artist,song) %>%
  arrange(year)
  

### Question 9 ---------
# Use group_by and summarize to find the average rank and 
# number of songs on the list by decade. To make things easier
# filter out the NA values from decade before summarizing
# You don't need to save the results anywhere
# Use the pipe %>% to string the commands together
#ANSWER
df_fixed %>%
  filter(!is.na(decade)) %>%
  group_by(decade) %>%
  summarize(rank_avg = round(mean(rank),0),
            song_n = n())


### Question 10 --------
# Look up the dplyr "count" function
# Use it to count up the number of songs by decade
# Then use slice_max() to pull the row with the most songs
# Use the pipe %>% to string the commands together
#ANSWER
df_fixed %>%
  count(decade) %>%
  slice_max(n)

  