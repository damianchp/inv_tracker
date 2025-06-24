#URL FOR EXCHANGE RATE https://nationalbanken.statistikbank.dk/909

read_exchange_rate <- function(path) {
  library(jsonlite)
  library(tidyverse)
  
  # Read the CSV, skipping the first 2 lines
  x <- read.csv(path, skip = 2, header = FALSE)
  
  # Select relevant rows and remove first two columns
  x <- x[c(1, 3), ]
  x <- x[, -c(1, 2)]
  
  # Reshape and clean the data
  result <- data.frame(
    Date = as.vector(t(x[1, ])), 
    Value = as.numeric(as.vector(t(x[2, ])))
  ) %>%
    mutate(
      Date = as.Date(gsub("([0-9]{4})M([0-9]{2})D([0-9]{2})", "\\1-\\2-\\3", Date)),
      Value = Value / 100  # Convert value to per unit
    )
  
  return(result)
}



rates <- read_exchange_rate("2025622231143550189016DNVALD83558967928.csv")
