USE mavenmovies;
-- Multiple Table Analysis
-- Final Course Project

/*List of store managers' name at each store with full address of each property(street address, district, city and country*/
SELECT staff.first_name, 
	staff.last_name, 
    address, 
    district, 
    city, 
    country
FROM store
LEFT JOIN staff 
	ON store.manager_staff_id = staff.staff_id
LEFT JOIN address 
	ON store.address_id = address.address_id
LEFT JOIN city 
	ON address.city_id = city.city_id
LEFT JOIN country 
	ON country.country_id = city.country_id;

/*List of each inventory item you have stocked including store_id, inventory_id, name of film, 
film rating, its rental rate and replacement cost*/
SELECT store_id, inventory_id, 
	title AS name_of_title, 
	rating AS film_rating, 
    rental_rate, replacement_cost
FROM inventory
LEFT JOIN film 
	ON inventory.film_id = film.film_id;

/* Count of all items with each rating at each store*/
SELECT inventory.store_id,rating, 
	COUNT(inventory_id) AS  inventory_items
FROM inventory
LEFT JOIN film 
	ON inventory.film_id = film.film_id
GROUP BY inventory.store_id, rating;

/*List of number of films, avg replacement cost, total replacement cost sliced by store and film category*/
SELECT inventory.store_id, category.name AS category_name, 
	COUNT(inventory.film_id) AS number_of_films, 
	AVG(replacement_cost) AS Avg_replacement_cost, 
	SUM(replacement_cost) AS total_replacement_cost
FROM inventory
LEFT JOIN film 
	ON inventory.film_id = film.film_id
LEFT JOIN film_category 
	ON inventory.film_id = film_category.film_id
LEFT JOIN category 
	ON category.category_id = film_category.category_id
GROUP BY inventory.store_id, category.name;

/* List of all customer names, which store they go to, whether or not they are active, 
their full addresses - street address, city and counrtry */
SELECT first_name, last_name, customer.store_id, active, 
	address AS street_address, 
    city,country
FROM customer
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id;

/* List of customer names, their total lifetime rentals, sum of all the payments collected from them*/
SELECT first_name, last_name, 
	COUNT(rental.rental_id) AS total_lifetime_rentals, 
    SUM(amount) AS total_payments_collected
FROM customer
LEFT JOIN rental
	ON customer.customer_id = rental.customer_id
LEFT JOIN payment
	ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name,customer.last_name
ORDER BY  SUM(amount) DESC;

/*List of investors and advisors combined in one table. Alongwith a label stating whether they are investor or advisor 
and also name of the company of investors are part of*/
SELECT first_name, last_name, 'Investor', company_name
FROM investor
UNION
SELECT first_name, last_name, 'Advisor', NULL
FROM advisor;

/*We are interested in how well you have covered the most awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
and how about actors with two awrds and same questions. Finally how about actors with just one award*/
SELECT 
CASE WHEN actor_award.awards = 'Emmy, Oscar, Tony' THEN '3 awards'
 WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy,Tony', 'Oscar, Tony') THEN '2 awards'
 ELSE '1 award'
 END AS number_of_awards,
 AVG (CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS percentage_with_one_film
 FROM actor_award
 GROUP BY 
 CASE WHEN actor_award.awards = 'Emmy, Oscar, Tony' THEN '3 awards'
 WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy,Tony', 'Oscar, Tony') THEN '2 awards'
 ELSE '1 award'
 END;


