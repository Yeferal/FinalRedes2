from os import system
from modules import commands_isp as commands

#funciones
def ejecutar_command(comando):
    try:
        print("Ejecutando... ",comando)
        system(comando)
        print("\n")
    except:
        print("Error")

#configurar isp
opc = int(input("Presione 1 si configurara el isp1 y 2 si el isp2"))
ISP_UP = f"ip addr add {opc}0.{opc}0.{opc}0.1/24 dev {commands.INTERFACE_IN}"
ISP_DOWN = f"ip addr add {opc}0.{opc}0.{opc}0.2/24 dev {commands.INTERFACE_OUT}"

#limpiar
ejecutar_command("/usr/sbin/tc qdisc del dev enp7s0 root")
ejecutar_command("/usr/sbin/tc qdisc del dev enp7s0 ingress")
ejecutar_command("/usr/sbin/tc qdisc del dev ifb0 root")

opc = int(input("Desea continuar?\n"))

def crear_isp():
    ejecutar_command(ISP_UP)
    ejecutar_command(commands.IFB)
    ejecutar_command(commands.C1)
    ejecutar_command(commands.C2)
    ejecutar_command(commands.C3)
    ejecutar_command(commands.C4)
    ejecutar_command(commands.C5)
    ejecutar_command(commands.C6)
    ejecutar_command(commands.COMANDO_IN_ROOT)
    ejecutar_command(commands.COMANDO_IN_ENLACE)
    ejecutar_command(commands.COMANDO_EXTRA_IN)    
    ejecutar_command(commands.COMANDO_OUT_ROOT)
    ejecutar_command(commands.COMANDO_OUT_ENLACE)
    ejecutar_command(commands.COMANDO_EXTRA_OUT)    
    ejecutar_command(commands.DOWNLOAD)
    ejecutar_command(commands.UPLOAD)

if opc == 1:
    crear_isp()