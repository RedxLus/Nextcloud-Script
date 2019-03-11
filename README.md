# Nextcloud-Script
Quick Nextcloud-Script installation 


Please not finished so not use




<a href="#instalación"><img src="https://images.emojiterra.com/twitter/v11/128px/1f1ea-1f1f8.png" alt="spanish" width="5%"></a>

Script de instalación rápida de Nextcloud<br>
Por favor, no terminado, así que no lo use

## Instalación

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




