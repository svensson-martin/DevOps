library(tidyverse)
library(vetiver)
library(pins)
library(plumber)

b <- board_folder("data/model")
v <- vetiver_pin_read(b, "penguin_model_r")

pr() %>% 
  vetiver_api(v) %>% 
  pr_run(port = 8088)
