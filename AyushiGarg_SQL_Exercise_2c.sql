--1. Find actors who acted in film "Lost Bird"
select fa.film_id, 
fa.actor_id,
f.title, 
a.first_name, 
a.last_name 
from film_actor as fa 
RIGHT JOIN film as f 
ON fa.film_id=f.film_id 
RIGHT JOIN actor as a 
ON fa.actor_id=a.actor_id 
WHERE title='Lost Bird';

--2. Find movies of "Sci-Fi" genre
select fc.film_id, 
fc.category_id, 
f.title from film_category as fc 
RIGHT JOIN film as f 
ON fc.film_id=f.film_id 
RIGHT JOIN category as c 
ON fc.category_id=c.category_id 
WHERE c.name='Sci-Fi'; 

--3. Find movies of actress 
	first_name: "PENELOPE"	
	last_name:"GUINESS"
select fa.actor_id, 
fa.film_id, f.title, 
a.first_name, a.last_name 
from film_actor as fa
RIGHT JOIN film as f 
ON fa.film_id=f.film_id 
RIGHT JOIN actor as a
ON fa.actor_id=a.actor_id 
WHERE a.first_name='PENELOPE' AND a.last_name='GUINESS';
 
--4. list Genres, movies (in each Genre), actors in each movie
select fc.film_id, 
fc.category_id, f.title 
from film_category as fc 
RIGHT JOIN film as f 
ON fc.film_id=f.film_id 
RIGHT JOIN category as c 
ON fc.category_id=c.category_id 
GROUP BY c.category_id;
select fa.actor_id, fa.film_id, 
f.title, a.first_name, a.last_name 
from film_actor as fa
RIGHT JOIN film as f 
ON fa.film_id=f.film_id 
RIGHT JOIN actor as a
ON fa.actor_id=a.actor_id;

--5. List films that are rented from inventory
select r.rental_id, 
r.inventory_id, 
i.film_id, 
f.title 
from rental as r 
RIGHT JOIN inventory as i 
ON r.inventory_id=i.inventory_id 
RIGHT JOIN film as f 
ON i.film_id=f.film_id;

--6. List genres corresponding movies rented by customer.
select r.rental_id, 
r.inventory_id, 
i.film_id, f.title, 
fc.category_id, c.name 
from rental as r 
RIGHT JOIN inventory as i 
ON r.inventory_id=i.inventory_id 
RIGHT JOIN film as f 
ON i.film_id=f.film_id 
RIGHT JOIN film_category as fc 
ON f.film_id=fc.film_id 
RIGHT JOIN category as c 
ON fc.category_id=c.category_id;

--7. List 5 rows of customer which have renated "Horror" generes.
select r.rental_id, 
r.inventory_id, 
i.film_id, 
f.title, 
fc.category_id, 
c.name from rental as r 
RIGHT JOIN inventory as i 
ON r.inventory_id=i.inventory_id 
RIGHT JOIN film as f 
ON i.film_id=f.film_id 
RIGHT JOIN film_category as fc 
ON f.film_id=fc.film_id 
RIGHT JOIN category as c 
ON fc.category_id=c.category_id 
WHERE c.name='Horror' 
LIMIT(5);

--8. List 5 staff members who have given maximum movies on rent (best performers)
select s.staff_id, 
s.first_name, 
s.last_name, 
r.rental_id, 
r.inventory_id, 
r.customer_id from staff as s 
RIGHT JOIN rental as r 
ON s.staff_id=r.staff_id 
RIGHT JOIN inventory as i 
ON r.inventory_id=i.inventory_id 
ORDER BY s.staff_id;

--9. List top movies types Genre (by count) rented by customers.
SELECT category.name, COUNT(*) AS rental_count
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film_category ON inventory.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY rental_count DESC
LIMIT 10;

--10. List top movies (by count) by Genre (by count) in the inventory.
SELECT c.name as genre, f.title as movie, COUNT(*) as count
FROM inventory i
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name, f.title
ORDER BY c.name, count DESC;

--11. List of actors who have not acted in any flim.
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

--12. List of films that are not in inventory
SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

--13. List of actors who are not in inventory
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id NOT IN (SELECT film_id FROM inventory);

--14. List of actors whose movies are not stores.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN store s ON i.store_id = s.store_id
WHERE s.store_id IS NULL;

--15. List of staff who have not rented movies.
SELECT DISTINCT s.*
FROM staff s
LEFT JOIN rental r ON s.staff_id = r.staff_id
WHERE r.rental_id IS NULL;

--16. categories which do not have movies.
SELECT c.*
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
WHERE f.film_id IS NULL;

--17. Actors who acted in all movie categories
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(DISTINCT c.category_id) = (SELECT COUNT(*) FROM category)

--18. Actors who did NOT act in all movie categories
SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT *
    FROM category c
    WHERE NOT EXISTS (
        SELECT *
        FROM film_category fc
        WHERE fc.category_id = c.category_id AND fc.film_id IN (
            SELECT fa.film_id
            FROM film_actor fa
            WHERE fa.actor_id = a.actor_id
        )
    )
);

--19. List of stores with address, city, countries.
SELECT s.store_id, a.address_id, a.address, c.city, co.country_id, co.country
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id;

--20. List of stores that do not have inventory.
SELECT s.*
FROM store s
LEFT JOIN inventory i ON s.store_id = i.store_id
WHERE i.inventory_id IS NULL;

--21. List of customers who do not have movie rentals.
SELECT customer.customer_id, customer.first_name, customer.last_name
FROM customer
LEFT JOIN rental ON customer.customer_id = rental.customer_id
WHERE rental.rental_id IS NULL;

--22. List of Customers in India with address.
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    a.address, 
    ct.city, 
    cy.country 
FROM 
    customer c 
    JOIN address a ON c.address_id = a.address_id 
    JOIN city ct ON a.city_id = ct.city_id 
    JOIN country cy ON ct.country_id = cy.country_id 
WHERE 
    cy.country = 'India';

--23. List of Customers with address all over the world.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    ci.city,
    co.country
FROM 
    customer c
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id

--24. List of movies made in Japanese or Mandarin.
SELECT film.film_id, film.title, film.language_id
FROM film
JOIN language ON film.language_id = language.language_id
WHERE language.name IN ('Japanese', 'Mandarin')

--25. List of languages with no movies.
SELECT name
FROM language
LEFT JOIN film ON language.language_id = film.language_id
WHERE film.language_id IS NULL;




