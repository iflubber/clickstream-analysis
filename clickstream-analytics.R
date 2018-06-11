# Read the csv file 
omniture_data <- read.csv("clickstreamdata_analysis.csv",1)

# Basic sanity check if the data loaded is proper
dim(omniture_data)
head(omniture_data)
tail(omniture_data)

# Understanding the structure of the data
str(omniture_data)
summary(omniture_data)

# View the data
View(omniture_data)

# Basic plots to understand the data
plot(omniture_data$country)
plot(omniture_data$url)
plot(omniture_data$ip)
plot(omniture_data$category)
plot(omniture_data$gender)

# extracting the unique values
unique(omniture_data$category)
levels(omniture_data$category)

# Identifying the count & list of unique values for columns
length(unique(omniture_data$category))
length(levels(omniture_data$category))

table(omniture_data$country, omniture_data$category)
# proportion / distribution
prop.table(table(omniture_data$country, omniture_data$category))

# Filtering the data from the dataset
omniture_data[omniture_data$country == "usa",]
omniture_data[which(omniture_data$category == "clothing"),]
omniture_data[which(omniture_data$country == "usa" & omniture_data$state == "CA"),]
omniture_data[which(omniture_data$category == "clothing" | omniture_data$category == "shoes"),c(4:9)]

# Undertanding basic functions in dplyr
library(dplyr)
omniture_data <- tbl_df(omniture_data)
omniture_data
select(omniture_data,country,state,city,category)


by_country <- group_by(omniture_data,country)
hits_by_country<-summarize(by_country, hits = n())
hits_by_country_ordered<-arrange(hits_by_country,desc(hits))
hits_by_country_ordered
barplot(hits_by_country_ordered$hits,names.arg = hits_by_country_ordered$country, xlim = c(0,30))

usa_db <- omniture_data %>%
  filter(omniture_data$country == "usa")
by_city <- group_by(usa_db,city)
hits_by_city<-summarize(by_city, hits = n())
hits_by_city_ordered<-arrange(hits_by_city,desc(hits))
barplot(hits_by_city_ordered$hits,names.arg = hits_by_city_ordered$city, xlim = c(0,10))

by_category <- group_by(omniture_data,category)
hits_by_category<-summarize(by_category, hits = n())
hits_by_category_ordered<-arrange(hits_by_category,desc(hits))
barplot(hits_by_category_ordered$hits,names.arg = hits_by_category_ordered$category, xlim = c(0,10))

male_db = omniture_data %>% 
  select(country, state, city, category, age) %>% 
  filter(omniture_data$gender == "M")
male_by_category <- group_by(male_db,category)
hits_by_category<-summarize(male_by_category, hits = n())
hits_by_category_ordered<-arrange(hits_by_category,desc(hits))
barplot(hits_by_category_ordered$hits,names.arg = hits_by_category_ordered$category, xlim = c(0,10))

female_db = omniture_data %>% 
  select(country, state, city, category, age) %>% 
  filter(omniture_data$gender == "F")
female_by_category <- group_by(female_db,category)
hits_by_category<-summarize(female_by_category, hits = n())
hits_by_category_ordered<-arrange(hits_by_category,desc(hits))
barplot(hits_by_category_ordered$hits,names.arg = hits_by_category_ordered$category, xlim = c(0,10))

male_by_age <- group_by(male_db,age)
hits_by_age<-summarize(male_by_age, hits = n())
hits_by_age_ordered<-arrange(hits_by_age,desc(hits))
barplot(hits_by_age_ordered$hits,names.arg = hits_by_age_ordered$age, xlim = c(0,30))

female_by_age <- group_by(female_db,age)
hits_by_age<-summarize(female_by_age, hits = n())
hits_by_age_ordered<-arrange(hits_by_age,desc(hits))
barplot(hits_by_age_ordered$hits,names.arg = hits_by_age_ordered$age, xlim = c(0,30))

# excel like pivoting in R
library(rpivotTable)
rpivotTable(omniture_data)