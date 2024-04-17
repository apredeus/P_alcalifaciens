#!/bin/bash

TAG=$1

flye --threads 16 --genome-size 5M --nano-raw $TAG.fastq -o $TAG.flye.out &> $TAG.flye.log
mv $TAG.flye.out/assembly.fasta $TAG.flye.fa

raven -t 16 $TAG.fastq > $TAG.raven.fa 2> $TAG.raven.log
rm raven.cereal

minimap2 -x ava-ont -t16 $TAG.fastq $TAG.fastq > $TAG.paf 2> $TAG.minimap2.log
miniasm -f $TAG.fastq $TAG.paf > $TAG.gfa 2> $TAG.miniasm.log
minipolish -t16 $TAG.fastq $TAG.gfa 2> $TAG.minipolish.log | awk '/^S/{print ">"$2"\n"$3}' | fold > $TAG.miniasm.fa
rm $TAG.gfa $TAG.paf

echo "Sample $TAG: ALL DONE!"  
