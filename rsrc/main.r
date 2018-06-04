# project: protein_graph
# author : drsenri (H.Shibata)
# date   : 2018/05/30~
# analysis of protein network between species

# usage:
# cd protein_graph
# Rscript rsrs/main.r

# import ------------------------------------------------------------------
require(tidyverse)
require(data.table)
require(doParallel)
require(graphkernels)
require(maptools)

# read_data ---------------------------------------------------------------
# all files were downloaded from http://hint.yulab.org/download/ at 2018/05/30

d <- dir("data", full.names = T) %>% lapply(fread, data.table = F)
names(d) <- dir("data") %>% str_remove("_binary_hq.txt$") # names = Species

# convert to graph --------------------------------------------------------

d_graph <- d %>% map(convert_graph, left = "Gene_A", right = "Gene_B")

# WL kernel ---------------------------------------------------------------

WLmat <- CalculateWLKernel(d_graph, 5) %>% as.data.frame()
names(WLmat) <- names(d_graph)

# k-means ---------------------------------------------------------------------

res <- kmeans(WLmat, 3)
cluster <- res$cluster
names(cluster) <- names(d_graph)

# plot --------------------------------------------------------------------

pca <- WLmat %>% prcomp
dir.create("output")
png("output/180604_species_cluster.png")
plot(x = pca$x[,1], y = pca$x[,2], col = cluster)
pointLabel(x = pca$x[,1], y = pca$x[,2], label = names(cluster))
dev.off()