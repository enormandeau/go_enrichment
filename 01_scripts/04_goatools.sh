#!/bin/bash

# Global variables
ALL_IDS=$1          #all_ids.txt
SIGNIFICANT_IDS=$2  #significant_ids.txt
ENRICHMENT=$3       #"$FISHER_FOLDER"/go_enrichment.csv
GO_DATABASE=02_go_database/go-basic.obo
ANNOTATIONS=06_fisher_tests/all_go_annotations.csv
FISHER_FOLDER=06_fisher_tests

# Running goa tools
echo "Running enrichment analysis..."
find_enrichment.py --pval=0.05 --indent \
    --obo $GO_DATABASE \
    $SIGNIFICANT_IDS \
    $ALL_IDS \
    $ANNOTATIONS --outfile $ENRICHMENT

echo "  --- Please find your results in '$ENRICHMENT' ---"
