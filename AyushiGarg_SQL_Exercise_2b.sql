--ACTOR TABLE
--1. Get first_name , last_name for actors
select first_name, 
last_name 
from actor;  

--2. Get first_name, last_name only 5 rows.
select first_name, 
last_name 
from actor 
LIMIT(5);

--3. Get first_name, last_name of 5 actors who have been modified last
select * 
from actor 
order by last_update 
desc limit 5;

--4. Get top 5 repeating last_names of actors.
SELECT last_name, 
COUNT(*) as count 
FROM actor 
GROUP BY last_name 
ORDER BY count 
DESC LIMIT 5;

--5. Get top 6 repeating first_name of actors.
SELECT first_name, 
COUNT(*) as count 
FROM actor 
GROUP BY first_name 
ORDER BY count 
DESC LIMIT 6;

--FILM TABLE

--6. Get count of films in table
select count(*) 
from film;

--7. What is average movie length (use length column)
SELECT AVG(length) as avg_length 
FROM film;

--8. Count of movies for each rating (use rating column)
SELECT rating, 
COUNT(title) AS count 
FROM film 
GROUP BY rating;

--9. Get list of horror movies
select fc.film_id, fc.category_id, f.title from film_category as fc 
RIGHT JOIN film as f 
ON fc.film_id=f.film_id 
RIGHT JOIN category as c 
ON fc.category_id=c.category_id WHERE c.name='Horror'; 

--10. Movies that contain CAT in title.
SELECT * 
FROM film 
WHERE title LIKE '%CAT%';

--CATEGORY

--11. How many movie categories are there?
select COUNT(*) 
FROM category;

--12. Are category names repeating ?
SELECT COUNT(*) as count 
FROM category 
GROUP BY name;

--COUNTRY & CITY

--13. how many countries and cities ?
select COUNT(*) 
from country;
select COUNT(*) 
from city;

--14. For each country get the list of cities.
select * 
from country as coun 
INNER JOIN city as cit 
ON coun.country_id =cit.country_id 
ORDER BY coun.country_id;

--CUSTOMER

--15. Get list of active customers
select * 
from customer 
where active=1;

--16. Do any customer share same emailID
SELECT * 
FROM customer 
WHERE email = 'your_email';

--17. List of customers with same lastname
SELECT * 
FROM customer 
WHERE last_name = 'your_last_name';

--FILM_CATEGORY

--18. Total movies that are categoried
select f.film_id, 
f.title, 
fc.category_id 
from film as f 
INNER JOIN film_category as fc 
ON f.film_id=fc.film_id;

--19. Total rows in inventory
select count(*) 
from inventory;

