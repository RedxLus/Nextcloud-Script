# Nextcloud-Script
<a href="#install"><img src="https://images.emojiterra.com/twitter/v11/512px/1f1fa-1f1f8.png" alt="usa" width="5%"> Press to go</a>

Quick Nextcloud-Script installation 

<a href="#instalación"><img src="https://images.emojiterra.com/twitter/v11/128px/1f1ea-1f1f8.png" alt="spanish" width="5%"> Pulsa para ir</a>

Script de instalación rápida de Nextcloud<br>

___
___



## Install

```
# First clone this repo:
git clone https://github.com/RedxLus/Nextcloud-Script.git

# You need to run the Script with root permissions. To do this, depending on the operating system, you can do it in several ways:
sudo bash Nextcloud-Script/Nextcloud-Script.sh
```

The installation takes approximately 4 minutes. Although it may vary.

Version 18 is installed (for added compatibility. It can be updated from within.)

The process is based on menus. At the beginning and the end. When the installation is complete it will take you to the start menu and just press exit.

## Tested and functional

- CT Virtual Machines (Linux Containers = **LXC**) in Proxmox:
  - [x]  DEBIAN  :heavy_check_mark:
  - [x]  Ubuntu 16  :heavy_check_mark:
  - [x]  Ubuntu 18  :heavy_check_mark:
  - [x]  CentOS  (<a href="#know-bugs">click to see possible errors</a>)
- Virtual Machines VM (**KVM**) in Proxmox: 
  - [x]  DEBIAN  :heavy_check_mark:
  - [x]  Ubuntu 16  :heavy_check_mark:
  - [x]  Ubuntu 18  :heavy_check_mark:
- Raspberry Pi OS (Buster/Jessie/Stretch):
  - [x]  Model 4  :heavy_check_mark:
  - [x]  Model 3  :heavy_check_mark:


## Still testing (not functional)

- Windows Subsystem linux

## Know-Bugs

#### CentOS
In LXC before using the script you need:
```
yum update -y && reboot
```

## Login

Once installed, just go to any browser within the same network and enter the URL:
https://THE-IP-OF-THE-MACHINE/nextcloud (on page https://THE-IP-OF-THE-MACHINE/ can verify that Apache has been installed correctly).

Once we see the input menu, the login data is as follows:
Nextcloud administrator user: admin
Nextcloud administrator user password: The one entered in the script

Also if we want to manage the database within the machine, the data is as follows:
MYSQL database administrator user: root
MYSQL database administrator user password: The one entered in the script
Database name: nextcloud

___

## Instalación

```
# Primero clona este repositorio:
git clone https://github.com/RedxLus/Nextcloud-Script.git

# Necesita ejecutar el Script con permisos root. Para ello, según el sistema operativo, puede hacerlo de varias formas:
sudo bash Nextcloud-Script/Nextcloud-Script.sh
```

La instalación dura aproximadamente 4 minutos. Aunque puede variar.

Se instala la versión 18 (para mayor compatibilidad. Se puede actualizar desde dentro.)

El proceso se basa en menús. Al inicio y al final. Cuando se complete la instalación, lo llevará al menú de inicio y simplemente presione salir.

## Probado y funcional

- Máquinas Virtuales CT (Linux Containers = **LXC**) en Proxmox:
  - [x]  DEBIAN  :heavy_check_mark:
  - [x]  Ubuntu 16  :heavy_check_mark:
  - [x]  Ubuntu 18  :heavy_check_mark:
  - [x]  CentOS  (<a href="#errores">clic para ver posibles errores</a>)
- Máquinas Virtuales VM (**KVM**) en Proxmox: 
  - [x]  DEBIAN  :heavy_check_mark:
  - [x]  Ubuntu 16  :heavy_check_mark:
  - [x]  Ubuntu 18  :heavy_check_mark:
- Raspberry Pi OS (Buster/Jessie/Stretch):
  - [x]  Model 4  :heavy_check_mark:
  - [x]  Model 3  :heavy_check_mark:


## Aún probando (no funcionales)

- Windows Subsystem linux

## Errores

#### CentOS
En LXC antes de usar el script necesita:
```
yum update -y && reboot
```

### Inicio sesión

Una vez instalado tan solo tiene que ir a cualquier navegador dentro de la misma red y entrar en la URL:
https://LA-IP-DE-LA-MAQUINA/nextcloud (en la página https://LA-IP-DE-LA-MAQUINA/ puede comprobar que se ha instalado correctamente Apache).

Una vez veamos el menú de entrada los datos de inicio de sesión son los siguientes:
Usuario administrador Nextcloud: admin
Contraseña usuario administrador Nextcloud: La que haya introducido en el script

Tambien si queremos gestionar la base de datos dentro de la máquina los datos son los seiguientes:
Usuario administrador de la base de datos MYSQL: root
Contraseña usuario administrador de la base de datos MYSQL: La que haya introducido en el script
Nombre base de datos: nextcloud

<br/>
<br/>
<br/>

___
