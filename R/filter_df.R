# filter_df: Filter a dataframe by a specified value in a given column.
# Description:
# Filters a dataframe based on a specific value within a specified column.
#
# Parameters:
# - df: The input dataframe.
# - column_name: The name of the column to filter by (character string).
# - filter_value: The value to filter for within the specified column.
#
# Returns:
# - A filtered dataframe containing only rows where the specified column matches the filter_value.
#
# Example Usage:
# library(dplyr)
# df <- data.frame(
#   category = c("A", "B", "A", "C"),
#   value = c(1, 2, 3, 4)
# )
# result <- filter_df(df, column_name = "category", filter_value = "A")
# print(result)

filter_df <- function(df, column_name, filter_value) {
  # Ensure the required package 'dplyr' is installed and loaded
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("'dplyr' package is required. Please install it using install.packages('dplyr').")
  }
  library(dplyr)
  
  # Check if the dataframe is empty
  if (nrow(df) == 0) {
    warning("The input dataframe is empty. Returning the same dataframe.")
    return(df)
  }

  # Check if the specified column exists in the dataframe
  if (!column_name %in% names(df)) {
    stop("The specified column name was not found in the dataframe.")
  }

  # Filter the dataframe
  filtered_df <- df %>% filter(.data[[column_name]] == filter_value)

  # Return the filtered dataframe
  return(filtered_df)
}
