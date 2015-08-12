#!/bin/bash

## Script para cargar o ámbito do POL
## Eduardo Corbelle, 12 de agosto de 2015

g.mapset -c POL

v.in.ogr input=./Data/POL/Ambito/AmbitoETRS89.shp out=Ambito