#!/bin/bash

## Script para cargar os datos de MDT200 e facer un mosaico con eles
## Eduardo Corbelle, 28 de xullo de 2015
g.mapset -c MDT200

r.in.gdal -o input=./Data/MDT200/MDT200-A_CORUNIA-H29.asc out=mdt200C
r.in.gdal -o input=./Data/MDT200/MDT200-LUGO-H29.asc out=mdt200LU
r.in.gdal -o input=./Data/MDT200/MDT200-OURENSE-H29.asc out=mdt200OU
r.in.gdal -o input=./Data/MDT200/MDT200-PONTEVEDRA-H29.asc out=mdt200PO

g.region rast=mdt200C,mdt200LU,mdt200PO,mdt200OU
r.patch in=mdt200C,mdt200LU,mdt200PO,mdt200OU out=mdt200

g.mremove rast=mdt200-* -f
