#!/bin/bash

## Script de probas en Polaris para a combinación dos resultados finais
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset Tmp
g.mapsets POL

########## Cruzar as categorías
r.mask raster=concellos
r.cross input=ClasesXeo,ClaseCuberta2,bioclima output=TiposPaisaxe
r.mask -r

########## Pasar a vector 
r.to.vect -v input=TiposPaisaxe output=TiposPaisaxe type=area

########## Recortar o ámbito do POL
v.overlay ainput=TiposPaisaxe binput=Ambito operator=not output=TiposPaisaxeR
## * Podería facerse en fases anteriores e en formato ráster

########## Simplificar (eliminar unidades menores de 1ha)
v.generalize input=TiposPaisaxeR output=TiposPaisaxeB method=reumann threshold=26 --o
v.clean input=TiposPaisaxeB output=TiposPaisaxeC tool=rmarea threshold=10000 --o



########## Exportar
now=$(date +"%Y_%m_%d")
result=TiposPaisaxe_$now

v.out.ogr in=TiposPaisaxeC output=./Resultados output_layer=$result

########## Limpeza do espazo de traballo
g.remove type=vect name=TiposPaisaxe  -f
g.remove type=vect name=TiposPaisaxeR -f
g.remove type=vect name=TiposPaisaxeB -f

########## Edición manual do mapa resultante: 
## Eliminación dos restos do recorte co POL (diferencia de 12-16m debida as transformacións de sistema de referencia)
## Separación da lenda en tres campos distintos da táboa de atributos.
