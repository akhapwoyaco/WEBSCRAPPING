#
library(purrr)
library(dplyr)
library(httr)
#
# tickers
ticker_req <- POST(
  'https://deveintapps.com/nseticker/api/v1/ticker', 
  accept_json(),
  query = list(
    "nopage"="true",
    "isinno"="KE3000009674"#,
    #"day" = "3/08/2024"
  ),
  add_headers(
    Accept = "application/json",
    `Content-Type` = "application/json",
    Host = "www.deveintapps.com",
    Origin = "https://www.nse.co.ke",
    Referer = "https://www.nse.co.ke/",
    `User-Agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36"
  )
) 
stop_for_status(ticker_req)
#
# content(m)
#
ticker_req_data <- content(ticker_req)
#ticker_req_data
ticker <- map_dfr(ticker_req_data$message, bind_rows)
# View(ticker)

#
ticker |> fill(date, time, market_status, .direction = 'downup') |> 
  drop_na(issuer) -> plt_data_1
View(plt_data_1)
#
date_data = gsub('/', '_',unique(plt_data_1$date))
#
write_csv(
  x = plt_data_1, file = paste('data/', date_data, '_NSE.csv', sep = ''))
#