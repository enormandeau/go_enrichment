# Blast sequences against swissprot
echo "Blasting sequences against swissprot..."
cat 03_sequences/analyzed_genes_full.fasta | parallel -k --block 1k --recstart '>' --pipe 'blastx -db ~/Software/blastplus_databases/swissprot -query - -evalue 1e-3 -outfmt 6 -max_target_seqs 1' > 04_blast_results/analyzed_genes.swissprot

# Extract analyzed_genes.hits
echo "Extracting hits..."
awk '{print $1,$2}' 04_blast_results/analyzed_genes.swissprot | uniq > 04_blast_results/analyzed_genes.hits

# Get info from uniprot for each hit
echo "Grab annotation from uniprot..."
# TODO Parallelize
cat 04_blast_results/analyzed_genes.hits | while read i; do echo $i; feature=$(echo $i | cut -d " " -f 1) hit=$(echo $i | cut -d "|" -f 4 | cut -d "." -f 1); echo $feature $hit; wget -q -O - http://www.uniprot.org/uniprot/${hit}.txt > 05_annotations/${feature}.info; done

# Extract wanted info
echo "Extracting GO information"
for i in 05_annotations/*.info; do echo -e "$(basename $i | perl -pe 's/\.info//')\t$(cat $i | grep -E '^DR\s+GO' | awk '{print $3}' | perl -pe 's/\n//')"; done > all_go_annotations.csv

# Create lists of all IDs and subset of IDs for enrichment
awk '{print $1}' all_go_annotations.csv > all_ids.txt

# TODO WARNING! This would be given by the user
head -200 all_ids.txt > significant_ids.txt

# goa tools
echo "Running enrichment analysis..."
python ../goatools/scripts/find_enrichment.py --pval=0.05 --indent --obo 02_go_database/go-basic.obo significant_ids.txt all_ids.txt all_go_annotations.csv > go_enrichment.csv

echo "  --- Please find your results in 'go_enrichment.csv' ---"

