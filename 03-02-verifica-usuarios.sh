#!/bin/bash

echo "Verifica que los usuarios si estén creados"

# Verificar usuarios y grupo sin entrar al contenedor
podman run --rm ubuntu-usuarios:1.0 getent group devops
podman run --rm ubuntu-usuarios:1.0 ls /home

# Sesión interactiva: cambiar a un usuario y probar sudo
podman run -it --rm --name ubu ubuntu-usuarios:1.0
  su - daniel
  sudo apt list --upgradable

