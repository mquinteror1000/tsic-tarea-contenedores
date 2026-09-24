#!/bin/bash

echo "A CONTINUACIÓN DE CREARÁ EL CONTENDOR POSTGRES  "

cd db-postgres
podman build -t pg-usuarios:1.0 .
podman volume create pgdata

# La contraseña del superusuario se pasa en ejecución, no en la imagen
podman run -d --name db \
  -e POSTGRES_PASSWORD='Admin2026!' \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  pg-usuarios:1.0


