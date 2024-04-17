library(ggtree)
library(ggtreeExtra)
library(fastbaps)
library(tidytree)
library(treeio)
library(patchwork)
library(pheatmap)
library(RColorBrewer)

## change as necessary; the directory needs to contain the following files:
## 1) Newick tree output from IQTree, "core.aln.treefile"; 2) metadata file "big_metadata.tsv"
## 3) Output from snp-dists on core.aln, "core_snp_distance_matrix.tsv". 
 
setwd('~/P_alcalifaciens/data')
dir() 

iqtree <- phytools::read.newick('core.aln.treefile')
## reroot to the edge with outgroup
iqtree2 <- root(iqtree, outgroup="GCA_900637755.1", edgelabel=T)
ggtree(iqtree2)

## add metadata to the tree

meta <- read.csv('big_metadata.tsv', sep='\t', row.names=1)
meta$p128kb_pres <- ifelse(meta$p128kb > 0.4, 'partial', 'none')
meta$p128kb_pres <- ifelse(meta$p128kb > 0.8, 'complete', meta$p128kb_pres)
table(meta$p128kb_pres)
meta$p41kb_pres <- ifelse(meta$p41kb  > 0.4, 'partial', 'none')
meta$p41kb_pres <- ifelse(meta$p41kb  > 0.8, 'complete', meta$p41kb_pres)
table(meta$p41kb_pres)
meta$p4kb_pres <- ifelse(meta$p4kb  > 0.4, 'partial', 'none')
meta$p4kb_pres <- ifelse(meta$p4kb  > 0.8, 'complete', meta$p4kb_pres)
table(meta$p4kb_pres)
meta$ass <- ifelse(meta$Assembly_level == "Complete", 1, 0)

### let's build a proper tree then!

meta2 <- meta[,c(6:8)]
colnames(meta2) <- c('p128kb', 'p41kb', 'p4kb')
meta3 <- data.frame(rownames(meta), meta$Strain, meta$ass)
colnames(meta3) <- c('label', 'label2', 'assembly')
iqtree3 <- full_join(iqtree2, meta3, by = "label")


### plot more-or-less final version of Figure 1C:
p <- ggtree(iqtree3) + 
  geom_tiplab(aes(subset=assembly > 0, label=label2), size=4, align=TRUE, linesize=.5, fontface='bold') + 
  geom_tiplab(aes(subset=assembly == 0, label=label2), size=4, align=TRUE, linesize=.5, fontface='plain') + 
  geom_text2(aes(subset = !isTip, label=label), nudge_x = -0.0005, size=3, check_overlap=T) + 
  theme_tree2() 
p1 <- gheatmap(p, meta2, offset=0.004, width=0.2, colnames=F, legend_title="plasmid presence") +
  scale_x_ggtree() + scale_fill_manual(breaks=c("complete", "partial", "none"), 
                    values=c("steelblue", "lightblue", "grey90"), name="plasmid presence")



### now try and make snp-dist heatmap (Figure 1D): 

## this is just core variable positions, so max about 44k SNPs can be observed
mtx1 <- read.csv('core_snp_distance_matrix.tsv', sep='\t', row.names=1)
rownames(mtx1) <- meta$Strain[match(rownames(mtx1), rownames(meta))]
colnames(mtx1) <- meta$Strain[match(colnames(mtx1), rownames(meta))]

## discrete breaks to highlight relevant distances
breaksList = c(0,100,250,500,750,1000,2000,3000,4000,5000,7500,10000,12500,15000,20000,25000,30000)

pheatmap(mtx1, color = colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(length(breaksList)),
         breaks=breaksList, cellwidth=10, cellheight=10)

