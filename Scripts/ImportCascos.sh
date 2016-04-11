#!/bin/bash

## Script para cargar a capa de Conxuntos históricos
## Eduardo Corbelle, 12 de agosto de 2015

g.mapset -c TmpPaisaxe_Cascos
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

v.in.ogr input=DatosOrixinais/CascosHistoricos/CaminoSantiago.shp
v.in.ogr input=DatosOrixinais/CascosHistoricos/ConxuntosHistoricos.shp snap=0.1

## Seleccionar as áreas integrais
v.extract input=ConxuntosHistoricos where="Tipo='Area Integral'" output=AreaIntegral
