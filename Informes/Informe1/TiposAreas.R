## Script de R para resumir os datos de tipos de paisaxe por grandes áreas

## Cargamos os datos orixinais
datos <- read.table("Informes/Informe1/TiposAreas_2015_11_16.txt", sep="|", header=FALSE)
colnames(datos) <- c("GAP_code","GAP","CXn","CXt","CCn","CCt","Cln","Clt","Aream2")
datos <- data.frame(datos, 
                    tipo = factor(paste(datos$CXt, ";", datos$CCt, ";", datos$Clt)))


## Creamos unha táboa cos nomes das GAP e o código asociado
tab0 <- tapply(datos$GAP_code, INDEX=datos$GAP, FUN=min)[-9]
tab0 <- tab0[order(tab0)]
taboa0 <- data.frame("Código" = as.integer(tab0))
rownames(taboa0) <- names(tab0)

## Clases xeomorfolóxicas por Grandes Áreas (en km2)
taboa1 <- round(tapply(datos$Aream2, INDEX=list(datos$CXt,datos$GAP_code), FUN=sum, na.rm=TRUE)/1e06,2)
taboa1[is.na(taboa1)] <- 0
## Clases xeomorfolóxicas por Grandes Áreas (en %)
taboa1p <- round(100*prop.table(taboa1, margin=2),1)
## Clases de cuberta por Grandes Áreas (en km2)
taboa2 <- round(tapply(datos$Aream2, INDEX=list(datos$CCt,datos$GAP_code), FUN=sum, na.rm=TRUE)/1e06,2)
taboa2[is.na(taboa2)] <- 0
## Clases xeomorfolóxicas por Grandes Áreas (en %)
taboa2p <- round(100*prop.table(taboa2, margin=2),1)
## Clases de termotipos por Grandes Áreas (en km2)
taboa3 <- round(tapply(datos$Aream2, INDEX=list(datos$Clt,datos$GAP_code), FUN=sum, na.rm=TRUE)/1e06,2)
taboa3[is.na(taboa3)] <- 0
## Clases xeomorfolóxicas por Grandes Áreas (en %)
taboa3p <- round(100*prop.table(taboa3, margin=2),1)

## Tipos para toda Galicia (km2)
taboaG <- round(tapply(datos$Aream2[-which(is.na(datos$GAP_code))], INDEX=datos$tipo[-which(is.na(datos$GAP_code))], FUN=sum, na.rm=TRUE)/1e06,2)
taboaG[is.na(taboaG)] <- 0
## Tipos para toda Galicia (%)
taboaGp<- round(100*taboaG/sum(taboaG), 1)

## Tipos por grandes áreas (km2)
taboa4 <- round(tapply(datos$Aream2, INDEX=list(datos$tipo,datos$GAP_code), FUN=sum, na.rm=TRUE)/1e06,2)
taboa4[is.na(taboa4)] <- 0
## Tipos por Grandes Áreas (en %)
taboa4p <- round(100*prop.table(taboa4, margin=2),1)


## Preparamos as táboas para LaTeX
library(xtable)

xtaboa0  <- xtable(taboa0,
            caption="Grandes Áreas paisaxísticas e código asignado",
            label="xtaboa0")

xtaboa1  <- xtable(taboa1[-4,],
            caption="Grandes unidades morfolóxicas por Grandes Áreas paisaxísticas (datos en km²)",
            label="xtaboa1",
            digits=0)
xtaboa1p <- xtable(taboa1p[-4,],
            caption="Grandes unidades morfolóxicas por Grandes Áreas paisaxísticas (datos en porcentaxe)",
            label="xtaboa1p",
            digits=1)

xtaboa2  <- xtable(taboa2[-9,],
            caption="Clases de cuberta por Grandes Áreas paisaxísticas (datos en km²)",
            label="xtaboa2",
            digits=0)
xtaboa2p <- xtable(taboa2p[-9,],
            caption="Clases de cuberta por Grandes Áreas paisaxísticas (datos en porcentaxe)",
            label="xtaboa2p",
            digits=1)

