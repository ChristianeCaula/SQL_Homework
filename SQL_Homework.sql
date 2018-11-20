USE sakila;

# 1a.
SELECT first_name, last_name
  FROM actor;

# 1b.
SELECT UPPER(CONCAT(FIRST_NAME, ' ', LAST_NAME)) AS 'Actor Name' 
  FROM actor;

# 2a.
SELECT actor_id, first_name, last_name 
  FROM actor
 WHERE first_name = "Joe";
 
# 2b.
SELECT actor_id, first_name, last_name 
  FROM actor
 WHERE last_name LIKE "%GEN%";
 
# 2c.
SELECT actor_id, first_name, last_name 
  FROM actor
 WHERE last_name LIKE "%LI%"
 ORDER BY last_name, first_name;

# 2d.
SELECT country_id, country 
  FROM country
 WHERE country IN ("Afghanistan", "Bangladesh", "China"); 

# 3a.
ALTER TABLE actor
  ADD COLUMN description blob;

# 3b.
ALTER TABLE actor
 DROP description;
    
# 4a.
SELECT last_name, 
 COUNT(last_name) as 'count lastname'
  FROM actor 
 GROUP BY last_name;
 
# 4b.
SELECT last_name, 
 COUNT(last_name) as 'count lastname'
  FROM actor
 GROUP BY last_name
HAVING COUNT(last_name) >=2;

# 4c.
SELECT * 
  FROM actor
 WHERE last_name = 'WILLIAMS';

UPDATE actor
   SET first_name = 'HARPO'
 WHERE first_name = 'GROUCHO' 
   AND last_name = 'WILLIAMS';

SELECT * 
  FROM actor
 WHERE last_name = 'WILLIAMS';

# 4d.
UPDATE actor
   SET first_name = 'GROUCHO'
 WHERE first_name = 'HARPO' 
   AND last_name = 'WILLIAMS';

SELECT * 
  FROM actor 
 WHERE first_name = 'GROUCHO';

# 5a.
SHOW CREATE TABLE address;

CREATE TABLE address (
  address_id SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT(5) UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  location GEOMETRY NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (address_id),
  KEY idx_fk_city_id (city_id),
  SPATIAL KEY idx_locatiON (locatiON),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE
)ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

# 6a.
SELECT first_name, last_name, address, address2, district, postal_code 
  FROM staff
  JOIN address 
    ON staff.address_id = address.address_id;

# 6b.
SELECT username, SUM(amount) 
  FROM staff
  JOIN payment 
    ON staff.staff_id=payment.staff_id 	
 WHERE payment_date BETWEEN '2005-08-01 00:00:00' and '2005-09-01 00:00:00' 
 GROUP BY username;
 
# 6c.
SELECT title, COUNT(*) AS 'number of actors' 
  FROM film
  JOIN film_actor 
    ON film.film_id = film_actor.film_id
 GROUP BY title;

# 6d.
SELECT title, COUNT(inventory_id) 
  FROM inventory 
  JOIN film  
    ON inventory.film_id=film.film_id
 WHERE title = 'HUNCHBACK IMPOSSIBLE'
 GROUP BY title;
 
# 6e.
SELECT first_name, last_name, SUM(amount) 
  FROM customer 
  JOIN payment 
    ON customer.customer_id=payment.customer_id
 GROUP BY first_name, last_name
 ORDER BY last_name;

# 7a.
SELECT title
FROM film
WHERE title LIKE "K%" OR title LIKE "Q%"
AND language_id IN
(
	SELECT language_id
      FROM language
     WHERE name = "English"
);

# Comparing results
SELECT film.title
  FROM film
 INNER JOIN language 
    ON film.language_id = language.language_id
 WHERE film.title LIKE "K%" OR title LIKE "Q%"
   AND language.name = "English";

# 7b.
SELECT first_name, last_name
  FROM actor
 WHERE actor_id IN
(
	SELECT actor_id
	  FROM film_actor
	 WHERE film_id IN
	(
		SELECT film_id
		  FROM film
		 WHERE title ='ALONE TRIP' 
	)
);

# Comparing results
SELECT title, first_name, last_name 
  FROM actor 
  JOIN film_actor
    ON actor.actor_id = film_actor.actor_id
  JOIN film 
    ON film_actor.film_id=film.film_id
 WHERE title ='ALONE TRIP';

# 7c.
SELECT first_name, last_name, email 
  FROM customer 
  JOIN address 
    ON customer.address_id=address.address_id
  JOIN city 
    ON address.city_id=city.city_id
  JOIN country 
    ON city.country_id=country.country_id
 WHERE country='CANADA';

# 7d.
SELECT title, name AS genre 
  FROM film_category
  JOIN category 
    ON category.category_id=film_category.category_id
  JOIN film 
    ON film.film_id=film_category.film_id
 WHERE name='FAMILY';

# 7e.
SELECT title, COUNT(*) AS 'rental numbers' 
  FROM payment
  JOIN rental 
    ON payment.rental_id=rental.rental_id
  JOIN inventory 
    ON rental.inventory_id=inventory.inventory_id
  JOIN film 
    ON inventory.film_id=film.film_id
 GROUP BY title
 ORDER BY COUNT(*) DESC;
    
# 7f.
SELECT store_id, CONCAT('$',FORMAT(SUM(amount),2)) AS USD 
  FROM staff 
  JOIN payment 
    ON staff.staff_id=payment.staff_id
 GROUP BY store_id;

# 7g.
SELECT store_id, city, country 
  FROM staff
  JOIN address 
    ON staff.address_id=address.address_id
  JOIN city 
    ON address.city_id=city.city_id
  JOIN country 
    ON city.country_id=country.country_id;
    
# 7h.
SELECT name AS genre, CONCAT('$',FORMAT(SUM(amount),2)) AS 'gross revenue' 
  FROM category
  JOIN film_category 
    ON category.category_id=film_category.category_id
  JOIN inventory 
    ON film_category.film_id=inventory.film_id
  JOIN rental 
    ON inventory.inventory_id=rental.inventory_id
  JOIN payment 
    ON rental.rental_id=payment.rental_id
 GROUP BY Genre
 ORDER BY SUM(amount) DESC
 LIMIT 5;

# 8a.
CREATE VIEW TOP_5_GENRES AS(
SELECT name AS genre, CONCAT('$',FORMAT(SUM(amount),2)) AS 'gross revenue' 
  FROM category
  JOIN film_category 
    ON category.category_id=film_category.category_id
  JOIN inventory 
    ON film_category.film_id=inventory.film_id
  JOIN rental 
    ON inventory.inventory_id=rental.inventory_id
  JOIN payment 
    ON rental.rental_id=payment.rental_id
 GROUP BY Genre
 ORDER BY SUM(amount) DESC
 LIMIT 5
    );

# 8b.
SELECT * 
  FROM TOP_5_GENRES; 

# 8c.
DROP VIEW TOP_5_GENRES;