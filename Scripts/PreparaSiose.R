## Script para reducir o tamaño da táboa de atributos de siose_reclasificado
## Eduardo Corbelle, 12 de novembro de 2015

library(foreign)

siose <- read.dbf("DatosProcesados/SIOSE_2011_agregado.dbf.bk")

sioseB <- data.frame(AGREGACION=siose$AGREGACION,
                     CLASELENDA=siose$CLASELENDA)

write.dbf(sioseB, "DatosProcesados/SIOSE_2011_agregado.dbf")
