#' データフレームをグラフ形式に変換する
#'
#' @param df    データ (data.frame)
#' @param left  辺のsourceのラベルの列 (chr)
#' @param right 辺のdestinationのラベルの列 (chr)
#'
#' @return グラフ型データ (igraph)
#' @export
#' @details 
#' データは1行につき辺1つになっていること
#' プロパティの付与はしない (辺のみのデータにする)
#'
#' @examples
#' df <- fread("data/HomoSapiens_binary_hq.txt", data.table = F)
#' convert_graph(df, left = "Gene_A", right = "Gene_B")
#' 
convert_graph <- function(df, left, right) {
  
  
}
