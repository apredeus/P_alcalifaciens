#!/bin/bash 

## download all of the necessary genome sequences from NCBI (see list of IDs in /data/accessions.list)
## rename all of the genomes to simplified names, see /data/rename.tsv
## inflate all of the renamed sequences + our assembled genome (P_alc_205_92_final.fna) and put them into $FNADIR

FNADIR=/pub60/alexp/data/0_FNA

for i in `cat accessions.list`
do
  snippy --cpus 1 --outdir $i --ref $FNADIR/P_alc_205_92_final.fna --ctgs $FNADIR/$i.fna &
done 

wait

## after this, remove the folders for the low-quality genomes, and only after this run

snippy-core --prefix core GCA*

snp-dists core.aln > core_snp_distance_matrix.tsv
