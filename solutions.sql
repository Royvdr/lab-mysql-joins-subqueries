-- Add you solution queries below:
USE sakila;

SHOW TABLES;

SELECT COUNT(inventory_id) 
FROM inventory 
WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'HUNCHBACK IMPOSSIBLE'
);

SELECT title, length 
FROM film 
WHERE length > (
    SELECT AVG(length) FROM film
);

SELECT first_name, last_name 
FROM actor 
WHERE actor_id IN (
    SELECT actor_id FROM film_actor WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'ALONE TRIP'
    )
);

SELECT title FROM film 
WHERE film_id IN (
    SELECT film_id FROM film_category WHERE category_id = (
        SELECT category_id FROM category WHERE name = 'Family'
    )
);

SELECT first_name, last_name, email FROM customer 
WHERE address_id IN (
    SELECT address_id FROM address WHERE city_id IN (
        SELECT city_id FROM city WHERE country_id = (
            SELECT country_id FROM country WHERE country = 'Canada'
        )
    )
); 
-- This looks so much more complicated than using JOIN


SELECT title FROM film 
WHERE film_id IN (
    SELECT film_id FROM film_actor 
    WHERE actor_id = (
        SELECT actor_id FROM film_actor 
        GROUP BY actor_id 
        ORDER BY COUNT(film_id) DESC 
        LIMIT 1
    )
);

SELECT f.title FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (
    SELECT customer_id FROM payment 
    GROUP BY customer_id 
    ORDER BY SUM(amount) DESC 
    LIMIT 1
);

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING total_spent > (
    SELECT AVG(total_per_client) FROM (
        SELECT SUM(amount) AS total_per_client 
        FROM payment 
        GROUP BY customer_id
    ) AS sub_table
);