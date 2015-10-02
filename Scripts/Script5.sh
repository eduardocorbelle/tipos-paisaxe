## Script para analizar a frecuencia de aparición dos tipos por grande área e comarca paisaxística
## Eduardo Corbelle, 1 de outubro de 2015

## Importamos a información de grandes áreas e comarcas
g.mapset -c GAP
v.in.ogr input=/media/sf_Datos_Corbelle/Data/areas_comarcas_paisaxe/Grandes_areas_paisaxisticas.shp out=GrandesAreas snap=1e-03
v.in.ogr input=/media/sf_Datos_Corbelle/Data/areas_comarcas_paisaxe/Comarcas_paisaxisticas.shp out=Comarcas snap=1e-03

## Aseguramos a rexión
g.region rast=mdt25@MDT25

## Convertimos ambos mapas a raster
v.to.rast in=GrandesAreas out=GrandesAreas use=cat label_column=GranArea
v.to.rast in=Comarcas out=Comarcas use=cat label_column=Comarca

## Cambiamos ao mapset Tmp
g.mapset Tmp
g.mapsets GAP

## Aseguramos a rexión
g.region rast=mdt25@MDT25

## Obtemos os tipos por grandes áreas (resultados en m2)
r.stats -alN in=GrandesAreas,ClasesXeo,ClaseCuberta2,termoclima out=./Informes/Informe1/TiposAreas_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA