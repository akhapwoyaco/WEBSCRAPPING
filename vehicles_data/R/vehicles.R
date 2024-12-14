#
library(jsonlite)
library(httr)
library(janitor)
#
vehicles = jsonlite::fromJSON("https://dashboard.kaiandkaro.com/api/v1/vehicles")
vehicles$count


# vehicle makes
vehicleMakes = jsonlite::fromJSON(
  "https://dashboard.kaiandkaro.com/api/v1/vehicle-makes")
vehicleMakes
readr::write_csv(vehicleMakes, 'vehicles_data/data-raw/vehicleMakes.csv')

# vehicle models
vehicleModels = jsonlite::fromJSON(
  "https://dashboard.kaiandkaro.com/api/v1/vehicle-models", flatten = T) |>
  clean_names(replace = c("\\." = '_', "$" = '_'))
vehicleModels |> head()

readr::write_csv(vehicleModels |> as_tibble(), 'vehicles_data/data-raw/vehicleModels.csv')
#

about = jsonlite::fromJSON(
  "https://dashboard.kaiandkaro.com/api/v1/about-us")
about
teamMembers = jsonlite::fromJSON(
  "https://dashboard.kaiandkaro.com/api/v1/team-members")
teamMembers
contactMessage = jsonlite::fromJSON(
  "https://dashboard.kaiandkaro.com/dashboard/api/v1/contact-messages/")
contactMessage
newsLetterSubscription = jsonlite::fromJSON(
  "https://dashboard.kaiandkaro.com/dashboard/api/v1/newsletter-subscriptions/")
newsLetterSubscription
#

#
library(dplyr)
library(tidyr)
#
kai_kairo_data <- data.frame()
kai_kairo_j = jsonlite::fromJSON("https://dashboard.kaiandkaro.com/api/v1/vehicles/?page=1", flatten = T)
kai_kairo_data = bind_rows(
  kai_kairo_data,
  kai_kairo_j$results
)
while (!is.null(kai_kairo_j$`next`)) {
  print(kai_kairo_j$`next`)
  kai_kairo_j = jsonlite::fromJSON(kai_kairo_j$`next`, flatten = T)
  kai_kairo_data = bind_rows(
    kai_kairo_data,
    kai_kairo_j$results
  )
}
# save data
all_vehicles_data = kai_kairo_data |>
  clean_names() |>
  select(-thumbnail, -agent_whatsapp_contact)


#
write_csv(all_vehicles_data , 
          paste0('vehicles_data/data-raw/vehicles_data_', strftime(now(),"%Y%m%d%H%M"), '.csv', sep = ''))
#
write_csv(all_vehicles_data , 
          paste0('vehicles_data/data/vehicles_data_', strftime(now(),"%Y%m%d%H%M"), '.csv', sep = ''))

write_csv(all_vehicles_data , 
          paste0('vehicles_data/analysis/vehicles_data_', strftime(now(),"%Y%m%d%H%M"), '.csv', sep = ''))


