## Makefile para substituír ao ficheiro ScriptMaestro.sh
## Eduardo Corbelle, 11 de abril de 2016

R_opts = --vanilla

all: relevo clima cubertas mapa


################# Grandes unidades do relevo ###########################
relevo: Logs/ScriptXeomorf2.log

## Segmentación
# Logs/ScriptXeomorf1.log: Scripts/ScriptXeomorf1.sh
#	sh -x Scripts/ScriptXeomorf1.sh 2>&1 | tee Logs/ScriptXeomorf1.log

## Importación da clasificación manual
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
	rm ResultadosIntermedios/PatronCubertas.img -f
	sh -x Scripts/ScriptCuberta2.sh 2>&1 | tee Logs/ScriptCuberta2.log


################# Mapa final ##########################################
mapa: Logs/TiposUnfold.Rout 

Logs/ImportPOL.log: Scripts/ImportPOL.sh
	sh -x Scripts/ImportPOL.sh 2>&1 | tee Logs/ImportPOL.log

Logs/ScriptMapa.log: Logs/ImportPOL.log Scripts/ScriptMapa.sh Logs/ScriptCuberta.log Logs/ScriptClima.log Logs/ScriptXeomorf2.log
	rm ResultadosFinais/UdsPaisaxe.* -f
	sh -x Scripts/ScriptMapa.sh 2>&1 | tee Logs/ScriptMapa.log

Logs/TiposUnfold.Rout: Logs/ScriptMapa.log Scripts/TiposUnfoldLegend.R
	R CMD BATCH $(R_opts) Scripts/TiposUnfoldLegend.R Logs/TiposUnfold.Rout

