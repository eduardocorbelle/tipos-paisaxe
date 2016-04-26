## Script para reducir o tamaño da táboa de atributos de siose_reclasificado
## Eduardo Corbelle, 12 de novembro de 2015

library(foreign)

siose <- read.dbf("DatosProcesados/nueva_agregacion.dbf.bk")

sioseB <- data.frame(OBJECTID = siose$OBJECTID,
                     code=siose$AGREGACI_1)

write.dbf(sioseB, "DatosProcesados/nueva_agregacion.dbf")
