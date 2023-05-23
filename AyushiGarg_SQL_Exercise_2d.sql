--1. Count of movies acted by actor with actor list in descending order (by count of movies acted).
SELECT actor.actor_id, CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, COUNT(DISTINCT film.film_id) AS movie_count
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
GROUP BY actor.actor_id
ORDER BY movie_count DESC;

--3. Count of movies per language
SELECT l.name AS language, COUNT(*) AS movie_count
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

--4. Movie collection by stores 

--4.1 How many movies of same film are stored in each store
SELECT s.store_id, f.title, COUNT(*) as num_copies
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN film f ON i.film_id = f.film_id
GROUP BY s.store_id, f.title

--4.2 How many unique movies in each store.
SELECT s.store_id, COUNT(DISTINCT i.film_id) AS unique_movies
FROM store s
INNER JOIN inventory i ON s.store_id = i.store_id
GROUP BY s.store_id;

--5. Average length of movies.
SELECT AVG(length) AS avg_length
FROM film;

--6. Which language movies are longest
SELECT language.name, film.title, film.length
FROM film
INNER JOIN language
ON film.language_id = language.language_id
ORDER BY film.length DESC;

--7. Which language movies have highest rating
SELECT DISTINCT language.name
FROM film
JOIN language ON film.language_id = language.language_id
WHERE film.rating = (
    SELECT MAX(rating)
    FROM film)

--8. Count of movies by category
SELECT c.name AS category_name, COUNT(*) AS movie_count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

--9. Top 3 actors who worked in horror movies
SELECT actor.first_name, actor.last_name, COUNT(*) as num_horror_movies
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film_category ON film_actor.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
JOIN film ON film_category.film_id = film.film_id
WHERE category.name = 'Horror'
GROUP BY actor.actor_id
ORDER BY num_horror_movies DESC
LIMIT 3;

--10. Top 3 actors who acted in action or romantic movies.
SELECT actor.first_name, actor.last_name, COUNT(*) AS num_movies
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name IN ('Action', 'Romance')
GROUP BY actor.actor_id
ORDER BY num_movies DESC
LIMIT 3;

--11. Count of movies rented by Country
SELECT c.country_id, COUNT(*) AS movie_count
FROM country c
JOIN city ct ON c.country_id = ct.country_id
JOIN address a ON ct.city_id = a.city_id
JOIN store s ON a.address_id = s.address_id
JOIN inventory i ON s.store_id = i.store_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY c.country_id;

--12. Top 3 film renting customers in each city of every country.
select first_name,last_name,city ,country,
customer.customer_id,count(customer.customer_id) from film
join inventory
on film.film_id=inventory.inventory_id
join rental
on rental.inventory_id=inventory.inventory_id
join customer 
on customer.customer_id=rental.customer_id
join address
on address.address_id=customer.address_id
join city c
on address.city_id=c.city_id
join country co
on co.country_id=c.country_id
group by first_name,last_name,city ,country,
customer.customer_id
order by count(customer.customer_id) desc
limit 3;

--13. Number of employees in each store
SELECT s.store_id, COUNT(st.staff_id) AS num_employees
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN address a ON s.address_id = a.address_id
GROUP BY s.store_id;

--14. Min, Max, average, 90 percentile of rental amount paid by customers in each country.
	Paraphrashing, which country provides more early opportunity.
select rental.customer_id,amount,count(rental.customer_id),
(amount * count(rental.customer_id)) as payable,city,country
from rental
join payment
on rental.rental_id=payment.rental_id
join customer 
on customer.customer_id=rental.customer_id
join address
on address.address_id=customer.address_id
join city c
on address.city_id=c.city_id
join country co
on co.country_id=c.country_id
group by rental.customer_id,amount,city,country
order by payable asc;

--15. Which employee has rented move movies and what is earning amount per film.
SELECT staff.staff_id, COUNT(rental.rental_id) AS num_rentals, SUM(payment.amount)/COUNT(rental.rental_id) AS earning_per_film
FROM staff
JOIN payment ON payment.staff_id = staff.staff_id
JOIN rental ON rental.rental_id = payment.rental_id
GROUP BY staff.staff_id
ORDER BY num_rentals DESC
LIMIT 1;

