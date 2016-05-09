## Script para analizar a frecuencia de aparición dos tipos por grande área e comarca paisaxística
## Eduardo Corbelle, 1 de outubro de 2015

## Importamos a información de grandes áreas e comarcas e os resultados finais
g.mapset -c TmpPaisaxe_GAP

g.mapsets mapset=MDT25
g.remove type=raster pattern=* -f
g.remove type=vector pattern=* -f

v.in.ogr input=DatosOrixinais/areas_comarcas_paisaxe/Grandes_areas_paisaxisticas.shp out=GrandesAreas snap=1e-03
v.in.ogr input=DatosOrixinais/areas_comarcas_paisaxe/Comarcas_paisaxisticas.shp out=Comarcas snap=1e-03
v.in.ogr input=ResultadosFinais/UdsPaisaxe.shp out=uds


v.db.addcolumn map=uds columns="xeo integer, cub integer, cli integer"

v.db.update map=uds column=xeo value=1 where='Xeomorf="Canons"'
v.db.update map=uds column=xeo value=2 where='Xeomorf="Chairas e vales interiores"'
v.db.update map=uds column=xeo value=3 where='Xeomorf="Litoral Cantabro-Atlantico"'
v.db.update map=uds column=xeo value=4 where='Xeomorf="Serras"'
v.db.update map=uds column=xeo value=5 where='Xeomorf="Vales sublitorais"'


v.db.update map=uds column=cub value=1 where='Cuberta="Agrosistema extensivo"'
v.db.update map=uds column=cub value=2 where='Cuberta="Agrosistema intensivo (mosaico agroforestal)"'
v.db.update map=uds column=cub value=3 where='Cuberta="Agrosistema intensivo (plantacion forestal)"'
v.db.update map=uds column=cub value=4 where='Cuberta="Agrosistema intensivo (superficie de cultivo)"'
v.db.update map=uds column=cub value=5 where='Cuberta="Bosque"'
v.db.update map=uds column=cub value=6 where='Cuberta="Conxunto Historico"'
v.db.update map=uds column=cub value=7 where='Cuberta="Extractivo"'
v.db.update map=uds column=cub value=8 where='Cuberta="Lamina de auga"'
v.db.update map=uds column=cub value=9 where='Cuberta="Matogueira e rochedo"'
v.db.update map=uds column=cub value=10 where='Cuberta="NoData"'
v.db.update map=uds column=cub value=11 where='Cuberta="Praias e cantis"'
v.db.update map=uds column=cub value=12 where='Cuberta="Rururbano (diseminado)"'
v.db.update map=uds column=cub value=13 where='Cuberta="Turbeira"'
v.db.update map=uds column=cub value=14 where='Cuberta="Urbano"'
v.db.update map=uds column=cub value=15 where='Cuberta="Vinedo"'


v.db.update map=uds column=cli value=1 where='Clima="Mesomediterr\xe1neo"'
v.db.update map=uds column=cli value=2 where='Clima="Mesotemperado inferior"'
v.db.update map=uds column=cli value=3 where='Clima="Mesotemperado superior"'
v.db.update map=uds column=cli value=4 where='Clima="no data"'
v.db.update map=uds column=cli value=5 where='Clima="Supra e orotemperado"'
v.db.update map=uds column=cli value=6 where='Clima="Termotemperado"'


## Aseguramos a rexión
g.region rast=mdt25@MDT25

## Convertimos os mapas a raster
v.to.rast in=GrandesAreas out=GrandesAreas use=cat label_column=GranArea
v.to.rast in=Comarcas out=Comarcas use=cat label_column=Comarca

v.to.rast in=uds out=xeo use=attr attr=xeo label_column=Xeomorf
v.to.rast in=uds out=cub use=attr attr=cub label_column=Cuberta
v.to.rast in=uds out=cli use=attr attr=cli label_column=Clima

## Obtemos os tipos por grandes áreas (resultados en m2)
r.stats -alN in=GrandesAreas,xeo,cub,cli out=ResultadosIntermedios/TiposAreas.txt separator=pipe null_value=NA

r.stats -alN in=GrandesAreas,Comarcas,xeo,cub,cli out=ResultadosIntermedios/TiposAreasComarcas.txt separator=pipe null_value=NA
