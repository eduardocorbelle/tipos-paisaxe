#!/bin/bash

## Script para renomear os ficheiros de viñedo
## Eduardo Corbelle, 10 de agosto de 2015

cd /media/sf_Datos_Corbelle/Data/Vinhedo

for file in 100*
do 
echo "Vin100.${file#*.}"
cp "$file" "Vin100.${file#*.}"
rm $file
done

for file in *vi*
do
echo "Vin0${file:0:2}.${file#*.}"
cp "$file" "Vin0${file:0:2}.${file#*.}"
rm $file
done