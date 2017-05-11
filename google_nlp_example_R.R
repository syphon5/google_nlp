#Install devtools, load devtools, install googleLanguageR, install dplyr - once

######################################
#install.packages("devtools")
#library(devtools)
#devtools::install_github("MarkEdmondson1234/googleLanguageR")
#install.packages("dplyr")
#####################################

#Load the necessary libraries (googleLanguageR for the Google NLP, dplyr for binding)
library(googleLanguageR)
library(dplyr)

#Import your Google service account credentials and authorize
gl_auth("google_auth_file.json")

#Import your CSV data
csv_data = read.csv("benelux_reviews.csv")

#Ensure the text for sentiment analysis is character format
csv_data$review = as.character(csv_data$review)

#Set an empty data frame
df = data.frame()

#Count number of review text for the loop
review_count = nrow(csv_data)

#Simple loop that queries the Google NLP API and binds the data to the empty data frame
for (i in 1:review_count) {
  
  count = i %>% data.frame() #Add the count into dataframe
  colnames(count) = "count" #Assign the column header
  id = csv_data$review_id[i] %>% data.frame()
  colnames(id) = "id"
  review = csv_data$review[i] %>% data.frame()
  colnames(review) = "review"
  nlp_results = gl_nlp(csv_data$review[i]) #Query each text content
  sentiment_score = nlp_results$documentSentiment$score %>% data.frame()
  colnames(sentiment_score) = "sentiment_score"
  sentiment_magnitude = nlp_results$documentSentiment$magnitude %>% data.frame()
  colnames(sentiment_magnitude) = "sentiment_magnitude"
  col_df = bind_cols(count, id, review, sentiment_score, sentiment_magnitude) #Bind the data variables together into dataframe
  df = bind_rows(df, col_df) #Bind this iteration dataframe to main dataframe
  
}
