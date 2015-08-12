#!/bin/bash

## Script para cargar a capa de Conxuntos históricos
## Eduardo Corbelle, 12 de agosto de 2015

g.mapset -c Cascos

v.in.ogr input=./Data/CascosHistoricos/CaminoSantiago.shp
v.in.ogr input=./Data/CascosHistoricos/ConxuntosHistoricos.shp snap=0.1

## Seleccionar as áreas integrais
v.extract input=ConxuntosHistoricos where="Tipo='Area Integral'" output=AreaIntegral