#!/bin/bash

#scp wrshoema@carbonate.uits.iu.edu:/N/dc2/projects/Lennon_Sequences/2019_dormancy_ead/data/refseq_genomes/*/*v1_genomic.fna.gz
#gunzip *.gz
#find . -name "*.fna" -exec bash -c 'mv "$1" "${1%.t1}".fa' - '{}' \;

external_genomes=/Users/WRShoemaker/GitHub/Dormancy_EAD/data/external-genomes.txt
rm $external_genomes
printf "name\tcontigs_db_path\n" >> $external_genomes

for fasta in /Users/WRShoemaker/GitHub/Dormancy_EAD/data/refseq_genomes/*v1_genomic.fna.fa; do
    name=$(echo $fasta | cut -d'/' -f8 | cut -d'.' -f1) # output is 1
    db="${fasta/.fa/.db}"
    #printf "${name}\t${db}\n" >> $external_genomes
    #anvi-script-FASTA-to-contigs-db $fasta
    anvi-run-ncbi-cogs -c $db --num-threads 4 --search-with blastp
done



#anvi-gen-genomes-storage -e external-genomes.txt -o bacillus-subtilis-GENOMES.db
#anvi-pan-genome -g bacillus-subtilis-GENOMES.db \
#                  -n bacillus_subtilis \
#                  --num-threads 2 \
#                  --use-ncbi-blast

#anvi-pan-genome -g bacillus-subtilis-GENOMES.db \
#                  -n bacillus_subtilis \
#                  --exclude-partial-gene-calls \
#                  --num-threads 2

#anvi-get-sequences-for-gene-clusters -p bacillus_subtilis/bacillus_subtilis-PAN.db \
#                                       -g bacillus-subtilis-GENOMES.db \
#                                       --report-DNA-sequences \
#                                       --min-num-genomes-gene-cluster-occurs 95 \
#                                       -o better_core.fa


#anvi-get-sequences-for-gene-clusters -p PROCHLORO/Prochlorococcus_Pan-PAN.db \
#                                      -g PROCHLORO-GENOMES.db \
#                                      -C default -b Better_core \
#                                      --concatenate-gene-clusters \
#                                      -o better_core.fa


#anvi-get-sequences-for-gene-clusters -p bacillus_subtilis/bacillus_subtilis-PAN.db -g bacillus-subtilis-GENOMES.db --list-bins



#anvi-get-sequences-for-gene-clusters --min-num-genes-from-each-genome 95
