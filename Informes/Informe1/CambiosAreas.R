## Script de R para resumir os cambios de cuberta estimados a partir do MCA por grandes áreas e comarcas

library(xtable)

## Cargamos os datos orixinais
cambiosGAP <- read.table("/Informes/Informe1/CambiosGAP_2015_10_09.txt", 
                         sep="|", na.strings=c("NA", "no data"), header=FALSE)
colnames(cambiosGAP) <- c("GAPid","GAP","cub89id","cub89","cub09id","cub09","Aream2")

cambiosCP <- read.table("./Informes/Informe1/CambiosComarcas_2015_10_09.txt",
                        sep="|", na.strings=c("NA", "no data"), header=FALSE)
colnames(cambiosCP) <- c("CPid","CP","cub89id","cub89","cub09id","cub09","Aream2")

## Reordenamos os niveis dos factores cub89 e cub09
cambiosGAP$cub89 <- factor(cambiosGAP$cub89, levels=c("SAU", "Mato", "Arb-plant", "Arb-revex", "Artificial"))
cambiosCP$cub89 <- factor(cambiosCP$cub89, levels=c("SAU", "Mato", "Arb-plant", "Arb-revex", "Artificial"))
cambiosGAP$cub09 <- factor(cambiosGAP$cub09, levels=c("SAU", "Mato", "Arb-plant", "Arb-revex", "Artificial"))
cambiosCP$cub09 <- factor(cambiosCP$cub09, levels=c("SAU", "Mato", "Arb-plant", "Arb-revex", "Artificial"))

## Creamos unha táboa cos nomes das GAP e CP e o código asociado
GAPtmp <- tapply(cambiosGAP$GAPid, INDEX=cambiosGAP$GAP, FUN=min)
GAPtmp <- GAPtmp[order(GAPtmp)]
GAP <- data.frame(ID = as.integer(GAPtmp))
rownames(GAP) <- names(GAPtmp)
rm(GAPtmp)

CPtmp <- tapply(cambiosCP$CPid, INDEX=cambiosCP$CP, FUN=min)
CPtmp <- CPtmp[order(CPtmp)]
CP <- data.frame(ID = as.integer(CPtmp))
rownames(CP) <- names(CPtmp)
rm(CPtmp)

## Creamos unha función para producir táboas de continxencia para unha determinada GAP ou CP

contin <- function(ID, t) {
  # ID: identificador de GAP ou CP (número enteiro)
  # t: obxecto tipo data.frame sobre o que producir a análise  
  selec = which(t[[1]]==ID)
  t2 = t[selec,]
  cambios = tapply(t2$Aream2, list(t2$cub89, t2$cub09), function(x) { round(sum(x)/1000000, 2) })
  return(cambios)
}

## Creamos unha función que exporta a táboa cara LaTeX (km2)
exportT <- function(ID, ud, file) {
  # ID: identificador de GAP ou CP (número enteiro)
  # ud: CP ou GAP (texto)
  # file: ruta do ficheiro
  require(xtable)
  if(ud=="GAP") {
  caption = paste("Cambios de cuberta 1985--2005 (km²),", rownames(GAP)[ID], "(GAP", GAP[ID,], ")")
  label = paste("TaboaContinx", "GAP", ID, sep="")
  tx = xtable(contin(ID, cambiosGAP), caption, label)
  print.xtable(tx, type="latex",
               file, append=TRUE,
               floating=TRUE, table.placement="p", caption.placement="top",
               latex.environments=c("center"))
} else {
  caption = paste("Cambios de cuberta 1985--2005 (km²),", rownames(CP)[ID], "(CP", CP[ID,], ")")
  label = paste("TaboaContinx", "CP", ID, sep="")
  tx = xtable(contin(ID, cambiosCP), caption, label)
  print.xtable(tx, type="latex",
               file, append=TRUE,
               floating=TRUE, table.placement="p", caption.placement="top",
               latex.environments=c("center"))
}
}

## Creamos unha función que exporta a táboa cara LaTeX (porcentaxe sobre total da área)
exportPT <- function(ID, ud, file) {
  # ID: identificador de GAP ou CP (número enteiro)
  # ud: CP ou GAP (texto)
  # file: ruta do ficheiro
  require(xtable)
  if(ud=="GAP") {
  caption = paste("Cambios de cuberta 1985--2005 (porcentaxe sobre o total da área),", rownames(GAP)[ID], "(GAP", GAP[ID,], ")")
  label = paste("TaboaContinxPT", "GAP", ID, sep="")
  tx = xtable(round(100*prop.table(contin(ID, cambiosGAP)),2), caption, label)
  print.xtable(tx, type="latex",
               file, append=TRUE,
               floating=TRUE, table.placement="p", caption.placement="top",
               latex.environments=c("center"))
} else {
  caption = paste("Cambios de cuberta 1985--2005 (porcentaxe sobre o total da área),", rownames(CP)[ID], "(CP", CP[ID,], ")")
  label = paste("TaboaContinxPT", "CP", ID, sep="")
  tx = xtable(round(100*prop.table(contin(ID, cambiosCP)),2), caption, label)
  print.xtable(tx, type="latex",
               file, append=TRUE,
               floating=TRUE, table.placement="p", caption.placement="top",
               latex.environments=c("center"))
}
}

