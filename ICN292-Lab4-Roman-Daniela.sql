-- ============================================================================
-- ICN292 - SISTEMAS DE INFORMACIÓN PARA LA GESTIÓN | LABORATORIO 4
-- AUSTRAL EDITORES
-- ============================================================================

-- ============================================================================
-- ENTREGABLE 1 | CREACIÓN DE LA BASE Y TABLAS
-- ============================================================================
DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;

-- Tabla de autores
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60),
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL,
    PRIMARY KEY (id_autor)
);

-- Tabla de colecciones
CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    PRIMARY KEY (id_coleccion)
);

-- Tabla de libros, con claves foráneas hacia autores y colecciones
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT,
    id_autor INT NOT NULL,
    id_coleccion INT,
    titulo VARCHAR(120) NOT NULL,
    paginas INT,
    ejemplares_vendidos INT,
    anio INT,
    PRIMARY KEY (id_libro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);

-- Tabla de pagos, con clave foránea hacia autores
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pago),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- ============================================================================
-- CARGA OFICIAL
-- ============================================================================
INSERT INTO autores (nombre, pais, genero) VALUES
('Elena Pizarro', 'Chile', 'Novela'),            -- 1
('Harold Finch', 'Inglaterra', 'Ensayo'),        -- 2
('Rodrigo Bahamonde', 'Chile', 'Poesía'),        -- 3
('Valentina Correa', 'Argentina', 'Infantil'),   -- 4
('Nora Keller', 'Estados Unidos', 'Novela'),     -- 5
('Kenji Arakawa', NULL, 'Cómic');                -- 6

INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio) VALUES
(1, 'Cielo de Enero', 210, 1500, 2024),
(1, 'Marea Baja', 185, 800, 2023),
(1, 'El Norte', 200, 2200, 2024),
(2, 'Estrellas que Caen', 240, 3000, 2022),
(2, 'Máquinas', 215, 450, 2024),
(3, 'Luz Artificial', 300, 1200, 2024),
(3, 'Ruido Blanco', 280, 600, 2023),
(4, 'El Barrio de Lila', 190, 5000, 2024),
(4, 'Antes del Amanecer', 205, 2700, 2024),
(4, 'La Calle 8', 175, 900, 2023),
(5, 'Flor de Hierro', 195, 4100, 2024),
(5, 'Hora Dorada', 220, 1800, 2022);

-- ============================================================================
-- ENTREGABLE 2 | CONSULTAS
-- ============================================================================

-- Consulta 1: autores cuyo país no es Chile, incluido quien no tiene país
SELECT nombre AS `Nombre`, genero AS `Género`
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre;

-- Consulta 2: libros entre 190 y 220 páginas, de menor a mayor
SELECT titulo AS `Título`, paginas AS `Páginas`
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas;

-- Consulta 3: resumen del catálogo en una sola fila
SELECT COUNT(*) AS `Total de libros`,
       SUM(ejemplares_vendidos) AS `Total de ejemplares`,
       AVG(paginas) AS `Promedio de páginas`,
       MIN(anio) AS `Año más antiguo`,
       MAX(ejemplares_vendidos) AS `Máximo por libro`
FROM libros;

-- Consulta 4: géneros distintos de los autores, en orden alfabético
SELECT DISTINCT genero AS `Género`
FROM autores
ORDER BY genero;

-- Consulta 5: autores con más de un libro publicado en 2024
SELECT a.nombre AS `Nombre`, COUNT(*) AS `Libros en 2024`
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre;

-- Consulta 6: los tres libros de 2024 con más de 2000 ejemplares vendidos
SELECT titulo AS `Título`, ejemplares_vendidos AS `Ejemplares vendidos`
FROM libros
WHERE anio = 2024 AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;

-- Consulta 7: insertar 'Papel Mojado' y luego eliminarlo por título
INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES (3, 'Papel Mojado', 260, 50, 2024);

SELECT id_libro AS `ID libro`,
       id_autor AS `ID autor`,
       id_coleccion AS `ID colección`,
       titulo AS `Título`,
       paginas AS `Páginas`,
       ejemplares_vendidos AS `Ejemplares vendidos`,
       anio AS `Año`
FROM libros
WHERE titulo = 'Papel Mojado';

DELETE FROM libros
WHERE titulo = 'Papel Mojado';

SELECT id_libro AS `ID libro`,
       id_autor AS `ID autor`,
       id_coleccion AS `ID colección`,
       titulo AS `Título`,
       paginas AS `Páginas`,
       ejemplares_vendidos AS `Ejemplares vendidos`,
       anio AS `Año`
FROM libros
WHERE titulo = 'Papel Mojado';

SELECT COUNT(*) AS `Libros encontrados`
FROM libros
WHERE titulo = 'Papel Mojado';

-- Consulta 8: sumar 100 ejemplares vendidos a 'Cielo de Enero'
SELECT titulo AS `Título`, ejemplares_vendidos AS `Ejemplares vendidos`
FROM libros
WHERE titulo = 'Cielo de Enero';

UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';

SELECT titulo AS `Título`, ejemplares_vendidos AS `Ejemplares vendidos`
FROM libros
WHERE titulo = 'Cielo de Enero';

-- Consulta 9: cada libro con su colección y la fecha de publicación
INSERT INTO colecciones (titulo, fecha_publicacion) VALUES
('Narrativa Austral', '2024-11-15'),   -- 1
('Ideas y Versos', '2024-08-20'),      -- 2
('Pequeños Lectores', '2025-03-10');   -- 3

UPDATE libros
SET id_coleccion = 1
WHERE id_autor IN (1, 5);

UPDATE libros
SET id_coleccion = 2
WHERE id_autor IN (2, 3);

UPDATE libros
SET id_coleccion = 3
WHERE id_autor = 4;

SELECT l.titulo AS `Libro`,
       c.titulo AS `Colección`,
       c.fecha_publicacion AS `Fecha de publicación`
FROM libros l
JOIN colecciones c ON l.id_coleccion = c.id_coleccion
ORDER BY c.fecha_publicacion, l.titulo;

-- Consulta 10: pagos a los autores y total pagado a cada uno
INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES
(1, '2026-03-31', 450000.00),
(4, '2026-03-31', 1250000.00),
(1, '2026-06-30', 385500.00),
(5, '2026-06-30', 980000.00);

SELECT a.nombre AS `Nombre`,
       p.fecha_pago AS `Fecha de pago`,
       p.monto AS `Monto`
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor
ORDER BY p.fecha_pago, a.nombre;

SELECT a.nombre AS `Nombre`, SUM(p.monto) AS `Total pagado`
FROM autores a
JOIN pagos p ON a.id_autor = p.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre;
