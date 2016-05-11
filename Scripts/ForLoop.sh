#!/bin/bash

cd Informes/Figuras/

for i in *.ps
do
j=`basename $i .ps`.pdf
ps2pdf $i $j
done
