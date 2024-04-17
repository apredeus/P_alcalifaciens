#!/bin/bash

## running Trycycler; follow this guide: https://github.com/rrwick/Trycycler/wiki/Quick-start
## make sure you have Trycycler/Polypolish/raven/flye/miniasm all installed in the same env
## I've assumed you cloned https://github.com/apredeus/P_alcalifaciens to your home dir - change when necessary

## step 1: make read subsets

trycycler subsample --reads nanopore_filtlong_100x.fastq --out_dir read_subsets

## step 2: assemble read subsets; make sure you have enough RAM/CPUs, otherwise do assemblies sequentially

cd read_subsets
cp ~/P_alcalifaciens/scripts/assemble_subset.sh .

for i in 01 02 03 04 05 06 07 08 09 10 11 12
do
  ./assemble_subset.sh sample_${i} &
done 
wait

mkdir ../assemblies 
mv *raven.fa *miniasm.fa *flye.fa ../assemblies 

## step 3: select 25 best assemblies - you can judge by visualising in Bandage, or just by size/N50/number of fragments
## this needs to be done manually

## step 4: cluster

trycycler cluster --assemblies assemblies/*.fa --reads nanopore_filtlong_100x.fastq --out_dir trycycler

## step 5: inspect cluster directories and only keep the well-supported ones. this needs to be done manually. 

## step 6: reconcile clusters. If the program identifies dramatic outliers, delete them and re-run

for i in trycycler/cluster_*
do
  trycycler reconcile --reads nanopore_filtlong_100x.fastq --cluster_dir $i
done 

## step 7: run multiple sequence alignment on each reconciled cluster: 

for i in trycycler/cluster_*
do
  trycycler msa --cluster_dir $i
done

## step 8: partition the reads

trycycler partition --reads nanopore_filtlong_100x.fastq --cluster_dirs trycycler/cluster_*

## step 9: generate consensi

for i in trycycler/cluster_*
do
  trycycler consensus --cluster_dir $i
done

## step 10: concatenate the consensus for each replicon into one mega-consensus fasta
cat trycycler/cluster_*/7_final_consensus.fasta > trycycler/consensus.fasta

