# Required package
    # Check if 'dplyr' is installed and install it if not
if (!require(dplyr, quietly = TRUE)) {
    install.packages("dplyr")
    library(dplyr)
}
library(dplyr)

# Filter dataframe by a specified value within a column
filter_df <- function(df, column_name, filter_value) {
    # Check if dataframe is empty
    if (nrow(df) == 0) {
        warning("Dataframe is empty.")
        return(df)
    }

    # Check if column_name exists in the dataframe
    if (!column_name %in% names(df)) {
        stop("Column name not found in the dataframe.")
    }

    # Filter the dataframe
    filtered_df <- df %>% filter(.data[[column_name]] == filter_value)

    # Return the filtered dataframe
    return(filtered_df)
}
