/*
Challenge

Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information 
about customers in the Sakila database, including their rental history and payment details. 
The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, 
and total number of rentals (rental_count).
*/

create view rental_info_view as
select c.customer_id, c.last_name, c.first_name, c.email, 
(select count(*) from rental r
where c.customer_id = r.customer_id) as total_rentals from customer c;

/*
Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table
 and calculate the total amount paid by each customer.
*/
drop table total_amount_paid;
create temporary table total_amount_paid as
select p.customer_id, sum(amount) as total_amount
from payment p
inner join rental_info_view rif
on p.customer_id = rif.customer_id
group by p.customer_id;

/* 
Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table 
created in Step 2. The CTE should include the customer's name, email address, rental count, 
and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, which should include: 
customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived 
column from total_paid and rental_count.
*/

WITH
  cte1 AS (SELECT rif.last_name, rif.first_name, rif.email, rif.total_rentals FROM rental_info_view rif),
  cte2 AS (SELECT tap.total_amount, tap.average_payment_per_rental FROM total_amount_paid tap)
SELECT * -- rif.last_name, rif.first_name, rif.email, rif.total_rentals,
		 tap.total_amount, tap.average_payment_per_rental
FROM cte1 JOIN cte2
WHERE cte1.customer_id = cte2.customer_id;