## Creamos unha función que exporta a táboa cara LaTeX (porcentaxe sobre total da fila)
exportPF <- function(ID, ud, file) {
  # ID: identificador de GAP ou CP (número enteiro)
  # ud: CP ou GAP (texto)
  # file: ruta do ficheiro
  require(xtable)
  if(ud=="GAP") {
  caption = paste("Cambios de cuberta 1985--2005 (porcentaxe sobre o total da fila),", rownames(GAP)[ID], "(GAP", GAP[ID,], ")")
  label = paste("TaboaContinxPF", "GAP", ID, sep="")
  tx = xtable(round(100*prop.table(contin(ID, cambiosGAP),1),2), caption, label)
  print.xtable(tx, type="latex",
               file, append=TRUE,
               floating=TRUE, table.placement="p", caption.placement="top",
               latex.environments=c("center"))
} else {
  caption = paste("Cambios de cuberta 1985--2005 (porcentaxe sobre o total da fila),", rownames(CP)[ID], "(CP", CP[ID,], ")")
  label = paste("TaboaContinxPF", "CP", ID, sep="")
  tx = xtable(round(100*prop.table(contin(ID, cambiosCP),1),2), caption, label)
  print.xtable(tx, type="latex",
               file, append=TRUE,
               floating=TRUE, table.placement="p", caption.placement="top",
               latex.environments=c("center"))
}
}

## Xeramos as táboas para GAP e CP
system("rm tipos-paisaxe/Informes/Informe1/CambiosGAP.tex")
system("rm tipos-paisaxe/Informes/Informe1/CambiosCP.tex")

for(i in 1:12) {
  exportT(i, "GAP", "tipos-paisaxe/Informes/Informe1/CambiosGAP.tex")
  exportPT(i, "GAP", "tipos-paisaxe/Informes/Informe1/CambiosGAP.tex")
  exportPF(i, "GAP", "tipos-paisaxe/Informes/Informe1/CambiosGAP.tex")
  write("\\clearpage", file="tipos-paisaxe/Informes/Informe1/CambiosGAP.tex", append=TRUE)
}

for(i in 1:50) {
  exportT(i, "CP", "tipos-paisaxe/Informes/Informe1/CambiosCP.tex")
}



### Exportar a MS Word
# (http://stackoverflow.com/questions/25425993/data-frame-to-word-table)
library(ReporteRs)

# Crear un obxecto docx
doc = docx()
# add a document title
doc = addParagraph( doc, "Cambios de cuberta entre MCA1980-1989 e MCA2000-2009", stylename = "TitleDoc" )
# add a section title
doc = addTitle( doc, "Numeración de grandes áreas", level = 1 )

# add a table
grandesareas = FlexTable( data = GAP, add.rownames = TRUE )
grandesareas = setFlexTableWidths(grandesareas, widths=c(10,3)/2.54)
doc = addFlexTable(doc, grandesareas)

doc = addTitle( doc, "Numeración de comarcas", level = 1 )
# add a section title
# add a table
comarcas = FlexTable( data = CP, add.rownames = TRUE )
comarcas = setFlexTableWidths(comarcas, widths=c(10,3)/2.54)
doc = addFlexTable(doc, comarcas)

# add a section title
doc = addTitle( doc, "Principais cambios por gran área paisaxística (km²)", level = 1 )

for(i in 1:12) {
# A) Cambios en km²
doc = addTitle( doc, paste("GAP número", i, "(km²)"), level = 2)
Taboa = FlexTable( data= contin(i, cambiosGAP), add.rownames = TRUE)
Taboa = setFlexTableWidths(Taboa, widths=c(5,2,2,2,2,2)/2.54)
doc = addFlexTable(doc, Taboa)
}

# add a section title
doc = addTitle( doc, "Principais cambios por gran área paisaxística (porcentaxe sobre a cuberta anterior)", level = 1 )
for(i in 1:12) {
# A) Cambios en % sobre cuberta anterior
doc = addTitle( doc, paste("GAP número", i, "(proporción por filas, %)"), level = 2)
Taboa = FlexTable( data= round(100*prop.table(contin(i, cambiosGAP), 1), 1), add.rownames = TRUE)
Taboa = setFlexTableWidths(Taboa, widths=c(5,2,2,2,2,2)/2.54)
doc = addFlexTable(doc, Taboa)
}



# add a section title
doc = addTitle( doc, "Principais cambios por comarca (km²)", level = 1 )

for(i in 1:50) {
# A) Cambios en km²
doc = addTitle( doc, paste("Comarca número", i, "(km²)"), level = 2)
Taboa = FlexTable( data= contin(i, cambiosCP), add.rownames = TRUE)
Taboa = setFlexTableWidths(Taboa, widths=c(5,2,2,2,2,2)/2.54)
doc = addFlexTable(doc, Taboa)
}

# add a section title
doc = addTitle( doc, "Principais cambios por comarca (porcentaxe sobre a cuberta anterior)", level = 1 )
for(i in 1:50) {
# A) Cambios en % sobre cuberta anterior
doc = addTitle( doc, paste("Comarca número", i, "(proporción por filas, %)"), level = 2)
Taboa = FlexTable( data= round(100*prop.table(contin(i, cambiosCP), 1), 1), add.rownames = TRUE)
Taboa = setFlexTableWidths(Taboa, widths=c(5,2,2,2,2,2)/2.54)
doc = addFlexTable(doc, Taboa)
}

# write the doc
writeDoc( doc, file = "./Informes/Informe1/Cambios.docx" )
