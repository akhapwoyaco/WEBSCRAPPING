all_vehicles_data |>
  head()
#
sapply(
  all_vehicles_data, FUN = function(x){100*sum(is.na(x))/length(x)}
) 
#
analysis_data <- all_vehicles_data %>%
  select(where(~100*sum(is.na(.x))/length(.x) < 0.01)) |>
  select(price, source, current_location, mileage, mileage_unit, 
         annual_insurance_currency, annual_insurance, year_of_manufacture,
         availability, purchase_status, model_make_name, model_make_vehicle_type) |>
  mutate(
    current_location = str_replace_all(
      current_location, c("[[:punct:]]" = '', 'Port of' = '')) |> 
      str_to_lower() |> trimws()
  ) |>
  mutate(
    price = as.numeric(price),
    mileage = as.numeric(mileage),
    annual_insurance = as.numeric(annual_insurance),
    current_location = str_replace_all(
       current_location, 
       c(
         "nairobi kenya"= "kenya", "nairobi" = "kenya" ,
         "mombasa" = "kenya", "kenyakenya" = "kenya",
         "enroute"  = "overseas", "high seas" = "overseas"
    )),
    model_make_name = str_replace_all(
      model_make_name, c("[[:punct:]]" = '', 'Port of' = '')) |> 
      str_to_lower() |> trimws() 
  ) |>
  mutate(
    mileage = case_when(
      mileage_unit == "Miles" ~ mileage*1.6094,
      .default = mileage
    )
  ) |>
  select(-mileage_unit, -annual_insurance_currency)
#
#View(analysis_data)
str(analysis_data)
#
#




#

#

#
#
analysis_data |>
  ggplot(aes(x = mileage, y = price, colour = source)) +
  geom_point() +
  labs(
    x = "Mileage",
    y = "Price",
    title = "Price ~ Milage"
  ) +
  scale_y_continuous(
    labels = scales::unit_format(unit = 'KSH')
  ) +
  scale_x_continuous(
    labels = scales::unit_format(unit = 'kms')
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(face = 'bold', hjust = 0.5),
    legend.title = element_blank(),
    legend.position = 'inside',
    legend.position.inside = c(0.6, 0.5),
    legend.background = element_blank()
  )
#
# analysis_data |>
#   ggplot(aes(x = mileage, y = price, colour = model_make_name)) + 
#   geom_point() +
#   # scale_color_brewer(palette = 'Dark2') +
#   theme_bw() +
#   theme(
#     plot.title = element_text(face = 'bold', hjust = 0.5),
#     legend.title = element_blank(),
#  #   legend.position = 'inside',
# #    legend.position.inside = c(0.6, 0.5),
#     legend.background = element_blank()
#   )

#  
analysis_data |>
  ggplot(aes(x = mileage, y = price, colour = availability)) + 
  geom_point() +
  scale_color_brewer(palette = 'Dark2') +
  theme_bw() +
  theme(
    plot.title = element_text(face = 'bold', hjust = 0.5),
    legend.title = element_blank(),
    legend.position = 'inside',
    legend.position.inside = c(0.6, 0.5),
    legend.background = element_blank()
  )
#  
analysis_data |>
  ggplot(aes(x = mileage, y = price, colour = model_make_name)) + 
  geom_point() +
  scale_color_brewer(palette = 'Dark2') +
  theme_bw() +
  theme(
    plot.title = element_text(face = 'bold', hjust = 0.5),
    legend.title = element_blank(),
    legend.position = 'inside',
    legend.position.inside = c(0.6, 0.5),
    legend.background = element_blank()
  )
#
analysis_data |>
  ggplot(aes(x = mileage, y = price, colour = model_make_vehicle_type)) + 
  geom_point() +
  scale_color_brewer(palette = 'Dark2') +
  theme_bw() +
  theme(
    plot.title = element_text(face = 'bold', hjust = 0.5),
    legend.title = element_blank(),
    legend.position = 'inside',
    legend.position.inside = c(0.6, 0.5),
    legend.background = element_blank()
  )
#
#
multi_lm = lm(price~., data = analysis_data)
summary(multi_lm)
#
mean((analysis_data$price - multi_lm$fitted.values)^2)
#

# library(leaps)
# reg_fit_full <- regsubsets(
#   price~., data = analysis_data, nvmax = 9, method="exhaustive", really.big = T)
# reg_summary <- summary(reg_fit_full)
# which.max(reg_summary$adjr2) #Select model based on R2
# as.data.frame(reg_summary$outmat)[which.max(reg_summary$adjr2) ,]
# 
# 
# multi_lm2 = lm(price~current_location+annual_insurance+year_of_manufacture+availability+model_make_name,
#               data = analysis_data)
# summary(multi_lm2)
# summary(multi_lm) 
#
set.seed(123)
library(glmnet)
library(caret)
library(magrittr)
#
lambda <- 10^seq(-3, 3, length = 100)
# Build the model
set.seed(123)
ridge <- train(
  price ~., data = analysis_data, method = "glmnet",
  trControl = trainControl(method = "LOOCV"),
  tuneGrid = expand.grid(alpha = 0, lambda = lambda)
)#
# Make predictions
predictions_r <- ridge |> predict(analysis_data)
# Model prediction performance
mean((analysis_data$price - predictions_r)^2)
#
# ######
# knitr::kable(
#   data.frame(
#     model = c("linear reg", "PCR", "PLS", "ridge regression"),
#     MSE = c(MSE_Q2a, MSE_Q2b,MSE_Q2c,MSE_Q2d)),caption = "test MSEs")




