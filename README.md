# Tarea Contenedores TSIC2

## Parte 1: solo el servidor web con python

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

```shellsession
<h1>Hola desde Podman</h1><p>Contenedor: ecc5b1b29151</p><p>Hora: 2026-09-24 23:24:32</p>martin@rocky10:~/tsic-tarea-contenedores$ curl 127.0.0.1:8080/healt
<h1>Hola desde Podman</h1><p>Contenedor: ecc5b1b29151</p><p>Hora: 2026-09-24 23:24:38</p>martin@rocky10:~/tsic-tarea-contenedores$
```



## Parte 2: potgres con usuarios

En la carpeta db_podgres se crea en **Containerfile** y el archivo de inicialización **init.sql**

```shellsession
db-postgres/
├── Containerfile
└── init.sql
```

tambien se crean los scripts

- 02-01-crea-db-posgres.sh   : Para crear el contenedor de posgres

- 02-02-usa-posgres.sh        : para hacer las pruebas

Se ejecuta el primero **02-01-crea-db-posgres.sh**

```shellsession
martin@rocky10:~/tsic-tarea-contenedores$ sh 02-01-crea-db-posgres.sh 
A CONTINUACIÓN DE CREARÁ EL CONTENDOR POSTGRES  
STEP 1/5: FROM docker.io/library/postgres:16
STEP 2/5: LABEL description="PostgreSQL con usuarios y datos iniciales"
--> Using cache 0f9ec7146c025013c58ca0240a1a165df02fec2cf55075df6e48e327afb51e8a
--> 0f9ec7146c02
STEP 3/5: COPY init.sql /docker-entrypoint-initdb.d/01-init.sql
--> Using cache a6794f9ac1e08daa9372becff36b9ac3e468b17ec976476eb7c8806af70699e7
--> a6794f9ac1e0
STEP 4/5: ENV TZ=America/Mexico_City
--> Using cache 5d6aa1f9a463575873a20af3ba8323466820507062792e40a6b45f3640117bc6
--> 5d6aa1f9a463
STEP 5/5: EXPOSE 5432
--> Using cache 3139517553f1190bcb1d38bbcac876d69c90dfb04dfe0354c1bdbbdf9421b30f
COMMIT pg-usuarios:1.0
--> 3139517553f1
Successfully tagged localhost/pg-usuarios:1.0
3139517553f1190bcb1d38bbcac876d69c90dfb04dfe0354c1bdbbdf9421b30f
Error: volume with name pgdata already exists: volume already exists
f493aa51795b53254e17898086d40960b3d3ef5340685075eeb10aefb9483463
```

Se listan los contenedores

```shellsession
martin@rocky10:~/tsic-tarea-contenedores$ podman container list
CONTAINER ID  IMAGE                      COMMAND           CREATED         STATUS         PORTS                   NAMES
ecc5b1b29151  localhost/py-web:1.0       python server.py  28 minutes ago  Up 28 minutes  0.0.0.0:8080->8080/tcp  web
f493aa51795b  localhost/pg-usuarios:1.0  postgres          21 seconds ago  Up 21 seconds  0.0.0.0:5432->5432/tcp  db
```

y se ejecuta el segundo sccript para hacer las pruebas

```shellsession
martin@rocky10:~/tsic-tarea-contenedores$ sh 02-02-usa-posgres.sh 
MOSTRAR LOS USUARIOS CREDOS
                             List of roles
 Role name |                         Attributes                         
-----------+------------------------------------------------------------
 app_user  | 
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS
 reporte   | 

CONSULTAR COMO APP_USER Y COMO REPORTE
 id |      nombre       | cantidad |           creado           
----+-------------------+----------+----------------------------
  1 | Servidor ProLiant |        4 | 2026-09-24 17:35:15.314784
  2 | Switch 48p        |        2 | 2026-09-24 17:35:15.314784
  3 | Disco NVMe 3.84TB |       12 | 2026-09-24 17:35:15.314784
(3 rows)

 count 
-------
     3
(1 row)

REPORTE NO PUEDE ESCRIBIR, DEBE FALLAR
ERROR:  permission denied for table productos

```

Las cuales son correctas

## Parte 3:
