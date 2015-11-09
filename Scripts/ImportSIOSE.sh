#!/bin/bash

## Script para cargar a capa de SIOSE
## Eduardo Corbelle, 11 de xuño de 2015

# Require previamente da unión entre a base de datos orixinal e o ficheiro SIOSElenda.csv (para asignar valores numéricos ás categorías do mapa)

g.mapset -c SIOSE

## Importamos o ficheiro
v.in.ogr input=/media/sf_Datos_Corbelle/Data/Datos_IET/SIOSE2011/SIOSE_2011_agregado.shp output=siose2011

## Creamos un campo 'codigo'
v.db.addcolumn map=siose2011 columns="codigo int"

v.db.update map=siose2011 column=codigo value=1 where="CLASELENDA='Afloramientos rochosos e rochedos'"
v.db.update map=siose2011 column=codigo value=2 where="CLASELENDA='Augas continentais'"
v.db.update map=siose2011 column=codigo value=3 where="CLASELENDA='Augas mariñas'"
v.db.update map=siose2011 column=codigo value=4 where="CLASELENDA='Coberturas artificiais'"
v.db.update map=siose2011 column=codigo value=5 where="CLASELENDA='Coníferas'"
v.db.update map=siose2011 column=codigo value=6 where="CLASELENDA='Cultivos e prados'"
v.db.update map=siose2011 column=codigo value=7 where="CLASELENDA='Especies caducifolias'"
v.db.update map=siose2011 column=codigo value=8 where="CLASELENDA='Eucaliptos'"
v.db.update map=siose2011 column=codigo value=9 where="CLASELENDA='Eucaliptos e coníferas'"
v.db.update map=siose2011 column=codigo value=10 where="CLASELENDA='Humedais'"
v.db.update map=siose2011 column=codigo value=11 where="CLASELENDA='Instalacións deportivas'"
v.db.update map=siose2011 column=codigo value=12 where="CLASELENDA='Mato'"
v.db.update map=siose2011 column=codigo value=13 where="CLASELENDA='Mato e especies arbóreas'"
v.db.update map=siose2011 column=codigo value=14 where="CLASELENDA='Mato e rochedo'"
v.db.update map=siose2011 column=codigo value=15 where="CLASELENDA='Mestura de especies arbóreas'"
v.db.update map=siose2011 column=codigo value=16 where="CLASELENDA='Mosaico agrícola e mato'"
v.db.update map=siose2011 column=codigo value=17 where="CLASELENDA='Mosaico agrícola e urbano'"
v.db.update map=siose2011 column=codigo value=18 where="CLASELENDA='Mosaico de cultivos e especies arbóreas'"
v.db.update map=siose2011 column=codigo value=18 where="CLASELENDA='Mosaico de cultivos e especies arbóreas\r\n'"
v.db.update map=siose2011 column=codigo value=19 where="CLASELENDA='Praias e cantís'"
v.db.update map=siose2011 column=codigo value=20 where="CLASELENDA='Repoboacións forestais'"
v.db.update map=siose2011 column=codigo value=21 where="CLASELENDA='Sistemas xerais de transporte'"
v.db.update map=siose2011 column=codigo value=22 where="CLASELENDA='Viñedo e cultivos leñosos'"
v.db.update map=siose2011 column=codigo value=23 where="CLASELENDA='Zonas de extracción ou vertido'"
v.db.update map=siose2011 column=codigo value=24 where="CLASELENDA='Zonas queimadas'"
v.db.update map=siose2011 column=codigo value=25 where="CLASELENDA='Zonas urbanas'"

## Establecemos a rexión
g.mapsets addmapset=MDT25
g.region rast=mdt25

## Convertimos a raster
v.to.rast input=siose2011 type=area out=siose2011 use=attr attribute_column=codigo

## Reclasificamos
r.reclass input=siose2011 output=siose2011r rules=./Scripts/ReclassSiose.txt title="Siose 2011 reclasificado"



