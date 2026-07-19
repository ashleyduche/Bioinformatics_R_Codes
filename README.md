# Bioinformatics_R_Codes
Useful `R` codes and functions for data conversion, cleaning and statistical analysis with examples provided for clarity.

# Available Functions

## 1. `CountsToFPKM`
R scripts for converting raw gene expression counts to FPKM values. FPKM (Fragments Per Kilobase of transcript per Million mapped reads) is a common method used to normalize RNA-seq count data, accounting for both sequencing depth and gene length. These scripts automate the conversion of raw counts into FPKM values by retrieving gene lengths from Ensembl. A straightforward script for quick processing or a modular script for more complex workflows can be choosen.

### 1.1 CountsToFPKM_Simple.R

This script provides a quick solution for converting raw counts to FPKM values without complex setup.  
Appropriate for processing a single dataset.

- **Input**: A tab-separated file where:
  - Rows represent genes (Ensembl gene IDs as row names).
  - Columns represent samples (sample names as column headers).
- **Output**: A tab-separated file where:
  - Rows represent genes.
  - Columns represent FPKM values for each sample.

### 1.2 CountsToFPKM_Modular.R

This is a more flexible version with separate functions for each step of the pipeline.  
It’s designed for reuse, modification, or extended workflows.

- **Input**: Same format as above (tab-separated file with gene IDs as rows and samples as columns).
- **Output**: Same format as above (tab-separated file with FPKM values).
- **Functions**:
  - `read_raw_counts`: Reads the input raw counts file.
  - `get_gene_lengths`: Queries Ensembl for gene lengths using Ensembl gene IDs.
  - `convert_to_fpkm`: Calculates FPKM values using raw counts and gene lengths.
  - `run_pipeline`: Main function that runs the entire process.

## Example Input

Example input file (`ROSMAP_DLPFC_Counts.tsv`):

| Gene ID        | Sample_1 | Sample_2 | Sample_3 |
|----------------|----------|----------|----------|
| ENSG00000123415| 1500     | 1800     | 1750     |
| ENSG00000234567| 2300     | 2100     | 2200     |
| ENSG00000345678| 1100     | 900      | 950      |

- The first column contains Ensembl gene IDs.
- The remaining columns contain raw counts for each sample.

## Example Output

Example output file (`FPKM_output.tsv`):

| Gene ID        | Sample_1 | Sample_2 | Sample_3 |
|----------------|----------|----------|----------|
| ENSG00000123415| 5.23     | 6.14     | 5.90     |
| ENSG00000234567| 8.45     | 7.85     | 8.11     |
| ENSG00000345678| 3.25     | 2.89     | 3.01     |

- The output file contains the same genes and samples as the input file.
- The values represent the calculated FPKM for each gene in each sample.

## Requirements

- **R** (version 4.0 or later)
- Required libraries: `biomaRt`, `edgeR`

## Usage Instructions

### Running the Simple Script

1. Open `CountsToFPKM_Simple.R`.
2. Update the following lines with the paths to your input and output files:
   ```r
   counts_file <- "path/to/your/ROSMAP_DLPFC_Counts.tsv"
   output_file <- "path/to/your/FPKM_output.tsv"



## 2. `format_ttest_summary`

## Function Overview
R script for performing indepdendent t-tests on **long-format grouped data** and formatting the results into a structured summary data frame. The function handles cases where groups are specified within a column and values are provided in another column.

## `format_ttest_summary`

This function performs Student's t-tests for specified group comparisons and outputs a data frame with relevant statistics, including means, standard deviations, degrees of freedom, t-statistics, p-values, exact p-values, 95% confidence intervals, and significance codes.

## Parameters

- `data`: A data frame containing the input data.
- `col_name`: The name of the column containing group labels (as a string).
- `value_col`: The name of the column containing numeric values to be compared (as a string).
- `comparisons`: A list of comparisons, where each comparison is a list with two elements:
  - `group1`: The first group (value in `col_name`) to compare.
  - `group2`: The second group (value in `col_name`) to compare.

## Output

The function returns a data frame with the following columns:

- `Group_Label`: The label of the group being described (either control or experimental).
- `Mean`: The mean of the numeric values for the group.
- `SD`: The standard deviation of the numeric values for the group.
- `df`: Degrees of freedom for the t-test.
- `t`: t-statistic for the comparison.
- `p`: Formatted p-value (e.g., "p < 0.001").
- `exact_p`: Exact p-value with 4 significant figures.
- `Lower`: Lower bound of the confidence interval.
- `Upper`: Upper bound of the confidence interval.
- `Significance`: Significance code based on the p-value:
  - `***` for p < 0.001
  - `**` for p < 0.01
  - `*` for p < 0.05
  - `.` for p < 0.1
  - No symbol for p ≥ 0.1

## Example Usage

```r
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

# Print the results
print(example_results)
```

## Example Input
| prediction | meta_group_A   |
|------------|----------------|
| 5.1        | control        |
| 4.9        | control        |
| 5.3        | control        |
| 6.9        | experimental   |
| 7.2        | experimental   |
| 6.8        | experimental   |

## Eample Output
| Group_Label   | Mean |  SD  |  df  |   t   |     p      |  exact_p  | Lower | Upper | Significance |
|---------------|------|------|------|-------|------------|-----------|-------|-------|--------------|
| control       | 5.10 | 0.16 | 18   | 6.75  | p < 0.001  | 2.45e-05  | 1.2   | 2.5   | ***          |
| experimental  | 6.94 | 0.21 |      |       |            |           |       |       |              |

## Requirements
- R (version 4.0 or later)
- No additional libraries are required.



## 3. `dropNA.R`

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
## 4. `filter_df.R`

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

## 5. `t_test_pvalues`
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

