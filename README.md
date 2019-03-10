# Nextcloud-Script
Quick Nextcloud-Script installation 


Please not finished so not use




<a href="#instalación"><img src="https://images.emojiterra.com/twitter/v11/128px/1f1ea-1f1f8.png" alt="Flowers in Chania" width="5%"></a>

Script de instalación rápida de Nextcloud<br>
Por favor, no terminado, así que no lo use

## Instalación

Necesita ejecutar el Script con permisos root. Para ello segun el sistema puede hacerlo de varias maneras:

```
sudo sh menu.sh
```

Tambien entrando diretamente como usuario root y ejecutando el script:

```
su
```
```
sh menu.sh
```


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




