#!/bin/bash

## Script para a combinación dos resultados finais
## Eduardo Corbelle, iniciado o 7 de maio de 2015

g.mapset -c TmpPaisaxe_MapaFinal
g.mapsets mapset=MDT25,AdminLimits,TmpPaisaxe_Cubertas,TmpPaisaxe_Cubertas2,TmpPaisaxe_Cascos 
g.mapsets mapset=TmpPaisaxe_Clima2,TmpPaisaxe_Xeo2,TmpPaisaxe_POL,TmpPaisaxe_SIOSE
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f


## Establecemos a máscara
g.region rast=ClasesXeo
r.mask concellos


## Cruzamos Relevo e patróns de cuberta
g.copy rast=ClaseCuberta,ClaseCubertaB
r.null map=ClaseCubertaB null=12

r.category map=ClaseCubertaB sep=: rules=- << EOF
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
12:NoData
EOF

r.mapcalc expression="ClasesXeoB=ClasesXeo"

r.mask -r
r.cross input=ClasesXeoB,ClaseCubertaB out=Tipos1
r.mask concellos

## Simplificar (eliminar unidades menores de 10ha) 
r.reclass.area input=Tipos1 out=Tipos2 value=10 mode=lesser method=rmarea

r.category map=Tipos2 raster=Tipos1
# Devolvemos o tipo
r.mapcalc expression="Tipos2b=if(Tipos2==0, Tipos1, Tipos2)"
r.category map=Tipos2b raster=Tipos2

## Asignar clima
r.clump input=Tipos2b output=Tipos2c
r.statistics -c base=Tipos2c cover=termoclima method=mode output=Tipos3
r.cross input=Tipos2b,Tipos3 output=TiposPaisaxeA

## Incorporar os conxuntos históricos (área integral de protección) e outras
# Área integral de protección
v.to.rast in=AreaIntegral out=AreaIntegral use=val val=1
r.null map=AreaIntegral null=0

# Lámina de auga
r.mapcalc expression="lAuga = if(siose2011==10, 1, 0)"
r.reclass.area input=lAuga out=lAuga2 value=15 mode=lesser method=rmarea

# Superposición
r.mapcalc expression="TiposPaisaxeC=if(lAuga2==1,20013,if(siose2011==4,20015, if(AreaIntegral==1, 20012, TiposPaisaxeA)))"

rm Tmp/Lenda1.txt -f

r.category map=TiposPaisaxeA >> Tmp/Lenda1.txt

TAB="$(printf '\t')"

cat <<EOT >> Tmp/Lenda1.txt
20012${TAB};Conxunto Historico;
20013${TAB};Lamina de auga;
20015${TAB};Praias e cantis;
EOT

r.category map=TiposPaisaxeC rules=Tmp/Lenda1.txt separator=tab


########## Pasar a vector 

r.to.vect -sv input=TiposPaisaxeC output=TiposPaisaxeC type=area

########## Exportar
v.out.ogr in=TiposPaisaxeC output=ResultadosFinais/ output_layer=UdsPaisaxe

