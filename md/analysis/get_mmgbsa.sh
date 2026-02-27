#!/bin/sh
#
result=$1
printf "%-20s%12s%12s%12s%12s%12s\n" "file" "tot" "eel" "vdw" "egb" "esurf" > $result
    #printf "%-8s" "con1:"
for nframe in `ls mmgbsa.out.prd*`
do
    printf "%-20s" "$nframe" >> $result
    tmp=`awk '{if ($0 ~ /DELTA TOTAL/) {print $3}}' $nframe`
    printf "%12s" $tmp >> $result
    vdw=`awk 'BEGIN{ifound=0}{if ($0 ~/Complex - Receptor/) {ifound=1} if (ifound == 1 && $1 == "VDWAALS"){print $2}}' $nframe`
    eel=`awk 'BEGIN{ifound=0}{if ($0 ~/Complex - Receptor/) {ifound=1} if (ifound == 1 && $1 == "EEL"){print $2}}' $nframe`
    egb=`awk 'BEGIN{ifound=0}{if ($0 ~/Complex - Receptor/) {ifound=1} if (ifound == 1 && $1 == "EGB"){print $2}}' $nframe`
    esurf=`awk 'BEGIN{ifound=0}{if ($0 ~/Complex - Receptor/) {ifound=1} if (ifound == 1 && $1 == "ESURF"){print $2}}' $nframe`
    printf "%12s%12s%12s%12s\n" $eel $vdw $egb $esurf >> $result
done
