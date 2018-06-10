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
require(cluster)
require(maptools)
source("rsrc/function.r", encoding = "utf-8")

# read_data ---------------------------------------------------------------
# all files were downloaded from http://hint.yulab.org/download/ at 2018/05/30

clust_species <- function() {
  
  d <- dir("data", full.names = T) %>% lapply(fread, data.table = F)
  names(d) <- dir("data") %>% str_remove("_binary_hq.txt$") # names = Species
  
  # convert to graph --------------------------------------------------------
  
  d_graph <- d %>% map(convert_graph, left = "Gene_A", right = "Gene_B")
  
  # WL kernel ---------------------------------------------------------------
  
  WLmat <- CalculateWLKernel(d_graph, 5) %>% as.data.frame()
  names(WLmat) <- names(d_graph)
  
  # k-means ---------------------------------------------------------------------
  
  # decide k (based on gap statistic)
  gap <- clusGap(WLmat, kmeans, K.max = 10, B = 100, verbose = interactive())
  gap_score <- gap$Tab[,"gap"]
  gap_se <- gap$Tab[,"SE.sim"]
  k <- min(which(gap_score - lag(gap_score, 1)  + lag(gap_se, 1) > 0)) # gap(k) >= gap(k+1) - SE.sim(k+1)となる最小のkを探す

  # clustering
  res <- kmeans(WLmat, k)
  cluster <- res$cluster
  names(cluster) <- names(d_graph)
  
  # plot --------------------------------------------------------------------
  
  # manually plot
  pca <- WLmat %>% prcomp(scale = T)
  if (!dir.exists("output"))
    dir.create("output")
  png("output/180604_species_cluster.png")
  plot(x = pca$x[,1], y = pca$x[,2], col = cluster, cex = 1, pch = 15)
  pointLabel(x = pca$x[,1], y = pca$x[,2], label = names(cluster), col = cluster)
  dev.off()
}


# analysis on human protein network ---------------------------------------------------

g <- fread("data/HomoSapiens_binary_hq.txt", data.table = F) %>% convert_graph(left = "Gene_A", right = "Gene_B")
proteins <- vertex_attr(g)$name
gl <- foreach(i = seq(proteins)) %do% induced_subgraph(g, proteins[i])
names(gl) <- proteins

