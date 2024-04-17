#!/bin/bash 

## unicycler assembly to recover the small plasmid

unicycler -t 32 -1 Ill.bbduk.R1.fastq -2 Ill.bbduk.R2.fastq -l nanopore_filtlong_100x.fastq -o unicycler.out &> unicycler.log
