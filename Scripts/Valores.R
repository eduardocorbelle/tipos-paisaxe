## Script de R para resumir o cruce de valores e unidades da paisaxe
## Eduardo Corbelle, 24 de novembro de 2015

library(xtable)

## Cargamos os datos orixinais
vbic <- read.table("ResultadosIntermedios/ValoresBic.txt",
                   sep="|", na.strings=c("NA", "no data"),
                   header=FALSE)
vcamino <- read.table("ResultadosIntermedios/ValoresCamino.txt",
                   sep="|", na.strings=c("NA", "no data"),
                   header=FALSE)
veolico <- read.table("ResultadosIntermedios/ValoresEolicos.txt",
                   sep="|", na.strings=c("NA", "no data"),
                   header=FALSE)
vnatura <- read.table("ResultadosIntermedios/ValoresNatura2000.txt",
                   sep="|", na.strings=c("NA", "no data"),
                   header=FALSE)
vSixotNat <- read.table("ResultadosIntermedios/ValoresSixotNat.txt",
                   sep="|", na.strings=c("NA", "no data"),
                   header=FALSE)
vSixotPat <- read.table("ResultadosIntermedios/ValoresSixotPat.txt",
                   sep="|", na.strings=c("NA", "no data"),
                   header=FALSE)
vSixotEst <- read.table("ResultadosIntermedios/ValoresSixotEst.txt",
                   sep="|", na.strings=c("NA", "no data"),
                   header=FALSE)

## Creamos unha táboa cos nomes das GAP e CP e o código asociado
GAPtmp <- tapply(vbic$V1, INDEX=vbic$V2, FUN=min)
GAPtmp <- GAPtmp[order(GAPtmp)]
GAP <- data.frame(ID = as.integer(GAPtmp))
rownames(GAP) <- names(GAPtmp)
rm(GAPtmp)


## Creamos unha función que calcula a porcentaxe de aparición en cada tipo e a porcentaxe de cada tipo respecto do total
porcentTipos <- function(taboa, valor, GAP=c(0:12)) {
  if(GAP==0) {
  # Selecciona os casos nos que aparece o valor identificado
  taboaB = taboa[which(taboa$V5 == 1),]
 } else {
  # Selecciona os casos nos que aparece o valor identificado
  taboaB = taboa[which(taboa$V5 == 1& taboa$V1==GAP),]
}
  # Calcula a porcentaxe que supón a súa aparición no tipo sobre o total de aparicións
  porcent = 100*taboaB$V7/sum(taboaB$V7)
  # Seleccionamos os casos maiores que o valor (en %) indicado
  taboaC = data.frame(V4=taboaB$V4,
                      porcent)[which(porcent >= valor),]
  # Calculamos a porcentaxe que supón cada tipo sobre o total da área xeográfica concreta
  if(GAP==0) {
  porcentT = 100*taboa$V7/sum(taboa$V7, na.rm=TRUE)
  suma = tapply(porcentT, taboa$V4, sum)
  } else {
  porcentT = 100*taboa$V7[taboa$V1==GAP]/sum(taboa$V7[taboa$V1==GAP], na.rm=TRUE)
  suma = tapply(porcentT, taboa$V4[taboa$V1==GAP], sum)
  }
  taboaD = data.frame(V4 = names(suma),
                      porcentT = as.numeric(suma))
  # Xuntamos as dúas táboas
  taboaE = merge(taboaC, taboaD, all.x=TRUE)
  # Ordenamos a táboa e devolvemos o resultado
  taboaF = taboaE[order(taboaE$porcent, decreasing=TRUE),]
  taboaG = data.frame(taboaF, 
                      taboaF[[2]]/taboaF[[3]])
  colnames(taboaG) = c("Tipo de paisaxe", "F.Aparic (%)", "F.Tipo (%)", "Ratio")
  return(taboaG)
}

## Creamos unha función que exporta a táboa cara LaTeX
exportT <- function(taboa, valor, GAP, file, caption, label) {
  # taboa: taboa sobre a que facer os cálculos
  # valor: % mínimo de aparición do valor
  # GAP: Grande área paisaxística
  # file: ruta do ficheiro
  # caption: título da táboa
  # label: etiqueta ("label") para latex
  require(xtable)
  tx = xtable(porcentTipos(taboa, valor, GAP), caption, label)
  print.xtable(tx, type="latex",
               file, append=TRUE,
               floating=TRUE, table.placement="p", caption.placement="top",
               latex.environments=c("center"),
               include.rownames=FALSE)
}


## Exportamos
for(i in 1:12) {
exportT(vbic, 1, i,
        "Informes/Taboas/valoresbic.tex",
        paste("Frecuencia de aparición de BIC e frecuencia de tipos asociados, GAP", rownames(GAP)[i]),
        paste("vbic", i, sep=""))
exportT(vcamino, 1, i,
        "Informes/Taboas/valorescamino.tex",
        paste("Frecuencia de aparición dos Camiños de Santiago (área de influencia de 500 m a ambos lados) e frecuencia de tipos asociados", rownames(GAP)[i]),
        paste("vcamino", i, sep=""))
exportT(veolico, 1, i,
        "Informes/Taboas/valoreseolico.tex",
        paste("Frecuencia de aparición de xeneradores eólicos e frecuencia de tipos asociados", rownames(GAP)[i]),
        paste("veolico", i, sep=""))
exportT(vnatura, 1, i,
        "Informes/Taboas/valoresnatura.tex",
        paste("Frecuencia de aparición de Lugares de Importancia Comunitaria e frecuencia de tipos asociados", rownames(GAP)[i]),
        paste("vnatura", i, sep=""))
exportT(vSixotNat, 1, i,
        "Informes/Taboas/valoressixotNat.tex",
        paste("Frecuencia de aparición de valores naturais identificados na participación pública e frecuencia de tipos asociados", rownames(GAP)[i]),
        paste("vsixotnat", i, sep=""))
exportT(vSixotPat, 1, i,
        "Informes/Taboas/valoressixotPat.tex",
        paste("Frecuencia de aparición de valores patrimoniais identificados na participación pública e frecuencia de tipos asociados", rownames(GAP)[i]),
        paste("vsixotpat", i, sep=""))
exportT(vSixotEst, 1, i,
        "Informes/Taboas/valoressixotEst.tex",
        paste("Frecuencia de aparición de valores estéticos identificados na participación pública e frecuencia de tipos asociados", rownames(GAP)[i]),
        paste("vsixotest", i, sep=""))
}

