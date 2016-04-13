#!/bin/bash

## Script para a clasificación de grandes unidades morfolóxicas da paisaxe (2)
## Eduardo Corbelle, iniciado o 7 de maio de 2015


## Acceso a mapsets e establecemento da rexión de cálculo
g.mapset -c TmpPaisaxe_Xeo2
g.mapsets mapset=AdminLimits,MDT25
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

g.region rast=mdt25

## Copiamos mapa de concellos e establecemos a máscara
g.copy vect=concellos_siam,concellos
v.build concellos
v.to.rast input=concellos out=concellos use=val value=1
r.mask concellos

# Importamos a clasificación manual dos segmentos resultantes
v.in.ogr input=DatosOrixinais/ClasifXeomorf/segmentos25_clasif.shp output=ClasesXeo snap=1
v.to.rast input=ClasesXeo output=ClasesXeo use=attr attr=Codigo label=Clase
r.null map=ClasesXeo null=2

r.category ClasesXeo sep=: rules=- << EOF
1:Litoral Cantabro-Atlantico
2:Vales sublitorais
3:Serras
4:Chairas e vales interiores
5:Canons
EOF

## Eliminamos a máscara
r.mask -r
