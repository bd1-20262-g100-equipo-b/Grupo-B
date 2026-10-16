--
-- Scripts de Modificación de la Base de Datos - SGBD PostgreSQL
-- Todas las instrucciones se deben realizar en secuencia sin errores
-- Probar los scripts en detalle
--

--
-- Modificación de la Base de Datos
-- 


--
-- 1.- DATOS SEMI-ESTRUCTURADOS PARA DATOS PARA BIG DATA
-- Gestionar el campo "perfil_usuario" en tabla "usuarios" 
-- Debe incluir otros datos diferentes al ejemplo del Anexo B

-- 1.- "agregar" un campo tipo JSON o JSNOB
ALTER TABLE usuario
ADD COLUMN perfil_usuario JSONB;


-- 2.- Agregar un par de registros
INSERT INTO usuario (
    id_usuario,
    id_rol,
    correo,
    nombre1,
    nombre2,
    apellido1,
    apellido2,
    perfil_usuario
) VALUES (
    1,
    1,
    'nicolas.gomez@email.com',
    'Nicolas',
    'Andres',
    'Gomez',
    'Lopez',
    '{
      "habilidades":["Python","PostgreSQL","Ciberseguridad"],
      "intereses":["Bases de Datos","Desarrollo Web","IA"],
      "idiomas":["Español","Inglés"],
      "nivel_academico":"Universitario"
    }'
);


-- 3.- Consultar la información agregada
SELECT
id_usuario,
id_rol,
correo,
nombre1,
nombre2,
apellido1,
apellido2,
perfil_usuario
FROM usuario;

-- 4.- Describir el campo y explicar su propósito
El campo perfil_usuario se creó utilizando el tipo de dato JSONB de PostgreSQL. 
Su propósito es almacenar información semiestructurada relacionada con los usuarios de la red social, como intereses, habilidades, gustos, certificaciones o 
cualquier otro dato complementario. Este tipo de dato permite almacenar estructuras flexibles sin necesidad de agregar múltiples columnas adicionales, 
facilitando el manejo de información utilizada en entornos de Big Data.


--
-- 2.- DATOS SEMI-ESTRUCTURADOS (PARA BIG DATA o IOT)
-- Gestionar un nuevo campo "nombre_campo" (de su propia creación) en cualquier tabla (de las existentes) que considere adecuada

-- 1.- "agregar" un campo tipo JSON o JSONB
ALTER TABLE evento
ADD COLUMN detalle_logistico JSONB;

-- 2.- Agregar un par de registros de información
INSERT INTO evento (
    id_evento,
    id_tipo_evento,
    id_usuario,
    descripcion,
    fecha_evento,
    detalle_logistico
) VALUES (
    1,
    1,
    1,
    'Conferencia de Ciberseguridad',
    '2025-11-15 09:00:00',
    '{
      "lugar":"Auditorio Principal",
      "capacidad":200,
      "equipos":["Proyector","Sonido","Micrófono"],
      "modalidad":"Presencial"
    }'
);


-- 3.- Consultar la información agregada
SELECT
id_evento,
id_tipo_evento,
id_usuario,
descripcion,
fecha_evento,
detalle_logistico
FROM evento;

-- 4.- Describir el campo y explicar su propósito
El campo detalle_logistico se implementó utilizando el tipo de dato JSONB en la tabla evento. 
Su objetivo es almacenar información variable asociada a la logística de los eventos, como ubicación, 
capacidad, modalidad, recursos tecnológicos y características organizativas. Gracias al uso de JSONB, 
es posible gestionar datos semiestructurados de manera flexible, eficiente y escalable, 
sin modificar continuamente el diseño físico de la base de datos.

