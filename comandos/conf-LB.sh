#!/bin/bash

interfaceCliente='enp0s10';
interfaceISP1='enp0s8';
interfaceISP2='enp0s9';
numIsp1='10';
numIsp2='20';

ifdown $interfaceCliente
ifdown $interfaceISP1
ifdown $interfaceISP2

ifup $interfaceCliente
ifup $interfaceISP1
ifup $interfaceISP2

num1='10';
num2='20';

if [ -f $FICHERO ];
then 
    while IFS= read -r linea
    do
        IN=$linea;
        arrIN=(${IN//=/ });
        if [ ${arrIN[0]} == "ISP1" ]; then num1=${arrIN[1]}; fi;
        if [ ${arrIN[0]} == "ISP2" ]; then num2=${arrIN[1]}; fi;
    done < $FICHERO
else 
    num1='10';
    num2='20';
fi

numP1=(num1/(num1+num2));
numP2=(num2/(num1+num2));

# agregar 
#nano /etc/iproute2/rt_tables
# 10 isp1
# 20 isp2 

ip route add 10.10.10.0/24 dev $interfaceISP1 src 10.10.10.3 table isp1
ip route add default via 10.10.10.1 table isp1

ip route add 10.10.20.0/24 dev $interfaceISP2 src 10.10.20.3 table isp2
ip route add default via 10.10.20.1 table isp2

iptables -t mangle -A PREROUTING -j CONNMARK --restore-mark
iptables -t mangle -A PREROUTING -m mark ! --mark 0 -j ACCEPT
iptables -t mangle -A PREROUTING -j MARK --set-mark $numIsp1
echo 'iptables -t mangle -A PREROUTING -m statistic --mode random --probability ${numP2} -j MARK --set-mark $numIsp2';
iptables -t mangle -A PREROUTING -m statistic --mode random --probability ${numP2} -j MARK --set-mark $numIsp2

iptables -t mangle -A PREROUTING -j CONNMARK --save-mark
iptables -t nat -A POSTROUTING -j MASQUERADE
ip rule add fwmark $numIsp1 table isp1 prio 33000
ip rule add fwmark $numIsp2 table isp2 prio 33000
ip route del default