#!/bin/bash 

## change the location of Bakta database to your folder
## change the number of threads to what you have available 

DB=/pub60/alexp/reference/Bakta/db
FNA=P_alc_205_92_final.fna
REPS=~/P_alcalifaciens/data/replicons.tsv

bakta --threads 32 --db $DB --complete --compliant --genus Providencia --species alcalifaciens --replicons $REPS --locus-tag PA205 --output bakta.out $FNA
