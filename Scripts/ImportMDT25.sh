#!/bin/bash

## Script para cargar os datos de MDT25 e facer un mosaico con eles
## Eduardo Corbelle, 21 de abril de 2015
g.mapset -c MDT25

for i in ./Data/MDT25/*.asc

do 

j=`basename $i .asc`

r.in.gdal -o input=$i output=$j

done

list=`g.mlist type=rast pattern=MDT25* separator=comma`

g.region rast=$list
r.patch input=$list output=mdt25
g.mremove rast=MDT25-* -f
