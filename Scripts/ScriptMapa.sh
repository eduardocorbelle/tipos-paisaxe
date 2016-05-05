#!/bin/bash

## Script para a combinación dos resultados finais
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset -c TmpPaisaxe_MapaFinal
g.mapsets mapset=MDT25,AdminLimits,TmpPaisaxe_Cubertas,TmpPaisaxe_Cubertas2,TmpPaisaxe_Cascos 
g.mapsets mapset=TmpPaisaxe_Clima2,TmpPaisaxe_Xeo2,TmpPaisaxe_POL,TmpPaisaxe_SIOSE
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

g.region rast=ClasesXeo

## Copiamos mapa de concellos e establecemos a máscara
r.mask concellos

## Simplificar (eliminar unidades menores de 10ha) nas clases (patróns) de cuberta
r.reclass.area input=ClaseCuberta out=ClaseCubertaB value=10 mode=lesser method=rmarea

r.category ClaseCubertaB sep=: rules=- << EOF
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

## Cruzar as categorías de clima e relevo
r.cross input=ClasesXeo,termoclima output=XeoClima





## Asignar relevo e clima
r.clump input=ClaseCubertaB output=ClaseCubertaClumps
r.statistics -c base=ClaseCubertaClumps cover=XeoClima method=mode output=TiposPaisaxeA
r.cross input=ClaseCubertaB,TiposPaisaxeA output=TiposPaisaxeB

## Incorporar os conxuntos históricos (área integral de protección) e outras
v.to.rast in=AreaIntegral out=AreaIntegral use=val val=1
r.null map=AreaIntegral null=0

r.mapcalc expression="TiposPaisaxeC=if(siose2011==10,20013,if(siose2011==4,20015, if(AreaIntegral==1, 20012, TiposPaisaxeB)))"

rm Tmp/Lenda1.txt -f

r.category map=TiposPaisaxeB >> Tmp/Lenda1.txt

TAB="$(printf '\t')"

cat <<EOT >> Tmp/Lenda1.txt
20012${TAB}Conxunto Historico; ;
20013${TAB}Lamina de auga; ;
20015${TAB}Praias e cantís; ;
EOT

r.category map=TiposPaisaxeC rules=Tmp/Lenda1.txt separator=tab


########## Pasar a vector 

r.to.vect -sv input=TiposPaisaxeC output=TiposPaisaxeC type=area

########## Exportar
v.out.ogr in=TiposPaisaxeC output=ResultadosFinais/ output_layer=UdsPaisaxe

