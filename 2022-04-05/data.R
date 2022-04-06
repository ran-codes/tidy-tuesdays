{# 0. Setup ----
  library(tidyverse)
  library(skimr)
  library(ggwordcloud)
  library(cowplot)
  raw <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-04-05/news_orgs.csv')  
}


## Get variables with not much missing data > 90% completion
xwalk_complete = raw %>% 
  skim_to_list() %>% 
  map_df(~{.x %>% select(var = skim_variable, complete_rate ) }) %>% 
  filter(complete_rate>0.9)
xwalk_complete$var


## World cloud of description: for profit vs not for profite
get_text_freq = function(raw,tax){
  # tax = "Not for Profit"
  # tax = "For Profit"
  words = raw %>% 
    filter(primary_language == "English",
           tax_status_current==tax) %>% 
    pull(summary) %>% 
    paste(collapse = " ") %>% 
    str_remove_all("\n") %>% 
    str_remove_all("\\(")  %>% 
    str_remove_all("\\)") %>% 
    str_remove_all(",") %>% 
    str_split(" ")
  tibble(word = words[[1]]) %>% 
    mutate(word = str_to_lower(word)) %>% 
    filter(!word%in%c("and",'the',"to","is",'a','of',
                      'na','an','on',
                      'with',
                    
                      'in','that','for')) %>%
    filter(nchar(word)>3) %>% 
    count(word) %>% 
    arrange(desc(n)) %>% 
    top_n(15, wt = n)
}



p = bind_rows(get_text_freq(raw,"For Profit") %>% mutate(type = "Profit"),
          get_text_freq(raw,"Not for Profit") %>% mutate(type = 'Non-profit'))   %>% 
  ggplot(aes(label = word, size = n, color = n)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 25) +
  theme_minimal()+
  scale_color_gradient(low = "blue", high = "red") +
  facet_wrap(~type)
p


