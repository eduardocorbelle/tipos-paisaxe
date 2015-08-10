#!/bin/bash

## Script para cargar a capa de SIOSE
## Eduardo Corbelle, 11 de xuño de 2015

g.mapset -c Clima

v.in.ogr dsn=./Data/Bioclima/01-bioclima-pol.shp out=bioclima # En principio, o que deberiamos utilizar
v.in.ogr dsn=./Data/Bioclima/02-macroclima-pol.shp out=macroclima
v.in.ogr dsn=./Data/Bioclima/03-ombroclima-pol.shp out=ombroclima
v.in.ogr dsn=./Data/Bioclima/04-termoclima-pol.shp out=termoclima