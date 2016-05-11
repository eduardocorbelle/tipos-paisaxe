## Script de R para crear as figuras a incorporar no informe 1
## Eduardo Corbelle, 20 agosto 2015

## Cargamos os paquetes necesarios
library(raster)
library(RColorBrewer) 

## Cargamos a imaxe "cubertas"
cubertas <- as.factor(raster("ResultadosIntermedios/Cubertas.img"))

## Categorías do mapa de cubertas
cat <- read.table("ResultadosIntermedios/CategoriasCuberta.txt", sep="\t")

## Coordenadas das escenas de referencia e categorías de paisaxe
esc <- read.table("Escenas/escenasCubertaC.txt", sep=",", skip=2)
colnames(esc) <- c("id", "x", "y", "Clase")

## Función para producir os gráficos
figura <- function(i) {
  # Coordenadas da escena a representar
  x = esc$x[i]
  y = esc$y[i]
  # Anchura de recorte
  b = 4000 # en metros
  # Recorte do mapa orixinal
  area = extent(c(x+c(-b,b), y+c(-b,b)))
  reco = crop(cubertas, area)
  # Paleta de cores
  cor = brewer.pal(12, "Paired")
  ## Parámetros do ficheiro resultante
  # Gráfico de 8 cm de altura, equiv. a 8 km a escala 1:25.000
  png(paste("Informes/Figuras/Escena_", esc$id[i], ".png", sep=""),
      width=12, height=12/1.5, units="cm", 
      res=300, pointsize=10)
  ## Preparación do espazo (2 espazos de debuxo)
  layout(matrix(c(1,1,2,1,1,2), 2, 3, byrow=TRUE))
  ## Primeiro espazo de debuxo
  par(mar=c(2,2,2,2), oma=c(0,0,0,0))
  image(reco, col=cor[as.numeric(levels(as.factor(reco@data@values)))-1], 
        xlim=x+c(-b,b),
        ylim=y+c(-b,b),
        cex.axis=.95,
        maxpixels=1.5e5,
        main= paste("Escena", esc$id[i], "-", esc$Clase[i]))
  points(x, y, pch=1, 
         col="white", cex=66*1/8) # para esta imaxe, cex=66 equivale a 8km diámetro
  ## Segundo espazo de debuxo
  par(mar=c(0,0,2,0))
  plot(0,0, col="white", axes=FALSE)
  legend("topleft", 
         legend=cat$V2,
         fill = cor[cat$V1-1],
         border=cor[cat$V1-1],
         bty="n",
         title= "Uso/cuberta do solo",
         cex=0.7)
  ## Peche do dispositivo png
  dev.off()
}

## Bucle para producir tódolos gráficos
for(i in 1:length(esc$id)) {
figura(i)
}
