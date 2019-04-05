#!/bin/bash

# Global variables
GOATOOLS=/home/labolb/miniconda2/bin/find_enrichment.py
FISHER_FOLDER=06_fisher_tests
GO_DATABASE=02_go_database/go-basic.obo
SIGNIFICANT_IDS=significant_ids.txt
ALL_IDS=all_ids.txt
ANNOTATIONS=06_fisher_tests/all_go_annotations.csv
ENRICHMENT="$FISHER_FOLDER"/go_enrichment.csv

# Running goa tools
echo "Running enrichment analysis..."
python2 $GOATOOLS --pval=0.05 --indent \
    --obo $GO_DATABASE \
    $SIGNIFICANT_IDS \
    $ALL_IDS \
    $ANNOTATIONS #> $ENRICHMENT

echo "  --- Please find your results in '$ENRICHMENT' ---"
