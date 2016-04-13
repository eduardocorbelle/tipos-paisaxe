#!/bin/bash

## Script para a combinación dos resultados finais
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset -c TmpPaisaxe_MapaFinal
g.mapsets mapset=MDT25,AdminLimits,TmpPaisaxe_Cubertas
g.mapsets mapset=TmpPaisaxe_Clima2,TmpPaisaxe_Xeo2,TmpPaisaxe_POL
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

g.region rast=ClasesXeo

## Copiamos mapa de concellos e establecemos a máscara
g.copy vect=concellos_siam,concellos
v.build concellos
v.to.rast input=concellos out=concellos use=val value=1
r.mask concellos

########## Cruzar as categorías
r.cross input=ClasesXeo,ClaseCuberta2,termoclima output=TiposPaisaxeA

########## Excluír o ámbito do POL do resultado do traballo
v.to.rast input=Ambito type=area use=cat out=POL
r.mapcalc "TiposPaisaxeB = if(isnull(POL), TiposPaisaxeA, 999)"
r.category map=TiposPaisaxeB raster=TiposPaisaxeA
r.mask -r

########## Pasar a vector 
r.to.vect -sv input=TiposPaisaxeB output=TiposPaisaxeB type=area

########## Simplificar (eliminar unidades menores de 2ha)
v.clean input=TiposPaisaxeB output=TiposPaisaxeC tool=rmarea threshold=20000

v.generalize input=TiposPaisaxeC output=TiposPaisaxeD method=reumann threshold=26

########## Exportar
v.out.ogr in=TiposPaisaxeD output=ResultadosFinais/ output_layer=UdsPaisaxe

########## Limpeza do espazo de traballo
g.remove type=vect name=TiposPaisaxeB -f
#g.remove type=vect name=TiposPaisaxeC -f

########## Edición manual do mapa resultante: 
## Separación da lenda en tres campos distintos da táboa de atributos.
