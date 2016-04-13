## Makefile para substituír ao ficheiro ScriptMaestro.sh
## Eduardo Corbelle, 11 de abril de 2016

R_opts = --vanilla

all: relevo clima cubertas


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
cubertas: Logs/ScriptCuberta.log

## Importación de capas
Logs/PreparaSiose.Rout: Scripts/PreparaSiose.R
	rm DatosProcesados/SIOSE_2011_agregado.* -f
	cp DatosOrixinais/Siose2011/SIOSE_2011_agregado.* DatosProcesados/
	mv DatosProcesados/SIOSE_2011_agregado.dbf DatosProcesados/SIOSE_2011_agregado.dbf.bk
	R CMD BATCH $(R_opts) Scripts/PreparaSiose.R Logs/PreparaSiose.Rout

Logs/ImportSIOSE.log: Logs/PreparaSiose.Rout Scripts/ReclassSiose.txt Scripts/ImportSIOSE.sh
	sh -x Scripts/ImportSIOSE.sh 2>&1 | tee Logs/ImportSIOSE.log

Logs/ImportHabitat.log: Scripts/ImportHabitat.sh
	sh -x Scripts/ImportHabitat.sh 2>&1 | tee Logs/ImportHabitat.log

Logs/ImportVinhedo.log: Scripts/ImportVinhedo.sh
#	(Cambiamos o nome de tódolos ficheiros a VinXXX.* con Renomea.sh)
	sh -x Scripts/ImportVinhedo.sh 2>&1 | tee Logs/ImportVinhedo.log

Logs/ImportCascos.log: Scripts/ImportCascos.sh
	sh -x Scripts/ImportCascos.sh 2>&1 | tee Logs/ImportCascos.log

## Busca de patróns
Logs/ScriptCuberta.log: Logs/ImportSIOSE.log Logs/ImportHabitat.log Logs/ImportVinhedo.log Logs/ImportCascos.log Scripts/ScriptCuberta.sh
	rm Tmp/* -f
	sh -x Scripts/ScriptCuberta.sh 2>&1 | tee Logs/ScriptCuberta.log
