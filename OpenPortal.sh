#!/bin/bash
clear
echo "En quina interficia vos operar?"
read interface

clear
#ip
echo -n "Aquesta es la teva IP:"
ip=`ifconfig |grep -n1 $interface|grep "inet addr"|cut -d' ' -f12|cut -d':' -f2`
echo $ip
#MAC
echo -n "Aquesta es la teva MAC:"
ifconfig |grep -n1 $interface|grep "HWaddr"|cut -d' ' -f11

#MASCARA
mask=0
nextp=1
echo -n "Aquesta es la teva MASCARA:"
ifconfig |grep -n1 $interface|grep Mask|cut -d' ' -f16|cut -d ':' -f2

while [ $nextp -lt 4 ]
do
numk=`ifconfig |grep -n1 $interface|grep Mask|cut -d' ' -f16|cut -d ':' -f2|cut -d "." -f$nextp`
binari=`echo "obase=2;$numk" | bc`
bits=`echo $binari|grep -o "1"|grep -c "1"`
mask=`expr $mask + $bits`
nextp=`expr $nextp + 1`
done

echo "Mask es $mask"
netdiscover -i $interface -P -r $ip/$mask
echo "Hola Hosts de la meva xarxa"
