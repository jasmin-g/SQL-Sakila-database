USE sakila;

-- Drop column picture from staff.
ALTER TABLE staff
DROP COLUMN picture;


-- A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
INSERT INTO sakila.staff (first_name, last_name, address_id, email, store_id, active, username)
SELECT first_name, last_name, address_id, email, store_id, active
FROM sakila.customer
WHERE first_name = 'TAMMY';

-- Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1
SELECT * FROM rental;

SELECT customer_id FROM sakila.customer
WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER';

SELECT staff_id FROM staff
WHERE first_name = 'Mike';

SELECT film_id FROM film
WHERE title = 'Academy Dinosaur';

SELECT inventory_id FROM inventory
WHERE film_id = 1 AND store_id = 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES
('2022-09-19', '1', '130', '1');

SELECT * FROM rental;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(i.inventory_id) AS no_copies
FROM film f
JOIN inventory i USING(film_id)
WHERE f.title = 'Hunchback Impossible';

-- List all films whose length is longer than the average of all the films.
SELECT title,length FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN (
		SELECT film_id FROM film WHERE title = 'Alone Trip'
	)
);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM Category;

SELECT title FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id IN (     
	SELECT category_id FROM category WHERE name = 'family')
    );

-- Get name and email from customers from Canada using subqueries. Do the same with joins
-- subquery:
SELECT CONCAT(first_name, ' ', last_name) AS customer, email
FROM customer
WHERE address_id IN (
	SELECT address_id FROM address
    WHERE city_id IN (
    SELECT city_id FROM city
    WHERE country_id IN(
    SELECT country_id FROM country WHERE country = 'Canada')
    ));
    
-- joins:
SELECT CONCAT(c.first_name, ' ', c.last_name) AS 'customer', c.email
FROM customer c
JOIN address a USING(address_id)
JOIN city ci USING(city_id)
JOIN country co USING(country_id)
WHERE co.country ='Canada';

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
SELECT a.actor_id, a.first_name, a.last_name, COUNT(a.actor_id) AS 'film_count'
FROM actor a
JOIN film_actor f
ON a.actor_id = f.actor_id 
GROUP BY actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;

SELECT title FROM film
WHERE film_id IN (
	SELECT film_id FROM film_actor WHERE actor_id = 107);

-- Films rented by most profitable customer.
SELECT customer_id, SUM(amount) AS 'total_amount'
FROM payment
WHERE customer_id IN (
	SELECT customer_id FROM customer)
GROUP BY customer_id
ORDER BY total_amount DESC;

SELECT title FROM film
WHERE film_id IN(
	SELECT film_id FROM inventory
WHERE inventory_id IN(
	SELECT inventory_id FROM rental
WHERE customer_id IN(
	SELECT customer_id FROM rental WHERE customer_id = 526)));

-- Customers who spent more than the average payments.
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS 'customer'
FROM customer
WHERE customer_id IN(
	SELECT customer_id FROM payment
    GROUP BY customer_id 
    HAVING AVG(amount) > (SELECT AVG(amount) FROM payment));

