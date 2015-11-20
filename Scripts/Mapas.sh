## Script para producir mapas a partir de GRASS
## Eduardo Corbelle, 19 de novembro de 2015

g.region n=4860000 s=4610000 w=470000 e=690000 res=150 -a

ps.map input=Mapas.txt out=mapa.ps copies=1

ps2pdf mapa.ps mapa.pdf
