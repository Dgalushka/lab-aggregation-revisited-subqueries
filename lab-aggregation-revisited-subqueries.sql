use sakila;

-- 1. Select the first name, last name, and email address of all the customers who have rented a movie
 
-- SELECT first_name, last_name, email
-- FROM SAKILA.RENTAL R
-- JOIN SAKILA.CUSTOMER C USING (customer_id)
-- GROUP BY customer_id
-- ORDER BY customer_id asc;

SELECT first_name, last_name, email 
FROM sakila.customer;

-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT customer_id, concat(first_name, ' ', last_name) customer_name, round(avg(amount),2) average_payment
FROM sakila.payment p
JOIN sakila.customer c 
USING (customer_id)
GROUP BY customer_id
ORDER BY average_payment desc;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies.
# Write the query using multiple join statements
# Write the query using sub queries with multiple WHERE clause and IN condition
# Verify if the above two queries produce the same results or not

SELECT concat(first_name, ' ', last_name) customer_name, email
FROM sakila.category cat
JOIN sakila.film_category fc USING (category_id)
JOIN sakila.film f USING (film_id)
JOIN sakila.inventory i USING (film_id)
JOIN sakila.rental r USING (inventory_id)
JOIN sakila.customer cust USING (customer_id)
WHERE cat.name = "Action"
GROUP BY customer_id;

-- now, using subqueries


SELECT concat(first_name, ' ', last_name) customer_name, email
FROM sakila.customer
WHERE customer_id IN (
	SELECT customer_id FROM sakila.rental
    WHERE inventory_id IN (
		SELECT inventory_id FROM sakila.inventory
        WHERE film_id IN (
			SELECT film_id FROM sakila.film
            WHERE film_id IN (
				SELECT film_id FROM sakila.film_category
                WHERE category_id = (
					SELECT category_id FROM sakila.category
                    WHERE name = "Action"
                    )
				)
			)
		)
	);
    
-- above 2 queries produce indeed the same resault, but I would not be able to select some other columns from tables that I used for subqueries, unlike with JOINS.

-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, 
-- and if it is more than 4, then it should be high.

SELECT customer_id, concat(first_name, ' ', last_name) customer_name, amount payment_amount, 
CASE 
	WHEN amount <=2 THEN "low"
    WHEN amount >2 and amount <= 4 THEN "medium"
    WHEN amount >4 THEN "high"
END as payment_classification
FROM sakila.payment p
JOIN sakila.customer c 
USING (customer_id);
