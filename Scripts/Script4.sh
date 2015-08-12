#!/bin/bash

## Script de probas en Polaris para a combinación dos resultados finais
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset Tmp
g.mapsets POL

########## Cruzar as categorías
r.mask raster=concellos
r.cross input=ClasesXeo,ClaseCuberta2,bioclima output=TiposPaisaxe
r.mask -r

########## Pasar a vector e simplificar (eliminar unidades menores de 1ha)
r.to.vect -v input=TiposPaisaxe output=TiposPaisaxe type=area --o
v.clean input=TiposPaisaxe output=TiposPaisaxeB tool=rmarea threshold=10000 --o
v.generalize input=TiposPaisaxeB output=TiposPaisaxeC method=reumann threshold=26 --o

########## Recortar o ámbito do POL
v.overlay ainput=TiposPaisaxeC binput=Ambito operator=not output=TiposPaisaxeD --o

########## Exportar
now=$(date +"%Y_%m_%d")
result=TiposPaisaxe_$now.shp

v.out.ogr in=TiposPaisaxeD output=./Resultados output_layer=$result