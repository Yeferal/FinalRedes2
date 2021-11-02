"""Parametros de configuracion para los ISP"""
#Variables
INTERFACE_IN = 'enp8s0'
INTERFACE_OUT = 'ifb0'
IP = '10.10.10.3'

#reglas de filtros a aplicar para ancho de banda de subida como de bajada
IN=f"/usr/sbin/tc  filter add dev {INTERFACE_IN} parent 1:0 protocol ip prio 1 u32 match ip dst"
OUT=f"/usr/sbin/tc  filter add dev {INTERFACE_OUT} parent 1:0 protocol ip prio 1 u32 match ip src"
PUERTO="match ip sport"
REGLA="0xffff"

#insertar modulo ifb, asignando el numero de interfacez virtuales 
# que se necesita por defecto es 2
IFB = "sudo modprobe ifb numifbs=1"

#limpiar interfacez
C1 = f"ip link set dev {INTERFACE_OUT} up"
C2 = f"/usr/sbin/tc  qdisc del dev {INTERFACE_IN} root 2>/dev/null"
C3 = f"/usr/sbin/tc  qdisc del dev {INTERFACE_IN} ingress 2>/dev/null"
C4 = f"/usr/sbin/tc  qdisc del dev {INTERFACE_OUT} root 2>/dev/null"

#hablitar interfaz para upload
C5 = f"/usr/sbin/tc  qdisc add dev {INTERFACE_IN} handle ffff: ingress"
C6 = f"/usr/sbin/tc  filter add dev {INTERFACE_IN} parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev {INTERFACE_OUT}"

#creando enlance para bajada
COMANDO_IN_ROOT = f"/usr/sbin/tc  qdisc add dev {INTERFACE_IN} root handle 1: htb"
COMANDO_IN_ENLACE = f"/usr/sbin/tc  class add dev {INTERFACE_IN} parent 1: classid 1:10 htb rate 2000kbit ceil 2000kbit"
COMANDO_EXTRA_IN = f"/usr/sbin/tc qdisc add dev {INTERFACE_IN} parent 1:10 handle 10: sfq perturb 10"

#Creando enlace para subida
COMANDO_OUT_ROOT = f"/usr/sbin/tc  qdisc add dev {INTERFACE_OUT} root handle 1: htb"
COMANDO_OUT_ENLACE = f"/usr/sbin/tc  class add dev {INTERFACE_OUT} parent 1: classid 1:10 htb rate 50kbit ceil 50kbit"
COMANDO_EXTRA_OUT = f"/usr/sbin/tc qdisc add dev {INTERFACE_OUT} parent 1:10 handle 10: sfq perturb 10"

#asignano ip a enlace
DOWNLOAD = f"{IN} {IP} flowid 1:10"
UPLOAD = f"{OUT} {IP} flowid 1:10"