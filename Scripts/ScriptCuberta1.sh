#!/bin/bash

## Script para a clasificación de unidades de tipo de cuberta da paisaxe (1)
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
r.mapcalc expression="cubertas = if(siose2011==1 | siose2011==4 | siose2011==10, null(), if(habitats==2, 5, if(habitats==11, 12, if(Vin==1, 13, siose2011))))"

r.category map=cubertas sep=: rules=- << EOF
1:Sistemas xerais de transporte
2:Zonas urbanas e cubertas artificiais
3:Zonas de extraccion ou verquido
4:Praias e cantís
5:Especies caducifolias
6:Mosaico agricola e urbano (diseminado)
7:Mosaico agricola e forestal (agr extensivo)
8:Mato e rochedo
9:Repoboacion forestal
10:Augas continentais
11:Cultivos leñosos (agr intensivo)
12:Turbeiras
13:Vinedo
EOF

r.support -s cubertas
r.out.gdal in=cubertas out=ResultadosIntermedios/Cubertas.img format=HFA


## Cálculo dos histogramas de co-ocorrencias 
# *Ventá circular, diámetros de 1000 e 250 m (resolución 25 m/píxel)
p.sig.grid -c input=cubertas size=40 shift=1 method=coocurence histograms=Tmp/GrellaCubertasA

p.sig.grid -c input=cubertas size=10 shift=1 method=coocurence histograms=Tmp/GrellaCubertasB
