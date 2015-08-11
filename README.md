# tipos-paisaxe
## Cartografía de tipos de paisaxe en Galicia
### Eduardo Corbelle Rico
### Abril-Agosto de 2015

--------------

Neste repositorio almacénanse ficheiros de ordes (*scripts*) para [GRASS GIS](http://grass.osgeo.org/), destinados a producir un mapa de tipos de paisaxe de Galicia.

A información orixinal utilizada no proceso inclúe:

- O modelo dixital do terreo con malla de 25 metros do [Instituto Geográfico Nacional](http://centrodedescargas.cnig.es/CentroDescargas/).
- Os límites administrativos de Galicia
- O mapa do *Sistema de Información de la Ocupación del Suelo de España*, na súa edición de 2009, proporcionada polo [Instituto de Estudios do Territorio](http://www.cmati.xunta.es/organizacion/c/Instituto_Estudos_Territorio).
- O mapa de hábitats de Galicia, versión de 2011, proporcionada polo Laboratorio de botánica da Universidade de Santiago de Compostela.
- O mapa de tipos bioclimáticos de Galicia publicado por Rodríguez Guitián e Ramil Rego (Clasificaciones climáticas aplicadas a Galicia: revisión desde una perspectiva biogeográfica. [*Recursos Rurais*](http://www.usc.es/revistas/index.php/rr) 1:3:31-53. 2007).

Os comandos executáronse en GRASS 7.0, sobre sistema operativo [GNU/Linux Debian](https://www.debian.org/index.es.html) 8. Poderían ser necesarios pequenos axustes dos scripts en caso de querer empregar outro sistema operativo. É preciso tamén contar co módulo [GeoPAT](http://sil.uc.edu/gitlist/geoPAT/) de GRASS instalado no sistema.

O ficheiro **ScriptMaestro.sh** resume a orde na que deberían executarse os diferentes ficheiros existentes na carpeta *Scripts*.