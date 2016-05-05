#!/bin/bash

## Script para a clasificación de unidades de tipo de cuberta da paisaxe (2)
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset -c TmpPaisaxe_Cubertas2
g.mapsets mapset=MDT25,AdminLimits,TmpPaisaxe_SIOSE,TmpPaisaxe_Habitat
g.mapsets mapset=TmpPaisaxe_Vinhedo,TmpPaisaxe_Cascos,TmpPaisaxe_Cubertas
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

## Uso do MDT25 para establecer a rexión
g.region rast=mdt25

## Copiamos mapa de concellos e establecemos a máscara
r.mask concellos


## Cálculo dos histogramas para as escenas seleccionadas
# Clases de paisaxe asociadas ás escenas: ver "escenasCubertaC.txt"
p.sig.points -c input=cubertas coorfile=Escenas/escenasCuberta_A.txt size=40 method=coocurence histograms=Tmp/escenasCubertaA.his

p.sig.points -c input=cubertas coorfile=Escenas/escenasCuberta_B.txt size=10 method=coocurence histograms=Tmp/escenasCubertaB.his

### Similaridade coas escenas seleccionadas
p.sim.search scenes=Tmp/escenasCubertaA.his grid=Tmp/GrellaCubertasA measure=shannon output=SC_A nulls=0.99

p.sim.search scenes=Tmp/escenasCubertaB.his grid=Tmp/GrellaCubertasB measure=shannon output=SC_B nulls=0.99

### Valores medios (e comprobación de valores extremos) de similaridade
## Monte raso (1)
g.copy raster=SC_A_1,sMR
## Turbeiras (2)
g.copy raster=SC_A_2,sTu
## Bosque (3)
g.copy raster=SC_A_3,sB
## Repoboacións (4)
g.copy raster=SC_A_5,sRF
## Agrogandeiro intensivo (5)
g.copy raster=SC_A_7,sAI
## Agrogandeiro extensivo (6)
r.mapcalc expression="sAE = (SC_A_8 + SC_A_9 + SC_A_10)/3"
## Rururbano diseminado (7)
r.mapcalc expression="sRD = (SC_A_4 + SC_A_11 + SC_A_12 + SC_A_13)/4"
## Urbano (8)
g.copy raster=SC_B_14,sU
## Extractivo (9) 
g.copy raster=SC_B_15,sEx
## Mosaico agroforestal (10)
r.mapcalc expression="sAF = (SC_A_16 + SC_A_17)/2"
## Viñedo (11)
r.mapcalc expression="sVI = (SC_A_18 + SC_A_19)/2"

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

## Desactivar máscara
r.mask -r
