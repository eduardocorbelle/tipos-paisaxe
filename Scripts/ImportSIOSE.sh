#!/bin/bash

## Script para cargar a capa de SIOSE
## Eduardo Corbelle, 11 de xuño de 2015

g.mapset -c TmpPaisaxe_SIOSE
g.remove type=raster pattern=* -f
g.remove type=raster pattern=* -f # (2 veces para eliminar o mapa reclasificado primeiro)
g.remove type=vector pattern=* -f

## Importamos o ficheiro
v.in.ogr input=DatosProcesados/SIOSE_2011_agregado.shp output=siose2011

## Establecemos a rexión
g.mapsets mapset=MDT25 operation=add
g.region rast=mdt25

## Convertimos a raster
# (Utilizamos o campo "AGREGACION")
v.to.rast input=siose2011 type=area out=siose2011 use=attr attribute_column=AGREGACION label_column=CLASELENDA

## Reclasificamos
r.reclass input=siose2011 output=siose2011r rules=Scripts/ReclassSiose.txt

# (Categorías orixinais da reclasificación feita no IET)
# [1] "10 Coníferas"                                  
# [2] "11 Eucaliptos e coníferas"                     
# [3] "12 Repoboacións forestais"                     
# [4] "13 Mestura de especies arbóreas"               
# [5] "14 Mato"                                       
# [6] "15 Mato e rochedo"                             
# [7] "16 Mato e especies arbóreas"                   
# [8] "16 Mato e especies arbóreas\r\n"               
# [9] "17 Cultivos e prados"                          
#[10] "18 Viñedo e cultivos leñosos"                  
#[11] "19 Mosaico de cultivos e especies arbóreas"    
#[12] "19 Mosaico de cultivos e especies arbóreas\r\n"
#[13] "1 Sistemas xerais de transporte"               
#[14] "20 Mosaico agrícola e mato"                    
#[15] "21 Mosaico agrícola e urbano"                  
#[16] "22 Augas continentais"                         
#[17] "23 Augas mariñas"                              
#[18] "24 Humedais"                                   
#[19] "25 Instalacións deportivas"                    
#[20] "2 Zonas urbanas"                               
#[21] "3 Coberturas artificiais"                      
#[22] "4 Afloramientos rochosos e rochedos"           
#[23] "5 Zonas de extracción ou vertido"              
#[24] "6 Zonas queimadas"                             
#[25] "7 Praias e cantís"                             
#[26] "8 Especies caducifolias"                       
#[27] "9 Eucaliptos"

