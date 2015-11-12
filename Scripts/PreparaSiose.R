## Script para reducir o tamaño da táboa de atributos de siose_reclasificado
## Eduardo corbele, 12 de novembro de 2015

library(foreign)

system("cp /media/sf_Datos_Corbelle/Data/Datos_IET/SIOSE2011/SIOSE_2011_agregado.dbf /media/sf_Datos_Corbelle/Data/Datos_IET/SIOSE2011/SIOSE_2011_agregado.dbf.bk")

system("rm /media/sf_Datos_Corbelle/Data/Datos_IET/SIOSE2011/SIOSE_2011_agregado.dbf")

siose <- read.dbf("/media/sf_Datos_Corbelle/Data/Datos_IET/SIOSE2011/SIOSE_2011_agregado.dbf")

sioseB <- data.frame(AGREGACION=siose$AGREGACION,
                     CLASELENDA=siose$CLASELENDA)

write.dbf(sioseB, "/media/sf_Datos_Corbelle/Data/Datos_IET/SIOSE2011/SIOSE_2011_agregado.dbf")