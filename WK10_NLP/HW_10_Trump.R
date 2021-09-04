library(tm)
library(stringr)
library(tidytext)
library(textdata) 
library(tidyverse)



t<- setwd("C:/Users/seanc/Desktop/Clinton-Trump Corpus/Clinton-Trump Corpus/Trump")

h <- VCorpus(DirSource(t))

get_stopwords()

h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ='<.*?>', replacement = "")))
h <- tm_map(h, removePunctuation)
h <- tm_map(h, content_transformer(tolower)) #Transform to lower case
h <- tm_map(h, removeNumbers) #Strip digits
h <- tm_map(h, removeWords, stopwords("english")) #Remove stopwords from standard stopword list
h <- tm_map(h, stripWhitespace) #Strip whitespace (cosmetic?)
h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="[\r\n]", replacement = "")))



#h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="[[:punct:][:blank:]]+", replacement =" ")))
#h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="\\d", replacement = " ")))
#h <- tm_map(h, content_transformer(function(h) gsub(h, pattern = "\\sll\\s|\\sve\\s", replace= " ")))
#h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="\\b[A-z]\\b{1}", replacement = "")))
#h <- tm_map(h, removeWords, stopwords("english"))
#h <- tm_map(h, content_transformer(tolower))
h <- tm_map(h, content_transformer(function(h) gsub(h, pattern ="[\r\n]", replacement = "")))
#h <- tm_map(h, stripWhitespace)


#Inspect 

for (i in 2:2) {
    cat(paste("[[", i, "]] ", sep = ""))
    t <- writeLines(as.character(h[[i]]))
}

#Stem document --- this  caused problems
#h<- tm_map(h,stemDocument) 

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



tidy_df <- tidy_df %>%
    anti_join(get_stopwords())

#The loop

#tidy_joy <- get_sentiments("nrc") %>%
    #filter(sentiment == "joy")

#create a tibble with word counts for positive terms using nrc

#tidy_df %>% 
    #inner_join(tidy_joy) %>%
    #count(word, sort = TRUE)

#tidy_df
#t_df<-c()
#df<-c()
#lex<-c("nrc","bing", "afinn")
#for (i in 1:length(lex)){
    #ifelse(i==1, name<-paste0("nrc_", i), 
           #ifelse(i==2, name<-paste0("bing_", i), 
                  #ifelse(i==3, name<-paste0("afinn_", i),)))
    #t<-tidy_df %>%
        #inner_join(get_sentiments(lex[i]))%>%
        #count(id, sentiment) %>%
        #spread(sentiment, n, fill = 0)%>%
        #mutate(sentiment_score = positive - negative)
    
    
    
    
    #print(typeof(t))
    #View(t)
    #df <- c(df, name)
    #t<-data.frame(t)
    #t_df <-c(t_df,t)

#}

#df_nrc

get_sentiments( "afinn")  # assigns relative value to word
get_sentiments( "nrc") # assigns category of emotion to word
get_sentiments( "bing") #assigns categories of positive or negative to word

d <- data.frame()
lex<-c("nrc","bing")

for (i in 1:length(lex)){
    print(lex[i])
    df <- tidy_df %>%
    inner_join(get_sentiments(lex[i])) %>%
    count(id, sentiment) %>%
    spread(sentiment, n, fill = 0)%>%
    mutate(sentiment = positive - negative)%>%
    mutate(method = lex[i])%>%
    select(id, method, positive, negative, sentiment)
    r<-df
    d <- rbind(r,d)%>%arrange(id, method)
}
#d%>%arrange(id, method)
View(d)
dim(d)











df_nrc <- tidy_df %>%
    inner_join(get_sentiments("nrc")) %>%
    count(id, sentiment) %>%
    spread(sentiment, n, fill = 0)%>%
    mutate(sentiment = positive - negative)%>%
    mutate(method = "nrc")%>%
    select(id, method, positive, negative, sentiment)

df_bing <- tidy_df %>%
    inner_join(get_sentiments("bing")) %>%
    count(id, sentiment) %>%
    spread(sentiment, n, fill = 0)%>%
    mutate(sentiment = positive - negative)%>%
    mutate(method = "bing")%>%
    select(id, method, positive, negative, sentiment)
    
check<-full_join(df_nrc, df_bing)%>%arrange(id, method)
dim(check)
View(check)
all(d == check)
all.equal(d,check)

#df_a <- tidy_df %>%
    #inner_join(get_sentiments("afinn")) #%>%
    #elseif(value > 0, )

    #group_by(id)%>%
   # mutate(sentiment=sum(value))
    #count(id, value) %>%
    #spread(value, n, fill = 0)#%>%
    #mutate(value = positive + negative)%>%
    #mutate(method = "afinn")%>%
    #select(id, method, positive, negative, value)
#df_a

    

# stop here





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















