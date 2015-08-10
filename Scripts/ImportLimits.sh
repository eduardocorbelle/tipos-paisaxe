#!/bin/bash

## Script para cargar os límites administrativos do IGN
## (Datos tomados da capa de límites de provincias, previa selección das provincias de Galicia e reproxección a EPSG:25829)
## Eduardo Corbelle, 23 de abril de 2015
g.mapset -c AdminLimits

v.in.ogr dsn=./Data/LimitesAdmin output=provinciasIGN
