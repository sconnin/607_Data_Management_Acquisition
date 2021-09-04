library(tm)
library(stringr)
library(tidytext)
library(textdata) 
library(tidyverse)

t<- setwd("C:/Users/seanc/Desktop/Clinton-Trump Corpus/Clinton-Trump Corpus/Clinton")

h <- VCorpus(DirSource(t))

h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ='<.*?>', replacement = "")))
h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="[[:punct:][:blank:]]+", replacement =" ")))
h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="\\d", replacement = " ")))
h <- tm_map(h, content_transformer(function(h) gsub(h, pattern = "\\sll\\s|\\sve\\s", replace= " ")))
h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="\\b[A-z]\\b{1}", replacement = "")))
h <- tm_map(h, removeWords, stopwords("english"))
h <- tm_map(h, content_transformer(tolower))
h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="[\r\n]", replacement = "")))
h <- tm_map(h, stripWhitespace)


#Inspect 

for (i in 2:2) {
    cat(paste("[[", i, "]] ", sep = ""))
    a[i] <- writeLines(as.character(h[[i]]))
}

#Stem document
h<- tm_map(h,stemDocument)

h_corpus <- h %>% tidy()
h_corpus

h_corpus <- h_corpus %>% 
    select(id, text)

tidy_df <- h_corpus %>%
    unnest_tokens(word, text)

tidy_df %>%
    select(id, word) %>%
    head(300)

View(tidy_df)

get_stopwords()

tidy_df <- tidy_df %>%
    anti_join(get_stopwords())

tidy_joy <- get_sentiments("nrc") %>%
    filter(sentiment == "joy")

tidy_df %>% 
    inner_join(tidy_joy) %>%
    count(word, sort = TRUE)

tidy_df_sent <- tidy_df %>%
    inner_join(get_sentiments("bing")) %>%
    count(id, sentiment) %>%
    spread(sentiment, n, fill = 0)

tidy_df_sent <- tidy_df_sent %>%
    mutate(sentiment = positive - negative)

tidy_df_sent

ggplot(tidy_df_sent, aes(id, sentiment, fill = id)) +
    geom_col(show.legend = FALSE) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

bing_word_counts <- tidy_df %>%
    inner_join(get_sentiments("bing")) %>%
    count(word, sentiment, sort = TRUE) %>%
    ungroup()

bing_word_counts %>%
    group_by(sentiment) %>%
    top_n(10) %>%
    ungroup() %>%
    mutate(word = reorder(word,n)) %>%
    ggplot(aes(word, n, fill = sentiment)) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~sentiment, scales = "free_y") +
    labs(y = "Contribution to sentiment",
         x = NULL) +
    coord_flip()















