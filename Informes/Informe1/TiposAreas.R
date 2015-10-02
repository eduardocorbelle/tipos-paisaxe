## Script de R para resumir os datos de tipos de paisaxe por grandes áreas

## Cargamos os datos orixinais
datos <- read.table("Informes/Informe1/TiposAreas_2015_10_02.txt", sep="|", header=FALSE)
colnames(datos) <- c("GAn","GAt","CXn","CXt","CCn","CCt","Cln","Clt","Aream2")

## Clases xeomorfolóxicas por Grandes Áreas (en km2)
taboa1 <- round(tapply(datos$Aream2, INDEX=list(datos$GAt,datos$CXt), FUN=sum, na.rm=TRUE)/1e06,2)
taboa1[is.na(taboa1)] <- 0
## Clases xeomorfolóxicas por Grandes Áreas (en %)
taboa1p <- round(100*prop.table(taboa1, margin=1),1)
## Clases de cuberta por Grandes Áreas (en km2)
taboa2 <- round(tapply(datos$Aream2, INDEX=list(datos$GAt,datos$CCt), FUN=sum, na.rm=TRUE)/1e06,2)
taboa2[is.na(taboa2)] <- 0
## Clases xeomorfolóxicas por Grandes Áreas (en %)
taboa2p <- round(100*prop.table(taboa2, margin=1),1)
## Clases de termotipos por Grandes Áreas (en km2)
taboa3 <- round(tapply(datos$Aream2, INDEX=list(datos$GAt,datos$Clt), FUN=sum, na.rm=TRUE)/1e06,2)
taboa3[is.na(taboa3)] <- 0
## Clases xeomorfolóxicas por Grandes Áreas (en %)
taboa3p <- round(100*prop.table(taboa3, margin=1),1)

## Preparamos as táboas para LaTeX
library(xtable)

xtaboa1  <- xtable(taboa1[-9,-4],
            caption="Grandes unidades morfolóxicas por Grandes Áreas paisaxísticas (datos en km²)",
            label="xtaboa1")
xtaboa1p <- xtable(taboa1p[-9,-4],
            caption="Grandes unidades morfolóxicas por Grandes Áreas paisaxísticas (datos en porcentaxe)",
            label="xtaboa1p")

xtaboa2  <- xtable(taboa2[-9, -5],
            caption="Clases de cuberta por Grandes Áreas paisaxísticas (datos en km²)",
            label="xtaboa2")
xtaboa2p <- xtable(taboa2p[-9, -5],
            caption="Clases de cuberta por Grandes Áreas paisaxísticas (datos en porcentaxe)",
            label="xtaboa2p")

xtaboa3  <- xtable(taboa3[-9,-4],
            caption="Termotipos por Grandes Áreas paisaxísticas (datos en km²)",
            label="xtaboa3")
xtaboa3p <- xtable(taboa3p[-9,-4],
            caption="Termotipos por Grandes Áreas paisaxísticas (datos en porcentaxe)",
            label="xtaboa3p")

## Exportamos a un ficheiro .tex
print.xtable(xtaboa1, type="latex", 
             file="Informes/Informe1/TaboasGA.tex", append=FALSE,
             floating=TRUE, table.placement = "p", caption.placement="top",
             latex.environments=c("center"))
print.xtable(xtaboa1p, type="latex", 
             file="Informes/Informe1/TaboasGA.tex", append=TRUE,
             floating=TRUE, table.placement = "p", caption.placement="top",
             latex.environments=c("center"))
print.xtable(xtaboa2, type="latex", 
             file="Informes/Informe1/TaboasGA.tex", append=TRUE,
             floating=TRUE, table.placement = "p", caption.placement="top",
             latex.environments=c("center"))
print.xtable(xtaboa2p, type="latex", 
             file="Informes/Informe1/TaboasGA.tex", append=TRUE,
             floating=TRUE, table.placement = "p", caption.placement="top",
             latex.environments=c("center"))
print.xtable(xtaboa3, type="latex", 
             file="Informes/Informe1/TaboasGA.tex", append=TRUE,
             floating=TRUE, table.placement = "p", caption.placement="top",
             latex.environments=c("center"))
print.xtable(xtaboa3p, type="latex", 
             file="Informes/Informe1/TaboasGA.tex", append=TRUE,
             floating=TRUE, table.placement = "p", caption.placement="top",
             latex.environments=c("center"))