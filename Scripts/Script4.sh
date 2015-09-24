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
<<<<<<< HEAD
r.to.vect -v input=TiposPaisaxe output=TiposPaisaxe type=area

########## Simplificar a forma das liñas
v.generalize input=TiposPaisaxeR output=TiposPaisaxeB method=reumann threshold=26 --o

########## Recortar o ámbito do POL
v.overlay ainput=TiposPaisaxe binput=Ambito operator=not output=TiposPaisaxeR
## * Podería facerse en fases anteriores e en formato ráster

########## Simplificar (eliminar unidades menores de 1ha)
v.clean input=TiposPaisaxeB output=TiposPaisaxeC tool=rmarea threshold=10000 --o
=======
r.to.vect -sv input=TiposPaisaxeB output=TiposPaisaxeB type=area

########## Simplificar (eliminar unidades menores de 1ha)
#v.generalize input=TiposPaisaxeB output=TiposPaisaxeC method=reumann threshold=26 --o
v.clean input=TiposPaisaxeB output=TiposPaisaxeD tool=rmarea threshold=10000 --o
>>>>>>> a4317ed1606e36eaa847218054f3628bcfb28a92

########## Exportar
now=$(date +"%Y_%m_%d")
result=TiposPaisaxe_$now

v.out.ogr in=TiposPaisaxeD output=./Resultados output_layer=$result

########## Limpeza do espazo de traballo
g.remove type=vect name=TiposPaisaxeB -f
g.remove type=vect name=TiposPaisaxeC -f

########## Edición manual do mapa resultante: 
## Separación da lenda en tres campos distintos da táboa de atributos.
