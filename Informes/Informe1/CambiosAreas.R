## Script de R para resumir os cambios de cuberta estimados a partir do MCA por grandes áreas e comarcas

## Cargamos os datos orixinais
cambiosGAP <- read.table("Informes/Informe1/CambiosGAP_2015_10_09.txt", 
                         sep="|", na.strings=c("NA", "no data"), header=FALSE)
colnames(cambiosGAP) <- c("GAPid","GAP","cub89id","cub89","cub09id","cub09","Aream2")

cambiosCP <- read.table("Informes/Informe1/CambiosComarcas_2015_10_09.txt",
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

## Creamos unha función que exporta a táboa cara LaTeX
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

## Xeramos as táboas para GAP e CP
system("rm Informes/Informe1/CambiosGAP.tex")
system("rm Informes/Informe1/CambiosCP.tex")

for(i in 1:12) {
  exportT(i, "GAP", "Informes/Informe1/CambiosGAP.tex")
}

for(i in 1:50) {
  exportT(i, "CP", "Informes/Informe1/CambiosCP.tex")
}