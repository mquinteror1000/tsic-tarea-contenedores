#! /bin/sh
echo "Se crea el servidor web basado en server.py y Containerfile"

cd web-python
podman build -t py-web:1.0 .
podman run -d --name web -p 8080:8080 py-web:1.0
