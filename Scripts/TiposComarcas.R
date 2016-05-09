### Script para desglosar as clases de paisaxe por comarca dentro de cada GAP
### Eduardo Corbelle, 14 de decembro de 2015

## Cargamos os datos orixinais
datos <- read.table("ResultadosIntermedios/TiposAreasComarcas.txt", sep="|", header=FALSE)
colnames(datos) <- c("GAPcode", "GAP", "CPcode", "CP",  "CXn", "CXt", "CCn", "CCt", "Cln", "Clt", "Aream2")

## Función para a equivalencia entre códigos e comarcas
tab0 <- tapply(datos$CPcode, INDEX=datos$CP, FUN=min)[-23]
tab0 <- tab0[order(tab0)]
taboa0 <- data.frame("Código" = as.integer(tab0))
rownames(taboa0) <- names(tab0)
rm(tab0)

## Función para extraer a distribución de clases por comarca, dentro de cada GAP
clasesCom <- function(taboa, GAP, clase) {
   T2 = taboa[which(taboa$GAPcode==GAP),]
   T2 = as.data.frame(lapply(T2, function(x) if(is.factor(x)) factor(x) else x))
   
   T3 = tapply(T2$Aream2, INDEX=list(T2[,clase], factor(T2$CPcode)), FUN=sum, na.rm=TRUE)  
   T4 = apply(T3, MARGIN=c(1,2), FUN=function(x) if(is.na(x)) 0 else x/1000000)
   T5 = round(prop.table(T4, 2)*100,1)
   return(T5)
}

   
## Exportamos as táboas resultantes a un documento de MS Word
library(ReporteRs)

doc = docx()

doc = addParagraph(doc, "Distribución de clases de paisaxe por comarcas dentro de cada GAP", stylename = "TitleDoc")

doc = addTitle(doc, "Códigos de comarca", level=1)
Comarcas = FlexTable(data=taboa0, add.rownames=TRUE)
Comarcas = setFlexTableWidths(Comarcas, widths=c(10,2)/2.54)
doc = addFlexTable(doc, Comarcas)
doc <- addPageBreak( doc )

for(i in 1:12) {
doc = addTitle(doc, paste("Comarcas da GAP", i), level=1) 
for(j in c("CXt", "CCt", "Clt")) {
tmp = clasesCom(datos, i, j)
Taboa = FlexTable(data= tmp, add.rownames=TRUE)
Taboa = setFlexTableWidths(Taboa, widths=c(5.5, rep(1.5,ncol(tmp)))/2.54)
doc = addFlexTable(doc, Taboa)
doc <- addPageBreak( doc )
rm(tmp)
}
}

writeDoc( doc, file= "Informes/Taboas/ClasesComarcas.docx" )

