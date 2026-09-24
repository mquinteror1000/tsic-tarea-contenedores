-- Usuarios
CREATE USER app_user WITH PASSWORD 'App2026!';
CREATE USER reporte  WITH PASSWORD 'Rep2026!';

-- Base de datos cuyo dueño es app_user
CREATE DATABASE inventario OWNER app_user;

\connect inventario

CREATE TABLE productos (
    id        SERIAL PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    cantidad  INTEGER      NOT NULL DEFAULT 0,
    creado    TIMESTAMP    NOT NULL DEFAULT now()
);
ALTER TABLE productos OWNER TO app_user;

INSERT INTO productos (nombre, cantidad) VALUES
    ('Servidor ProLiant', 4),
    ('Switch 48p', 2),
    ('Disco NVMe 3.84TB', 12);

-- reporte: solo lectura
GRANT CONNECT ON DATABASE inventario TO reporte;
GRANT USAGE   ON SCHEMA public       TO reporte;
GRANT SELECT  ON ALL TABLES IN SCHEMA public TO reporte;
ALTER DEFAULT PRIVILEGES FOR ROLE app_user IN SCHEMA public
    GRANT SELECT ON TABLES TO reporte;
