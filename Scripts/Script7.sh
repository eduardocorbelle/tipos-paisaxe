## Script para analizar a frecuencia de aparición dalgúns valores paisaxísticos por unidade de paisaxe
## Eduardo Corbelle, 24 de novembro de 2015

g.mapset -c Valores

## Establecemos o acceso a mapset do mapa de unidades
g.mapsets UdsPaisaxe,GAP

## Establecemos a rexión de cálculo
g.region rast=TiposPaisaxeA

## Importamos as capas para analizar
## BIC
v.in.ogr input=/home/eduardo/Proxectos/CatalogoPaisaxe/Capas_Valores_Iventariados_IET/BIC/BIC_2015_IET.shp out=bic 
v.to.rast input=bic output=bic use=val value=1
## Camiño de Santiago
v.in.ogr input=/home/eduardo/Proxectos/CatalogoPaisaxe/Capas_Valores_Iventariados_IET/CamiñoSantiago/CamiñoSantiago.shp out=camino
v.to.rast input=camino out=camino use=val value=1
r.buffer input=camino out=camino2 dist=500
r.reclass input=camino2 out=camino2R rules=./Scripts/ReclassBuff.txt
## Capacidade produtiva

## Xeneradores eólicos
v.in.ogr input=/home/eduardo/Proxectos/CatalogoPaisaxe/Capas_Valores_Iventariados_IET/Eolicos/Eolicos.shp out=eolicos
v.to.rast input=eolicos out=eolicos use=val value=1
## ENP: Rede Natura 2000
v.in.ogr input=/home/eduardo/Proxectos/CatalogoPaisaxe/Capas_Valores_Iventariados_IET/EspazosProtexidos/RedeNatura2000/ZONIFICACION_PD_RNAT2000.shp out=natura2000 
v.to.rast input=natura2000 out=natura2000 use=val value=1
## Puntos participación pública SIXOT
v.in.ogr input=/home/eduardo/Proxectos/CatalogoPaisaxe/PtosSixotConValores/_20151118_Lugares_clasificacion_crucecapasXLS.shp out=puntosSixot
v.to.rast input=puntosSixot where="NATURAL='SI'" out=puntosSixotNatural use=val value=1
v.to.rast input=puntosSixot where="PATRIMONIA='SI'" out=puntosSixotPatrimonial use=val value=1
v.to.rast input=puntosSixot where="ESTETICO='SI'" out=puntosSixotEstetico use=val value=1



## Calculamos a frecuencia de aparación
# BIC
r.stats -clN in=GrandesAreas,TiposPaisaxeA,bic out=./Informes/Informe2/ValoresBic_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA
# Camiño Santiago
r.stats -clN in=GrandesAreas,TiposPaisaxeA,camino2R out=./Informes/Informe2/ValoresCamino_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA
# Xeneradores eólicos
r.stats -clN in=GrandesAreas,TiposPaisaxeA,eolicos out=./Informes/Informe2/ValoresEolicos_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA
# Rede Natura 2000
r.stats -clN in=GrandesAreas,TiposPaisaxeA,natura2000 out=./Informes/Informe2/ValoresNatura2000_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA
# Puntos participación pública SIXOT
r.stats -clN in=GrandesAreas,TiposPaisaxeA,puntosSixotNatural out=./Informes/Informe2/ValoresSixotNat_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA
r.stats -clN in=GrandesAreas,TiposPaisaxeA,puntosSixotPatrimonial out=./Informes/Informe2/ValoresSixotPat_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA
r.stats -clN in=GrandesAreas,TiposPaisaxeA,puntosSixotEstetico out=./Informes/Informe2/ValoresSixotEst_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA










