#!/bin/bash

## Scrip maestro para executar as diferentes compoñentes do traballo de clasificación de tipos de paisaxe
## Eduardo Corbelle, 23 de xullo de 2015

############
## Instalación de GRASS 7.0 a partir de:
## http://grasswiki.osgeo.org/wiki/Compile_and_Install
## e de GeoPAT seguindo as intruccións de:
## http://sil.uc.edu/gitlist/geoPAT/tree/master/


### Cargar datos base (as rutas aos arquivos poden ter cambiado)
# MDT25
sh ./Scripts/ImportMDT25.sh
# MDT200
sh ./Scripts/ImportMDT200.sh
# Límites administrativos
sh ./Scripts/ImportLimits.sh
# SIOSE 2011
sh ./Scripts/ImportSIOSE.sh
# Hábitats
sh ./Scripts/ImportHabitat.sh
# Datos climáticos
sh ./Scripts/ImportCLIMA.sh
# Datos de Viñedo
sh ./Scripts/ImportVinhedo.sh


### Procesado da información
# Cartografía de rexións xeomorfolóxicas
sh ./Scripts/Script1.sh # (Require operacións manuais no seu interior)
# Cartografía de clases de uso ou cuberta
sh ./Scripts/Script2.sh
# Información climática
sh ./Scripts/Script3.sh
# Incorporación de información de patrimonio e outras, e exportación
sh ./Scripts/Script4.sh
