#!/bin/bash

## Script para a combinación dos resultados finais
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset -c TmpPaisaxe_MapaFinal
g.mapsets mapset=MDT25,AdminLimits,TmpPaisaxe_Cubertas,TmpPaisaxe_Cubertas2 
g.mapsets mapset=TmpPaisaxe_Clima2,TmpPaisaxe_Xeo2,TmpPaisaxe_POL
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

g.region rast=ClasesXeo

## Copiamos mapa de concellos e establecemos a máscara
r.mask concellos

########## Cruzar as categorías
r.cross input=ClasesXeo,ClaseCuberta2,termoclima output=TiposPaisaxeA

########## Pasar a vector 
g.copy vect=TiposPaisaxeA,TiposPaisaxeB
r.to.vect -sv input=TiposPaisaxeB output=TiposPaisaxeB type=area

########## Simplificar (eliminar unidades menores de 2ha)
v.clean input=TiposPaisaxeB output=TiposPaisaxeC tool=rmarea threshold=20000

#v.generalize input=TiposPaisaxeC output=TiposPaisaxeD method=douglas threshold=30



########## Exportar
v.out.ogr in=TiposPaisaxeC output=ResultadosFinais/ output_layer=UdsPaisaxe

