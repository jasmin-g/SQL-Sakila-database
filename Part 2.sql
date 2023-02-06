USE sakila;

-- Which are the actors whose last names are not repeated?
SELECT last_name FROM actor 
GROUP BY last_name HAVING COUNT(last_name) = 1;

-- Which last names appear more than once?
SELECT last_name FROM actor 
GROUP BY last_name HAVING COUNT(last_name) > 1;

-- how many rentals were processed by each employee
SELECT staff_id, COUNT(rental_id) AS transactions FROM rental
GROUP BY staff_id HAVING transactions;

-- how many films were released each year
SELECT release_year, COUNT(film_id)FROM film
GROUP BY release_year;

-- Using the film table, find out for each rating how many films were there
SELECT rating, COUNT(film_id) AS film_amount  FROM film
GROUP BY rating HAVING film_amount;

-- What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
SELECT rating, ROUND(AVG(length),2) as avg_length FROM film
GROUP BY rating HAVING avg_length;

-- Which kind of movies (rating) have a mean duration of more than two hours?
SELECT rating, ROUND(AVG(length),2) as avg_length FROM film
GROUP BY rating HAVING avg_length > 120;

-- Rank films by length (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, and the rank.
SELECT title, length, 
RANK() OVER (ORDER BY length DESC) AS my_rank
FROM film
WHERE (length IS NOT NULL) AND (length > 0);

-- How many films are there for each of the categories in the category table
SELECT c.name, c.category_id, COUNT(f.film_id)
FROM film_category f
JOIN category c
ON f.category_id = c.category_id
GROUP BY c.name, c.category_id
ORDER BY c.category_id ASC;

-- Display the total amount rung up by each staff member in August of 2005.
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'Total Amount'
FROM payment p
JOIN staff s
ON p.staff_id = s.staff_id
WHERE payment_date LIKE '2005-08%'
GROUP BY p.staff_id;

-- Which actor has appeared in the most films?
SELECT a.actor_id, a.first_name, a.last_name, COUNT(a.actor_id) AS 'film_count'
FROM actor a
JOIN film_actor f
ON a.actor_id = f.actor_id 
GROUP BY actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;

-- Most active customer (the customer that has rented the most number of films)
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS 'customer', COUNT(c.customer_id) AS 'total_rentals'
FROM customer c
JOIN rental r USING (customer_id)
GROUP BY c.customer_id
ORDER BY total_rentals DESC
LIMIT 1;

-- Display the first and last names, as well as the address, of each staff member.
SELECT CONCAT(s.first_name, ' ', s.last_name) AS 'staff name', a.address, a.district, a.postal_code
FROM staff s
JOIN address a USING (address_id);

-- List each film and the number of actors who are listed for that film.
SELECT f.title, COUNT(fa.actor_id) AS 'number_of_actors'
FROM film f
LEFT JOIN film_actor fa USING (film_id)
GROUP BY f.title
ORDER BY number_of_actors DESC;

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
SELECT SUM(p.amount) AS 'total paid', CONCAT(c.first_name, ' ', c.last_name) AS 'customer_name'
FROM payment p
JOIN customer c USING(customer_id)
GROUP BY customer_id
ORDER BY customer_name ASC;

-- Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a USING(address_id)
JOIN city c USING (city_id)
JOIN country co USING(country_id);

-- Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount)
FROM payment p
JOIN staff s USING(staff_id)
JOIN store st USING(store_id)
GROUP BY s.store_id;

-- Which film categories are longest?
SELECT c.name, AVG(f.length) AS 'movie_length'
FROM category c
JOIN film_category fc USING(category_id)
JOIN film f USING(film_id)
GROUP BY c.name
ORDER BY movie_length DESC;

-- Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.inventory_id) AS 'number_rented'
FROM rental r
JOIN inventory i USING(inventory_id)
JOIN film f USING(film_id)
GROUP BY f.title
ORDER BY number_rented DESC
LIMIT 10;

-- List the top five genres in gross revenue in descending order.
SELECT c.name, SUM(p.amount) AS 'gross_revenue'
FROM category c 
JOIN film_category fc USING(category_id)
JOIN inventory i USING(film_id)
JOIN rental r USING(inventory_id)
JOIN payment p USING(rental_id)
GROUP BY c.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
SELECT f.title, i.store_id
FROM film f
JOIN inventory i USING(film_id)
WHERE f.title = "Academy Dinosaur" AND i.store_id = 1;