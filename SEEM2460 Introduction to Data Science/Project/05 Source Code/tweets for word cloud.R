## import libraries
library(rtweet)
library(httpuv)

# personal information omitted here
name <- "CCN3163"
key <- "DaHAtekMUj1X1FnRDOL7UYPPT"
secret <- "wDfGKweGG6snP7v6lzYuIKXO3OB3FlJaQSgRGskohHoF3110db"

## create token named "twitter_token"

twitter_token <- create_token(app = name, consumer_key = key, consumer_secret = secret)

## keywords for filtering tweets
q <- "the novel coronavirus, covid 19, coronavirus"

# streaming time in second
streamtime <- 60

# retrieve and save the tweets
filename <- "/Users/jackchan/Downloads/tweets.json"
rt <- stream_tweets(q = q, timeout = streamtime, file_name = filename,token=twitter_token)

# clean up the tweets
clean_tweet = rt$text
clean_tweet = gsub("&amp", "", clean_tweet)
clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet)
clean_tweet = gsub("@\\w+", "", clean_tweet)
clean_tweet = gsub("[[:punct:]]", "", clean_tweet)
clean_tweet = gsub("[[:digit:]]", "", clean_tweet)
clean_tweet = gsub("http\\w+", "", clean_tweet)
clean_tweet = gsub("[ \t]{2,}", "", clean_tweet)
clean_tweet = gsub("^\\s+|\\s+$", "", clean_tweet) 
clean_tweet = gsub("[^[:graph:]]", " ", clean_tweet) 
clean_tweet = trimws(clean_tweet,"both")
clean_tweet = iconv(clean_tweet, "latin1", "ASCII")
clean_tweet = clean_tweet[!is.na(clean_tweet)]
clean_tweet = clean_tweet[clean_tweet!=""]

# save the tweet to a csv file
write.csv(clean_tweet,"/Users/jackchan/Downloads/Tweets.csv",row.names=FALSE)