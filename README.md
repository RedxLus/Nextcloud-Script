# Nextcloud-Script
<a href="#install"><img src="https://images.emojiterra.com/twitter/v11/512px/1f1fa-1f1f8.png" alt="usa" width="5%"> Press to go</a>

Quick Nextcloud-Script installation 

<a href="#instalación"><img src="https://images.emojiterra.com/twitter/v11/128px/1f1ea-1f1f8.png" alt="spanish" width="5%"> Pulsa para ir</a>

Script de instalación rápida de Nextcloud<br>

___
___
<div align="center"><img src="https://images.emojiterra.com/twitter/v11/512px/1f1fa-1f1f8.png" alt="usa" width="5%"> </div> 

___
___


## Install

There are two installation methods to follow with this script. **Both have the same result**. The first method is the one recommended for the average user.
It is based on following a series of menus to configure the variables of the Nextcloud installation.
The other method is based on directly entering the variables at the same time as the command, this can save time but you have to be more sure of the variables and follow an order.

### Menu mode installation

```
# First clone this repo:
git clone https://github.com/RedxLus/Nextcloud-Script.git

# You need to run the Script with root permissions. To do this, depending on the operating system, you can do it in several ways:
sudo bash Nextcloud-Script/Nextcloud-Script.sh
```

<div align="center">
<table style="width:100%">
  <tr>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/62dddd4f4c7a20fcfb501d5c298e5b8030671252/Files/img/terminal-1-all.png">
        </div> 
    </td>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/62dddd4f4c7a20fcfb501d5c298e5b8030671252/Files/img/terminal-2-all.png">
        </div> 
    </td>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/62dddd4f4c7a20fcfb501d5c298e5b8030671252/Files/img/terminal-3-eng.png">
        </div> 
    </td>
  </tr>
  <tr>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/62dddd4f4c7a20fcfb501d5c298e5b8030671252/Files/img/terminal-4-eng.png">
        </div> 
    </td>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/d21e121fdbb7087a24e0947be5fd2df3c0559f41/Files/img/terminal-5-eng.png">
        </div> 
    </td>
    <td align="center">
        <div>
          <img src="https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/7535f707871127a271aca8d51cd7eec789dd5a37/Files/img/script-instalacion-nextcloud.PNG" width="20%">
        </div> 
    </td>
  </tr>
</table>
</div>

The installation takes approximately 4 minutes. Although it may vary depending on the download speed.

The process is based on menus. At the beginning and the end. It is a process that will guide you through the menus, so in the graphic version you will only have to select the variables and Nextcloud will be configured.

### Headless mode installation


```
# First clone this repo:
git clone https://github.com/RedxLus/Nextcloud-Script.git

# You need to run the Script with root permissions. To do this, depending on the operating system, you can do it in several ways.
# You must enter the configuration variables in order. This is a example:
sudo bash Nextcloud-Script/Nextcloud-Script.sh EN ubuntu18 P@ssw0rd 192.168.1.14
```

Variables and their order:
1.  First. We put the country code. Possibilities:

| Variable  | Meaning |
| ------------- | ------------- |
| EN  | Script messages in English |
| ES  | Script messages in Spanish  |

2.  Second. We put the operating system of the machine. Possibilities:

| Variable  | Meaning |
| ------------- | ------------- |
| ubuntu16  | The machine has the operating system Ubuntu 16  |
| ubuntu18  | The machine has the operating system Ubuntu 18  |
| debian  | The machine has the operating system Debian  |
| centos  | The machine has the operating system CENTOS  |
| raspberry  | The machine has the operating system Raspberry OS (Buster/Jessie/Stretch)  |

3.  Third. We put the password to configure the Nextcloud admin user and the MYSQL root user. It can be at your choice.

4. Fourth. We put the private IP of the machine, we can use the command:
```
ip a
```

## Tested and functional

- Virtual Machines LXC/KVM in Proxmox / VirtualBox/ or install fresh:
  - [x]  DEBIAN  :heavy_check_mark:
  - [x]  Ubuntu 16  :x: (Ubuntu 16.04 End of Life: April 30th 2021) **Not Recommend, better use Ubuntu 20**
  - [x]  Ubuntu 18  :heavy_check_mark: (Works with PHP 7.2 and Nextcloud 20.0.14) **Not Recommend, better use Ubuntu 20**
  - [x]  Ubuntu 20  :heavy_check_mark: (Works with PHP 7.4 and Nextcloud 23.0.0)
  - [x]  CentOS  (<a href="#know-bugs">click to see possible errors</a>)
- Raspberry Pi OS:
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
___
<div align="center"><img src="https://images.emojiterra.com/twitter/v11/128px/1f1ea-1f1f8.png" alt="spanish" width="5%"> </div> 

