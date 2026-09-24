#!/bin/bash
cd db-postgres

#podman logs -f db          # espera "ready to accept connections"

# Ver usuarios creados
echo "MOSTRAR LOS USUARIOS CREDOS"
podman exec -it db psql -U postgres -c '\du'

# Consultar como app_user y como reporte
echo "CONSULTAR COMO APP_USER Y COMO REPORTE"
podman exec -it db psql -U app_user -d inventario -c 'SELECT * FROM productos;'
podman exec -it db psql -U reporte  -d inventario -c 'SELECT count(*) FROM productos;'

# reporte no puede escribir (debe fallar)
echo "REPORTE NO PUEDE ESCRIBIR, DEBE FALLAR"
podman exec -it db psql -U reporte -d inventario \
  -c "INSERT INTO productos(nombre) VALUES ('prueba');"
