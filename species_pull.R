library(tidyverse)
library(ape)
library(taxize)

# Read in fasta file
df <- read.FASTA('my_proteins.fasta', type='AA')

# Pull out the species labels and extract species from fasta file
species_list <- c()
for(i in 1:length(df)) {
  species_list[(i)] <- as.character(labels(df[(i)]))
}
species <- as_tibble(species_list)
x <- str_extract_all(species$value, "(?<=\\[).+?(?=\\])")
species$clean <- as.character(x)

# Query and retrieve family and class identifiers for the fasta file
family <- tax_name(sci=species$clean,get='family',db='ncbi')
class <- tax_name(sci=species$clean,get='class',db='ncbi')
species$family <- as.character(family$family)
species$class <- as.character(class$class)
write.csv(species, './species_list.csv')