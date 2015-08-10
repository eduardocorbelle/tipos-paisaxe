#!/bin/bash

## Script de probas en Polaris para a incorporación de información climática
## Eduardo Corbelle, iniciado o 7 de maio de 2015

########## Mapa climático
#### Copiar ao mapset activo, engadir códigos numéricos
g.copy vect=bioclima@Clima,bioclima
v.build map=bioclima
v.db.addcolumn map=bioclima columns='codigo INT'
v.db.update map=bioclima layer=1 column=codigo value=1 where="BIOCLIMA='Subhiperoceánico'"
v.db.update map=bioclima layer=1 column=codigo value=2 where="BIOCLIMA='Semihiperoceánico'"
v.db.update map=bioclima layer=1 column=codigo value=3 where="BIOCLIMA='Euoceánico'"
v.db.update map=bioclima layer=1 column=codigo value=4 where="BIOCLIMA='Semicontinental'"
#### Pasar a ráster
v.to.rast input=bioclima type=area use=attr attribute_column=codigo out=bioclima
r.category bioclima sep=: rules=- << EOF
1:Subhiperoceánico
2:Semihiperoceánico
3:Euoceánico
4:Semicontinental
EOF