options("scipen"=999)

#If packages below are not installed, just uncomment this command and run once
#install.packages(c("devtools", "data.table", "dplyr", "ggplot2", "hunspell"))
library(devtools)
library(data.table)
library(dplyr)
library(ggplot2)
library(hunspell)

setwd("~")

#Load the files
TrumpTweets<-read.csv("realDonaldTrump_tweets.csv", sep="|")

#Create summary - Just ID and Timestamp for each tweet
TT_Summary<-unique(subset(TrumpTweets, select = c(id, timestamp)))

#Calculate number of words in each tweet
TT_Wordcount<-data.frame(count(TrumpTweets, id))

#Combine above data to give ID, Timestamp and Word count
TT_Summary<-merge(TT_Summary, TT_Wordcount)

#Create dataset with just ID and word
TT_Words<-subset(TrumpTweets, select = c(id, words))

#Convert words to character type
TT_Words$words<-as.character(TT_Words$words)

#Test whether each word is contained in hunspell dictionary 
correct<-hunspell_check(TT_Words$words, dict=dictionary("en_US"))
#Join the reslt with the original word
TT_Result<-cbind(TT_Words, correct)
#Create a summary with number of correct words in each tweet
TT_Result_Summary<-aggregate(correct~id, TT_Result, sum)
#Merge summary from above to give ID, Timestamp, Word count and Correct word count
TT_Final<-merge(TT_Summary, TT_Result_Summary)

#Calculate mean proportion of correctly spelled words per tweet
mean(TT_Final$correct/TT_Final$n)

#Look at individual results
subset(TT_Final)
subset(TT_Result)
subset(TrumpTweets)
