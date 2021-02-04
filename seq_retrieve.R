library(ape)
library(rentrez)
library(readxl)
library(tidyverse)

### Functions
retrieveSeq <- function(id) {
  temp_fasta <- entrez_fetch(id = id,
                             db = 'protein',
                             rettype = 'fasta',
                             api_key='9d27de55176f553529fb57ad6d2217bf3f08')
  return (temp_fasta)
}
###

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
  fasta <- tryCatch(retrieveSeq(temp_id),
                    error = function(e){
                      message("An error occurred:\n", e)
                    },
                    warning = function(w){
                      message("A warning occured:\n", w)
                    },
                    finally = {
                      message(paste('[',i,'] ',temp_id,' sequence retrieved.',sep=''))
                    })
  #sleep(0.1)
}
write(full_fasta, file="my_proteins.fasta")