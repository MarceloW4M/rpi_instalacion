#!/bin/bash

# Asegurarse de que el script se ejecuta como root
if [ "$EUID" -ne 0 ]
then 
  echo "Por favor, ejecute este script como root"
  exit
fi

# Usuario para el inicio de sesión automático
USER="w4m"

# Archivo de configuración para el autologin en la consola
AUTOSTART_FILE="/etc/systemd/system/getty@tty1.service.d/autologin.conf"

# Crear el directorio si no existe
mkdir -p $(dirname $AUTOSTART_FILE)

# Configurar el autologin
cat > $AUTOSTART_FILE <<EOL
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER --noclear %I \$TERM
EOL

# Reiniciar el servicio para aplicar los cambios
systemctl daemon-reload
systemctl restart getty@tty1.service

echo "El inicio de sesión automático ha sido configurado para el usuario $USER."
