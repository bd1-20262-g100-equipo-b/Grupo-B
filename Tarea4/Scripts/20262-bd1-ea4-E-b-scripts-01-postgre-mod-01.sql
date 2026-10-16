--
-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL
-- Todas las instrucciones se deben realizar en secuencia sin errores
-- Probar los scripts en detalle
--

--
-- Modificación de Tablas
-- 

--
-- Gestionar una tabla "nueva"
-- 1.- "agregar" una nueva tabla a la base de datos que tenga relación con el sistema
-- 2.- Darle un nombre "coherente"
-- 3.- Agregar campos coherentes con la tabla
-- 4.- Realizar todas las operaciones que se solicitan a continuación
--


-- 1.
-- Crear una tabla "nueva" de su iniciativa (una tabla coherente con el sistema con su nombre, no coloque "nueva" como nombre)
--
CREATE TABLE categoria_grupo (
);


-- 2
-- Agregar una clave primaria y otros 3 campos cualquiera a la tabla "nueva"
-- Mínimo un campo tipo texto y uno numérico
--
ALTER TABLE categoria_grupo
ADD COLUMN id_categoria SERIAL PRIMARY KEY;

ALTER TABLE categoria_grupo
ADD COLUMN nombre_categoria VARCHAR(100);

ALTER TABLE categoria_grupo
ADD COLUMN prioridad INTEGER;

ALTER TABLE categoria_grupo
ADD COLUMN descripcion TEXT;


-- 3
-- Quitar uno de los campos de la tabla "nueva"
--
ALTER TABLE categoria_grupo
DROP COLUMN descripcion;


-- 4
-- Cambiar el nombre de la tabla "nueva" a otro nombre "otro_nombre"
-- Todas las operaciones siguientes se realizan sobre la tabla renombrada
--
ALTER TABLE categoria_grupo
RENAME TO categoria_comunidad;


-- 5 
-- Agregar un campo único a la tabla 
--
ALTER TABLE categoria_comunidad
ADD COLUMN codigo_categoria VARCHAR(20) UNIQUE;


-- 6
-- Agregar 2 fechas de inicio y fin; y colocar un control de orden de fechas
--
ALTER TABLE categoria_comunidad
ADD COLUMN fecha_inicio DATE;

ALTER TABLE categoria_comunidad
ADD COLUMN fecha_fin DATE;

ALTER TABLE categoria_comunidad
ADD CONSTRAINT chk_fechas
CHECK (fecha_inicio <= fecha_fin);


-- 7
-- Agregar 1 campo entero y colocar un control para que no sea negativo
--
ALTER TABLE categoria_comunidad
ADD COLUMN cantidad_miembros INTEGER;

ALTER TABLE categoria_comunidad
ADD CONSTRAINT chk_cantidad_miembros
CHECK (cantidad_miembros >= 0);
``


-- 8
-- Modificar el tamaño de un campo texto de la tabla renombra
--
ALTER TABLE categoria_comunidad
ALTER COLUMN nombre_categoria TYPE VARCHAR(200);

-- 9
-- Modificar el campo numeríco y colocar un control de rango 
--
ALTER TABLE categoria_comunidad
ADD CONSTRAINT chk_rango_miembros
CHECK (cantidad_miembros BETWEEN 0 AND 1000);


-- 10
-- Agregar un índice a la tabla (cualquier campo)
--
CREATE INDEX idx_nombre_categoria
ON categoria_comunidad(nombre_categoria);


--
-- 11 
-- Eliminar una de las fechas
--
ALTER TABLE categoria_comunidad
DROP COLUMN fecha_fin;


-- 12
-- Borrar todos los datos de una tabla sin dejar traza
--
TRUNCATE TABLE categoria_comunidad;