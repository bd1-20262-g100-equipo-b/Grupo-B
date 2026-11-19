--
-- Scripts - Enunciados DML para Manipulación de Datos Semi-Estructurados (JSON)
-- Manipulación de Campo JSON (Perfil Profesional y Competencias)

--Punto 2. Datos JSON.


ALTER TABLE perfil
ADD COLUMN perfil_profesional JSONB;


UPDATE perfil
SET perfil_profesional = '{
    "resumen": "Estudiante de Ingeniería de Software con conocimientos en desarrollo de aplicaciones y bases de datos.",
    "skills": [
        "C++",
        "C#",
        "Python",
        "SQL",
        "PostgreSQL"
    ],
    "areas_interes": [
        "Desarrollo de software",
        "Bases de datos",
        "Inteligencia artificial",
        "Desarrollo web"
    ],
    "idiomas": [
        {
            "nombre": "Español",
            "nivel": "Nativo"
        },
        {
            "nombre": "Inglés",
            "nivel": "Intermedio"
        }
    ],
    "proyectos": [
        {
            "nombre": "Sistema de gestión musical",
            "descripcion": "Aplicación desarrollada en C++ para administrar canciones y listas musicales."
        }
    ]
}'
WHERE id_usuario = 1;


SELECT
    id_usuario,
    perfil_profesional ->> 'resumen' AS resumen_profesional,
    perfil_profesional -> 'skills' AS habilidades,
    perfil_profesional -> 'areas_interes' AS areas_academicas,
    perfil_profesional -> 'idiomas' AS idiomas,
    perfil_profesional -> 'proyectos' AS proyectos
FROM perfil
WHERE id_usuario = 1;


SELECT
    id_usuario,
    perfil_profesional -> 'skills' ->> 0 AS primera_habilidad,
    perfil_profesional -> 'skills' ->> 1 AS segunda_habilidad
FROM perfil
WHERE id_usuario = 1;


SELECT
    id_perfil,
    id_usuario,
    descripcion,
    perfil_profesional
FROM perfil
WHERE id_usuario = 1;