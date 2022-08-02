tweetme <- function(rss, type) {
  
  feed <- tidyRSS::tidyfeed(rss) %>% 
    select(item_title, item_link)
  
  parse_item <- function(x) {
    html <- read_html(x)
    
    au <- html %>% 
      html_nodes(xpath = "//meta[@name='DC.creator'][1]") %>% 
      html_attr('content')
    
    au_nr <- html %>% 
      html_nodes(xpath = "//meta[@name='DC.creator']")
    
    title <- html %>% 
      html_node(xpath = "//meta[@name='DC.title']") %>%
      html_attr('content')
    
    link <- html %>%
      html_node(xpath = "//meta[@name='DC.identifier' and @scheme='DCTERMS.URI']") %>%
      html_attr('content')
    
    return(list(au = au, au_nr = length(au_nr), title = title, link = link))
  }
  
  feed_items <- feed$item_link %>% 
    purrr::map_df(~ parse_item(.))
  
  if (file.exists(paste0("C:\\Users\\Me\\Documents\\aaltodocbot\\", type, "tweets.csv"))) {
    tweeted <- read.table(paste0("C:\\Users\\Me\\Documents\\aaltodocbot\\", type, "tweets.csv"), stringsAsFactors = FALSE)
    names(tweeted) <- c("text")
  }
  
  # From now on, while determining whether the tweet is already sent, 
  # I should probably replace string matching with aaltodoc ID (link) matching.
  
  tweeted <- tweeted %>% 
    mutate(link = stringi::stri_extract_first_regex(str = text, pattern = "https?.*"))
  
  items_to_tweet <- feed_items %>% 
    mutate(title_length = nchar(title),
           link_length = nchar(link),
           surname_au = stringi::stri_extract_first_regex(str = au, pattern = "^[^,]+"), 
           tweet_au = ifelse(au_nr > 1, paste0(surname_au, " et al.: "), paste0(surname_au, ": ")),
           tweet_au_length = nchar(tweet_au),
           tweet_chars_left_for_title = as.integer(280 - (tweet_au_length + link_length + 1)), # 1 = space btw title and link
           # If the title is too long to fit, remove the last 4 chars, and replace with an ellipsis ("... ")
           need_ellipsis = ifelse(title_length >= tweet_chars_left_for_title, TRUE, FALSE),
           tweet_title = ifelse(need_ellipsis,
                                paste0(stringi::stri_sub(str = title, from = 1, to = tweet_chars_left_for_title - 4), "... "),
                                paste0(stringi::stri_sub(str = title, from = 1, to = tweet_chars_left_for_title), " ")),
           tweet_text = paste0(tweet_au, tweet_title, link),
           already_tweeted = link %in% tweeted$link)
  
  # Tweet items with already_tweeted as FALSE, and append tweets to the log file
  tweet_these <- items_to_tweet %>% 
    filter(!already_tweeted) %>% 
    select(tweet_text)
  
  purrr::walk(unlist(tweet_these$tweet_text), rtweet::post_tweet)
  
  write.table(tweet_these$tweet_text, 
              file = paste0("C:\\Users\\Me\\Documents\\aaltodocbot\\", type, "tweets.csv"), 
              append = TRUE, row.names = FALSE, col.names = FALSE)
  
  if (exists("tweeted")) remove(tweeted)
  
  
  
}
