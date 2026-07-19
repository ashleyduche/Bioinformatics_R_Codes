#CountsToFPKM_Simple
# Load necessary libraries
library(biomaRt)
library(edgeR)

# Set input/output file paths
counts_file <- "path/to/your/ROSMAP_DLPFC_Counts.tsv"
output_file <- "path/to/your/FPKM_output.tsv"

# Step 1: Read raw counts
raw_counts <- read.table(counts_file, header = TRUE, row.names = 1, check.names = FALSE)

# Step 2: Get gene lengths from Ensembl
ensembl_ids <- rownames(raw_counts)
ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
gene_length_data <- getBM(attributes = c("ensembl_gene_id", "start_position", "end_position"),
                          filters = "ensembl_gene_id",
                          values = ensembl_ids,
                          mart = ensembl)
gene_length_data$size <- gene_length_data$end_position - gene_length_data$start_position

# Match gene lengths to the counts data
gene_lengths <- gene_length_data$size[match(rownames(raw_counts), gene_length_data$ensembl_gene_id)]

# Step 3: Convert raw counts to FPKM
total_reads <- colSums(raw_counts)
fpkm_matrix <- t(t(raw_counts) / (total_reads / 1e6)) / (gene_lengths / 1e3)
fpkm_df <- as.data.frame(fpkm_matrix)
colnames(fpkm_df) <- colnames(raw_counts)
rownames(fpkm_df) <- rownames(raw_counts)

# Step 4: Save the output
write.table(fpkm_df, file = output_file, sep = "\t", quote = FALSE, row.names = TRUE)

message("FPKM conversion completed. Output saved to: ", output_file)
