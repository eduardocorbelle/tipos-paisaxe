## Script de R para resumir o cruce de valores e unidades da paisaxe
## Versión para exportar o resultado en formato .docx
## Eduardo Corbelle, 13 de xaneiro de 2016

library(ReporteRs)


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
  porcent = round(100*taboaB$V7/sum(taboaB$V7),2)
  # Seleccionamos os casos maiores que o valor (en %) indicado
  taboaC = data.frame(V4=taboaB$V4,
                      porcent)[which(porcent >= valor),]
  # Calculamos a porcentaxe que supón cada tipo sobre o total da área xeográfica concreta
  if(GAP==0) {
  porcentT = round(100*taboa$V7/sum(taboa$V7, na.rm=TRUE),2)
  suma = tapply(porcentT, taboa$V4, sum)
  } else {
  porcentT = round(100*taboa$V7[taboa$V1==GAP]/sum(taboa$V7[taboa$V1==GAP], na.rm=TRUE),2)
  suma = tapply(porcentT, taboa$V4[taboa$V1==GAP], sum)
  }
  taboaD = data.frame(V4 = names(suma),
                      porcentT = round(as.numeric(suma),2))
  # Xuntamos as dúas táboas
  taboaE = merge(taboaC, taboaD, all.x=TRUE)
  # Ordenamos a táboa e devolvemos o resultado
  taboaF = taboaE[order(taboaE$porcent, decreasing=TRUE),]
  taboaG = data.frame(taboaF, 
                      round(taboaF[[2]]/taboaF[[3]],2))
  colnames(taboaG) = c("Tipo de paisaxe", "F.Aparic (%)", "F.Tipo (%)", "Ratio")
  return(taboaG)
}






## Exportamos
doc = docx()
doc = addParagraph( doc, "Valores e unidades da paisaxe", stylename = "TitleDoc" )


for(i in 1:12) {

doc = addTitle( doc, paste("GAP", rownames(GAP)[i]), level = 1 )  

tx = FlexTable(porcentTipos(vbic, 1, i), add.rownames=FALSE)
tx = setFlexTableWidths(tx, widths=c(7,3,3,3)/2.54)
doc = addTitle( doc, "Frecuencia de aparición de BIC e frecuencia de tipos asociados", level = 2 )  
doc = addFlexTable(doc, tx)

if(i!=10){
tx = FlexTable(porcentTipos(vcamino, 1, i), add.rownames=FALSE)
tx = setFlexTableWidths(tx, widths=c(7,3,3,3)/2.54)
doc = addTitle( doc, "Frecuencia de aparición dos Camiños de Santiago (área de influencia de 500 m a ambos lados) e frecuencia de tipos asociados", level = 2 )  
doc = addFlexTable(doc, tx)
}


tx = FlexTable(porcentTipos(veolico, 1, i), add.rownames=FALSE)
tx = setFlexTableWidths(tx, widths=c(7,3,3,3)/2.54)
doc = addTitle( doc, "Frecuencia de aparición de xeneradores eólicos e frecuencia de tipos asociados", level = 2 )  
doc = addFlexTable(doc, tx)

tx = FlexTable(porcentTipos(vnatura, 1, i), add.rownames=FALSE)
tx = setFlexTableWidths(tx, widths=c(7,3,3,3)/2.54)
doc = addTitle( doc, "Frecuencia de aparición de Lugares de Importancia Comunitaria e frecuencia de tipos asociados", level = 2 )  
doc = addFlexTable(doc, tx)

tx = FlexTable(porcentTipos(vSixotNat, 1, i), add.rownames=FALSE)
tx = setFlexTableWidths(tx, widths=c(7,3,3,3)/2.54)
doc = addTitle( doc, "Frecuencia de aparición de valores naturais identificados na participación pública e frecuencia de tipos asociados", level = 2 )  
doc = addFlexTable(doc, tx)


tx = FlexTable(porcentTipos(vSixotPat, 1, i), add.rownames=FALSE)
tx = setFlexTableWidths(tx, widths=c(7,3,3,3)/2.54)
doc = addTitle( doc, "Frecuencia de aparición de valores patrimoniais identificados na participación pública e frecuencia de tipos asociados", level = 2 )  
doc = addFlexTable(doc, tx)


tx = FlexTable(porcentTipos(vSixotEst, 1, i), add.rownames=FALSE)
tx = setFlexTableWidths(tx, widths=c(7,3,3,3)/2.54)
doc = addTitle( doc, "Frecuencia de aparición de valores estéticos identificados na participación pública e frecuencia de tipos asociados", level = 2 )  
doc = addFlexTable(doc, tx)

}

writeDoc( doc, file = "Informes/Taboas/ValoresTipos.docx" )

