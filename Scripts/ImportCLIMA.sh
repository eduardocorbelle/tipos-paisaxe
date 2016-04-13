#!/bin/bash

## Script para cargar a información sobre rexións bioclimáticas
## Eduardo Corbelle, 11 de xuño de 2015

g.mapset -c Bioclima
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

# Importación
v.in.ogr dsn=DatosOrixinais/RodriguezGuitian_RamilRego_2007/Shapefiles/01-bioclima-pol.shp out=bioclima 
v.in.ogr dsn=DatosOrixinais/RodriguezGuitian_RamilRego_2007/Shapefiles/02-macroclima-pol.shp out=macroclima
v.in.ogr dsn=DatosOrixinais/RodriguezGuitian_RamilRego_2007/Shapefiles/03-ombroclima-pol.shp out=ombroclima
v.in.ogr dsn=DatosOrixinais/RodriguezGuitian_RamilRego_2007/Shapefiles/04-termoclima-pol.shp out=termoclima # O que deberiamos utilizar
