#! /bin/sh
echo correr la primer parte: servidor web con python puro

cd web-python
podman build -t py-web:1.0 .
podman run -d --name web -p 8080:8080 py-web:1.0

curl http://127.0.0.1:8080
curl http://127.0.0.1:8080/health
podman logs web
