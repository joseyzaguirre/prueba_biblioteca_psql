CREATE DATABASE biblioteca;

\c biblioteca

-- SE CREAN TODAS LAS TABLAS NECESARIAS PARA LA BASE DE DATOS

CREATE TABLE libros (
    isbn varchar(255) not null,
    titulo varchar(255) not null,
    num_pags int not null,
    dias_prestamo int not null,
    PRIMARY KEY (isbn)
);

CREATE TABLE autores (
    codigo int not null,
    nombre varchar(255) not null,
    apellido varchar(255) not null,
    nacimiento int not null,
    fallecimiento int,
    PRIMARY KEY (codigo)
);

CREATE TABLE librosautores (
    libro_isbn varchar(255) not null,
    autor_codigo int not null,
    tipo_autor varchar(255),
    PRIMARY KEY (libro_isbn, autor_codigo),
    FOREIGN KEY (libro_isbn) REFERENCES libros (isbn),
    FOREIGN KEY (autor_codigo) REFERENCES autores (codigo)
);

CREATE TABLE comunas (
    id serial not null,
    nombre varchar(255) not null,
    PRIMARY KEY (id)
);

CREATE TABLE direcciones (
    id serial not null,
    comuna_id int not null,
    calle varchar(255) not null,
    numero int not null,
    PRIMARY KEY (id),
    FOREIGN KEY (comuna_id) REFERENCES comunas (id)
);

CREATE TABLE socios (
    rut varchar(255) not null,
    direccion_id int not null,
    nombre varchar(255) not null,
    apellido varchar(255) not null,
    telefono varchar(255) not null,
    PRIMARY KEY (rut),
    FOREIGN KEY (direccion_id) REFERENCES direcciones (id)
);

CREATE TABLE prestamos (
    id serial not null,
    libro_isbn varchar(255) not null,
    socio_rut varchar(255) not null,
    fecha_prestamo date not null,
    fecha_devolucion date not null,
    fecha_real_dev date,
    PRIMARY KEY (id),
    FOREIGN KEY (libro_isbn) REFERENCES libros (isbn),
    FOREIGN KEY (socio_rut) REFERENCES socios (rut)
);

-- SE IMPORTAN LOS DATOS DADOS POR LA PAUTA A LAS RESPECTIVAS TABLAS

INSERT INTO comunas (nombre) 
VALUES 
    ('SANTIAGO'),
    ('TEMUCO'),
    ('VILCUN');

INSERT INTO direcciones (comuna_id, calle, numero)
VALUES
    (1, 'AVENIDA', 1),
    (1, 'PASAJE', 2),
    (1, 'AVENIDA', 2),
    (1, 'AVENIDA', 3),
    (1, 'PASAJE', 3);

INSERT INTO socios (rut, direccion_id, nombre, apellido, telefono)
VALUES
    ('1111111-1', 1, 'JUAN', 'SOTO', '911111111'),
    ('2222222-2', 2, 'ANA', 'PEREZ', '922222222'),
    ('3333333-3', 3, 'SANDRA', 'AGUILAR', '933333333'),
    ('4444444-4', 4, 'ESTEBAN', 'JEREZ', '944444444'),
    ('5555555-5', 5, 'SILVANA', 'MUÑOZ', '955555555');

INSERT INTO libros (isbn, titulo, num_pags, dias_prestamo)
VALUES
    ('111-1111111-111', 'CUENTOS DE TERROR', 344, 7),
    ('222-2222222-222', 'POESIAS CONTEMPORANEAS', 167, 7),
    ('333-3333333-333', 'HISTORIA DE ASIA', 511, 14),
    ('444-4444444-444', 'MANUAL DE MECANICA', 298, 14);

INSERT INTO autores (codigo, nombre, apellido, nacimiento, fallecimiento)
VALUES
    (3, 'JOSE', 'SALGADO', 1968, 2020),
    (4, 'ANA', 'SALGADO', 1972, null),
    (1, 'ANDRES', 'ULLOA', 1982, null),
    (2, 'SERGIO', 'MARDONES', 1950, 2012),
    (5, 'MARTIN', 'PORTA', 1976, null);

INSERT INTO librosautores (libro_isbn, autor_codigo, tipo_autor)
VALUES
    ('111-1111111-111', 3, 'PRINCIPAL'),
    ('111-1111111-111', 4, 'COAUTOR'),
    ('222-2222222-222', 1, 'PRINCIPAL'),
    ('333-3333333-333', 2, 'PRINCIPAL'),
    ('444-4444444-444', 5, 'PRINCIPAL');

INSERT INTO prestamos (libro_isbn, socio_rut, fecha_prestamo, fecha_devolucion)
VALUES
    ('111-1111111-111', '1111111-1', '2020-01-20', '2020-01-27'),
    ('222-2222222-222', '5555555-5', '2020-01-20', '2020-01-30'),
    ('333-3333333-333', '3333333-3', '2020-01-22', '2020-01-30'),
    ('444-4444444-444', '4444444-4', '2020-01-23', '2020-01-30'),
    ('111-1111111-111', '2222222-2', '2020-01-27', '2020-02-04'),
    ('444-4444444-444', '1111111-1', '2020-01-31', '2020-02-12'),
    ('222-2222222-222', '3333333-3', '2020-01-31', '2020-02-12');

--REQUERIMIENTO A

SELECT titulo
FROM libros
WHERE num_pags < 300;

--REQUERIMIENTO B

SELECT nombre, apellido
FROM autores
WHERE nacimiento > 1970;

--REQUERIMIENTO C

SELECT libros.titulo, COUNT(libros.titulo)
AS veces_prestadas
FROM libros
JOIN prestamos
ON libros.isbn = prestamos.libro_isbn
GROUP BY libros.titulo
ORDER BY veces_prestadas
DESC LIMIT 1;

--REQUERIMIENTO D

