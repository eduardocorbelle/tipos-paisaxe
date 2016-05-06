## Makefile para substituír ao ficheiro ScriptMaestro.sh
## Eduardo Corbelle, 11 de abril de 2016

R_opts = --vanilla

all: relevo clima cubertas mapa analise


################# Grandes unidades do relevo ###########################
relevo: Logs/ScriptXeomorf2.log

# Segmentación
# Logs/ScriptXeomorf1.log: Scripts/ScriptXeomorf1.sh
#	sh -x Scripts/ScriptXeomorf1.sh 2>&1 | tee Logs/ScriptXeomorf1.log

# Importación da clasificación manual
Logs/ScriptXeomorf2.log: Scripts/ScriptXeomorf2.sh DatosOrixinais/ClasifXeomorf/segmentos25_clasif.shp
#	Debería depender tamén de Logs/ScriptXeomorf1.log
	sh -x Scripts/ScriptXeomorf2.sh 2>&1 | tee Logs/ScriptXeomorf2.log


################# Clasificación bioclimática ###########################
clima: Logs/ScriptClima.log

Logs/ImportCLIMA.log: Scripts/ImportCLIMA.sh
	sh -x Scripts/ImportCLIMA.sh 2>&1 | tee Logs/ImportCLIMA.log

Logs/ScriptClima.log: Logs/ImportCLIMA.log Scripts/ScriptClima.sh
	sh -x Scripts/ScriptClima.sh 2>&1 | tee Logs/ScriptClima.log


################# Patróns de cubertas ##################################
cubertas: Logs/ScriptCuberta2.log

## Importación de capas
Logs/PreparaSiose.Rout: Scripts/PreparaSiose.R
	rm DatosProcesados/nueva_agregacion.* -f
	cp DatosOrixinais/Siose2011_B/nueva_agregacion.* DatosProcesados/
	mv DatosProcesados/nueva_agregacion.dbf DatosProcesados/nueva_agregacion.dbf.bk
	R CMD BATCH $(R_opts) Scripts/PreparaSiose.R Logs/PreparaSiose.Rout

Logs/ImportSIOSE.log: Logs/PreparaSiose.Rout DatosOrixinais/Siose2011_B/nueva_agregacion.txt Scripts/ImportSIOSE.sh
	sh -x Scripts/ImportSIOSE.sh 2>&1 | tee Logs/ImportSIOSE.log

Logs/ImportHabitat.log: Scripts/ImportHabitat.sh
	sh -x Scripts/ImportHabitat.sh 2>&1 | tee Logs/ImportHabitat.log

Logs/ImportCascos.log: Scripts/ImportCascos.sh
	sh -x Scripts/ImportCascos.sh 2>&1 | tee Logs/ImportCascos.log

## Busca de patróns
Logs/ScriptCuberta1.log: Logs/ImportSIOSE.log Logs/ImportHabitat.log Logs/ImportCascos.log Scripts/ScriptCuberta1.sh
	rm Tmp/* -f
	rm ResultadosIntermedios/Cubertas.img -f
	sh -x Scripts/ScriptCuberta1.sh 2>&1 | tee Logs/ScriptCuberta1.log

Logs/ScriptCuberta2.log: Logs/ImportSIOSE.log Logs/ImportHabitat.log Logs/ImportCascos.log Logs/ScriptCuberta1.log Scripts/ScriptCuberta2.sh
	rm Tmp/escenasCuberta* -f
	rm ResultadosIntermedios/PatronCubertas.img -f
	sh -x Scripts/ScriptCuberta2.sh 2>&1 | tee Logs/ScriptCuberta2.log


################# Mapa final ##########################################
mapa: Logs/TiposUnfold.Rout 

Logs/ImportPOL.log: Scripts/ImportPOL.sh
	sh -x Scripts/ImportPOL.sh 2>&1 | tee Logs/ImportPOL.log

Logs/ScriptMapa.log: Logs/ImportPOL.log Scripts/ScriptMapa.sh Logs/ScriptCuberta2.log Logs/ScriptClima.log Logs/ScriptXeomorf2.log
	rm ResultadosFinais/UdsPaisaxe.* -f
	sh -x Scripts/ScriptMapa.sh 2>&1 | tee Logs/ScriptMapa.log

Logs/TiposUnfold.Rout: Logs/ScriptMapa.log Scripts/TiposUnfoldLegend.R
	R CMD BATCH $(R_opts) Scripts/TiposUnfoldLegend.R Logs/TiposUnfold.Rout


################# Análise de resultados ################################
analise: Logs/Figuras1.Rout Logs/Mapas.log Logs/TiposComarcas.Rout Logs/TiposUnfold.Rout

# Figuras para o informe: áreas de entrenamento
Logs/Figuras1.Rout: Scripts/Figuras1.R
	R CMD BATCH $(R_opts) Scripts/Figuras1.R Logs/Figuras1.Rout

# Figuras para o informe: mapas de grandes clases
Logs/Mapas.log: Scripts/Mapa*
	sh -x Scripts/Mapas.sh 2>&1 | tee Logs/Mapas.log
	sh Scripts/ForLoop.sh
	cd Informes/Informe1/Figuras/; pdftk MapaXeo.pdf MapaCub.pdf MapaCli.pdf MapaFin.pdf cat output Mapas.pdf
	convert -density 300 Informes/Informe1/Figuras/Mapas.pdf Informes/Informe1/Figuras/Mapas.jpeg
	rm Informes/Informe1/Figuras/*.ps

# Análise de tipos de paisaxe por grandes áreas e comarcas
Logs/TiposComarcas.Rout: Scripts/Script5.sh Scripts/Tipos*
	rm Informes/Informe1/TiposAreas*.txt
	sh -x Scripts/Script5.sh 2>&1 | tee Logs/Script5.log
	R CMD BATCH $(R_opts) Scripts/TiposAreas.R Logs/TiposAreas.Rout
	R CMD BATCH $(R_opts) Scripts/TiposComarcas.R Logs/TiposComarcas.Rout

# Análise de cambios de cuberta por grandes áreas e comarcas paisaxísticas
#bash ./Scripts/Script6.sh
#R CMD BATCH ./Informes/Informe1/CambiosAreas.R

# Frecuencia de aparición de valores paisaxísticos por tipos de paisaxe
Logs/Valores.Rout: Scripts/Script7.sh Scripts/Valores*
	sh -x Scripts/Script7.sh 2>&1 | tee Logs/Script7.log
	R CMD BATCH .$(R_opts) Scripts/Valores.R Logs/Valores.Rout
	R CMD BATCH .$(R_opts) Scripts/ValoresDoc.R Logs/ValoresDoc.Rout
