#!/bin/bash

# Global variables
SWISSPROT_HITS=04_blast_results/analyzed_genes.hits
ANNOTATION_FOLDER=05_annotations
FISHER_FOLDER=06_fisher_tests

## Get info from uniprot for each hit
#cat $SWISSPROT_HITS | while read i; do echo $i; feature=$(echo $i | cut -d " " -f 1) hit=$(echo $i | cut -d "|" -f 4 | cut -d "." -f 1); echo $feature $hit; wget -q -O - http://www.uniprot.org/uniprot/${hit}.txt > $ANNOTATION_FOLDER/${feature}.info; done

# Get info from uniprot for each hit in parallel
cat $SWISSPROT_HITS | while read i; do feature=$(echo $i | cut -d " " -f 1) hit=$(echo $i | cut -d "|" -f 4 | cut -d "." -f 1); echo "wget -q -O - http://www.uniprot.org/uniprot/${hit}.txt > $ANNOTATION_FOLDER/${feature}.info"; done > temp_wget_commands.txt

cat temp_wget_commands.txt | parallel "eval {}"
rm temp_wget_commands.txt

# Extract wanted info
for i in $ANNOTATION_FOLDER/*.info; do echo -e "$(basename $i | perl -pe 's/\.info//')\t$(cat $i | grep -E '^DR\s+GO' | awk '{print $3}' | perl -pe 's/\n//')"; done > $FISHER_FOLDER/all_go_annotations.csv

