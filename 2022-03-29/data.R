{# 0. Setup ----
  library(tidyverse)
  library(skimr)
  sports <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-03-29/sports.csv')
  
}


skim(sports)
