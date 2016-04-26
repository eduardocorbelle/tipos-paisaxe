#!/bin/bash

## Script para cargar a capa de SIOSE
## Eduardo Corbelle, 11 de xuño de 2015

g.mapset -c TmpPaisaxe_SIOSE
g.remove type=raster pattern=* -f
g.remove type=raster pattern=* -f # (2 veces para eliminar o mapa reclasificado primeiro)
g.remove type=vector pattern=* -f

## Importamos o ficheiro
v.in.ogr input=DatosProcesados/nueva_agregacion.shp output=siose2011

## Establecemos a rexión
g.mapsets mapset=MDT25 operation=add
g.region rast=mdt25

## Convertimos a raster
# (Utilizamos o campo "AGREGACION")
v.to.rast input=siose2011 type=area out=siose2011 use=attr attribute_column=code

## Reclasificamos
r.category map=siose2011 rules=DatosOrixinais/Siose2011_B/nueva_agregacion.txt
