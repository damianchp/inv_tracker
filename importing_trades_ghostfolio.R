convert_json_to_ghostfolio_csv <- function(input_folder, output_csv_path) {
  library(jsonlite)
  library(dplyr)
  library(readr)
  
  json_files <- list.files(input_folder, pattern = "\\.json$", full.names = TRUE)
  all_rows <- list()
  
  for (file in json_files) {
    original <- fromJSON(file, simplifyVector = FALSE)
    
    # Trade Activities
    if (!is.null(original$trade_activities) && length(original$trade_activities) > 0) {
      for (trade in original$trade_activities) {
        action <- tolower(trade$side)
        data_source <- ifelse(action %in% c("buy", "sell"), "YAHOO", "MANUAL")
        all_rows[[length(all_rows) + 1]] <- list(
          Date = format(as.Date(trade$trade_date), "%d-%m-%Y"),
          Code = trade$symbol,
          DataSource = data_source,
          Currency = original$currency,
          Price = as.numeric(trade$price),
          Quantity = as.numeric(trade$qty),
          Action = action,
          Fee = 0.00,
          Note = ifelse(is.null(trade$note) || trade$note == "", "", trade$note)
        )
      }
    }
    
    # Fee Activities
    if (!is.null(original$fee_activities) && length(original$fee_activities) > 0) {
      for (fee in original$fee_activities) {
        all_rows[[length(all_rows) + 1]] <- list(
          Date = format(as.Date(original$creation_date), "%d-%m-%Y"),
          Code = "Fee",
          DataSource = "MANUAL",
          Currency = original$currency,
          Price = 0.00,
          Quantity = 0,
          Action = "fee",
          Fee = as.numeric(fee$gross_amount),
          Note = fee$description
        )
      }
    }
    
    # Dividend Activities (example)
    if (!is.null(original$dividend_activities) && length(original$dividend_activities) > 0) {
      for (div in original$dividend_activities) {
        all_rows[[length(all_rows) + 1]] <- list(
          Date = format(as.Date(div$ex_date), "%d-%m-%Y"),
          Code = div$symbol,
          DataSource = "MANUAL",
          Currency = original$currency,
          Price = as.numeric(div$amount),
          Quantity = 0,
          Action = "dividend",
          Fee = 0.00,
          Note = ifelse(is.null(div$note) || div$note == "", "", div$note)
        )
      }
    }
  }
  
  df <- bind_rows(all_rows)
  write_csv(df, output_csv_path, na = "")
}


# Example usage:
convert_json_to_ghostfolio_csv(getwd(), "all_trades_import.csv")
#when importing trades, make sure the right portfolio (if >1) is filtered

