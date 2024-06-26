## Test code ----

# load packages ----
library(tidyverse)

## read data ----
participants <- read_csv("participants.csv")

questions <- read_csv("questions.csv")
  

draft_name <- participants %>% 
  filter(draft_num == 3)


## random question
purrr::map_dfr(1:1, ~ slice_sample(questions, n = 1, replace = T), 
               .id = "simulation") %>% 
  select(questions)
