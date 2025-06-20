read_alpaca_trades <- function(json_path){
  library(jsonlite); library(dplyr)
  json_names <- list.files(path = json_path, pattern = "\\.json$", full.names = TRUE)

  json_files <- lapply(json_names, function(x) fromJSON(x)[["trade_activities"]])
  json_files <- do.call(bind_rows,json_files)

  trades <- json_files %>%
  as.data.frame() %>%
  select(1,3:5,8:11)
  return(trades)
}

trades <- read_alpaca_trades(getwd())
