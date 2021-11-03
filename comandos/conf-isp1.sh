#!/bin/bash

# interfaceCliente='enp0s10';
interfaceISP='enp0s8';
INTERFACE_IN='enp0s8';
INTERFACE_OUT='ifb0';
IP='10.10.10.3';
IN="/usr/sbin/tc  filter add dev $INTERFACE_IN parent 1:0 protocol ip prio 1 u32 match ip dst"
OUT="/usr/sbin/tc  filter add dev $INTERFACE_OUT parent 1:0 protocol ip prio 1 u32 match ip src"
# interfaceISP2='enp0s8';
numIsp1='10';
numIsp2='20';

#limpiar
/usr/sbin/tc qdisc del dev $interfaceISP root
/usr/sbin/tc qdisc del dev $interfaceISP ingress
/usr/sbin/tc qdisc del dev ifb0 root

# echo 'Presione 1 para configurar el ISP1 0';
# read -p "Presione 2 para configurar el ISP2: " NUMISP;

# ISP UP 
ip addr add 10.10.10.1/24 dev $interfaceISP

# ISP DOWN
# ip addr add 10.10.$NUMISP0.2/24 dev $interfaceISP


modprobe ifb numifbs=1

ip link set dev $INTERFACE_OUT up
/usr/sbin/tc  qdisc del dev $INTERFACE_IN root 2>/dev/null
/usr/sbin/tc  qdisc del dev $INTERFACE_IN ingress 2>/dev/null
/usr/sbin/tc  qdisc del dev $INTERFACE_OUT root 2>/dev/null

/usr/sbin/tc  qdisc add dev $INTERFACE_IN handle ffff: ingress
/usr/sbin/tc  filter add dev $INTERFACE_IN parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev $INTERFACE_OUT

#creando enlance para bajada
/usr/sbin/tc  qdisc add dev $INTERFACE_IN root handle 1: htb
/usr/sbin/tc  class add dev $INTERFACE_IN parent 1: classid 1:10 htb rate 2000kbit ceil 2000kbit
/usr/sbin/tc qdisc add dev $INTERFACE_IN parent 1:10 handle 10: sfq perturb 10

#Creando enlace para subida
/usr/sbin/tc  qdisc add dev $INTERFACE_OUT root handle 1: htb
/usr/sbin/tc  class add dev $INTERFACE_OUT parent 1: classid 1:10 htb rate 50kbit ceil 50kbit
/usr/sbin/tc qdisc add dev $INTERFACE_OUT parent 1:10 handle 10: sfq perturb 10

#asignano ip a enlace
$IN $IP flowid 1:10
$OUT $IP flowid 1:10