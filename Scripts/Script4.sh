#!/bin/bash

## Script de probas en Polaris para a incorporación de información climática
## Eduardo Corbelle, iniciado o 7 de maio de 2015

########## Establecer máscara
r.mask raster=concellos

########## Cruzar as categorías
r.cross input=Claseforma,Clasecuberta,bioclima output=TiposPaisaxe
r.mask -r

########## Pasar a vector e simplificar
r.to.vect -v input=TiposPaisaxe output=TiposPaisaxe type=area
v.clean input=TiposPaisaxe output=TiposPaisaxeB tool=rmarea threshold=1000000
v.generalize input=TiposPaisaxeB output=TiposPaisaxeC method=reumann threshold=26

########## Exportar
v.out.ogr in=TiposPaisaxeB out=/media/sf_Datos_Corbelle/Resultados/Resultado.shp 