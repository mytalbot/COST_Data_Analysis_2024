# Load necessary libraries
library(tidyverse)
library(reshape2)
library(e1071)
library(caret)
library(pROC)
library(ggplot2)
library(readxl)
source("./R/aggregate_further.R") # call a helper function

# Generate some sample data for demonstration
set.seed(123)

data          <- as.data.frame(read_excel("./data/hc_simdat.xlsx")) # <3>
data$org_time <- as.POSIXct(data$org_time , origin="1970-01-01", tz="UTC") # <4>

# further aggregate data or use every data point when commented out
#data          <- aggregate_further(data=data, hours=9)
#head(data)

# annotate RELSA
data$class     <- "none"
data$class[data$relsa >= 0.3 & data$relsa <= 0.8] <- "medium"
data$class[data$relsa >  0.8] <- "high"
data$class     <- factor(data$class, levels=c("none","medium","high"))

# Split data into training and test sets
set.seed(123)
trainIndex <- createDataPartition(data$treatment,
                                  p    = .8,
                                  list = FALSE,
                                  times = 1)

train_data <- data[ trainIndex,]
test_data  <- data[-trainIndex,]

vars       <- c("activity", "heart_rate", "temperature","class")

# Train a model (e.g., SVM)
model      <- svm(class ~ .,
                  data   = train_data[, vars],
                  kernel = "linear",
                  type   = "C-classification")

# Predict on test data
predictions           <- predict(model, test_data)
test_data$predictions <- predictions

# Evaluate the model
confusionMatrix(predictions, test_data$class)

# plot the classifications in the RELSA data
test_data %>%
  # filter(org_time >= as.POSIXct("2024-06-02 11:00:00", tz = "UTC") & org_time <= as.POSIXct("2024-06-04 07:00:00", tz = "UTC") ) %>%
  ggplot(aes(x=org_time, y=relsa, color=predictions, group=1)) +
  geom_point() +
  #geom_line()  +
  labs(group = "",
       color = "") +
  theme_bw()       +
  theme(legend.position = "top") +
  geom_hline(yintercept = 1,   linetype="dashed", color = "black",   size=1) +
  geom_hline(yintercept = 0.3, linetype="dashed", color = "gray60",  size=1) +
  geom_hline(yintercept = 0.8, linetype="dashed", color = "gray60",  size=1)








