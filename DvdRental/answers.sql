-- List each film's title and its category
SELECT
	film.title,
	category.name AS film_category
FROM
	film
JOIN
	film_category ON film.film_id = film_category.film_id
JOIN
	category ON category.category_id = film_category.category_id;

-- List each customer's name, last name, and the number of films they rented
SELECT
	customer.first_name AS name,
	customer.last_name AS last_name,
	COUNT(film.film_id) AS film_rent_count
FROM
	customer
JOIN
	rental ON customer.customer_id = rental.customer_id
JOIN
	inventory ON rental.inventory_id = inventory.inventory_id
JOIN
	film ON inventory.film_id = film.film_id
GROUP BY
	customer.customer_id, 
	customer.first_name, 
	customer.last_name
ORDER BY
	film_rent_count;

-- List customers who have not rented any films
SELECT
	customer.first_name,
	customer.last_name
FROM
	customer
LEFT JOIN
	rental ON rental.customer_id = customer.customer_id
WHERE
	rental.customer_id IS NULL;

-- How many films are in each category?
SELECT
	category.name AS category_name,
	COUNT(film_category.film_id) AS film_count
FROM
	category
JOIN
	film_category ON film_category.category_id = category.category_id
JOIN
	film ON film.film_id = film_category.film_id
GROUP BY
	category.category_id,
	category_name
ORDER BY
	film_count,
	category_name;

-- List categories with more than 10 films
SELECT
	category.name AS category_name,
	COUNT(film_category.film_id) AS film_count
FROM
	category
JOIN
	film_category ON film_category.category_id = category.category_id
JOIN
	film ON film.film_id = film_category.film_id
GROUP BY
	category.category_id,
	category_name
HAVING
	COUNT(film.film_id) > 10
ORDER BY
	film_count,
	category_name;

-- Find the number of films each actor has appeared in. Rank the top 5 actors
SELECT
	actor.first_name,
	actor.last_name,
	COUNT(film_actor.film_id) AS played_film_count
FROM
	actor
JOIN
	film_actor ON film_actor.actor_id = actor.actor_id
JOIN
	film ON film.film_id = film_actor.film_id
GROUP BY
	actor.actor_id
ORDER BY
	played_film_count;
	
-- Get the title of the longest film
SELECT
	film.title
FROM
	film
WHERE
	length = (SELECT MAX(length) FROM film);

-- List films longer than the average length
SELECT
	title
FROM
	film
WHERE
	length > (SELECT ROUND(AVG(length)) FROM film);

-- List films longer than the average length in their own category
SELECT
	f.title,
	f.length
FROM
	film f
JOIN
	film_category fc ON f.film_id = fc.film_id
JOIN
	category c ON c.category_id = fc.category_id
WHERE
	f.length > (
		SELECT
			AVG(f2.length)
		FROM
			film f2
		JOIN
			film_category fc2 ON fc2.film_id = f2.film_id
		WHERE
			fc2.category_id = c.category_id
	)
ORDER BY
	f.length;

-- Show the number of rentals made in each month (Group by year and month)
SELECT
	DATE_TRUNC('year', rental.rental_date) AS year,
	DATE_TRUNC('month', rental.rental_date) AS month,
	COUNT(rental.rental_id) AS rental_count
FROM
	rental
GROUP BY
	DATE_TRUNC('year', rental.rental_date),
	DATE_TRUNC('month', rental.rental_date)
ORDER BY
	rental_count;

-- List transactions where the rental duration was more than 5 days
SELECT
	rental.rental_id
FROM
	rental
WHERE
	return_date > rental_date + INTERVAL '5 years';

-- Rank films in each category by length and show the rank number
SELECT
	ROW_NUMBER() OVER (ORDER BY film.length) AS row_no,
	film.title,
	film.length
FROM
	film
JOIN
	film_category ON film_category.film_id = film.film_id
JOIN
	category ON film_category.category_id = category.category_id
ORDER BY
	film.length;
	
-- Create a column showing the average of the last 5 payments
SELECT
	ROUND(AVG(amount)) AS average_of_last_5_payment
FROM (
		SELECT
			amount,
			payment_date,
			payment_id
		FROM
			payment
		ORDER BY
			payment_date DESC
		LIMIT 5
	) AS last_5_payments;

-- Show each customer's total payment, total number of rentals, and average rental amount
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	SUM(p.amount) AS total_payment,
	COUNT(DISTINCT r.rental_id) AS total_rent_count,
	ROUND(SUM(p.amount) / COUNT(DISTINCT r.rental_id), 2) AS average_rent_price
FROM
	customer c
JOIN
	rental r ON r.customer_id = c.customer_id
JOIN
	payment p ON p.rental_id = r.rental_id
GROUP BY
	c.customer_id,
	c.first_name,
	c.last_name
ORDER BY
	total_payment DESC;

-- Rank the top 10 customers with the highest total payments
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	SUM(p.amount) AS total_payment
FROM
	customer c
JOIN
	payment p ON p.customer_id = c.customer_id
GROUP BY
	c.customer_id,
	c.first_name,
	c.last_name
ORDER BY
	total_payment DESC
LIMIT 10;

-- Find the highest-grossing film in each category
SELECT
	c.name,
	f.title,
	SUM(p.amount) AS toplam_kazanc
FROM
	film f
JOIN
	inventory i ON i.film_id = f.film_id
JOIN
	rental r ON r.inventory_id = i.inventory_id
JOIN
	payment p ON p.rental_id = r.rental_id
JOIN
	film_category fc ON fc.film_id = f.film_id
JOIN
	category c ON c.category_id = fc.category_id
GROUP BY
	c.name,
	c.category_id,
	f.title
HAVING
	SUM(p.amount) = (
		SELECT
			MAX(toplam_kazanc)
		FROM (
			SELECT
				c2.category_id,
				SUM(p2.amount) AS toplam_kazanc
			FROM
				film f2
			JOIN
				inventory i2 ON i2.film_id = f2.film_id
			JOIN
				rental r2 ON r2.inventory_id = i2.inventory_id
			JOIN
				payment p2 ON p2.rental_id = r2.rental_id
			JOIN
				film_category fc2 ON fc2.film_id = f2.film_id
			JOIN
				category c2 ON c2.category_id = fc2.category_id
			WHERE
				fc2.category_id = c.category_id
			GROUP BY
				c2.category_id,
				f2.title
				
		) AS kazanc_alt
	)
ORDER BY
	c.name;

-- Show the number of rentals and total payments made by customers living in each city
SELECT
	city.city,
	COUNT(r.rental_id) AS rent_count,
	SUM(p.amount) AS total_payment_amount
FROM
	city
JOIN
	address a ON a.city_id = city.city_id
JOIN
	customer c ON c.address_id = a.address_id
JOIN
	rental r ON r.customer_id = c.customer_id
JOIN
	payment p ON p.rental_id = r.rental_id
GROUP BY
	city.city;

-- Sort the results from the city with the highest payment to the lowest
SELECT
	city.city,
	SUM(p.amount) AS total_payment
FROM
	city
JOIN
	address a ON a.city_id = city.city_id
JOIN
	customer c ON c.address_id = a.address_id
JOIN
	payment p ON p.customer_id = c.customer_id
GROUP BY
	city.city
ORDER BY
	total_payment DESC;