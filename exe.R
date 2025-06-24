setwd("C:/Users/Damian/Downloads")

rates <- read_exchange_rate("2025622231143550189016DNVALD83558967928.csv")
trades <- read_alpaca_trades(getwd())

rates %>% 
  filter(Date %in% trades$settle_date) %>% 
  right_join(trades, by = c("Date"="settle_date")) %>% 
  mutate(dkk=round(as.numeric(net_amount)*Value, digits = 1))

#NEXT IS CHECK BUYS MAND SELLS (OJO CON PERDIDAS - SUBSTRACT FROM CALCULATIONS) AND CALCULATE TAX USING PERCENTAGE PLUS BUFFER OF 2000 DKK ANNUALY -DOUBLE CHECK
