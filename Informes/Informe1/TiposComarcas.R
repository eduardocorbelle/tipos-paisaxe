### Script para desglosar as clases de paisaxe por comarca dentro de cada GAP
### Eduardo Corbelle, 14 de decembro de 2015

## Cargamos os datos orixinais
datos <- read.table("Informes/Informe1/TiposAreas_2015_11_16.txt", sep="|", header=FALSE)
colnames(datos) <- c("GAP_code","GAP","CXn","CXt","CCn","CCt","Cln","Clt","Aream2")


