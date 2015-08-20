## Script de R para crear as figuras a incorporar no informe 1
## Eduardo Corbelle, 20 agosto 2015
## Para ser executado desde a sesión de GRASS

## Cargamos os paquetes necesarios
#library(rgdal)
library(rgrass7)
#library(raster)
#library(maptools)
library(RColorBrewer) 
#library(ggplot2)

## Cargamos os parámetros da localización de GRASS
G = gmeta()

## Cargamos a imaxe "cubertas" desde GRASS
cubertas <- readRAST("cubertas", cat=FALSE, ignore.stderr=TRUE)



# Valores iniciais: coordenadas dos puntos e cores do gráfico
coor <- data.frame(x=552000, y=4752000)
cores <- brewer.pal(5, "Set1")










## Figura en .png

png("Figura1.png", width=12, height=12/1.5, units="cm", res=300, pointsize=10)
# Gráfico de 8 cm de altura, equiv. a 8 km a escala 1:25.000
layout(matrix(c(1,1,2,1,1,2), 2, 3, byrow=TRUE))
par(mar=c(0,0,0,0), oma=c(0,0,0,0))

image(cubertas, col=cores, 
     xlim=c(coor$x-4000, coor$x+4000),
     ylim=c(coor$y-4000, coor$y+4000)
)

points(coor$x, coor$y, pch=1, col="white", cex=76*(1.5/8)) # para esta imaxe, cex=76 equivale a 8km diámetro

par(mar=c(1,1,1,1))
plot(NA,NA, axes=FALSE)

legend("topleft", 
       legend=c("1","2","3", "4", "5"),
       fill = cores,
       border=cores,
       bty="n")

dev.off()
