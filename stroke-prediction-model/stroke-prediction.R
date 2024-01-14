# Loading data & dependencies
library(tidyverse)
library(reshape2)
library(ggplot2)
library(GGally)
df <- read.csv("healthcare-dataset-stroke-data.csv")

# Dataset review
head(df)
summary(df)
str(df)

# Var 1: id
# Var 2: gender
# Var 3: age
# Var 4: hypertension
# Var 5: heart_disease
# Var 6: ever_married
# Var 7: work_type
# Var 8: Residence_type
# Var 9: avg_glucose_level
# Var 10: bmi
# Var 11: smoking_status
# Var 12: stroke

# Checking data for missing info
colSums(is.na(df))

# There are 201 missing values in the 'bmi' category
# I have made the decision to keep the rows with missing bmi values to continue
# with the rest of the analysis and I plan to create a separate model based on 
# bmi with those missing values removed along with the other info

# This means one model will contain more data than the other in order to
# remove any bias or assume a mean bmi value for the missing data


# Displaying each value per variable & Converting values
for (col_name in names(df)) {
  cat(col_name, ":\n")
  print(unique(df[[col_name]]))
  cat("\n")
}

df$gender <- ifelse(df$gender == "Male", 1, ifelse(df$gender == "Female", 0, NA))
df$ever_married <- ifelse(df$ever_married == "Yes", 1, 0)
df$Residence_type <- ifelse(df$Residence_type == "Urban", 1, 0)
df$work_type <- as.numeric(factor(df$work_type, levels = c("Never_worked", "children", "Govt_job", "Private", "Self-employed")))
df$smoking_status <- as.numeric(factor(df$smoking_status, levels = c("never smoked", "formerly smoked", "smokes", "Unknown")))

# Write the cleaned dataframe to a new CSV file
write.csv(df, file = "cleaned_stroke_data.csv", row.names = FALSE)

# Developing a correlation matrix

# Select only numeric columns, excluding 'id' if necessary
numeric_columns <- sapply(df, is.numeric)
# Optionally, exclude the 'id' column if it's numeric
numeric_columns["id"] <- FALSE
numeric_df <- df[, numeric_columns]

# Calculating the correlation matrix
cor_matrix <- cor(numeric_df, use = "complete.obs")

# Melting the correlation matrix for ggplot
melted_cor_matrix <- melt(cor_matrix)

# Correlation plot
cor_plot <- ggplot(melted_cor_matrix, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1),
        axis.text.y = element_text(size = 12)) +
  coord_fixed()

# Save the plot as an image file
ggsave("correlation_matrix_plot.png", plot = cor_plot, width = 10, height = 8)


# Work type & age correlation
plot1 <- ggplot(df, aes(x = as.factor(work_type), y = age)) +
  geom_boxplot() +
  labs(x = "Work Type", y = "Age") +
  theme_minimal()
ggsave("work_type_age_plot.png", plot = plot1, width = 8, height = 6)

# Work type & marital status correlation
plot2 <- ggplot(df, aes(x = as.factor(work_type), fill = as.factor(ever_married))) +
  geom_bar(position = "dodge") +
  labs(x = "Work Type", fill = "Ever Married") +
  theme_minimal()
ggsave("work_type_marital_status_plot.png", plot = plot2, width = 8, height = 6)

# Average glucose level & age
plot3 <- ggplot(df, aes(x = age, y = avg_glucose_level)) +
  geom_point(alpha = 0.5) +
  labs(x = "Age", y = "Average Glucose Level") +
  theme_minimal()
ggsave("glucose_level_age_plot.png", plot = plot3, width = 8, height = 6)

# Stroke & age
plot4 <- ggplot(df, aes(x = as.factor(stroke), y = age)) +
  geom_boxplot() +
  labs(x = "Stroke (0 = No, 1 = Yes)", y = "Age") +
  theme_minimal()
ggsave("stroke_age_plot.png", plot = plot4, width = 8, height = 6)

# Heart disease & age
plot5 <- ggplot(df, aes(x = as.factor(heart_disease), y = age)) +
  geom_boxplot() +
  labs(x = "Heart Disease (0 = No, 1 = Yes)", y = "Age") +
  theme_minimal()
ggsave("heart_disease_age_plot.png", plot = plot5, width = 8, height = 6)

# Hypertension & age
plot6 <- ggplot(df, aes(x = as.factor(hypertension), y = age)) +
  geom_boxplot() +
  labs(x = "Hypertension (0 = No, 1 = Yes)", y = "Age") +
  theme_minimal()
ggsave("hypertension_age_plot.png", plot = plot6, width = 8, height = 6)


# Selecting relevant columns for the pairwise plot
selected_columns <- c("age", "ever_married", "work_type", "avg_glucose_level", 
                      "stroke", "heart_disease", "hypertension")

# Creating the pairwise scatter plot
pairwise_plot <- ggpairs(df[, selected_columns], 
                         title = "Pairwise Scatter Plot with Age")

# Save the plot as an image file
ggsave("pairwise_scatter_plot_with_age.png", plot = pairwise_plot, width = 12, height = 10)





# T-test for comparing age between two groups (e.g., hypertension)
t.test(df$age ~ df$hypertension)

# ANOVA for comparing age across multiple groups (e.g., work_type)
anova(lm(age ~ as.factor(work_type), data = df))

# Chi-squared test for association between stroke and ever_married
chisq.test(table(df$stroke, df$ever_married))

# Chi-squared test for association between stroke and work_type
chisq.test(table(df$stroke, df$work_type))

# Pearson correlation test for age and avg_glucose_level
cor.test(df$age, df$avg_glucose_level, method = "pearson")

# Spearman correlation test if data is not normally distributed
cor.test(df$age, df$avg_glucose_level, method = "spearman")

# Linear regression for age and avg_glucose_level
summary(lm(avg_glucose_level ~ age, data = df))

# Logistic regression for predicting stroke (binary outcome) based on age
summary(glm(stroke ~ age, data = df, family = "binomial"))

