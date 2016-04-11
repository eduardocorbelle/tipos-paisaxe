#!/bin/bash

## Script para cargar as capas de viñedo procedentes de SIOSE 2011
## Eduardo Corbelle, 10 de agosto de 2015

g.mapset -c TmpPaisaxe_Vinhedo
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

# Importamos tódalas capas
for layer in DatosProcesados/Vin*.shp
do 
v.in.ogr input=$layer output=`basename $layer .shp`
done

# convertimos a ráster
g.mapsets mapset=MDT25 operation=add
g.region rast=mdt25

for layer in `g.list type=vect mapset=.`
do 
v.to.rast in=$layer out=$layer use=val val=1
r.null map=$layer null=0
done
