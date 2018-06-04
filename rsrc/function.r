#' データフレームをグラフ形式に変換する
#'
#' @param df       データ (data.frame)
#' @param left     辺のsourceのラベルの列 (chr)
#' @param right    辺のdestinationのラベルの列 (chr)
#' @param directed グラフの有向・無向 (logical)
#'
#' @return グラフ型データ (igraph)
#' @export
#' @details 
#' データは1行につき辺1つになっていること
#' プロパティの付与はしない (辺のみのデータにする)
#'
#' @examples
#' df <- data.frame(Gene_A = c("RRP9", "TRIM21", "PSMA7", "RPS16", "TRIM23"),
#'  Gene_B = c("RAP2A", "TXN2", "PSMB7", "ESR2", "RSRC2"), sources = c("HT", "HT", "LC", "HT", "HT"))
#' convert_graph(df, left = "Gene_A", right = "Gene_B")
#' 
convert_graph <- function(df, left, right, directed = F)
  df %>% select(left, right) %>% graph_from_data_frame(directed = directed)

