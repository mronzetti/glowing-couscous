library(ape)
library(rentrez)
library(readxl)
library(tidyverse)

## Pull in file containing MEROPS-copied accession IDS and remove empty rows
prot_ids <- read.csv('./data/merops_seqs.csv')
prot_ids <- prot_ids %>%
  select('NCBI_ID') %>%
  na_if("") %>%
  na.omit()

## use entrez_fetch() to get the protein FASTAs
## set `db = "protein"` to specify the database type as protein
## You may need to un-comment the sleep box in order to access NCBI resources
full_fasta <- c('')
for(i in 1:length(prot_ids$NCBI_ID)){
  temp_id <- prot_ids$NCBI_ID[(i)]
  temp_fasta <- entrez_fetch(id = temp_id,
                             db = 'protein',
                             rettype = 'fasta',
                             api_key='9d27de55176f553529fb57ad6d2217bf3f08')
  full_fasta[(i)] <- temp_fasta
  #sleep(0.1)
}
write(full_fasta, file="my_proteins.fasta")