xtaboa3  <- xtable(taboa3[-4,],
            caption="Termotipos por Grandes Áreas paisaxísticas (datos en km²)",
            label="xtaboa3",
            digits=0)
xtaboa3p <- xtable(taboa3p[-4,],
            caption="Termotipos por Grandes Áreas paisaxísticas (datos en porcentaxe)",
            label="xtaboa3p",
            digits=1)

## Exportamos a un ficheiro .tex
print.xtable(xtaboa0, type="latex", 
             file="Informes/Informe1/TaboasGA.tex", append=FALSE,
             floating=TRUE, table.placement = "p", caption.placement="top",
             latex.environments=c("center"))
print.xtable(xtaboa1, type="latex", 
             file="Informes/Informe1/TaboasGA.tex", append=TRUE,
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

### Resumo dos principais tipos para toda Galicia
ordeG <- order(taboaGp, decreasing=TRUE)
Limiar <- 1 # % mínimo de aparición

TiposG <- data.frame(Tipo = names(taboaG),
                     Área = as.numeric(taboaG),
                     Porcentaxe = as.numeric(taboaGp))[ordeG,]
TiposGm<- TiposG[which(TiposG$Porcentaxe>=Limiar),]

### Resumo dos principais tipos por grande área
resumo <- function(GArea, porcent) {
  ## GArea = número da GAP
  ## porcent = porcentaxe mínimo do tipo sobre a GA
  listap = taboa4p[order(taboa4p[,GArea], decreasing=TRUE),GArea]
  listan = taboa4[order(taboa4p[,GArea], decreasing=TRUE),GArea]
  selecp = listap[which(listap >= porcent)]
  selecn = listan[which(listap >= porcent)]
  frame = data.frame(Tipo = names(selecp),
                     Área = as.numeric(selecn),
                     Porcentaxe = as.numeric(selecp))
  total = data.frame(Tipo = "Total",
                     Área = sum(selecn),
                     Porcentaxe = sum(selecp))
  frame = rbind(frame, total)
  colnames(frame)[2] = "Área (km²)"
  return(frame)
}

### Aplicar a función ás 12 grandes áreas e exportar a LaTeX
# (bucle)
system("rm Informes/Informe1/TaboasTipos.tex")
for(i in 1:12) {
 print.xtable(xtable(resumo(i, 1),
                     caption=paste("Principais tipos de paisaxe, ", rownames(taboa0)[i] , "(", i, ")"),
                     label=paste("Tipos", i)),
             type="latex", 
             file="Informes/Informe1/TaboasTipos.tex", append=TRUE,
             floating=TRUE, table.placement = "p", caption.placement="top",
             latex.environments=c("center"))
}


### Aplicar as funcións ás 12 GAP e exportar a MS Word
# (http://stackoverflow.com/questions/25425993/data-frame-to-word-table)
library(ReporteRs)

# Crear un obxecto docx
doc = docx()
# add a document title
doc = addParagraph( doc, "Principais tipos de paisaxe de Galicia e Grandes Áreas Paisaxísticas", stylename = "TitleDoc" )
# add a section title
doc = addTitle( doc, "Principais tipos en Galicia", level = 1 )


# add a table
Galicia = FlexTable( data = TiposGm, add.rownames = FALSE )
Galicia = setFlexTableWidths(Galicia, widths=c(10,3,3)/2.54)
Galicia = setFlexTableBackgroundColors(Galicia, j=1:3, "white")
#Galicia[,] = cellProperties(background.color="white")
doc = addFlexTable(doc, Galicia)

# add a section title
doc = addTitle( doc, "Principais tipos por GAP", level = 1 )

for(i in 1:12) {
# some text
doc = addTitle( doc, paste("Principais tipos: GAP", i), level = 2 )
Taboa = FlexTable( data= resumo(i, 1), add.rownames = FALSE)
Taboa = setFlexTableWidths(Galicia, widths=c(10,3,3)/2.54)
doc = addFlexTable(doc, Taboa)
}

# write the doc
writeDoc( doc, file = "./Informes/Informe1/TaboasTipos.docx" )

