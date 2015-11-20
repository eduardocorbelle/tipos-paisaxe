## Script para producir mapas a partir de GRASS
## Eduardo Corbelle, 19 de novembro de 2015

g.region n=4860000 s=4610000 w=470000 e=690000 res=150 -a
g.mask concellos

iconv -f UTF-8 -t ISO_8859-1 ./Scripts/MapaXeo.txt > ./Scripts/MapaXeoIso.txt
iconv -f UTF-8 -t ISO_8859-1 ./Scripts/MapaCub.txt > ./Scripts/MapaCubIso.txt
iconv -f UTF-8 -t ISO_8859-1 ./Scripts/MapaCli.txt > ./Scripts/MapaCliIso.txt
iconv -f UTF-8 -t ISO_8859-1 ./Scripts/MapaFin.txt > ./Scripts/MapaFinIso.txt

ps.map input=./Scripts/MapaXeoIso.txt out=./Informes/Informe1/Figuras/MapaXeo.ps copies=1 --o
ps.map input=./Scripts/MapaCubIso.txt out=./Informes/Informe1/Figuras/Mapacub.ps copies=1 --o
ps.map input=./Scripts/MapaCliIso.txt out=./Informes/Informe1/Figuras/MapaCli.ps copies=1 --o
ps.map input=./Scripts/MapaFinIso.txt out=./Informes/Informe1/Figuras/MapaFin.ps copies=1 --o

ps2pdf ./Informes/Informe1/Figuras/MapaXeo.ps ./Informes/Informe1/Figuras/MapaXeo.pdf
ps2pdf ./Informes/Informe1/Figuras/MapaCub.ps ./Informes/Informe1/Figuras/MapaCub.pdf
ps2pdf ./Informes/Informe1/Figuras/MapaCli.ps ./Informes/Informe1/Figuras/MapaCli.pdf
ps2pdf ./Informes/Informe1/Figuras/MapaFin.ps ./Informes/Informe1/Figuras/MapaFin.pdf

rm ./Informes/Informe1/Figuras/*.ps