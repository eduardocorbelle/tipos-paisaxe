#!/bin/bash

## Scrip maestro para executar as diferentes compoñentes do traballo de clasificación de tipos de paisaxe
## Eduardo Corbelle, 23 de xullo de 2015

############
## Instalación de GRASS 7.0 a partir de:
## http://grasswiki.osgeo.org/wiki/Compile_and_Install
## e de GeoPAT seguindo as intruccións de:
## http://sil.uc.edu/gitlist/geoPAT/


### Cargar datos base (as rutas aos arquivos poden ter cambiado)
# MDT25
bash ./Scripts/ImportMDT25.sh
# Límites administrativos
bash ./Scripts/ImportLimits.sh
# SIOSE 2011
bash ./Scripts/ImportSIOSE.sh
# Hábitats
bash ./Scripts/ImportHabitat.sh
# Datos climáticos
bash ./Scripts/ImportCLIMA.sh
# Datos de Viñedo
bash ./Scripts/ImportVinhedo.sh
# Conxuntos históricos
bash ./Scripts/ImportCascos.sh
# Ámbito de actuación do POL
bash ./Scripts/ImportPOL.sh


### Procesado da información
# Cartografía de rexións xeomorfolóxicas
bash ./tipos-paisaxe/Scripts/Script1.sh # (Require operacións manuais no seu interior)
# Cartografía de clases de uso ou cuberta
bash ./tipos-paisaxe/Scripts/Script2.sh
# Información climática
bash ./tipos-paisaxe/Scripts/Script3.sh
# Incorporación de información de patrimonio e outras, e exportación
bash ./tipos-paisaxe/Scripts/Script4.sh


### Análise dos resultados
# Figuras para o informe
R CMD BATCH Informes/Informe1/Figuras/Figuras1.R
# Análise de tipos de paisaxe por grandes áreas
bash ./Scripts/Script5.sh
R CMD BATCH /media/sf_Datos_Corbelle/tipos-paisaxe/Informes/Informe1/TiposAreas.R
# Análise de cambios de cuberta por grandes áreas e comarcas paisaxísticas
bash ./Scripts/Script6.sh
R CMD BATCH /media/sf_Datos_Corbelle/tipos-paisaxe/Informes/Informe1/CambiosAreas.R
