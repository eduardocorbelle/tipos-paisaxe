## Script para producir mapas a partir de GRASS
## Eduardo Corbelle, 19 de novembro de 2015

g.mapset -c TmpPaisaxe_MapaFinal
g.mapsets mapset=MDT25,AdminLimits,TmpPaisaxe_Cubertas,TmpPaisaxe_Cubertas2,TmpPaisaxe_Cascos 
g.mapsets mapset=TmpPaisaxe_Clima2,TmpPaisaxe_Xeo2,TmpPaisaxe_POL,TmpPaisaxe_SIOSE

g.region n=4860000 s=4610000 w=470000 e=690000 res=150 -a
g.mask concellos

iconv -f UTF-8 -t ISO_8859-1 Scripts/MapaXeo.txt > Tmp/MapaXeoIso.txt
iconv -f UTF-8 -t ISO_8859-1 Scripts/MapaCub.txt > Tmp/MapaCubIso.txt
iconv -f UTF-8 -t ISO_8859-1 Scripts/MapaCli.txt > Tmp/MapaCliIso.txt
iconv -f UTF-8 -t ISO_8859-1 Scripts/MapaFin.txt > Tmp/MapaFinIso.txt

ps.map input=Tmp/MapaXeoIso.txt out=Informes/Informe1/Figuras/MapaXeo.ps copies=1 --o
r.colors map=ClaseCuberta2 rules=Scripts/MapaCubRules.txt
ps.map input=Tmp/MapaCubIso.txt out=Informes/Informe1/Figuras/MapaCub.ps copies=1 --o
ps.map input=Tmp/MapaCliIso.txt out=Informes/Informe1/Figuras/MapaCli.ps copies=1 --o
ps.map input=Tmp/MapaFinIso.txt out=Informes/Informe1/Figuras/MapaFin.ps copies=1 --o
