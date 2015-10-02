## Script de R para a estimación das áreas totais de cada clase no mapa de unidades de paisaxe
## Eduardo Corbelle, 28 de setembro de 2015

# Cargamos a táboa de atributos (debería incluír un campo Area_ha)
library(foreign)
uds <- read.dbf("~/Traballo/Proxectos/2015_04_CatalogoPaisaxe/Resultados/TiposPaisaxe_v03/TiposPaisaxe_v0.3_2015_09_25.dbf")

## Áreas por grandes clases (en ha)
## Débese ter en conta que o ámbito do POL está excluído do cómputo
# Área por grandes unidades morfolóxicas
area.xeo <- round(tapply(uds$Area_ha, INDEX=uds$Xeomorf, FUN=sum, na.rm=TRUE),0)
# Área por grandes clases de cuberta
area.cub <- round(tapply(uds$Area_ha, INDEX=uds$Cuberta, FUN=sum, na.rm=TRUE),0)
# Área por grandes clases de clima
area.cli <- round(tapply(uds$Area_ha, INDEX=uds$Clima, FUN=sum, na.rm=TRUE),0)

## Combinación entre diferentes clases
area.xeo.cub <- round(tapply(uds$Area_ha, 
                             INDEX=list(uds$Cuberta, uds$Xeomorf),
                             FUN=sum, na.rm=TRUE),0)

area.xeo.cub2 <- area.xeo.cub
area.xeo.cub2[which(is.na(area.xeo.cub))] <- 0
