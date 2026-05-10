-- TALLER 02 - SQL Practico Sakila
-- Alvaro G. Acevedo

USE sakila;

-- ============================================================
-- PARTE 1 - SELECT y WHERE
-- ============================================================

-- Lista de todos los clientes con nombre y apellido
SELECT first_name, last_name
FROM customer;

-- Peliculas que duran mas de 2 horas
-- Filtramos por length > 120 porque el campo esta en minutos
SELECT title, length
FROM film
WHERE length > 120;


-- ============================================================
-- PARTE 2 - ORDER BY
-- ============================================================

-- Clientes ordenados alfabeticamente por apellido (A -> Z)
SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC;

-- Top 5 peliculas mas largas del catalogo
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 5;


-- ============================================================
-- PARTE 3 - INNER JOIN
-- ============================================================

-- Pagos con el nombre del cliente
-- Unimos payment con customer usando customer_id para saber quien hizo cada pago
SELECT c.first_name, c.last_name, p.amount, p.payment_date
FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id;

-- Peliculas que han sido alquiladas
-- rental no tiene el nombre de la pelicula directamente, hay que pasar por inventory primero
SELECT f.title, r.rental_date
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id;


-- ============================================================
-- PARTE 4 - LEFT JOIN
-- ============================================================

-- Clientes que nunca han hecho un pago
-- Con LEFT JOIN traemos todos los clientes y filtramos los que no tienen
-- ningun registro en payment (IS NULL en el campo del join)
SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
WHERE p.customer_id IS NULL;

-- Peliculas sin actores registrados
-- Hay titulos en el catalogo que no tienen ningun actor en film_actor,
-- este query los identifica
SELECT f.title, f.length
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.film_id IS NULL;


-- ============================================================
-- PARTE 5 - INSERT, UPDATE, DELETE
-- ============================================================

-- Insertamos un actor temporal para probar las operaciones DML
INSERT INTO actor (first_name, last_name, last_update)
VALUES ('Carlos', 'Prueba', NOW());

-- Actualizamos el apellido del actor que acabamos de insertar
-- IMPORTANTE: siempre usar WHERE para no modificar otros registros
UPDATE actor
SET last_name = 'Temporal'
WHERE first_name = 'Carlos' AND last_name = 'Prueba';

-- Eliminamos el actor de prueba
-- IMPORTANTE: siempre usar WHERE en DELETE
DELETE FROM actor
WHERE first_name = 'Carlos' AND last_name = 'Temporal';


-- ============================================================
-- PARTE 6 - CONSULTAS AVANZADAS
-- ============================================================

-- Pregunta: ?Cuales son los 5 clientes que mas dinero han gastado en el servicio?
-- Esto permite identificar los clientes mas rentables para el negocio.
-- Agrupamos por cliente y sumamos todos sus pagos, luego ordenamos de mayor a menor.
SELECT c.first_name AS nombre, c.last_name AS apellido, SUM(p.amount) AS total_pagado
FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_pagado DESC
LIMIT 5;

-- Pregunta: ?Cuales son las 5 peliculas mas alquiladas del catalogo?
-- Sirve para entender que titulos tienen mas demanda.
-- Contamos cuantas veces aparece cada pelicula en los registros de alquiler.
SELECT f.title AS pelicula, COUNT(*) AS total_alquileres
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY total_alquileres DESC
LIMIT 5;
