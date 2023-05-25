# Bike Comm System
Archivos de configuración para los nodos de la MANET

## Instalación y configuración del OS
1. Descargar la imagen de [Raspberry Pi OS Lite Debian 10 Buster (Legacy)](https://www.raspberrypi.com/software/operating-systems/) desde la página oficial

2. Instalar este Raspbian en la tarjeta Micro SD mediante el [Raspberry Pi Imager](https://www.raspberrypi.com/software/)

3. Usuario: pi / Contraseña: raspberry

4. Para cambiar la fuente de la terminal
```
sudo dpkg-reconfigure console-setup
```
- Encoding: UTF-8
- Guess optional character set
- Font for the console: Terminus
- Font size: 12x24

5. Para configurar la raspberry
```
sudo raspi-config
```

- System Options
  - Wireless LAN: Country EC / SSID Nombre de la red / Passphrase Clave de la red
  - Boot / Auto Login: Console Autologin
  
- Interface options:
  - SSH
  - I2C

- Localisation Options
  - Locale: es_EC.UTF-8 UTF-8
  - Timezone: America / Guayaquil
  - Keyboard: Generic 105-key PC (intl.) / Other / Spanish (Latin American) / The default for the keyboard layout / No compose key

- Advanced Options
  - Expand Filesystem

## Instalación de paquetes necesarios
1. Actualización
```
sudo apt-get update -y && sudo apt-get upgrade -y
```

2. TCPDUMP
```
sudo apt-get install tcpdump -y
```

3. GIT
```
sudo apt-get install git -y
```

4. Clonación del repositorio propio
```
sudo git clone https://github.com/josandotavalo/Bike_Comm_System.git
```

5. PIP - PYBLUEZ - INA219
```
sudo apt-get install python3-pip -y
sudo pip3 install pybluez
sudo pip3 install adafruit-circuitpython-ina219
sudo pip3 install pi-ina219
sudo apt-get install i2c-tools -y
```

Para comprobar que la conexión I2C está correcta:
```
sudo i2cdetect -y -1
```

6. FFMPEG
```
sudo apt-get install ffmpeg -y
```

7. IPERF3
```
sudo apt-get install iperf3 -y
```

8. NTP
```
sudo apt-get install ntp -y
sudo apt-get install ntpdate -y
```

## Configuración Bluetooth
1. Copiar el archivo **dbus-org.bluez.service** 
```
sudo cp dbus-org.bluez.service /etc/systemd/system/dbus-org.bluez.service
```
en este archivo se ha modificado la siguiente línea al añadir la opción -C
```
ExecStart=/usr/lib/bluetooth/bluetoothd -C
```

2. Añadir el Serial Port Profile con el comando:
```
sudo sdptool add SP
sudo systemctl daemon-reload
sudo systemctl restart bluetooth
```

## Configuración del nodo OLSR
1. Instalación del protocolo
```
sudo wget: http://www.olsr.org/releases/0.9/olsrd‐0.9.0.3.tar.bz2
sudo mount /dev/sda1 /mnt
sudo cp -r /mnt/olsrd-0.9.0.3 /home/pi/Bike_Comm_System
cd olsrd-0.9.0.3
sudo make clean
sudo make
sudo make install
```

2. Uso del script olsr
```
cd ../olsr_scripts
sudo cp olsrd.conf /etc/olsrd/olsrd.conf
sudo chmod +x olsr_server.sh 
```

3. Para cualquier modificación del protocolo se debe acceder al directorio **olsrd/src** y recompilar

4. En caso del error:
```
[BISON] src/cfgparser/oparse.c
/bin/sh: 1: bison: not found
make: *** [src/cfgparser/oparse.c] Error 127
```
instalar las siguientes librerías:
```
sudo apt-get install --reinstall bison libbison-dev flex libfl-dev -y
```

## Configuración del nodo BATMAN
1. Instalación del protocolo
```
sudo apt-get install libnl-3-dev libnl-genl-3-dev -y
sudo git clone https://git.open-mesh.org/batctl.git
cd batctl
sudo make install
```

2. Ensure the batman-adv kernel module is loaded at boot time by issuing the following command :
```
echo 'batman-adv' | sudo tee --append /etc/modules
```

3. Stop the DHCP process from trying to manage the wireless lan interface by issuing the following command :
```
echo 'denyinterfaces wlan1' | sudo tee --append /etc/dhcpcd.conf
```

4. Permisos de ejecución
```
cd ../batman_scripts
sudo chmod +x batman_server.sh 
```

5. Ejecutar el script al bootear la RPi, para esto se debe añadir la ruta 
```
/home/pi/Bike_Comm_System/batman_scripts/batman_server.sh & 
```

a la ruta **/etc/rc.local**

## Configuración del nodo Servidor
1. Para la conexión ethernet de la RPi servidor con el PC
```
sudo cp dhcpcd.conf /etc/dhcpcd.conf 
```
## Restablecer WiFi
1. Para salir del modo ad-hoc
```
sudo systemctl start dhcpcd 
```
## Configuración de la sincronización de los nodos (NTP)
1. Copiar el archivo **hosts** en todos los nodos
```
sudo cp hosts /etc/hosts
```

2. Para el nodo servidor:
```
sudo cp ntp.conf.server /etc/ntp.conf
```

3. Para los nodos de la MANET:
```
sudo cp ntp.conf /etc/ntp.conf
```
4. Correr los scripts **ntp_configura.sh** para el servidor y nodos
```
sudo chmod +x ntp_configura.sh
sudo ./ntp_configura.sh
```

5. Reiniciar el servicio NTP
```
sudo systemctl restart ntp
```
