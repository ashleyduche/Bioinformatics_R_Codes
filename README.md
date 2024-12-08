# Bioinformatics_R_Codes
Useful `R` functions for efficent data cleaning and statistical analysis with examples provided for clarity.

## Available Functions

### 1. `dropNA.R`

**Purpose**: Cleans a dataframe by removing columns that have a proportion of missing (NA) values above a specified threshold.

**Parameters**:
- `df`: Input dataframe.
- `threshold`: Maximum allowed proportion of NA values per column (default = 0.5). Columns exceeding this threshold are dropped.

**Returns**:
- A cleaned dataframe with only the columns meeting the NA threshold.

**Example**:
```r
df <- data.frame(
  col1 = c(1, 2, NA, 4),
  col2 = c(NA, NA, 3, 4),
  col3 = c(5, 6, 7, 8)
)

# Drop columns with >30% NA values
cleaned_df <- dropNA(df, threshold = 0.3)
print(cleaned_df)
```
### 2. `filter_df.R`

**Purpose**: Filters rows in a dataframe where a specified column matches a given value.

**Parameters**:
- `df`: Input dataframe.
- `column_name`: Name of the column to filter by (character string).
- `filter_value`: Value to filter on.
  
**Returns**:
- A dataframe containing only rows where the column matches the filter value.
  
**Example**:
```r
df <- data.frame(
  category = c("A", "B", "A", "C"),
  value = c(1, 2, 3, 4)
)

# Filter rows where 'category' is 'A'
filtered_df <- filter_df(df, column_name = "category", filter_value = "A")
print(filtered_df)
```

### 3. `t_test_pvalues`
**Purpose**: Performs pairwise t-tests between a reference group and specified comparison groups. Adjusts p-values for multiple testing if requested.

**Parameters**:
- `df`: Input dataframe.
- `x_var`: Column containing grouping categories (independent variable).
- `y_var`: Column containing numerical values to compare (dependent variable).
- `ref_group`: Reference group for comparison.
- `compare_groups`: A vector of groups to compare against the reference group.
- `adjust_method`: Method for p-value adjustment (e.g., "bonferroni", "fdr"). Default is "none".
  
**`Returns**:
- A named vector of p-values for the comparisons.
  
**Example**:
```r
df <- data.frame(
  group = rep(c("Control", "Treatment1", "Treatment2"), each = 10),
  value = c(rnorm(10, 5, 1), rnorm(10, 6, 1), rnorm(10, 7, 1))
)

# Perform t-tests comparing "Control" with "Treatment1" and "Treatment2"
pvals <- t_test_pvalues(
  df = df,
  x_var = "group",
  y_var = "value",
  ref_group = "Control",
  compare_groups = c("Treatment1", "Treatment2"),
  adjust_method = "fdr"
)

print(pvals)
```
