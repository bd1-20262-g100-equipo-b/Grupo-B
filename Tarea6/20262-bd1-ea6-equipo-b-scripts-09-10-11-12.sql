
-- ---------------------------------------------------------------------------------------------------------------------------------
-- 9.- Enunciado para creación de Vista (VIEW) con 4 JOINs, GROUP BY y HAVING
-- Construya una vista (VIEW) con el enunciado del ítem 7. Debe crear la vista (darle un nombre) y ejecutarla.
-- ---------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW vw_reporte_consolidado_productos AS
SELECT
    p.id_producto,
    p.descripcion AS producto,
    tp.nombre_tipo AS categoria_producto,
    p.precio,
    CONCAT(
        u.nombre1, ' ',
        COALESCE(u.nombre2 || ' ', ''),
        u.apellido1, ' ',
        COALESCE(u.apellido2, '')
    ) AS comprador,
    tu.nombre_tipo AS tipo_usuario
FROM producto p
INNER JOIN tipo_producto tp
    ON p.id_tipo_producto = tp.id_tipo_producto
INNER JOIN usuario u
    ON p.id_usuario = u.id_usuario
INNER JOIN usu_tipo_usu utu
    ON u.id_usuario = utu.id_usuario
INNER JOIN tipo_usuario tu
    ON utu.id_tipo_usuario = tu.id_tipo_usuario
WHERE
    tu.nombre_tipo IN ('Egresado', 'Estudiante')
    AND p.precio > 100000;

-- ---------------------------------------------------------------------------------------------------------------------------------
-- 10.- Ejercicio del enunciado para consulta parametrizada (PREPARE / EXECUTE) con 4 JOINs (GROUP BY y HAVING)
-- ---------------------------------------------------------------------------------------------------------------------------------

PREPARE stmt_analisis_participacion_eventos (INTEGER, DATE) AS
SELECT
    organizador.id_usuario AS codigo_organizador,
    CONCAT_WS(
        ' ',
        organizador.nombre1,
        organizador.nombre2,
        organizador.apellido1,
        organizador.apellido2
    ) AS nombre_organizador,
    te.nombre_tipo AS tipo_evento,
    COUNT(DISTINCT epu.id_evento_usuario) AS total_participantes_confirmados
FROM evento_parti_usu AS epu
JOIN evento AS e
    ON epu.id_evento = e.id_evento
JOIN tipo_evento AS te
    ON e.id_tipo_evento = te.id_tipo_evento
JOIN usuario AS organizador
    ON e.id_usuario = organizador.id_usuario
JOIN usu_tipo_usu AS utu
    ON organizador.id_usuario = utu.id_usuario
JOIN tipo_usuario AS tu
    ON utu.id_tipo_usuario = tu.id_tipo_usuario
WHERE te.id_tipo_evento = $1
  AND e.fecha_event >= $2
  AND epu.asistencia IS TRUE
GROUP BY
    organizador.id_usuario,
    organizador.nombre1,
    organizador.nombre2,
    organizador.apellido1,
    organizador.apellido2,
    te.id_tipo_evento,
    te.nombre_tipo
HAVING COUNT(DISTINCT epu.id_evento_usuario) >= 10;

EXECUTE stmt_analisis_participacion_eventos(1, DATE '1900-01-01');

DEALLOCATE stmt_analisis_participacion_eventos;


-- ---------------------------------------------------------------------------------------------------------------------------------
--11.- Ejercicio del enunciado para Evaluación Experimental de Rendimiento con ANALYZE
-- ---------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE usuario_1000 AS
SELECT
    serie AS id_usuario,
    DATE '2024-01-01' + FLOOR(RANDOM() * 1096)::INTEGER AS fecha_registro,
    CASE FLOOR(RANDOM() * 4)::INTEGER
        WHEN 0 THEN 'Estudiante'
        WHEN 1 THEN 'Docente'
        WHEN 2 THEN 'Empleado'
        ELSE 'Empresario'
    END AS tipo_usuario
FROM GENERATE_SERIES(1, 1000) AS serie;


