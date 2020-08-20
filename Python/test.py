from __future__ import division
import os, re, gzip, subprocess, textwrap
import numpy as np
import pandas as pd


#module unload python
#module load python/3.6.1

#mydir = '/Users/WRShoemaker/GitHub/Dormancy_EAD/'
mydir = '/N/dc2/projects/Lennon_Sequences/2019_dormancy_ead/'


class classFASTA:

    def __init__(self, fileFASTA):
        self.fileFASTA = fileFASTA

    def readFASTA(self):
        '''Checks for fasta by file extension'''
        file_lower = self.fileFASTA.lower()
        '''Check for three most common fasta file extensions'''
        if file_lower.endswith('.txt') or file_lower.endswith('.fa') or \
        file_lower.endswith('.fasta') or file_lower.endswith('.fna'):
            with open(self.fileFASTA, "r") as f:
                return self.ParseFASTA(f)

        elif file_lower.endswith('.txt.gz') or file_lower.endswith('.fa.gz') or \
        file_lower.endswith('.fasta.gz') or file_lower.endswith('.fna.gz'):
            with gzip.open(self.fileFASTA, "rb") as f:
                return self.ParseFASTA(f, gz=True)
        else:
            print("Not in FASTA format")

    def ParseFASTA(self, fileFASTA, gz=False):
        '''Gets the sequence name and sequence from a FASTA formatted file'''
        fasta_list=[]
        for line in fileFASTA:
            if gz==True:
                try:
                    line = line.decode()
                except (UnicodeDecodeError, AttributeError):
                    pass

            if line[0] == '>':
                try:
                    fasta_list.append(current_dna)
            	#pass if an error comes up
                except UnboundLocalError:
                    #print "Inproper file format."
                    pass
                current_dna = [line.lstrip('>').rstrip('\n'),'']
            else:
                current_dna[1] += "".join(line.split())
        fasta_list.append(current_dna)
        '''Returns fasa as nested list, containing line identifier \
            and sequence'''
        return fasta_list


def get_genomes():
    df = pd.read_csv('/N/dc2/projects/Lennon_Sequences/2019_dormancy_ead/data/bacillus_subtilis_complete.csv', sep=',')

    RefSeq = df['RefSeq FTP'].to_list()
    RefSeq = [l for l in RefSeq if str(l) != 'nan' ]
    #RefSeq = [str(l) for l in RefSeq]

    #wget  ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/006/088/795/GCA_006088795.1_ASM608879v1/* -P ./GCA_006088795.1_ASM608879v1
    for ftp in RefSeq:
        dir_name = ftp.split('/')[-1]
        #print(dir_name)
        out_path = '/N/dc2/projects/Lennon_Sequences/2019_dormancy_ead/data/refseq_genomes/' + dir_name
        os.mkdir(out_path)
        subprocess.Popen(['wget', '-P', out_path, ftp + '/*'])


def get_gene_fastas():
    #gene_dict = {}
    #count = 0
    for subdir, dirs, files in os.walk(mydir + 'data/refseq_genomes'):
        for file in files:
            if file.endswith('_cds_from_genomic.fna.gz'):
                genome = subdir.split('/')[-1]
                genome = genome.replace('.', '_')
                read_FASTA = classFASTA(os.path.join(subdir, file))
                for x in read_FASTA.readFASTA():
                    header = x[0].split(' [')
                    header = [h.replace('[', '').replace(']', '') for h in header]
                    protein_id_list = [x for x in header if 'protein_id=' in x]
                    if len(protein_id_list) == 0:
                        continue
                    protein_id = protein_id_list[0].split('=')[1].encode("utf-8")
                    protein_id = protein_id.decode("utf-8")
                    protein_id = protein_id.split('.')[0]
                    fa_path = f"{mydir}data/refseq_genes/{protein_id}.fa"
                    with open(fa_path, 'a+') as file:
                        file.write(f">{genome}\n")
                        fa_lines = textwrap.wrap(x[1], 80)
                        for fa_line in fa_lines:
                            file.write(f"{fa_line}\n")

                    file.close()


# figure out ortholog cluster



get_gene_fastas()
