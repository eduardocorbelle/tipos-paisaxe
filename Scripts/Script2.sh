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

### Cálculo dos histogramas de co-ocorrencias (ventá circular, diámetro de 1500 m, resolución 25 m)
echo "Calculando a grella de escenas"
p.sig.grid -c input=cubertas size=60 shift=1 method=coocurence histograms=./Tmp/GrellaCubertas

### Cálculo dos histogramas para as escenas seleccionadas
p.sig.points -c input=cubertas coorfile=./Escenas/escenasCuberta.txt size=60 method=coocurence histograms=./Tmp/escenasCuberta.his

## Clases de cuberta asociadas ás escenas (escenascuberta.txt)
# 1 : monte raso
# 2 : turbeiras
# 3 : bosque
# 5 : repoboacións
# 7 : agrogandeiro intensivo
# 9 e 10: agrogandeiro extensivo
# 11 e 12: rururbano diseminado
# 13 : urbano
# 15 : extractivo
# 16 e 17: mosaico agroforestal
# 18 e 19: viñedo

### Similaridade coas escenas seleccionadas
p.sim.search scenes=./Tmp/escenasCuberta.his grid=./Tmp/GrellaSiose measure=shannon output=SC_shannon nulls=0.80

### Valores medios (e comprobación de valores extremos) de similaridade
# (Máscara co mapa de concellos) [xerado polo Script1]
r.mask concellos
## Monte raso (1)
r.mapcalc expression="sMR = (SC_shannon_1)"
## Turbeiras (2)
r.mapcalc expression="sTu = (SC_shannon_2)"
## Bosque (3)
r.mapcalc expression="sB = (SC_shannon_3)"
## Repoboacións (4)
r.mapcalc expression="sRF = (SC_shannon_5)"
## Agrogandeiro intensivo (5)
r.mapcalc expression="sAI = (SC_shannon_7)"
## Agrogandeiro extensivo (6)
r.mapcalc expression="sAE = (SC_shannon_9 + SC_shannon_10)/2"
r.mapcalc expression="dAE = sqrt((SC_shannon_9 - SC_shannon_10)^2)"
## Rururbano diseminado (7)
r.mapcalc expression="sRD = (SC_shannon_11 + SC_shannon_12)/2"
r.mapcalc expression="dRD = sqrt((SC_shannon_11 - SC_shannon_12)^2)"
## Urbano (8)
r.mapcalc expression="sU = (SC_shannon_13)"
## Extractivo (9) 
g.copy raster=SC_shannon_15,sEx
## Mosaico agroforestal (10)
r.mapcalc expression="sAF = (SC_shannon_16 + SC_shannon_17)/2"
r.mapcalc expression="dAF = sqrt((SC_shannon_16 - SC_shannon_17)^2)"
## Viñedo (11)
r.mapcalc expression="sVI = (SC_shannon_18 + SC_shannon_19)/2"
r.mapcalc expression="dVI = sqrt((SC_shannon_18 - SC_shannon_19)^2)"


### Asignación por máxima similaridade
r.mapcalc expression="ClaseCuberta = if(sMR > sTu & sMR > sB & sMR > sRF & sMR > sAI & sMR > sAE & sMR > sRD & sMR > sU & sMR > sEx & sMR > sAF & sMR > sVI, 1, if(sTu > sB & sTu > sRF & sTu > sAI & sTu > sAE & sTu > sRD & sTu > sU  & sTu > sEx & sTu > sAF & sTu > sVI, 2, if(sB > sRF & sB > sAI & sB > sAE & sB > sRD & sB > sU & sB > sEx & sB > sAF & sB > sVI, 3, if(sRF > sAI & sRF > sAE & sRF > sRD & sRF > sU & sRF > sEx & sRF > sAF & sRF > sVI, 4, if(sAI > sAE & sAI > sRD & sAI > sU & sAI > sEx & sAI > sAF  & sAI > sVI, 5, if(sAE > sRD & sAE > sU & sAE > sEx & sAE > sAF & sAE > sVI, 6, if(sRD > sU & sRD > sEx & sRD > sAF & sRD > sVI, 7, if(sU > sEx & sU > sAF & sU > sVI, 8, if(sEx > sAF & sEx > sVI, 9, if(sAF > sVI, 10, 11))))))))))"

r.category ClaseCuberta sep=: rules=- << EOF
1:Monte raso
2:Turbeira
3:Bosque
4:Repoboacion forestal
5:Agrogandeiro intensivo
6:Agrogandeiro extensivo
7:Rururbano (diseminado)
8:Urbano
9:Extractivo
10:Mosaico agroforestal
11:Vinhedo
EOF

## Desactivar máscara
r.mask -r