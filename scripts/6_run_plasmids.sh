#!/bin/bash 

## make a table of % coverage for each plasmid

SNPDIR=/pub60/alexp/data/1_SNIPPY/

for i in `cat pass_accession.list`
do
  echo "Processing sample $i .." 
  ## make fake fastq reads from the BAM
  samtools fastq -@16 $SNPDIR/$i/snps.bam > $i.fastq
  bwa mem -t 16 S2L.rotated.fna $i.fastq 2> $i.bwa.log | samtools view -@16 -F4 -O BAM - | samtools sort -@16 -O BAM - > $i.bam
  samtools index $i.bam
  samtools coverage $i.bam > $i.coverage
done

## parse the results 

echo -e "Strain\tp128kb\tp41kb\tp4kb"
for i in `cat pass_accession.list`
do
  N1=`grep p128kb $i.coverage | awk '{printf "%.3f\n",$5/$3}'`
  N2=`grep p41kb  $i.coverage | awk '{printf "%.3f\n",$5/$3}'`
  N3=`grep p4kb   $i.coverage | awk '{printf "%.3f\n",$5/$3}'`
  echo -e "$i\t$N1\t$N2\t$N3"
done
