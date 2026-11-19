--
-- Script Poblamiento
--
-- 


--
-- 1.1- Poblamiento Directo mediante INSERT INTO (Catálogos Base):
--

-- rol: 4 registros

INSERT INTO rol (id_rol,nombre_rol) VALUES
(1,'Administrador'),
(2,'Auxiliar'),
(3,'Miembro'),
(4,'Visitante');

-- tipo_usuario: 9 registros

INSERT INTO tipo_usuario (id_tipo_usuario,nombre_tipo) VALUES
(1,'Estudiante'),
(2,'Docente'),
(3,'Egresado'),
(4,'Empleado'),
(5,'Empresario'),
(6,'Ex-Empleado'),
(7,'Ex-Estudiante'),
(8,'Ex-Docente'),
(9,'Guess');

-- tipo_servicio: 20 registros

INSERT INTO tipo_servicio VALUES
(1,'Asesoría Académica'),
(2,'Mantenimiento Moto'),
(3,'Diseño Gráfico'),
(4,'Programación'),
(5,'Fotografía'),
(6,'Marketing'),
(7,'Traducción'),
(8,'Reparación PC'),
(9,'Electricidad'),
(10,'Plomería'),
(11,'Clases Inglés'),
(12,'Clases Matemáticas'),
(13,'Consultoría'),
(14,'Redacción'),
(15,'Producción Audiovisual'),
(16,'Mensajería'),
(17,'Transporte'),
(18,'Jardinería'),
(19,'Entrenamiento Personal'),
(20,'Soporte Técnico');

-- tipo_producto: 20 registros
INSERT INTO tipo_producto VALUES
(1,'Libros'),
(2,'Motocicletas'),
(3,'Alimentos'),
(4,'Electrodomésticos'),
(5,'Ropa'),
(6,'Computadores'),
(7,'Celulares'),
(8,'Tabletas'),
(9,'Videojuegos'),
(10,'Muebles'),
(11,'Herramientas'),
(12,'Accesorios'),
(13,'Arte'),
(14,'Instrumentos Musicales'),
(15,'Artículos Deportivos'),
(16,'Juguetes'),
(17,'Papelería'),
(18,'Mascotas'),
(19,'Vehículos'),
(20,'Otros');

-- tipo_evento: 20 registros
INSERT INTO tipo_evento VALUES
(1,'Congreso'),
(2,'Conferencia'),
(3,'Taller'),
(4,'Seminario'),
(5,'Curso'),
(6,'Capacitación'),
(7,'Feria'),
(8,'Networking'),
(9,'Encuentro'),
(10,'Hackathon'),
(11,'Competencia'),
(12,'Foro'),
(13,'Charla'),
(14,'Exposición'),
(15,'Festival'),
(16,'Webinar'),
(17,'Campaña'),
(18,'Lanzamiento'),
(19,'Mesa Redonda'),
(20,'Actividad Cultural');

--
-- 1.2- oblamiento Masivo Automatizado (Generadores Aleatorios):
--

-- usuario: 18.550 registros
INSERT INTO usuario(
    id_rol,
    correo,
    nombre1,
    nombre2,
    apellido1,
    apellido2
)
SELECT
    (1 + floor(random()*4))::int,

    lower(nombre_generado)
    || '.'
    || lower(apellido_generado)
    || lpad((floor(random()*1000))::text,3,'0')
    || g
    || '@redsocial.com',

    nombre_generado,

    (ARRAY[
        'José','Alejandro','Sofía','Paula',
        'Isabel','Julián','Mateo','Carolina'
    ])[1 + floor(random()*8)::int],

    apellido_generado,

    (ARRAY[
        'Vargas','Muñoz','Castro',
        'Morales','Ríos','Zapata',
        'Giraldo','Restrepo'
    ])[1 + floor(random()*8)::int]

FROM (
    SELECT
        g,

        (ARRAY[
            'Juan','María','Carlos','Ana','Pedro',
            'Luisa','Miguel','Laura','Daniel','Valentina',
            'Andrés','Camila','David','Sara'
        ])[1 + floor(random()*14)::int] AS nombre_generado,

        (ARRAY[
            'Gómez','Pérez','Rodríguez',
            'López','Martínez','Ramírez',
            'Torres','Hernández'
        ])[1 + floor(random()*8)::int] AS apellido_generado

    FROM generate_series(1,18550) g
) datos;

-- usu_tipo_usu: 18.550 registros
INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,1
FROM usuario
WHERE id_usuario BETWEEN 1 AND 7000;

INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,2
FROM usuario
WHERE id_usuario BETWEEN 7001 AND 7500;

INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,3
FROM usuario
WHERE id_usuario BETWEEN 7501 AND 17500;

INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,4
FROM usuario
WHERE id_usuario BETWEEN 17501 AND 18000;

INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,5
FROM usuario
WHERE id_usuario BETWEEN 18001 AND 18050;

INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,6
FROM usuario
WHERE id_usuario BETWEEN 18051 AND 18100;

INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,7
FROM usuario
WHERE id_usuario BETWEEN 18101 AND 18400;

INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,8
FROM usuario
WHERE id_usuario BETWEEN 18401 AND 18500;

INSERT INTO usu_tipo_usu(id_usuario,id_tipo_usuario)
SELECT id_usuario,9
FROM usuario
WHERE id_usuario BETWEEN 18501 AND 18550;

-- perfil: 18.550 registros
INSERT INTO perfil(id_usuario,descripcion)
SELECT
    id_usuario,
    'Perfil generado automáticamente para usuario ' || id_usuario
