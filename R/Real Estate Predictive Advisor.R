library(dplyr)
library(ggplot2)
library(lubridate)

set.seed(2024)

cat("📅 Generating daily sales data over 2 years...\n")

# Generate daily dates
dates <- seq.Date(from = as.Date("2023-01-01"), to = as.Date("2024-12-31"), by = "day")
n_sales <- length(dates) * 15  # Approx. 15 sales per day

cat("🛍️ Simulating", n_sales, "sales across", length(dates), "days...\n")

# Simulate raw sales data
sales_raw <- data.frame(
  date          = sample(dates, n_sales, replace = TRUE),
  store         = sample(c("Paris Centre", "Lyon Part-Dieu", "Marseille Vieux-Port",
                           "Toulouse Capitole", "Nice Promenade"), n_sales, replace = TRUE),
  seller        = sample(paste0("Seller_", 1:25), n_sales, replace = TRUE),
  product       = sample(c("Smartphone", "Laptop", "Tablet", "Earbuds",
                           "Smartwatch", "Accessories"), n_sales, replace = TRUE,
                         prob = c(0.3, 0.25, 0.2, 0.15, 0.05, 0.05)),
  unit_price    = round(runif(n_sales, 50, 1500), 2),
  quantity      = sample(1:5, n_sales, replace = TRUE,
                         prob = c(0.6, 0.25, 0.1, 0.04, 0.01)),
  client_age    = round(rnorm(n_sales, mean = 35, sd = 12)),
  client_gender = sample(c("M", "F", NA), n_sales, replace = TRUE,
                         prob = c(0.45, 0.45, 0.1)),
  payment_mode  = sample(c("Card", "Cash", "Check", ""), n_sales, replace = TRUE,
                         prob = c(0.7, 0.15, 0.1, 0.05))
)

cat("⚠️ Injecting realistic data issues (missing prices, age bounds)...\n")

# Introduce realistic data issues
sales_raw$unit_price[sample(1:nrow(sales_raw), 50)] <- NA  # Missing prices
sales_raw$client_age <- pmax(16, pmin(80, sales_raw$client_age))  # Clamp ages
sales_raw$total_amount <- sales_raw$unit_price * sales_raw$quantity  # Calculate total amount

cat("💾 Saving dataset to CSV: 'sales_data_raw.csv'\n")

# Save to CSV
write.csv(sales_raw, "sales_data_raw.csv", row.names = FALSE)

cat("✅ Data generation complete:", nrow(sales_raw), "sales across", length(unique(sales_raw$date)), "days\n")
