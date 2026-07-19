# Function to format t-test results from long-format data with significance codes
format_ttest_summary <- function(data, col_name, value_col, comparisons) {
  # Initialize an empty data frame to store results
  results_df <- data.frame(
    Group_Label = character(),
    Mean = numeric(),
    SD = numeric(),
    df = numeric(),
    t = numeric(),
    p = character(),
    exact_p = character(),
    Lower = numeric(),
    Upper = numeric(),
    Significance = character(),
    stringsAsFactors = FALSE
  )
  
  # Loop through each comparison
  for (comparison in comparisons) {
    group1 <- comparison$group1
    group2 <- comparison$group2
    
    # Filter data for each group
    data_group1 <- data[[value_col]][data[[col_name]] == group1]
    data_group2 <- data[[value_col]][data[[col_name]] == group2]
    
    # Perform t-test
    ttest_result <- t.test(data_group1, data_group2)
    
    # Calculate means and standard deviations
    mean1 <- mean(data_group1, na.rm = TRUE)
    sd1 <- sd(data_group1, na.rm = TRUE)
    mean2 <- mean(data_group2, na.rm = TRUE)
    sd2 <- sd(data_group2, na.rm = TRUE)
    
    # Create formatted p-value and significance code
    p_value <- ttest_result$p.value
    exact_p <- format(signif(p_value, 4), scientific = TRUE)
    formatted_p <- if (p_value < 0.001) "p < 0.001" else paste("p =", signif(p_value, 3))
    
    # Determine significance code
    significance_code <- if (p_value < 0.001) {
      "***"
    } else if (p_value < 0.01) {
      "**"
    } else if (p_value < 0.05) {
      "*"
    } else if (p_value < 0.1) {
      "."
    } else {
      ""
    }
    
    # Append rows for group1 (control) and group2 (experimental)
    results_df <- rbind(
      results_df,
      data.frame(
        Group_Label = group1,
        Mean = signif(mean1, 3),
        SD = signif(sd1, 3),
        df = signif(ttest_result$parameter, 3),
        t = signif(ttest_result$statistic, 3),
        p = formatted_p,
        exact_p = exact_p,
        Lower = signif(ttest_result$conf.int[1], 3),
        Upper = signif(ttest_result$conf.int[2], 3),
        Significance = significance_code,
        stringsAsFactors = FALSE
      ),
      data.frame(
        Group_Label = group2,
        Mean = signif(mean2, 3),
        SD = signif(sd2, 3),
        df = NA,
        t = NA,
        p = NA,
        exact_p = NA,
        Lower = NA,
        Upper = NA,
        Significance = NA,
        stringsAsFactors = FALSE
      )
    )
  }
  
  # Return the formatted results
  return(results_df)
}

# Example usage
# Example long-format data
example_data <- data.frame(
  prediction = c(rnorm(10, mean = 5, sd = 1), rnorm(10, mean = 7, sd = 1.5)),
  meta_group_A = c(rep("control", 10), rep("experimental", 10))
)

# Define comparisons (list format)
example_comparisons <- list(
  list(group1 = "control", group2 = "experimental")
)

# Run the function
example_results <- format_ttest_summary(
  data = example_data,
  col_name = "meta_group_A",
  value_col = "prediction",
  comparisons = example_comparisons
)

# Print example results
print(example_results)
