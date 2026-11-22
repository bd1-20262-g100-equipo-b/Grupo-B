-- ---------------------------------------------------------------------------------
-- Scripts - Enunciados 3, 4, 5, 6 y 7 DML para consultas Sin Join, 1 Join, 2 Join, 3 Join y 4 Join
-- ---------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------
-- 3.- Enunciado para Consulta sin JOIN
-- Análisis de Precios y Disponibilidad en Oferta de Productos
-- ---------------------------------------------------------------------------------
SELECT
    id_producto AS "Código del producto",
    descripcion AS "Título descriptivo",
    precio AS "Precio de venta",
    ROUND(precio * 1.05, 2) AS "Precio con recargo del 5%",
    'Disponible' AS "Estado de disponibilidad"
FROM producto
WHERE precio BETWEEN 50000 AND 500000
ORDER BY precio DESC
LIMIT 20;



-- ---------------------------------------------------------------------------------
-- 4.- Enunciado para consulta con 1 JOIN. 
-- Censo Institucional de Usuarios por Categoría
-- -----------------------------------------------------------------------------------


SELECT
    tu.nombre_tipo AS categoria,
    COUNT(u.id_usuario) AS total_usuarios
FROM usuario u
INNER JOIN usu_tipo_usu utu
    ON u.id_usuario = utu.id_usuario
INNER JOIN tipo_usuario tu
    ON utu.id_tipo_usuario = tu.id_tipo_usuario
GROUP BY tu.nombre_tipo
ORDER BY total_usuarios DESC;


-- ---------------------------------------------------------------------------------
-- 5.- Enunciado para consulta con 2 JOINs
-- Trazabilidad de Eventos Académicos y sus Organizadores
-- ---------------------------------------------------------------------------------


-- Población de la tabla evento para este ejercicio

INSERT INTO evento
    (id_tipo_evento, id_usuario, descripcion, fecha_event)
VALUES
    (1, 1, 'Congreso de Ingeniería de Software', '2024-05-15'),
    (2, 2, 'Conferencia de Inteligencia Artificial', '2025-03-20'),
    (4, 3, 'Seminario de Innovación Tecnológica', '2025-08-12');


-- Consulta con 2 JOINs

SELECT
    even.descripcion AS titulo_evento,
    teven.nombre_tipo AS tipo_evento,
    even.fecha_event AS fecha_realizacion,
    CONCAT_WS(' ',
        usu.nombre1,
        usu.nombre2,
        usu.apellido1,
        usu.apellido2
    ) AS nombre_completo_organizador,
    usu.correo AS correo_institucional
FROM evento even

INNER JOIN tipo_evento teven
    ON even.id_tipo_evento = teven.id_tipo_evento
INNER JOIN usuario usu
    ON even.id_usuario = usu.id_usuario

WHERE even.fecha_event >= '2024-01-01'
    AND even.fecha_event < '2026-01-01'

ORDER BY even.fecha_event;


-- ---------------------------------------------------------------------------------
-- 6.- Enunciado para consulta SELECT con 3 JOINs
-- Consumo de Servicios Académicos por Estudiantes Activos
-- ---------------------------------------------------------------------------------

SELECT
    CONCAT_WS(
        ' ',
        u.nombre1,
        u.nombre2,
        u.apellido1,
        u.apellido2
    ) AS "Estudiante solicitante",
    s.descripcion AS "Servicio solicitado",
    ts.nombre_tipo AS "Categoría del servicio",
    ss.fecha_solicitud AS "Fecha de solicitud"
FROM servicio_solicitud AS ss
JOIN servicio AS s
    ON ss.id_servicio = s.id_servicio
JOIN tipo_servicio AS ts
    ON s.id_tipo_servicio = ts.id_tipo_servicio
JOIN usuario AS u
    ON ss.id_usuario = u.id_usuario
WHERE ss.estado = 'Completado'
  AND EXISTS (
      SELECT 1
      FROM usu_tipo_usu AS utu
      WHERE utu.id_usuario = u.id_usuario
        AND utu.id_tipo_usuario = 1
  );



-- ---------------------------------------------------------------------------------
-- 7.- Enunciado para consulta con 4 JOINs
-- Reporte Transaccional Consolidado de Venta de Productos
-- ---------------------------------------------------------------------------------

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
    AND p.precio > 100000
ORDER BY p.precio DESC;