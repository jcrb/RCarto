#Timothée Giraud, UMS RIATE, 2012
#Script pour cartographie en cercles proportionnelles
#QUANTI/Sciences sociales

#chargement des packages nécessaires
library(RColorBrewer)
library(maptools)

#nettoyage de l'espace de travail / attention, cette commande est à utiliser 
#avec précaution, elle effacera tous les objets R créés dans la session 
#courante!
rm(list=ls())

#Fermeture de fenêtres graphiques éventuellement ouvertes
dev.off()

#definition du dossier de travail ou se trouvent les données et le fond de carte
setwd("Le_chemin_de_mon_dossier_de_travail")

#import des données à cartographier
dt <- read.csv( "data.csv",header=TRUE,sep=";",dec=",",skip=1)

#import du fond de carte
fdc <- readShapeSpatial("COMMUNE")

#création d'un dataframe avec les coordonnées des centroides des communes
pt <- cbind(fdc@data[,"INSEE_COM"],as.data.frame(coordinates(fdc)))

#renommage des colonnes de ce dataframe
colnames(pt) <- c("Code","x","y")

#jointure entre le dataframe des coordonnées des centroides et les données à cartographier
pt <- merge(pt,dt, by.x="Code",by.y="CODGEO", all.x=TRUE)

#extension maximale du fond de carte
#la fonction bbox donne les coordonnées max et min du fond de carte
x1 <- bbox(fdc)[1]
y1 <- bbox(fdc)[2]
x2 <- bbox(fdc)[3]
y2 <- bbox(fdc)[4]

#surface maximale de la carte
sfdc <- (x2-x1)*(y2-y1)

#somme de la variable à cartographier
sc <- sum(pt$P09_POP,na.rm=TRUE)

#création d'une variable contenant les rayons des cercles à représenter
pt$var <- sqrt((pt$P09_POP*0.1*sfdc/sc)/pi) #la somme des surfaces des cercles 
#représentera ici 10% (0.1) de la surface de la carte

#tri du dataframe de manière à ce que les cercles soient dessiner du plus gros 
#au plus petit
pt <- pt[order(pt$var,decreasing=TRUE),]

#affichage de la carte
plot(fdc, border="Grey", col="#FEE08B")
symbols(pt[,c("x","y")],circles=pt$var,add=TRUE,bg="#C7E9C0",inches=FALSE)
#la fonction symbols() dessine des cercles d’un diamètre donné

#affichage de la légende
rLeg <- quantile(pt$var,c(1,0.9,0.25,0),type=1)
rVal <- quantile(pt$P09_POP,c(1,0.9,0.25,0),type=1)
l <- NULL
l$x <- x1
l$y <- y1
xinit <- l$x+rLeg[1]
ypos <- l$y+rLeg
symbols(x=rep(xinit,4),y=ypos,circles=rLeg,add=TRUE,bg="#C7E9C0",inches=FALSE)
text(x=rep(xinit,4)+rLeg[1]*1.2,y=(l$y+(2*rLeg)),rVal,cex=0.5,srt=0,adj=0)
for (i in 1:4){
  segments (xinit,(l$y+(2*rLeg[i])),xinit+rLeg[1]*1.1,(l$y+(2*rLeg[i])))
}
text(x=xinit-rLeg[1],y=(l$y+(2*rLeg[1])),"Population communale 
en 2009\n",adj=c(0,0),cex=0.6)

#titre et sous titres
title(main="Répartition de la population en Martinique",
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