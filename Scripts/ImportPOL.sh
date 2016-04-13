#!/bin/bash

## Script para cargar o ámbito do POL
## Eduardo Corbelle, 12 de agosto de 2015

g.mapset -c TmpPaisaxe_POL
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f



v.in.ogr input=DatosOrixinais/POL/Ambito/AmbitoETRS89.shp out=Ambito
