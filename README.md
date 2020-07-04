# Nextcloud-Script
<a href="#install"><img src="https://images.emojiterra.com/twitter/v11/512px/1f1fa-1f1f8.png" alt="usa" width="5%"></a>

Quick Nextcloud-Script installation 

<a href="#instalación"><img src="https://images.emojiterra.com/twitter/v11/128px/1f1ea-1f1f8.png" alt="spanish" width="5%"></a>

Script de instalación rápida de Nextcloud<br>

___
___



## Install

First clone this repo:
```
git clone https://github.com/RedxLus/Nextcloud-Script.git
```

You need to run the Script with root permissions. To do this, depending on the operating system, you can do it in several ways:
```
sudo sh Nextcloud-Script.sh
```

Also entering directly as root user and running the script:
```
su
```
```
sh Nextcloud-Script.sh
```

The installation takes approximately 4 minutes. Although it may vary.

Version 13 is installed (for added compatibility. It can be updated from within.)

The process is based on menus. At the beginning and the end.

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


## Still testing (not functional)

- Windows Subsystem linux

## Know-Bugs

#### CentOS
In LXC before using the script you need:
```
yum update -y && reboot
```

___

## Instalación

Primero clona este repositorio:
```
git clone https://github.com/RedxLus/Nextcloud-Script.git
```

Necesita ejecutar el Script con permisos root. Para ello, según el sistema operativo, puede hacerlo de varias formas:

```
sudo sh Nextcloud-Script.sh
```

También entrando directamente como usuario root y ejecutando el script:

```
su
```
```
sh Nextcloud-Script.sh
```

La instalación dura aproximadamente 4 minutos. Aunque puede variar.

Se instala la versión 13 (para mayor compatibilidad. Se puede actualizar desde dentro.)

El proceso se basa en menús. Al inicio y al final. 

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


## Aún probando (no funcionales)

- Windows Subsystem linux

## Errores

#### CentOS
En LXC antes de usar el script necesita:
```
yum update -y && reboot
```
<br/>
<br/>
<br/>

___
