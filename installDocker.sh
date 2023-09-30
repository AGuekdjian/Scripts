#!/bin/bash

check_exit_code() {
  if [ $? -ne 0 ]; then
    echo "Error en el comando: $1"
    exit 1
  fi
}

# Instalar ca-certificates, curl, y gnupg
echo "***** Instalando ca-certificates, curl, y gnupg *****"
sudo apt install -y ca-certificates curl gnupg
check_exit_code "sudo apt install -y ca-certificates curl gnupg"
printf "\n"

# Crear directorio /etc/apt/keyrings si no existe
echo "***** Creando directorio /etc/apt/keyrings si no existe *****"
sudo install -m 0755 -d /etc/apt/keyrings
check_exit_code "sudo install -m 0755 -d /etc/apt/keyrings"
printf "\n"

# Descargar la clave GPG de Docker y guardarla en /etc/apt/keyrings/docker.gpg
echo "***** Descargando la clave GPG de Docker y guardando en /etc/apt/keyrings/docker.gpg *****"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
check_exit_code "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg"
printf "\n"

# Dar permisos de lectura a la clave
echo "***** Dando permisos de lectura a la clave *****"
sudo chmod a+r /etc/apt/keyrings/docker.gpg
check_exit_code "sudo chmod a+r /etc/apt/keyrings/docker.gpg"
printf "\n"

# Agregar el repositorio de Docker al archivo sources.list.d/docker.list
echo "***** Agregando el repositorio de Docker al archivo sources.list.d/docker.list *****"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu" \
  "$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
check_exit_code "echo ... | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
printf "\n"

# Actualizar la lista de paquetes
echo "***** Actualizando la lista de paquetes *****"
sudo apt update
check_exit_code "sudo apt update"
printf "\n"

# Instalar paquetes de Docker
echo "***** Instalando paquetes de Docker *****"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_exit_code "sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
printf "\n"

# Actualizar nuevamente la lista de paquetes
echo "***** Actualizando nuevamente la lista de paquetes *****"
sudo apt update
check_exit_code "sudo apt update"
printf "\n"

# Realizar una actualización del sistema
echo "***** Realizando actualización del sistema *****"
sudo apt upgrade -y
check_exit_code "sudo apt upgrade -y"
printf "\n"

echo "----- Todos los comandos se ejecutaron con éxito. -----"
