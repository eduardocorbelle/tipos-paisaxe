#!/bin/bash

## Script para a clasificación de unidades morfolóxicas da paisaxe en GRASS GIS
## Eduardo Corbelle, iniciado o 7 de maio de 2015


############
## Acceso a mapsets
echo "-------------1-------------"
g.mapset -c Tmp
g.mapsets mapset=AdminLimits,MDT25,MDT200,SIOSE,Clima,Habitat,Vinhedo,Cascos

## Uso do MDT25 para establecer a rexión
echo "-------------2-------------"
g.region rast=mdt25

## Copiamos mapa de concellos e establecemos a máscara (se non fora executado antes)
echo "-------------3-------------"
g.copy vect=concellos_siam,concellos
v.build concellos
v.to.rast input=concellos out=concellos use=val value=1
r.mask concellos

## Baleiramos a carpeta Tmp
rm ./Tmp/*

############
### Información de cubertas
### (unha combinación de SIOSE2011, mapa de hábitats, e parcelas de viñedo en SIOSE2011)

## Creamos unha capa de viñedo (cuberta de viñedo na parcela superior a 40%)
echo "-------------4-------------"
r.mapcalc expression="Vin=Vin040+Vin045+Vin050+Vin055+Vin060+Vin065+Vin070+Vin075+Vin080+Vin085+Vin090+Vin095+Vin100"

## Combinamos as diferentes capas
echo "-------------5-------------"
r.mapcalc expression="cubertas = if(siose2011r==2|siose2011r==8, null(), if(habitats==2, 5, if(habitats==11, 2, if(Vin==1, 8, siose2011r))))"
r.category map=cubertas rules=./Scripts/CategoriasCuberta.txt separator=":"
r.support -s cubertas
r.out.gdal in=cubertas out=./Tmp/cubertas.img format=HFA

### Cálculo dos histogramas de co-ocorrencias (ventá circular, diámetro de 4000 m, resolución 25 m)
echo "-------------6-------------"
p.sig.grid -c input=cubertas size=160 shift=1 method=coocurence histograms=./Tmp/GrellaCubertas

### Cálculo dos histogramas para as escenas seleccionadas
echo "-------------7-------------"
p.sig.points -c input=cubertas coorfile=./tipos-paisaxe/Escenas/escenasCuberta.txt size=160 method=coocurence histograms=./Tmp/escenasCuberta.his

## Clases de paisaxe asociadas ás escenas: ver "escenasCubertaC.txt"

### Similaridade coas escenas seleccionadas
p.sim.search scenes=./Tmp/escenasCuberta.his grid=./Tmp/GrellaCubertas measure=shannon output=SC_shannon nulls=0.10

### Valores medios (e comprobación de valores extremos) de similaridade
# (Máscara co mapa de concellos) [xerado polo Script1]
echo "-------------8-------------"
#r.mask concellos
## Monte raso (1)
r.mapcalc expression="sMR = (SC_shannon_1)"
## Turbeiras (2)
r.mapcalc expression="sTu = (SC_shannon_2)"
## Bosque (3)
r.mapcalc expression="sB = (SC_shannon_3)"
## Repoboacións (4)
r.mapcalc expression="sRF = (SC_shannon_5+SC_shannon_6)/2"
## Agrogandeiro intensivo (5)
r.mapcalc expression="sAI = (SC_shannon_7+SC_shannon_8)/2"
## Agrogandeiro extensivo (6)
r.mapcalc expression="sAE = (SC_shannon_9 + SC_shannon_10)/2"
#r.mapcalc expression="dAE = sqrt((SC_shannon_9 - SC_shannon_10)^2)"
## Rururbano diseminado (7)
r.mapcalc expression="sRD = (SC_shannon_11 + SC_shannon_12)/2"
#r.mapcalc expression="dRD = sqrt((SC_shannon_11 - SC_shannon_12)^2)"
## Urbano (8)
r.mapcalc expression="sU = (SC_shannon_13)"
## Extractivo (9) 
g.copy raster=SC_shannon_15,sEx
## Mosaico agroforestal (10)
r.mapcalc expression="sAF = (SC_shannon_16 + SC_shannon_17)/2"
#r.mapcalc expression="dAF = sqrt((SC_shannon_16 - SC_shannon_17)^2)"
## Viñedo (11)
r.mapcalc expression="sVI = (SC_shannon_18 + SC_shannon_19)/2"
#r.mapcalc expression="dVI = sqrt((SC_shannon_18 - SC_shannon_19)^2)"

### Asignación por máxima similaridade
echo "-------------9-------------"
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

## Incorporar os conxuntos históricos (área integral de protección)
echo "-------------10-------------"
v.to.rast in=AreaIntegral out=AreaIntegral use=val val=1
r.null map=AreaIntegral null=0

r.mapcalc expression="ClaseCuberta2=if(AreaIntegral==1, 12, ClaseCuberta)"

r.category ClaseCuberta2 sep=: rules=- << EOF
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
12:Conxunto Historico
EOF

## Desactivar máscara
r.mask -r

## Borrar capas intermedias (libera aprox. 10 GB)
echo "-------------11-------------"
g.remove type=raster pattern=SC* -f
g.remove type=raster pattern=s* -f
g.remove type=raster pattern=d* -f
g.remove type=raster name=AreaIntegral -f
#g.remove type=raster name=Vin -f
