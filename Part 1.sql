USE sakila;

-- get all data from tables actor, film, customer
SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM customer;

-- Get film titles
SELECT title FROM film;

-- Get unique list of film languages
SELECT DISTINCT(name) AS language FROM language;

-- Find out how many stores does the company have
SELECT COUNT(store_id) AS 'number of stores' FROM store;

-- Find out how many employees staff does the company have
SELECT COUNT(staff_id) AS 'number of staff' FROM staff;

-- Return a list of employee first names only
SELECT first_name FROM staff;

-- Select all the actors with the first name ‘Scarlett’
SELECT first_name, last_name FROM actor
WHERE first_name = 'Scarlett';

-- How many films (movies) are available for rent and how many films have been rented?
SELECT COUNT(film_id) FROM inventory;
SELECT COUNT(rental_id) FROM rental;

-- What are the shortest and longest movie duration? Name the values max_duration and min_duration
SELECT MAX(length) AS 'max_duration' FROM film;
SELECT MIN(length) AS 'min_duration' FROM film;

-- What's the average movie duration expressed in format (hours, minutes)?
SELECT SEC_TO_TIME(AVG(LENGTH)) FROM film;

-- How many distinct (different) actors' last names are there?
SELECT COUNT(DISTINCT last_name) FROM actor;

-- Since how many days has the company been operating (check DATEDIFF() function)?
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date))
FROM rental;

-- Show rental info with additional columns month and weekday. Get 20 results.
SELECT *,
DATE_FORMAT((rental_date), '%M') AS month, 
DAYNAME(rental_date) 
From rental
LIMIT 20;

-- Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *,
DAYNAME(rental_date) AS day_of_the_week
FROM rental;

-- Get release years.
SELECT DISTINCT(release_year) FROM film;

-- Get all films with ARMAGEDDON in the title.
SELECT * FROM film
WHERE title LIKE '%ARMAGEDDON%';

-- Get all films which title ends with APOLLO.
SELECT * FROM film
WHERE title LIKE '%APOLLO';

-- Get 10 the longest films.
SELECT title FROM film
ORDER BY length DESC
LIMIT 10;

-- How many films include Behind the Scenes content?
SELECT COUNT(special_features) AS 'Behind the Scenes' FROM film
WHERE special_features LIKE '%Behind the Scenes%';
