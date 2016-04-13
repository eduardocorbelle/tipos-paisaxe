#!/bin/bash

## Script para a incorporación de información climática
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset -c TmpPaisaxe_Clima2
g.mapsets mapset=MDT25,AdminLimits,Bioclima
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

g.region rast=mdt25

########## Mapa climático
#### Copiar ao mapset activo, engadir códigos numéricos
g.copy vect=termoclima@Clima,termoclima
v.build map=termoclima

v.db.addcolumn map=termoclima columns='codigo INT'

v.db.update map=termoclima layer=1 column=codigo value=1 where="TERMOTIPO='Termotemperado'"
v.db.update map=termoclima layer=1 column=codigo value=2 where="TERMOTIPO='Mesotemperado inferior'"
v.db.update map=termoclima layer=1 column=codigo value=3 where="TERMOTIPO='Mesotemperado superior'"
v.db.update map=termoclima layer=1 column=codigo value=4 where="TERMOTIPO='Supratemperado inferior'"
v.db.update map=termoclima layer=1 column=codigo value=4 where="TERMOTIPO='Supratemperado superior'"
v.db.update map=termoclima layer=1 column=codigo value=4 where="TERMOTIPO='Orotemperado'"
v.db.update map=termoclima layer=1 column=codigo value=5 where="TERMOTIPO='Mesomediterráneo'"

#### Pasar a ráster
v.to.rast input=termoclima type=area use=attr attribute_column=codigo out=termoclima

r.category termoclima sep=: rules=- << EOF
1:Termotemperado
2:Mesotemperado inferior
3:Mesotemperado superior
4:Supra e orotemperado
5:Mesomediterráneo
EOF
