# calcul de la distance euclidienne entre deux points
#'@source ElementR. R pour les cartographes pp 72
#'@param x1,y1 point 1, x2,y2 point 2
#'
dist.euclidienne <- function(x1, y1, x2, y2){
        sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)
}