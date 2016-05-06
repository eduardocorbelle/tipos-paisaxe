#!/bin/bash

cd Informes/Informe1/Figuras/

for i in *.ps
do
j=`basename $i .ps`.pdf
ps2pdf $i $j
done
