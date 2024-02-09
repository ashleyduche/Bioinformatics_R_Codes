clean_colnames <- function(df_list) {
  # Apply the cleaning function to each dataframe in the list
  cleaned_dfs <- lapply(df_list, function(df) {
    colnames(df) <- gsub("^X", "", colnames(df))
    return(df)
  })
  
  # Automatically update the original dataframes in your environment
  list2env(cleaned_dfs, envir = .GlobalEnv)
}

# Usage
# Create a list of your dataframes, ensuring each element is named after the dataframe variable
dfs <- list(df1 = df1, df2 = df2, df3 = df3)

# Call the function with your list of dataframes
clean_colnames(dfs)
