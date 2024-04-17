#!/bin/bash

## commands used to clean/filter Illumina and Nanopore reads 

bbduk.sh in1=S2L_1_S32_R1_001.fastq.gz in2=S2L_1_S32_R2_001.fastq.gz out1=Ill.bbduk.R1.fastq out2=Ill.bbduk.R2.fastq ref=/pub60/alexp/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo &> bbduk.log

filtlong -1 Ill.bbduk.R1.fastq -2 Ill.bbduk.R2.fastq --min_length 1000 --keep_percent 90 --target_bases 500000000 --trim --split 500 nanopore_all.fastq > nanopore_filtlong_100x.fastq

