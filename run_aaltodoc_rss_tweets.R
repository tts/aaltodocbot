###################################################
#
# 30.1.2015 Tuija Sonkkila
# 16.5.2020 twitterR -> rtweet, on token see auth.r
# 11.5.2022 Re-written
#
# Tweets new items in Aalto University 
# document repository, Aaltodoc. 
#
# https://twitter.com/Aaltodoc/
#
###################################################

library(xml2)
library(rvest)
library(dplyr)

source("C:\\Users\\Me\\Documents\\aaltodocbot\\tweet_aaltodoc_rss.R")

# Dissertations
tweetme("https://aaltodoc.aalto.fi/feed/rss_2.0/123456789/5", "diss")

# Licentiate theses
tweetme("https://aaltodoc.aalto.fi/feed/rss_2.0/123456789/4", "lic")

# Compiled works
tweetme("https://aaltodoc.aalto.fi/feed/rss_2.0/123456789/15", "compiledworks")

# Reports
tweetme("https://aaltodoc.aalto.fi/feed/rss_2.0/123456789/6", "reports")

# Working papers
tweetme("https://aaltodoc.aalto.fi/feed/rss_2.0/123456789/9", "workingpapers")

# Final projects
tweetme("https://aaltodoc.aalto.fi/feed/rss_2.0/123456789/1025", "final")

# Articles
tweetme("https://aaltodoc.aalto.fi/feed/rss_2.0/123456789/79", "article")

# Articles from ACRIS
tweetme("https://aaltodoc.aalto.fi/feed/rss_2.0/123456789/21256", "acrisarticle")
