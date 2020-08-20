##!/usr/bin/env bash


for i in awk -F "\"*,\"*" '{print $16}' /Users/WRShoemaker/GitHub/Dormancy_EAD/data/bacillus_subtilis_complete.csv
do
  echo $i
done

paths=awk -F "\"*,\"*" '{print $16}' /Users/WRShoemaker/GitHub/Dormancy_EAD/data/bacillus_subtilis_complete.csv


#wget  ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/006/088/795/GCA_006088795.1_ASM608879v1/* -P ./GCA_006088795.1_ASM608879v1
