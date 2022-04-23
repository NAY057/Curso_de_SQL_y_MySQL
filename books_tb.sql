-- comando para el login  
 -u root -h localhost -p
-- mysql password: root

--ruta a mysql
C:\Program Files\MySQL\MySQL Workbench 8.0

--comando para mostrar las bases de datos
show databases;

-- comando para seleccionar una base de datos
use  NOMBRE DE LA BASE DE DATOS

-- comando para mostrar la base de datos selecionada
select database();

--comando para ver la estrutura de una tabla
desc NOMBRE DE LA TABLA;

--comando para ver la estrutura de una tabla con mucho mas detalle
show full columns from NOMBRE DE LA TABLA;

--para utilizar nombre de columnas que esten reservador por el sistema se debe de utilizar las siguientes comillas
``
year => `year`


--para realizar un join o inner join que es lo mismo se debe de usar la siguiente estructura
SELECT  b.book_id, a.name, a.author_id,b.title (columnas a mostrar de las tablas que se estan relacionando)
    from    books as b (tabla pivote)
    join    authors as a (tabla a relacionar)
    on      a.author_id = b.author_id (campos a relacionar entre las dos tablas)
    where   a.author_id between 1 and 5; (condicional opcional)

-- SELECT  b.book_id, a.name, a.author_id,b.title 
--     from    books as b 
--     join    authors as a 
--     on      a.author_id = b.author_id 
--     where   a.author_id between 1 and 5;

--se pueden usar tantos joins como sean necesarios


-- ejemplo con triple join
SELECT      c.name, b.title, a.name, t.type
FROM        transactions as t
JOIN        clients as c
ON          c.client_id = t.client_id
JOIN        books as b
ON          b.book_id = t.book_id
JOIN        authors as a
ON          a.author_id = b.author_id
WHERE       c.gender = 'F'
AND         t.type in ('sell','lend')


-- para realizar un LEFT JOIN se debe user la siguiente estructura

-- MUY IMPORTANTE TENER ENCUENTA LO SIGUIENTE...
-- Si usamos inner join (o solo join) nos muestra la info que existe en las dos tablas.
-- Con left join nos muestra la información que esta en la tabla principal del from, y nos trae vacio si no existe en la otra tabla

SELECT      a.author_id, a.name, a.nationality, b.title
FROM        authors as a --(TABLA PIVOTE A LA CUAL SE LE TRAERA TODA LA INFORMACION, ASI NO COINCIDA CON LA TABLA A RELACIONAR)
LEFT JOIN   books as b --(TABLA A RELACIONAR)
ON          b.author_id = a.author_id --(campos a relacionar entre las dos tablas)
WHERE       a.author_id BETWEEN 1 AND 5
ORDER BY    a.author_id

-- si se quiere utilizar el la funcion COUNT, tambien se debe de agregar un GROUP BY

SELECT      a.author_id, a.name, a.nationality, COUNT(b.book_id) (cuenta cunantos book id distintos hay)
FROM        authors as a 
LEFT JOIN   books as b 
ON          b.author_id = a.author_id 
WHERE       a.author_id BETWEEN 1 AND 5
GROUP BY    a.author_id (este es el campo que hace de pivote para el count, es decir que este dato no se repite, es decir que cuenta todos los libros que tiene un autor )
ORDER BY    a.author_id



CREATE TABLE IF NOT EXISTS books(
    book_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    author_id INTEGER UNSIGNED,
    title VARCHAR(100) NOT NULL,
    `year` INTEGER UNSIGNED NOT NULL DEFAULT 1900,
    lenguage VARCHAR(2) NOT NULL DEFAULT 'es' COMMENT  'ISO 639-1 Lenguage',
    cover_url VARCHAR(500),
    price DOUBLE NOT NULL DEFAULT 10.0,
    sellable INTEGER ,
    copies INTEGER NOT NULL DEFAULT 1,
    `description` TEXT
    );

INSERT INTO books(title,author_id, `year`) 
    VALUES  ('El Laberinto de la Soledad', 6,1958),
            ('Vuelta al Laberinto de la Soledad', 6,1960);


-- NO SE RECOMIENDAN LAS CONSULTAS ANIDADAS YA QUE CONSUMEN MUCHOS RECURSOS DE FORMA EXPONENCIAL
-- Y PUEDEN SER PELIGROSAS
--(EJEMPLIO DE CONSULTA ANIDADA)
INSERT INTO books(title, author_id, `year`)
VALUES('Vueltra al laberinto de la soledad',
    (SELECT author_id FROM authors
    where name = 'Octavio Paz'
    LIMIT 1
    )
);


-- PARA HAVER UN UPDATE ES OBLIGATORIO!! TENER UNA CONDICION WHERE, DE LO CONTRARIO SE VA A ACTUALIZAR TODA LA TABLA
UPDATE tabla
SET 
    [columna = valor,...]
WHERE
    [condiciones]
LIMIT 1;
-- se considera buena practica dejar un limit por seguridad, esto tambien se debe de hacer con el DELETE


CREATE TABLE IF NOT EXISTS  authors(
    author_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(120) NOT NULL,
    nationality VARCHAR(3)
);
-- hacer chunks size de 50
INSERT INTO authors(name,nationality) 
VALUES('Nicolas Aguirre Yacup', 'COL'),
('Gabriel García Márquez', 'COL'),
('Juan Gabriel Vasquez', 'COL'),
('Julio Cortázar', 'ARG'),
('Isabel allende', 'CHI'),
('Octavio Paz', 'Mex');

CREATE TABLE clients (
    client_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(120) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    birthdate DATETIME,
    gender ENUM('M', 'F', 'ND') NOT NULL,
    active TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP
    
);

INSERT INTO clients(name, email, birthdate, gender, active)
VALUES('Maria Dolores Gomez','Maria Dolores.95983222J@random.names','1971-06-06','F', 0),
('Adrian Fernandez','Adrian.55818851J@random.names','1970-04-09','M', 1),
('Maria Luisa Marin','Maria Luisa.83726282A@random.names','1957-07-30','F', 1),
('Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M', 1);

-- The following will generate an error if we weren't to update the valueS
--lA SIGUIENTE SENDENCIA ACTUALIZA LAS FIAS QUE COINCIDAN CON EL PRIMARY KEY 
INSERT INTO clients (name, email, birthdate, gender, active)
VALUES('Maria Dolores Gomez','Maria Dolores.95983222J@random.names','1971-06-06','F', 1)
ON DUPLICATE KEY UPDATE active = VALUES(active);




CREATE TABLA IF NOT EXISTS operations(
    operation_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    book_id INTEGER UNSIGNED,
    client_id INTEGER UNSIGNED,
    `type` ENUM('borrowed','returned','sold'),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP
    finshed TINYINT NOT NULL DEFAULT 1
);




