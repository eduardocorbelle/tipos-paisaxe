#!/bin/bash

## Script para a clasificación de unidades de tipo de cuberta da paisaxe
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset -c TmpPaisaxe_Cubertas
g.mapsets mapset=MDT25,AdminLimits,TmpPaisaxe_SIOSE,TmpPaisaxe_Habitat,TmpPaisaxe_Vinhedo,TmpPaisaxe_Cascos
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

## Uso do MDT25 para establecer a rexión
g.region rast=mdt25

## Copiamos mapa de concellos e establecemos a máscara
g.copy vect=concellos_siam,concellos
v.build concellos
v.to.rast input=concellos out=concellos use=val value=1
r.mask concellos


############
### Información de cubertas
### (unha combinación de SIOSE2011, mapa de hábitats, e parcelas de viñedo en SIOSE2011)

## Creamos unha capa de viñedo (cuberta de viñedo na parcela superior a 40%)
r.mapcalc expression="Vin=Vin040+Vin045+Vin050+Vin055+Vin060+Vin065+Vin070+Vin075+Vin080+Vin085+Vin090+Vin095+Vin100"

## Combinamos as diferentes capas
r.mapcalc expression="cubertas = if(siose2011r==2 | siose2011r==8, null(), if(habitats==2, 5, if(habitats==11, 2, if(Vin==1, 8, siose2011r))))"
r.category map=cubertas rules=Scripts/CategoriasCuberta.txt separator=":"
r.support -s cubertas
r.out.gdal in=cubertas out=ResultadosIntermedios/Cubertas.img format=HFA




## Cálculo dos histogramas de co-ocorrencias 
# *Ventá circular, diámetros de 250 e 1000 m (resolución 25 m/píxel)
p.sig.grid -c input=cubertas size=10 shift=1 method=coocurence histograms=Tmp/GrellaCubertas250

p.sig.grid -c input=cubertas size=40 shift=1 method=coocurence histograms=Tmp/GrellaCubertas1000

## Cálculo dos histogramas para as escenas seleccionadas
# Clases de paisaxe asociadas ás escenas: ver "escenasCubertaC.txt"
p.sig.points -c input=cubertas coorfile=Escenas/escenasCuberta.txt size=10 method=coocurence histograms=Tmp/escenasCuberta250.his

p.sig.points -c input=cubertas coorfile=Escenas/escenasCuberta.txt size=40 method=coocurence histograms=Tmp/escenasCuberta1000.his

### Similaridade coas escenas seleccionadas
p.sim.search scenes=Tmp/escenasCuberta1000.his grid=Tmp/GrellaCubertas1000 measure=shannon output=SC_1000 nulls=0.99

p.sim.search scenes=Tmp/escenasCuberta250.his grid=Tmp/GrellaCubertas250 measure=shannon output=SC_250 nulls=0.99

### Valores medios (e comprobación de valores extremos) de similaridade
## Monte raso (1)
g.copy raster=SC_1000_1,sMR
## Turbeiras (2)
g.copy raster=SC_1000_2,sTu
## Bosque (3)
g.copy raster=SC_1000_3,sB
## Repoboacións (4)
g.copy raster=SC_1000_5,sRF
## Agrogandeiro intensivo (5)
g.copy raster=SC_1000_7,sAI
## Agrogandeiro extensivo (6)
r.mapcalc expression="sAE = max(SC_1000_9, SC_1000_10)"
## Rururbano diseminado (7)
r.mapcalc expression="sRD = max(SC_250_11, SC_250_12)"
## Urbano (8)
g.copy raster=SC_250_13,sU
## Extractivo (9) 
g.copy raster=SC_250_15,sEx
## Mosaico agroforestal (10)
r.mapcalc expression="sAF = max(SC_1000_16, SC_1000_17)/2"
## Viñedo (11)
r.mapcalc expression="sVI = (SC_250_18 + SC_250_19)/2"

### Asignación por máxima similaridade
r.mapcalc expression="ClaseCuberta = if(sMR > sTu & sMR > sB & sMR > sRF & sMR > sAI & sMR > sAE & sMR > sRD & sMR > sU & sMR > sEx & sMR > sAF & sMR > sVI, 1, if(sTu > sB & sTu > sRF & sTu > sAI & sTu > sAE & sTu > sRD & sTu > sU  & sTu > sEx & sTu > sAF & sTu > sVI, 2, if(sB > sRF & sB > sAI & sB > sAE & sB > sRD & sB > sU & sB > sEx & sB > sAF & sB > sVI, 3, if(sRF > sAI & sRF > sAE & sRF > sRD & sRF > sU & sRF > sEx & sRF > sAF & sRF > sVI, 4, if(sAI > sAE & sAI > sRD & sAI > sU & sAI > sEx & sAI > sAF  & sAI > sVI, 5, if(sAE > sRD & sAE > sU & sAE > sEx & sAE > sAF & sAE > sVI, 6, if(sRD > sU & sRD > sEx & sRD > sAF & sRD > sVI, 7, if(sU > sEx & sU > sAF & sU > sVI, 8, if(sEx > sAF & sEx > sVI, 9, if(sAF > sVI, 10, 11))))))))))"

r.category ClaseCuberta sep=: rules=- << EOF
1:Matogueira e rochedo
2:Turbeira
3:Bosque
4:Agrosistema intensivo (plantacion forestal)
5:Agrosistema intensivo (superficie de cultivo)
6:Agrosistema extensivo
7:Rururbano (diseminado)
8:Urbano
9:Extractivo
10:Agrosistema intensivo (mosaico agroforestal)
11:Vinedo
EOF

## Incorporar os conxuntos históricos (área integral de protección)
v.to.rast in=AreaIntegral out=AreaIntegral use=val val=1
r.null map=AreaIntegral null=0

r.mapcalc expression="ClaseCuberta2=if(siose2011r==2,13,if(AreaIntegral==1, 12, ClaseCuberta))"

r.category ClaseCuberta2 sep=: rules=- << EOF
1:Matogueira e rochedo
2:Turbeira
3:Bosque
4:Agrosistema intensivo (plantacion forestal)
5:Agrosistema intensivo (superficie de cultivo)
6:Agrosistema extensivo
7:Rururbano (diseminado)
8:Urbano
9:Extractivo
10:Agrosistema intensivo (mosaico agroforestal)
11:Vinedo
12:Conxunto Historico
13:Lamina de auga
EOF


r.out.gdal in=ClaseCuberta2 out=ResultadosIntermedios/PatronCubertas_750m.img format=HFA

## Desactivar máscara
r.mask -r
