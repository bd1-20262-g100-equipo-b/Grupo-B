--
-- Scripts - 8.- Enunciados para Consultas con Funciones de Agregación

-- ---------------------------------------------------------------------------------------------------------------------------------
-- Script del Enunciado 8.1 — Función COUNT: Volumen Global de Solicitudes de Servicio
-- Calcular la cantidad total de solicitudes de servicios registradas en la plataforma agrupadas por el estado de la transacción (Completado, Pendiente, Cancelado). 
-- ---------------------------------------------------------------------------------------------------------------------------------


-- En nuestra base de datos no existe un *estado* del servicio


-- CREACIÓN de la columna estado

ALTER TABLE servicio
ADD COLUMN estado VARCHAR(20);


-- POBLACIÓN de la columna estado (solo los 100 primeros servicios)

UPDATE servicio
SET estado = CASE
    WHEN id_servicio BETWEEN 1 AND 40 THEN 'Completado'
    WHEN id_servicio BETWEEN 41 AND 75 THEN 'Pendiente'
    WHEN id_servicio BETWEEN 76 AND 100 THEN 'Cancelado'
END
WHERE id_servicio BETWEEN 1 AND 100;


-- Consulta

SELECT
    estado,
    COUNT(*) AS cantidad_solicitudes
FROM servicio
WHERE estado IS NOT NULL
GROUP BY estado
ORDER BY estado;


-- ---------------------------------------------------------------------------------------------------------------------------------
-- Script del Enunciado 8.2 — Función SUM: Recaudo Comercial Total por Categoría de Producto
-- Calcular el monto total acumulado ($) en ventas de productos pertenecientes a la categoría 'Libros' y 'Tecnología/Computadores'.
-- ---------------------------------------------------------------------------------------------------------------------------------


SELECT
    tipro.nombre_tipo AS categoria,
    SUM(pre.precio) AS total_acumulado
FROM producto pre
INNER JOIN tipo_producto tipro
    ON pre.id_tipo_producto = tipro.id_tipo_producto
WHERE tipro.nombre_tipo IN ('Libros', 'Computadores')
GROUP BY tipro.nombre_tipo
ORDER BY tipro.nombre_tipo;