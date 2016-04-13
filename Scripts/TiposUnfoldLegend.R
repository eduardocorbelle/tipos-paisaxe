## Script de R para dividir automaticamente a lenda do mapa de tipos de paisaxe en tres categorías simples
## Eduardo Corbelle, 16 de novembro de 2015

library(foreign)

# Establecemos a ruta do ficheiro
ruta     <- "ResultadosFinais/"
ficheiro <- "UdsPaisaxe" 

# Creamos unha copia de respaldo do .dbf orixinal
base = paste(ruta, ficheiro, ".dbf", sep="")
copia = paste(ruta, ficheiro, ".dbf.bk", sep="")
system2("cp", args=c(base, copia))

# Importamos o dbf
tipos <- read.dbf(base)

# Dividimos a lenda orixinal
write.csv(tipos$label, paste(ruta, "tipos.csv", sep=""),
          col.names=FALSE, row.names=FALSE, quote=FALSE)
tipos2 <- read.csv(paste(ruta, "tipos.csv", sep=""), 
                   sep=";", header=FALSE, skip=1)

colnames(tipos2) <- c("Xeomorf", "Cuberta", "Clima")

# Unimos as dúas táboas (orixinal e dividida)
tipos3 <- cbind(tipos, tipos2)

# Exportamos como dbf
write.dbf(tipos3, base)
