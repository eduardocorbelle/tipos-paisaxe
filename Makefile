## Makefile para substituír ao ficheiro ScriptMaestro.sh
## Eduardo Corbelle, 11 de abril de 2016

R_opts = --vanilla

all: cubertas


################# Patróns de cubertas
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
