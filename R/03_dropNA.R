# Function: dropNA
# Description:
# Removes columns from a dataframe that have a proportion of missing (NA) values 
# greater than the specified threshold.
#
# Parameters:
# - df: Input dataframe.
# - threshold: A numeric value (default = 0.5) representing the maximum allowed proportion
#              of NA values per column. Columns exceeding this threshold will be removed.
#
# Returns:
# - A cleaned dataframe containing only columns with NA proportions below the threshold.
#
# Example Usage:
# data_cleaned <- dropNA(data, threshold = 0.3)
# View(data_cleaned)

dropNA <- function(df, threshold = 0.5) {
  # Calculate the proportion of NAs in each column
  na_proportion <- colMeans(is.na(df))
  
  # Identify columns to keep (NA proportion <= threshold)
  cols_to_keep <- names(na_proportion[na_proportion <= threshold])
  
  # Subset the dataframe to include only these columns
  df_cleaned <- df[, cols_to_keep, drop = FALSE]  # drop = FALSE ensures the result remains a dataframe
  
  # Return the cleaned dataframe
  return(df_cleaned)
}
