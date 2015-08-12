#!/bin/bash

## Script para cargar a capa de SIOSE
## Eduardo Corbelle, 11 de xuño de 2015

# Require previamente da unión entre a base de datos orixinal e o ficheiro SIOSElenda.csv (para asignar valores numéricos ás categorías do mapa)

g.mapset -c SIOSE

## Importamos o ficheiro
v.in.ogr dsn=./Data/Datos_IET/SIOSE2011/SIOSE2011lenda.shp output=siose2011

## Establecemos a rexión
g.mapsets addmapset=MDT25
g.region rast=mdt25

## Convertimos a raster
v.to.rast input=siose2011 type=area out=siose2011 use=attr column=SIOSElenda labelcolumn=CLASELENDA

## Reclasificamos
r.reclass input=siose2011 output=siose2011r rules=./Scripts/ReclassSiose.txt title="Siose 2011 reclasificado"