FROM usuario;

-- evento: 3.000 registros
INSERT INTO evento(
    id_tipo_evento,
    id_usuario,
    descripcion,
    fecha_event
)
SELECT
    (1 + floor(random()*20))::int,
    (1 + floor(random()*18550))::int,
    'Evento automático #' || g,
    CURRENT_DATE + ((random()*365)::int)
FROM generate_series(1,3000) g;


-- servicio: 3.000 registros
INSERT INTO servicio(
    id_tipo_servicio,
    id_usuario,
    precio,
    descripcion
)
SELECT
    (1 + floor(random()*20))::int,
    (1 + floor(random()*18550))::int,
    ROUND((10000 + random()*490000)::numeric,2),
    'Servicio automático #' || g
FROM generate_series(1,3000) g;

-- producto: 3.000 registros
INSERT INTO producto(
    id_usuario,
    id_tipo_producto,
    descripcion,
    precio
)
SELECT
    (1 + floor(random()*18550))::int,
    (1 + floor(random()*20))::int,
    'Producto automático #' || g,
    ROUND((5000 + random()*995000)::numeric,2)
FROM generate_series(1,3000) g;

-- publicacion: 5.000 registros
INSERT INTO publicacion(
    id_usuario,
    contenido,
    fecha_publica
)
SELECT
    (1 + floor(random()*18550))::int,
    'Publicación automática #' || g,
    CURRENT_DATE - ((random()*365)::int)
FROM generate_series(1,5000) g;

-- comentario: 5.000 registros
INSERT INTO comentario(
    id_usuario,
    id_publicacion,
    contenido,
    fecha_coment
)
SELECT
    (1 + floor(random()*18550))::int,
    (1 + floor(random()*3000))::int,
    'Comentario generado automáticamente',
    CURRENT_DATE - ((random()*365)::int)
FROM generate_series(1,5000);

-- notificacion: 5.000 registros
INSERT INTO notificacion(
    id_usuario,
    mensaje,
    fecha_noti
)
SELECT
    (1 + floor(random()*18550))::int,
    'Nueva actividad detectada',
    CURRENT_DATE
FROM generate_series(1,5000);

--mensaje: 5.000 registros
INSERT INTO mensaje(
    contenido,
    fecha_mensaje,
    id_emisor,
    id_receptor
)
SELECT
    'Mensaje automático',
    CURRENT_DATE - ((random()*365)::int),
    (1 + floor(random()*18550))::int,
    (1 + floor(random()*18550))::int
FROM generate_series(1,5000);

-- amistad: 5.000 registros
INSERT INTO amistad(
    estado,
    id_usuario1,
    id_usuario2
)
SELECT
    (ARRAY['Pendiente','Aceptada','Bloqueada'])
    [1 + floor(random()*3)::int],

    u1,
    u2

FROM(
    SELECT
        (1 + floor(random()*18550))::int AS u1,
        (1 + floor(random()*18550))::int AS u2
    FROM generate_series(1,5000)
) t
WHERE u1 <> u2;

-- historial: 5.000 registros
INSERT INTO historial(
    accion,
    fecha,
    id_usuario
)
SELECT
    'Inicio de sesión',
    CURRENT_DATE - ((random()*365)::int),
    (1 + floor(random()*18550))::int
FROM generate_series(1,5000);

-- evento_parti_usu: 5.000 registros
INSERT INTO evento_parti_usu(
    id_usuario,
    id_evento,
    fecha_inscripcion,
    asistencia,
    preguntas_evento
)
SELECT
    (1 + floor(random()*18550))::int,
    (1 + floor(random()*3000))::int,
    CURRENT_DATE - ((random()*200)::int),
    random() > 0.5,
    'Pregunta generada automáticamente'
FROM generate_series(1,5000);

-- usu_parti_grupo: 5.000 registros
INSERT INTO grupo(
    id_usuario,
    nombre_grupo
)
SELECT
    (1 + floor(random()*18550))::int,
    'Grupo #' || g
FROM generate_series(1,1000) g;

INSERT INTO usu_parti_grupo(
    id_usuario,
    id_grupo,
    fecha_union,
    rol_grupo
)
SELECT
    (1 + floor(random()*18550))::int,
    (1 + floor(random()*1000))::int,
    CURRENT_DATE - ((random()*365)::int),

    (ARRAY[
        'Administrador',
        'Moderador',
        'Miembro'
    ])[1 + floor(random()*3)::int]

FROM generate_series(1,5000);

-- reaccion: 5.000 registros
INSERT INTO reaccion(
    id_usuario,
    id_publicacion,
    id_comentario,
    tipo_reaccion
)
SELECT
    (1 + floor(random()*18550))::int,

    CASE
        WHEN destino = 'P'
        THEN (
            SELECT id_publicacion
            FROM publicacion
            ORDER BY random()
            LIMIT 1
        )
        ELSE NULL
    END,

    CASE
        WHEN destino = 'C'
        THEN (
            SELECT id_comentario
            FROM comentario
            ORDER BY random()
            LIMIT 1
        )
        ELSE NULL
    END,

    (ARRAY[
        'Like',
        'Love',
        'Wow',
        'Sad',
        'Angry'
    ])[1 + floor(random()*5)::int]

FROM (
    SELECT
        CASE
            WHEN random() < 0.5 THEN 'P'
            ELSE 'C'
        END AS destino
    FROM generate_series(1,5000)
) t;

--
-- 1.3- Respaldo Físico de la Base de Datos (AQUÍ O SE HACE NADA) - Se debe entregar el respaldo en archivo PLANO por aparte
--