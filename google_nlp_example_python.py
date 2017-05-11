#Install the necessary packages: google-cloud, pandas

####################
#pip install --upgrade google-cloud --ignore-installed
#pip install pandas
#If service account auth does not work, do the below:
#Install the Cloud SDK: https://cloud.google.com/sdk/docs/#deb
#Run this command once installed: gcloud auth application-default login
####################

#Go here to learn how to create Google service account credentials: https://cloud.google.com/natural-language/docs/common/auth

#Import the necessary packages:
from google.cloud import language
import pandas as pd
import os

#Set your Google service account JSON
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = 'google_service_account.json'

#Authorize with your Google service account JSON
language_client = language.Client()

#Import your text data to pandas dataframe for sentiment analysis
csv_data = pd.read_csv('benelux_reviews.csv')

#Create an empty list
output = []

#Simple loop that iterates over dataframe review data and stores in nested list
for i in range(0,len(csv_data.index)): #loops through dataframe total rows
    review_id = csv_data.loc[csv_data.index[i], 'review_id'] 
    review = csv_data.loc[csv_data.index[i], 'review'] #extracts the iterated review
    document = language_client.document_from_text(review) #set as google doc that represents text
    sentiment = document.analyze_sentiment().sentiment #send to google nlp api for analysis
    result = {"id": review_id, "review": review, "sentiment_score": sentiment.score, "sentiment_magnitude": sentiment.magnitude} #store data into dictionary
    output.append(result.copy()) #appends dictionary to list
    print(result)

df = pd.DataFrame(output) #save nested list to pandas data frame