CREATE TABLE usuario_100000 AS
SELECT
    serie AS id_usuario,
    DATE '2024-01-01' + FLOOR(RANDOM() * 1096)::INTEGER AS fecha_registro,
    CASE FLOOR(RANDOM() * 4)::INTEGER
        WHEN 0 THEN 'Estudiante'
        WHEN 1 THEN 'Docente'
        WHEN 2 THEN 'Empleado'
        ELSE 'Empresario'
    END AS tipo_usuario
FROM GENERATE_SERIES(1, 100000) AS serie;


CREATE INDEX idx_usuario_1000_fecha
ON usuario_1000 (fecha_registro);

CREATE INDEX idx_usuario_100000_fecha
ON usuario_100000 (fecha_registro);


ANALYZE usuario_1000;
ANALYZE usuario_100000;


EXPLAIN (ANALYZE, BUFFERS)
SELECT
    tipo_usuario,
    COUNT(*) AS cantidad_usuarios
FROM usuario_1000
WHERE fecha_registro >= '2025-05-01'
  AND fecha_registro < '2025-05-08'
GROUP BY tipo_usuario;


-- ---------------------------------------------------------------------------------------------------------------------------------
-- 12.- Enunciado para Validación de Propiedades ACID en 4 Tablas del DDL
-- ---------------------------------------------------------------------------------------------------------------------------------
-- 12.1.- Atomicidad (Atomicity): Demostrar que una compra de un producto que falla en medio de la transacción por 
-- saldo  insuficiente o error de clave foránea revierte absolutamente todas las operaciones previas mediante ROLLBACK, 
-- dejando las tablas intactas.
-- ---------------------------------------------------------------------------------------------------------------------------------

BEGIN;

INSERT INTO usuario(
    id_rol,
    correo,
    nombre1,
    apellido1
)
VALUES(
    3,
    'usuario_atomicidad@redsocial.com',
    'Prueba',
    'Atomicidad'
);

INSERT INTO producto(
    id_usuario,
    id_tipo_producto,
    descripcion,
    precio
)
VALUES(
    currval('usuario_id_usuario_seq'),
    1,
    'Producto de prueba',
    150000
);

INSERT INTO historial(
    accion,
    fecha,
    id_usuario
)
VALUES(
    'Compra realizada',
    CURRENT_DATE,
    99999999
);

ROLLBACK;

-- ---------------------------------------------------------------------------------------------------------------------------------
-- 12.2.- Consistencia (Consistency): Demostrar cómo las restricciones de integridad física (CHECK precio >= 0, FOREIGN KEY, NOT NULL) 
-- impiden que la base de datos ingrese a un estado de datos inconsistente o embasurado.
-- ---------------------------------------------------------------------------------------------------------------------------------

--- Violación de FOREIGN KEY

BEGIN;

INSERT INTO producto(
    id_usuario,
    id_tipo_producto,
    descripcion,
    precio
)
VALUES(
    99999999,
    1,
    'Producto inconsistente',
    150000
);

ROLLBACK;

--- Violación de NOT NULL

BEGIN;

INSERT INTO usuario(
    id_rol,
    correo,
    nombre1,
    apellido1
)
VALUES(
    1,
    'prueba@correo.com',
    NULL,
    'Gomez'
);

ROLLBACK;

--- Violación de CHECK

BEGIN;

INSERT INTO reaccion(
    id_usuario,
    id_publicacion,
    id_comentario,
    tipo_reaccion
)
VALUES(
    1,
    1,
    1,
    'Like'
);

ROLLBACK;

-- ---------------------------------------------------------------------------------------------------------------------------------
-- 12.4.- Durabilidad (Durability): Demostrar que una vez ejecutado exitosamente el comando COMMIT, los datos persisten de manera 
-- permanente en el almacenamiento físico de PostgreSQL (archivos WAL) incluso ante una simulación de desconexión imprevista del servidor.
-- ---------------------------------------------------------------------------------------------------------------------------------

BEGIN;

INSERT INTO historial(
    accion,
    fecha,
    id_usuario
)
VALUES(
    'Prueba de Durabilidad',
    CURRENT_DATE,
    1
);

COMMIT;

-- ---------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM historial
WHERE accion = 'Prueba de Durabilidad';