#! /bin/bash
echo "El containerfile: Creara , acutualizara y agregara los usuarios a ubutu"

cd ubuntu-usuarios
podman build -t ubuntu-usuarios:1.0 .
