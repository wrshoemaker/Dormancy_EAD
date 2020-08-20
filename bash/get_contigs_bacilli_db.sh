#!/bin/bash

#gunzip *.gz
find . -name "*.fna" -exec bash -c 'mv "$1" "${1%.t1}".fa' - '{}' \;

external_genomes=/Users/WRShoemaker/GitHub/Dormancy_EAD/data/bacilli-external-genomes.txt
rm $external_genomes
printf "name\tcontigs_db_path\n" >> $external_genomes



for fasta in /Users/WRShoemaker/GitHub/Dormancy_EAD/data/bacilli_genomes/*_genomic.fna.fa; do
    name=$(echo $fasta | cut -d'/' -f8 | cut -d'.' -f1) # output is 1
    db="${fasta/.fa/.db}"
    #printf "${name}\t${db}\n" >> $external_genomes
    #anvi-script-FASTA-to-contigs-db $fasta
    #anvi-run-ncbi-cogs -c $db --num-threads 4 --search-with blastp
    #anvi-db-info $db
done


declare -a dbs=("GCF_000724775.3_ASM72477v3_genomic.fna.db" "GCF_001586195.1_ASM158619v1_genomic.fna.db" "GCF_001687565.2_ASM168756v2_genomic.fna.db")
for db in "${dbs[@]}"
do
  echo $db
  anvi-db-info $db
  #anvi-run-ncbi-cogs -c $db --num-threads 4 --search-with blastp
done



anvi-gen-genomes-storage -e bacilli-external-genomes.txt -o bacilli-GENOMES.db

anvi-pan-genome -g bacilli-GENOMES.db \
                  -n bacilli \
                  --num-threads 2 \
                  --use-ncbi-blast

#anvi-pan-genome -g bacillus-subtilis-GENOMES.db \
#                  -n bacillus_subtilis \
#                  --exclude-partial-gene-calls \
#                  --num-threads 2

anvi-get-sequences-for-gene-clusters -p bacilli/bacilli-PAN.db \
                                       -g bacilli-GENOMES.db \
                                       --report-DNA-sequences \
                                       --min-num-genomes-gene-cluster-occurs 29 \
                                       --concatenate-gene-clusters \
                                       --max-num-genes-from-each-genome 1 \
                                       -o bacilli_core.fa


#anvi-get-sequences-for-gene-clusters -p PROCHLORO/Prochlorococcus_Pan-PAN.db \
#                                      -g PROCHLORO-GENOMES.db \
#                                      -C default -b Better_core \
#                                      --concatenate-gene-clusters \
#                                      -o better_core.fa
