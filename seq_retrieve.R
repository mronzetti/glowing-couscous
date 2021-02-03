library(ape)
library(rentrez)
library(readxl)
library(tidyverse)

## make a character vector of accession IDs
prot_ids <- read_xlsx('./merops_seqs.xlsx', sheet='all')
df_id <- as.vector(prot_ids$NCBI_ID)

## use entrez_fetch() to get the protein FASTAs
## set `db = "protein"` to specify the database type as protein
prot_fasta <- entrez_fetch(id = df_id,
                           db = 'protein',
                           rettype = 'fasta')
write(prot_fasta, file="my_proteins.fasta")