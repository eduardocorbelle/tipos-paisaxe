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
bash ./Scripts/Script1.sh # (Require operacións manuais no seu interior)
# Cartografía de clases de uso ou cuberta
bash ./Scripts/Script2.sh
# Información climática
bash ./Scripts/Script3.sh
# Incorporación de información de patrimonio e outras, e exportación
bash ./Scripts/Script4.sh

# Separación da lenda en campos independentes
R CMD BATCH ./Scripts/TiposUnfoldLegend.R


### Análise dos resultados
# Figuras para o informe: áreas de entrenamento
R CMD BATCH Informes/Informe1/Figuras/Figuras1.R
# Figuras para o informe: mapas de clases
bash ./Scripts/Mapas.sh
# Análise de tipos de paisaxe por grandes áreas
bash ./Scripts/Script5.sh
R CMD BATCH /media/sf_Datos_Corbelle/tipos-paisaxe/Informes/Informe1/TiposAreas.R
R CMD BATCH /media/sf_Datos_Corbelle/tipos-paisaxe/Informes/Informe1/TiposComarcas.R
# Análise de cambios de cuberta por grandes áreas e comarcas paisaxísticas
bash ./Scripts/Script6.sh
R CMD BATCH /media/sf_Datos_Corbelle/tipos-paisaxe/Informes/Informe1/CambiosAreas.R
# Frecuencia de aparición dalgúns valores paisaxísticos por unidade de paisaxe
bash ./Scripts/Script7.sh
