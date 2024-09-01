#!/bin/bash

# Nombre del archivo: install_programs.sh

# Verificar si el archivo de lista de programas existe
PROGRAMS_FILE="program.svc"
if [ ! -f "$PROGRAMS_FILE" ]; then
  echo "El archivo $PROGRAMS_FILE no existe. Por favor, crea un archivo de texto con la lista de programas."
  exit 1
fi

# Comprueba si el script se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta el script como root (con sudo)"
  exit 1
fi

# Actualizar la lista de paquetes e instalar actualizaciones
echo "Actualizando la lista de paquetes y el sistema..."
sudo apt-get update && sudo apt-get upgrade -y

# Leer los programas del archivo y proceder a instalarlos
echo "Instalando programas..."
while IFS= read -r PROGRAMA; do
  if ! dpkg -l | grep -q "^ii  $PROGRAMA"; then
    echo "Instalando $PROGRAMA..."
    sudo apt-get install -y $PROGRAMA
  else
    echo "$PROGRAMA ya está instalado."
  fi
done < "$PROGRAMS_FILE"

# Limpiar paquetes innecesarios
echo "Limpiando paquetes innecesarios..."
sudo apt-get autoremove -y
sudo apt-get clean

# Mensaje final
echo "Instalación completada."
