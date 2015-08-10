#!/bin/bash

## Script de probas en Polaris para a clasificación de unidades morfolóxicas da paisaxe
## Eduardo Corbelle, iniciado o 7 de maio de 2015


############
### Sesión do 28 de xullo de 2015

## Acceso a mapsets e establecemento da rexión de cálculo
g.mapset -c Tmp
g.mapsets mapset=AdminLimits,MDT25,MDT200,SIOSE,Clima,Vinhedo

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
v.out.ogr input=segmentos25 output=./Tmp

# Seguida de clasificación manual dos segmentos resultantes en serra, canón, chaira e resto.
# (fixemos unha copia en ./Backup)
v.in.ogr input=./Backup/segmentos25.shp output=ClasesXeo 
v.to.rast input=ClasesXeo output=ClasesXeo use=attr attr=CodXeo label=ClaseXeo

## Eliminamos a máscara
r.mask -r