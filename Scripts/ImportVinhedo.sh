#!/bin/bash

## Script para cargar as capas de viñedo procedentes de SIOSE 2011
## Eduardo Corbelle, 10 de agosto de 2015

g.mapset -c Vinhedo

## (Cambiamos o nome de tódolos ficheiros a VinXXX.* con Renomea.sh)
#bash ./Data/Vinhedo/Renomea.sh

# Importamos tódalas capas
for layer in ./Data/Vinhedo/*.shp
do 
v.in.ogr input=$layer output=`basename $layer .shp`
done

# convertimos a ráster
g.mapsets mapset=MDT25
g.region rast=mdt25

for layer in `g.list type=vect mapset=.`
do 
#v.to.rast in=$layer out=$layer use=val val=1
r.null map=$layer null=0
done