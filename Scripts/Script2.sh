#!/bin/bash

## Script de probas en Polaris para a clasificación de unidades morfolóxicas da paisaxe
## Eduardo Corbelle, iniciado o 7 de maio de 2015


############
### Sesión do 29 de xullo de 2015

## Acceso a mapsets
g.mapset -c Tmp
g.mapsets mapset=AdminLimits,MDT25,MDT200,SIOSE,Clima,Habitat,Vinhedo

## Uso do MDT25 para establecer a rexión
g.region rast=mdt25

### Información de cubertas: combinación de SIOSE2011, mapa de hábitats, e viñedo
## Creamos unha capa de viñedo (cuberta de viñedo superior a 40%)
r.mapcalc expression="Vin=Vin040+Vin045+Vin050+Vin055+Vin060+Vin065+Vin070+Vin075+Vin080+Vin085+Vin090+Vin095+Vin100"
## Combinamos as diferentes capas
r.mapcalc expression="cubertas = if(siose2011r==2|siose2011r==8, null(), if(habitats==2, 5, if(habitats==11, 2, if(Vin==1, 8, siose2011r))))"
r.category map=cubertas rules=./Scripts/CategoriasCuberta.txt separator=":"
r.support -s cubertas

### Cálculo dos histogramas de co-ocorrencias (ventá circular, radio de 1500 m, resolución 25 m)
p.sig.grid -c input=cubertas size=60 shift=1 method=coocurence histograms=./Tmp/GrellaCubertas

### Cálculo dos histogramas para as escenas seleccionadas
p.sig.points -c input=cubertas coorfile=./Escenas/escenasCuberta.txt size=60 method=coocurence histograms=./Tmp/escenasCuberta.his

## Clases de cuberta asociadas ás escenas (escenascuberta.txt)
# 1 e 2: monte raso
# 3 e 4: bosque
# 5 e 6: repoboacións
# 7 e 8: agrogandeiro intensivo
# 9 e 10: agrogandeiro extensivo
# 11 e 12: rururbano diseminado
# 13 e 14: urbano
# 15 : extractivo
# 16 e 17: mosaico agroforestal

### Similaridade coas escenas seleccionadas
p.sim.search scenes=./Tmp/escenasCuberta.his grid=./Tmp/GrellaSiose measure=shannon output=SC_shannon nulls=0.55

### Valores medios (e comprobación de valores extremos) de similaridade
# (Máscara co mapa de concellos) [xerado polo Script1]
r.mask concellos
## Monte raso (1)
r.mapcalc expression="sMR = (SC_shannon_1 + SC_shannon_2)/2"
r.mapcalc expression="dMR = sqrt((SC_shannon_1 - SC_shannon_2)^2)"
## Bosque (2)
r.mapcalc expression="sB = (SC_shannon_3 + SC_shannon_4)/2"
r.mapcalc expression="dB = sqrt((SC_shannon_3 - SC_shannon_4)^2)"
## Repoboacións (3)
r.mapcalc expression="sRF = (SC_shannon_5 + SC_shannon_6)/2"
r.mapcalc expression="dRF = sqrt((SC_shannon_5 - SC_shannon_6)^2)"
## Agrogandeiro intensivo (4)
r.mapcalc expression="sAI = (SC_shannon_7 + SC_shannon_8)/2"
r.mapcalc expression="dAI = sqrt((SC_shannon_7 - SC_shannon_8)^2)"
## Agrogandeiro extensivo (5)
r.mapcalc expression="sAE = (SC_shannon_9 + SC_shannon_10)/2"
r.mapcalc expression="dAE = sqrt((SC_shannon_9 - SC_shannon_10)^2)"
## Rururbano diseminado (6)
r.mapcalc expression="sRD = (SC_shannon_11 + SC_shannon_12)/2"
r.mapcalc expression="dRD = sqrt((SC_shannon_11 - SC_shannon_12)^2)"
## Urbano (7)
r.mapcalc expression="sU = (SC_shannon_13 + SC_shannon_14)/2"
r.mapcalc expression="dU = sqrt((SC_shannon_13 - SC_shannon_14)^2)"
## Extractivo (8) 
# Non procede (1 única mostra) --> SC_shannon_15
g.copy raster=SC_shannon_15,sEx
## Mosaico agroforestal (9)
r.mapcalc expression="sAF = (SC_shannon_16 + SC_shannon_17)/2"
r.mapcalc expression="dAF = sqrt((SC_shannon_16 - SC_shannon_17)^2)"

### Asignación por máxima similaridade
r.mapcalc expression="ClaseCuberta = if(sMR > sB & sMR > sRF & sMR > sAI & sMR > sAE & sMR > sRD & sMR > sU & sMR > sEx & sMR > sAF, 1, if(sB > sRF & sB > sAI & sB > sAE & sB > sRD & sB > sU & sB > sEx & sB > sAF, 2, if(sRF > sAI & sRF > sAE & sRF > sRD & sRF > sU & sRF > sEx & sRF > sAF, 3, if(sAI > sAE & sAI > sRD & sAI > sU & sAI > sEx & sAI > sAF, 4, if(sAE > sRD & sAE > sU & sAE > sEx & sAE > sAF, 5, if(sRD > sU & sRD > sEx & sRD > sAF, 6, if(sU > sEx & sU > sAF, 7, if(sEx > sAF, 8, 9))))))))"

r.category ClaseCuberta sep=: rules=- << EOF
1:Monte raso
2:Bosque
3:Repoboacion forestal
4:Agrogandeiro intensivo
5:Agrogandeiro extensivo
6:Rururbano (diseminado)
7:Urbano
8:Extractivo
9:Mosaico agroforestal
EOF

## Desactivar máscara
r.mask -r