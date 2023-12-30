# Loading data & dependencies
library(tidyverse)
library(reshape2)
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
ggplot(melted_cor_matrix, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 12, hjust = 1),
        axis.text.y = element_text(size = 12)) +
  coord_fixed()


