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

# read_data ---------------------------------------------------------------
# all files were downloaded from http://hint.yulab.org/download/ at 2018/05/30
