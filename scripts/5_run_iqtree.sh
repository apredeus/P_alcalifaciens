#!/bin/bash

## run iqtree using AGCT-only variable sites (core.aln), but with constant site counts

## get fconst output from snp-sites -C core.full.aln
## result on our alignment: 1156062,812954,812392,1156333

iqtree -s core.aln -fconst 1156062,812954,812392,1156333 -redo -ntmax 16 -nt AUTO -st DNA -bb 1000 -alrt 1000
