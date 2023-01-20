USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.
SELECT l.store_id, m1.city_id, m2.city, m2.country_id, r.country
FROM store as l
JOIN address as m1
ON l.address_id = m1.address_id
JOIN city as m2
ON m1.city_id = m2.city_id
JOIN country as r
ON m2.country_id = r.country_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.
SELECT r.store_id, sum(l.amount) AS total_amount
FROM payment as l
JOIN customer as r
ON l.customer_id = r.customer_id
GROUP BY r.store_id;

-- 3. Which film categories are longest?
SELECT l.name, AVG(r.length) AS avg_length
FROM category as l
JOIN film_category as m
ON l.category_id = m.category_id
JOIN film as r
ON m.film_id = r.film_id
GROUP BY l.name
ORDER BY avg_length DESC;

-- 4. Display the most frequently rented movies in descending order.
SELECT l.title, count(r.inventory_id) AS number_rentals
FROM film as l
JOIN inventory as m
ON l.film_id = m.film_id
JOIN rental as r
ON m.inventory_id = r.inventory_id
GROUP BY l.title
ORDER BY number_rentals DESC;

-- 5. List the top five genres in gross revenue in descending order.
SELECT l.name, sum(amount) AS revenue
FROM category as l
JOIN film_category as m1
ON l.category_id = m1.category_id
JOIN inventory as m2
ON m1.film_id = m2.film_id
JOIN rental as m3
ON m2.inventory_id = m3.inventory_id
JOIN payment as r
ON m3.rental_id = r.rental_id
GROUP BY l.name
ORDER BY revenue DESC
LIMIT 5;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?
SELECT l.title, count(r.rental_id)
FROM film as l
JOIN inventory as m
ON l.film_id = m.film_id
JOIN rental as r
ON m.inventory_id = r.inventory_id
WHERE title = 'ACADEMY DINOSAUR' AND store_id = 1 AND NOT return_date IS NULL;

-- 7. Get all pairs of actors that worked together.
SELECT l.actor_id as Actor_1, concat(r1.first_name, ' ', r1.last_name) AS '1st_Actor',
m.actor_id as Actor_2, concat(r2.first_name, ' ', r2.last_name) AS '2st_Actor'
FROM film_actor AS l
INNER JOIN film_actor AS m
ON l.actor_id < m.actor_id AND l.film_id = m.film_id
INNER JOIN actor AS r1
ON l.actor_id = r1.actor_id
INNER JOIN actor AS r2
ON m.actor_id = r2.actor_id
GROUP BY l.actor_id, m.actor_id
ORDER BY l.actor_id, m.actor_id;

-- 8. Get all pairs of customers that have rented the same film more than 3 times.
SELECT l.customer_id as C1, r.customer_id as C2,
count(l.rental_id)+count(r.rental_id) as rentals
FROM rental l
JOIN inventory m
ON l.inventory_id = m.inventory_ID
JOIN rental r
ON l.inventory_id = r.inventory_ID AND l.customer_id < r.customer_id
GROUP BY m.film_id, l.customer_id, r.customer_id
HAVING rentals > 3;

-- 9. For each film, list actor that has acted in more films.
SELECT count(distinct film_id) FROM film_actor;

SELECT l.film_id, l.actor_id, count(r.film_id) AS number_films,
ROW_NUMBER() OVER(PARTITION BY l.film_id ORDER BY count(r.film_id) DESC) AS row_num
FROM film_actor l
JOIN film_actor r
ON l.actor_id = r.actor_id
GROUP BY l.actor_id, l.film_id
ORDER BY row_num, l.film_id
LIMIT 997;