#!/bin/bash

## Script para a clasificación de grandes unidades morfolóxicas da paisaxe
## Eduardo Corbelle, iniciado o 7 de maio de 2015


## Acceso a mapsets e establecemento da rexión de cálculo
g.mapset -c TmpPaisaxe_Xeo1
g.mapsets mapset=AdminLimits,MDT25,MDT200,SIOSE,Clima,Vinhedo
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

g.region rast=mdt25

## Copiamos mapa de concellos e establecemos a máscara
g.copy vect=concellos_siam,concellos
v.build concellos
v.to.rast input=concellos out=concellos use=val value=1
r.mask concellos

## Segmentación sobre mdt25 (segmentos de tamaño mínimo 250*625 m² = 15 ha)
r.slope.aspect elev=mdt25 slope=pendente25 format=percent
i.group group=grupo25 input=mdt25,pendente25
i.segment group=grupo25 threshold=0.1 memory=3000 minsize=250 out=segmentos25
r.to.vect input=segmentos25 output=segmentos25 type=area
v.out.ogr input=segmentos25 output=ResultadosIntermedios/Segmentos25.shp

## Eliminamos a máscara
r.mask -r
