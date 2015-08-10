#!/bin/bash

## Script para cargar a capa de SIOSE
## Eduardo Corbelle, 28 de xullo de 2015

g.mapset -c Habitat

## Importamos o ficheiro
v.in.ogr input=./Data/Habitats/2011_habitats_GAL_U1_ETRS89.shp output=habitats

## Creamos unha nova columna con códigos numéricos
v.db.addcolumn map=habitats columns='codigo integer'

v.db.update map=habitats column=codigo value=1 where='HABITAT="Acantilados y pendientes costeras"'
v.db.update map=habitats column=codigo value=2 where='HABITAT="Bosques naturales"'
v.db.update map=habitats column=codigo value=3 where='HABITAT="Estuarios-Marismas"'
v.db.update map=habitats column=codigo value=4 where='HABITAT="Hbitats rocosos"'
v.db.update map=habitats column=codigo value=5 where='HABITAT="Masas de agua"'
v.db.update map=habitats column=codigo value=6 where='HABITAT="Matorrales secos"'
v.db.update map=habitats column=codigo value=7 where='HABITAT="Paisaje rural"'
v.db.update map=habitats column=codigo value=8 where='HABITAT="Playas-Dunas"'
v.db.update map=habitats column=codigo value=9 where='HABITAT="reas urbanas e industriales"'
v.db.update map=habitats column=codigo value=10 where='HABITAT="Repoblaciones y bosques transformados"'
v.db.update map=habitats column=codigo value=11 where='HABITAT="Turberas-Brezales hmedos"'
v.db.update map=habitats column=codigo value=12 where='HABITAT="Vas de comunicacin"'

## Establecemos a rexión
g.mapsets mapset=MDT25
g.region rast=mdt25

## Convertimos a raster
v.to.rast input=habitats type=area out=habitats use=attr attr=codigo label=HABITAT