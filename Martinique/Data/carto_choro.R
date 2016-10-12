#Timothée Giraud, UMS RIATE, 2012
#Script pour cartographie choroplète
#QUANTI/Sciences sociales

#chargement des packages nécessaires
library(RColorBrewer)
library(maptools)
library(classInt)

#nettoyage de l'espace de travail / attention, cette commande est à utiliser 
#avec précaution, elle effacera tous les objets R créés dans la session 
#courante!
rm(list=ls())

#fermeture de fenêtres graphiques éventuellement ouvertes
dev.off()

#definition du dossier de travail ou se trouvent les données et le fond de carte
setwd("Le_chemin_de_mon_dossier_de_travail")

#import des données à cartographier
dt <- read.csv( "data.csv",header=TRUE,sep=";",dec=",",skip=1)

#création de la variable VAR_POP du taux d’accroissement de la population 
dt$VAR_POP <- (dt$P09_POP-dt$P99_POP) / dt$P99_POP

#import du fond de carte
fdc <- readShapeSpatial("COMMUNE")

#jointure entre le fond de carte et les données
fdc@data <- merge(fdc@data,dt, by.x="INSEE_COM",by.y="CODGEO", all.x=TRUE)

#discrétisation en 4 classes (quantiles)
distr <- classIntervals(fdc$VAR_POP,4,style="quantile")$brks

#choix d'une gamme de couleurs
#pour voir les palettes disponibles : display.brewer.all()
colours <- brewer.pal(4,"PuOr")

#optionnel - codes des couleurs utilisées
colours

#attribution des couleurs aux régions
colMap <- colours[(findInterval(fdc$VAR_POP,distr,all.inside=TRUE))]

#fonction de gestion d'affichage des bornes de la légende
#fonction de calcul des bornes de la légende
myLeg <- function (vec, arrond) {
  x <- vec
  lx <- length(x)
  if (lx < 3) 
    stop("pas suffisamment de classes")
  res <- character(lx - 1)
  res
  for (i in 1:(lx - 1))
  {res[i] <- paste(round(x[i],arrond), round(x[i + 1],arrond),sep=" - ")
  }
  res
}

#affichage de la carte
plot(fdc, col=colMap)

#affichage de la légende
legend("bottomleft", legend=myLeg(distr,2),pch=22, 
       pt.bg=colours, bty="n",
       title="Taux d'accroissement\ndémographique de 1999 à 2009",
       title.adj=0.5, xpd=TRUE,y.intersp=1,xjust=0,adj=0,
       pt.cex=1.3,cex=0.7)
#l’introduction de la chaine de caractère « \n » entraine un saut de ligne dans 
#le texte à afficher

#titre et sous titres
title(main="Evolution de la population en Martinique",
      sub="Auteur: Timothée Giraud, UMS RIATE, 2012\nSource: IGN (fond de carte GEOFLA), INSEE (Recensement de la population)",
      cex.sub=0.7)

#affichage de l'échelle
l <- locator(n=1)   #cliquer dans la fenêtre graphique à l'endroit choisi
SpatialPolygonsRescale(layout.scale.bar(),offset=c(l$x,l$y),scale=5000,
                       fill=c("black"),plot.grid=F)
text(l$x+5000/2,l$y,paste("5 km","\n\n",sep=""),cex=0.7)
  
#ajout d'une flèche nord
l <- locator(n=1)   #idem
SpatialPolygonsRescale(layout.north.arrow(2),offset=c(l$x,l$y),scale=5000,
                       plot.grid=F)
					   
#exportation
#formats disponibles
#.emf, .eps, .pdf, .png, .bmp, .tiff, .jpg
#savePlot(nom, type="format")