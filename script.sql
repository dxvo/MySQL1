
USE sakila;

#1a
-- Display the first and last names of all actors from the table actor
SELECT first_name, last_name 
FROM actor; 

#1b
-- Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name,' ', last_name)) AS  'Actor Name'
FROM actor; 

#2a. 
-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor 
WHERE first_name = 'Joe'; 

#2b 
-- Find all actors whose last name contain the letters GEN:
SELECT * 
FROM actor 
WHERE last_name LIKE '%GEN%'; 

#2c. 
-- Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order.
SELECT *
FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name; 

#2d. 
-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China'); 

#3a 
-- You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, so create a column in the table actor named description
-- and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN description BLOB; 

#3b. 
-- Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor 
DROP COLUMN description; 

#4a. 
-- List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) 
FROM actor
GROUP BY last_name; 

#4b. 
-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS 'count'
FROM actor
GROUP BY last_name
HAVING count >= 2;

#4c. 
-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record
UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'; 


#4d. 
-- Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET first_name = 'GROUCHO' 
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS'; 


#5a. 
-- You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
CREATE TABLE IF NOT EXISTS address (
 address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
 address varchar(50) NOT NULL,
 address2 varchar(50) DEFAULT NULL,
 district varchar(20) NOT NULL,
 city_id smallint(5) unsigned NOT NULL,
 postal_code varchar(10) DEFAULT NULL,
 phone varchar(20) NOT NULL,
 location geometry NOT NULL,
 last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (address_id),
 KEY idx_fk_city_id (city_id),
 SPATIAL KEY idx_location (location),
 CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;


#6a 
-- Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT staff.first_name , staff.last_name , address.address 
FROM staff 
JOIN address 
ON staff.address_id = address.address_id; 


#6b. 
-- Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT staff.first_name , staff.last_name, SUM(payment.amount)
FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id
WHERE payment.payment_date  LIKE '2005-08%'
GROUP BY staff.staff_id; 


#6c. 
-- List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id)
FROM film 
INNER JOIN film_actor 
ON film.film_id = film_actor.film_id
GROUP BY film.title; 

#6d. 
-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT F.title, COUNT(I.inventory_id) 
FROM inventory I
INNER JOIN film F
ON F.film_id  = I.film_id
WHERE F.title = 'Hunchback Impossible';


#6e
-- Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
SELECT C.first_name, C.last_name, SUM(P.amount) 
FROM customer C
INNER JOIN payment P
ON P.customer_id = C.customer_id
GROUP BY P.customer_id
ORDER BY last_name; 


#7a. 
-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT film.title
FROM film 
WHERE  ((title LIKE 'K%' ) OR (title LIKE 'Q%' )) AND language_id IN 
(
    SELECT language_id
    FROM language
    WHERE name = 'English'
); 


#7b
-- Use subqueries to display all actors who appear in the film Alone Trip.
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
        WHERE title = 'Alone Trip'));


#7c. 
-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

SELECT CONCAT(first_name, '  ' , last_name) AS 'Name', email
FROM customer
WHERE address_id IN 
(
        SELECT address_id
        FROM address
        WHERE city_id IN
        (
            SELECT city_id
            FROM city
            WHERE country_id IN 
        
            (
                SELECT country_id
                FROM country
                WHERE country = 'Canada'))); 



#7d
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films. 
SELECT  film.title
FROM film 
INNER JOIN film_list  -- film list is one of VIEWS 
ON film.title = film_list.title
WHERE film_list.category = 'Family'; 

#7e. 
-- Display the most frequently rented movies in descending order.
SELECT F.title, COUNT(rental_id) AS 'Total_Rental_Count'
FROM film F
    JOIN inventory I ON F.film_id = I.film_id
    JOIN rental R ON I.inventory_id = R.inventory_id
GROUP BY F.title
ORDER BY `Total_Rental_Count` DESC; 
    










