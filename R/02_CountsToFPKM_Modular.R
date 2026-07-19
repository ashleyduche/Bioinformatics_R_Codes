# Load necessary libraries
library(biomaRt)
library(edgeR)

# Function to read raw counts from a file
read_raw_counts <- function(file_path) {
  raw_counts <- read.table(file_path, header = TRUE, row.names = 1, check.names = FALSE)
  message("Loaded raw counts with dimensions: ", paste(dim(raw_counts), collapse = " x "))
  return(raw_counts)
}

# Function to get gene lengths from Ensembl
get_gene_lengths <- function(ensembl_ids) {
  ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  gene_data <- getBM(attributes = c("hgnc_symbol", "ensembl_gene_id", "start_position", "end_position"),
                     filters = "ensembl_gene_id",
                     values = ensembl_ids,
                     mart = ensembl)
  gene_data$size <- gene_data$end_position - gene_data$start_position
  return(gene_data)
}

# Function to convert counts to FPKM
convert_to_fpkm <- function(counts, gene_lengths) {
  total_mapped_reads <- colSums(counts)
  fpkm_matrix <- t(t(counts) / (total_mapped_reads / 1e6)) / (gene_lengths / 1e3)
  fpkm_df <- as.data.frame(fpkm_matrix)
  colnames(fpkm_df) <- colnames(counts)
  rownames(fpkm_df) <- rownames(counts)
  return(fpkm_df)
}

# Main function to run the entire pipeline
run_pipeline <- function(counts_file_path, output_file_path) {
  raw_counts <- read_raw_counts(counts_file_path)
  
  ensembl_ids <- rownames(raw_counts)
  gene_lengths_data <- get_gene_lengths(ensembl_ids)
  
  # Match gene lengths with raw counts
  gene_lengths <- gene_lengths_data$size[match(rownames(raw_counts), gene_lengths_data$ensembl_gene_id)]
  
  # Convert raw counts to FPKM
  fpkm_df <- convert_to_fpkm(raw_counts, gene_lengths)
  
  # Save the output
  write.table(fpkm_df, file = output_file_path, sep = "\t", quote = FALSE, row.names = TRUE)
  message("FPKM values saved to: ", output_file_path)
}

# Example usage (uncomment and modify file paths as needed)
# counts_file <- "path/to/your/ROSMAP_DLPFC_Counts.tsv"
# output_file <- "path/to/your/FPKM_output.tsv"
# run_pipeline(counts_file, output_file)