___
___
## Instalación

Hay dos métodos de instalación a seguir con este script. **Ambos tienen el mismo resultado**. El primer método es el recomendado para el usuario promedio, se 
basa en seguir una serie de menús para configurar las variables de la instalación de Nextcloud. 
El otro método se basa en introducir directamente las variables al mismo tiempo del comando, esto puede ahorrar tiempo pero se tiene que estar más seguro de las variables y seguir un orden.

### Instalación modo menús

```
# Primero clona este repositorio:
git clone https://github.com/RedxLus/Nextcloud-Script.git

# Necesita ejecutar el Script con permisos root. Para ello, según el sistema operativo, puede hacerlo de varias formas:
sudo bash Nextcloud-Script/Nextcloud-Script.sh
```

<div align="center">
<table style="width:100%">
  <tr>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/62dddd4f4c7a20fcfb501d5c298e5b8030671252/Files/img/terminal-1-all.png">
        </div> 
    </td>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/62dddd4f4c7a20fcfb501d5c298e5b8030671252/Files/img/terminal-2-all.png">
        </div> 
    </td>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/62dddd4f4c7a20fcfb501d5c298e5b8030671252/Files/img/terminal-3-esp.png">
        </div> 
    </td>
  </tr>
  <tr>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/62dddd4f4c7a20fcfb501d5c298e5b8030671252/Files/img/terminal-4-esp.png">
        </div> 
    </td>
    <td align="center">
        <div>
          <img src="https://github.com/RedxLus/Nextcloud-Script/blob/d21e121fdbb7087a24e0947be5fd2df3c0559f41/Files/img/terminal-5-esp.png">
        </div> 
    </td>
    <td align="center">
        <div>
          <img src="https://raw.githubusercontent.com/RedxLus/Nextcloud-Script/7535f707871127a271aca8d51cd7eec789dd5a37/Files/img/script-instalacion-nextcloud.PNG" width="20%">
        </div> 
    </td>
  </tr>
</table>
</div>


La instalación dura aproximadamente 4 minutos. Aunque puede variar dependiendo de la velocidad de descarga.

El proceso se basa en menús. Al inicio y al final. Es un proceso que le guiara entre los menus, así en la version grafica solo va a tener que seleccionar las variables y se le configurara Nextcloud

### Instalación modo headless

```
# Primero clona este repositorio:
git clone https://github.com/RedxLus/Nextcloud-Script.git

# Necesita ejecutar el Script con permisos root. Para ello, según el sistema operativo, puede hacerlo de varias formas.
# Debe introducir las variables de configuración en orden. Este seria un ejemplo:
sudo bash Nextcloud-Script/Nextcloud-Script.sh ES ubuntu20 P@ssw0rd 192.168.1.14
```

Variables y su orden:
1.  Primero. Ponemos el código del país. Posibilidades:

| Variable  | Significado |
| ------------- | ------------- |
| ES  | Mensajes del script en Español  |
| EN  | Mensajes del script en Inglés  |

2.  Segundo. Ponemos el sistema operativo de la máquina. Posibilidades:

| Variable  | Significado |
| ------------- | ------------- |
| ubuntu20  | La máquina tiene el sistema operativo Ubuntu 20  |
| ubuntu18  | La máquina tiene el sistema operativo Ubuntu 18  |
| ubuntu16  | La máquina tiene el sistema operativo Ubuntu 16  |
| debian  | La máquina tiene el sistema operativo Debian  |
| raspberry  | La máquina tiene el sistema operativo Raspberry OS |
| centos  | La máquina tiene el sistema operativo CENTOS  |

3.  Tercero. Ponemos la contraseña para configurar el usuario admin de Nextcloud y el usuario root de MYSQL. Puede ser a elección.

4. Cuarto. Ponemos la IP privada de la máquina, podemos utilizar el comando "ip a" para verla:
```
ip a
```

## Probado y funcional

- Virtual Machines LXC/KVM in Proxmox / VirtualBox/ or install fresh:
  - [x]  DEBIAN  :heavy_check_mark:
  - [x]  Ubuntu 16  :x: (Ubuntu 16.04 End of Life: April 30th 2021) **Not Recommend, better use Ubuntu 20**
  - [x]  Ubuntu 18  :heavy_check_mark: (Works with PHP 7.2 and Nextcloud 20.0.14) **Not Recommend, better use Ubuntu 20**
  - [x]  Ubuntu 20  :heavy_check_mark: (Works with PHP 7.4 and Nextcloud 23.0.0)
  - [x]  CentOS  (<a href="#know-bugs">click to see possible errors</a>)
- Raspberry Pi OS:
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

## Inicio sesión

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
