## Script para analizar a frecuencia de aparición dos tipos por grande área e comarca paisaxística
## Eduardo Corbelle, 1 de outubro de 2015

g.mapset Tmp

## Establecemos o acceso a mapset do mapa de cultivos e aproveitamentos
g.mapsets MCA_Magrama

## Reclasificamos ambos mapas
g.region rast=mca_1980_1990
r.reclass input=mca_1980_1990 out=mca89 rules=./Scripts/ReclassMCA.txt
r.reclass input=mca_2000_2010 out=mca09 rules=./Scripts/ReclassMCA.txt

## Importamos a información de grandes áreas e comarcas
# (Feito no Script5)

## Obtemos os tipos por grandes áreas (resultados en m2, neste caso sobre píxeles de 25m2)
r.stats -alN in=GrandesAreas,mca89,mca09 out=./Informes/Informe1/CambiosGAP_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA

r.stats -alN in=Comarcas,mca89,mca09 out=./Informes/Informe1/CambiosComarcas_$(date +"%Y_%m_%d").txt separator=pipe null_value=NA