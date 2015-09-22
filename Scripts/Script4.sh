#!/bin/bash

## Script de probas en Polaris para a combinación dos resultados finais
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset Tmp
g.mapsets POL
r.mask raster=concellos

########## Cruzar as categorías
r.cross input=ClasesXeo,ClaseCuberta2,termoclima output=TiposPaisaxeA

########## Excluír o ámbito do POL do resultado do traballo
v.to.rast input=Ambito@POL type=area use=cat out=POL
r.mapcalc "TiposPaisaxeB = if(isnull(POL), TiposPaisaxeA, 999)"
r.category map=TiposPaisaxeB raster=TiposPaisaxeA
r.mask -r

########## Pasar a vector 
r.to.vect -sv input=TiposPaisaxeB output=TiposPaisaxeB type=area

########## Simplificar (eliminar unidades menores de 1ha)
#v.generalize input=TiposPaisaxeB output=TiposPaisaxeC method=reumann threshold=26 --o
v.clean input=TiposPaisaxeB output=TiposPaisaxeD tool=rmarea threshold=10000 --o

########## Exportar
now=$(date +"%Y_%m_%d")
result=TiposPaisaxe_$now

v.out.ogr in=TiposPaisaxeD output=./Resultados output_layer=$result

########## Limpeza do espazo de traballo
g.remove type=vect name=TiposPaisaxeB -f
g.remove type=vect name=TiposPaisaxeC -f

########## Edición manual do mapa resultante: 
## Separación da lenda en tres campos distintos da táboa de atributos.