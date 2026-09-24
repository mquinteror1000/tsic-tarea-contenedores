# Tarea Contenedores TSIC2

## Parte 1 solo el servidor web con python

se Crearon lo archivos indicados  **Containerfile** y **server.py** demás del script **01-run-web-python.sh**

```shell
├── 01-run-web-python.sh
├── README.md
└── web-python
    ├── Containerfile
    └── server.py
```

Que después de ejecutarlo, contruye los contenedores

```shellsession
martin@rocky10:~/tsic-tarea-contenedores$ sh 01-run-web-python.sh 
correr la primer parte: servidor web con python puro
STEP 1/8: FROM registry.access.redhat.com/ubi9/python-311
Trying to pull registry.access.redhat.com/ubi9/python-311:latest...
Getting image source signatures
[...]
COMMIT py-web:1.0
--> 526556678c64
Successfully tagged localhost/py-web:1.0
526556678c6456e57f90658b592279d20a6e7c76930ec6b8177e61970a44e112
90c06b019ac383c6dbf3a22b3a79eac455514cdbe39bc4882532d9b75168054d
curl: (56) Recv failure: Connection reset by peer
curl: (56) Recv failure: Connection reset by peer
Escuchando en 0.0.0.0:8080
```

Sin embargo CURL falla, sospecho que se debe a que hay otro contenedor, aunque apago que usa ese puerto

```shellsession
martin@rocky10:~$ podman container list --all
CONTAINER ID  IMAGE                           COMMAND               CREATED             STATUS                    PORTS                   NAMES
932501104aae  docker.io/library/nginx:latest  nginx -g daemon o...  6 days ago          Exited (0) 292 years ago  80/tcp                  nginx01
a79d47231d77  docker.io/library/nginx:latest  nginx -g daemon o...  6 days ago          Exited (0) 292 years ago  0.0.0.0:8080->80/tcp    nginx02
a3b4217fa43d  docker.io/library/nginx:latest  nginx -g daemon o...  6 days ago          Exited (0) 5 days ago     0.0.0.0:8081->80/tcp    nginx03
a041d76b26b3  docker.io/library/nginx:latest  nginx -g daemon o...  6 days ago          Exited (0) 292 years ago  0.0.0.0:8082->80/tcp    nginx04
90c06b019ac3  localhost/py-web:1.0            python server.py      About a minute ago  Up About a minute         0.0.0.0:8080->8080/tcp  web
martin@rocky10:~$ curl localhost:8080
curl: (56) Recv failure: Connection reset by peer
```

se hace  la prueba con **curl http://127.0.0.1:8080**

y se obtiene una respuesta adecuada

```shellsession
martin@rocky10:~$ curl 127.0.0.1:8080
<h1>Hola desde Podman</h1><p>Contenedor: 90c06b019ac3</p><p>Hora: 2026-09-24 22:36:09</p>martin@rocky10:~$ 
martin@rocky10:~/tsic-tarea-contenedores$ curl 127.0.0.1:8080/healt
<h1>Hola desde Podman</h1><p>Contenedor: 90c06b019ac3</p><p>Hora: 2026-09-24 22:45:23</p>martin@rocky10:~/tsic-tarea-contenedores$
```

elimino el contenedor conflictivo

```shellsession
martin@rocky10:~/tsic-tarea-contenedores$ podman container rm nginx02
nginx02
```

y seguia fallando, investigando se llega a la conclusión de que cuando se curl con localhost intenta resolver en ipv6 . asi que se usará mejor la dirección ipv4 127.0.0.1 **01-run-web-python.sh**

```bash
#! /bin/sh
echo correr la primer parte: servidor web con python puro

cd web-python
podman build -t py-web:1.0 .
podman run -d --name web -p 8080:8080 py-web:1.0

curl http://127.0.0.1:8080
curl http://127.0.0.1:8080/health
podman logs web
```

Se elimina el contenedor y se recrea


