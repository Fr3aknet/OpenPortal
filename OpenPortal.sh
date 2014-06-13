#!/bin/bash
clear
echo "En quina interficia vos operar?"
read interface

clear
#ip
echo -n "Aquesta es la teva IP:"
ifconfig |grep -n1 $interface|grep "inet addr"|cut -d' ' -f12|cut -d':' -f2

#MAC
echo -n "Aquesta es la teva MAC:"
ifconfig |grep -n1 $interface|grep "HWaddr"|cut -d' ' -f11

#MASCARA
mask=0
nextp=1
echo -n "Aquesta es la teva MASCARA:"
ifconfig |grep -n1 $interface|grep Mask|cut -d' ' -f16|cut -d ':' -f2

numk=`ifconfig |grep -n1 $interface|grep Mask|cut -d' ' -f16|cut -d ':' -f2|cut -d "." -f1`
echo $numk

while [ $numk -eq 255 ]
do
mask=`expr $mask + 8`
nextp=`expr $nextp + 1`
numk=`ifconfig |grep -n1 $interface|grep Mask|cut -d' ' -f16|cut -d ':' -f2|cut -d "." -f$nextp`
echo $numk
done

echo "Mask es $mask"
