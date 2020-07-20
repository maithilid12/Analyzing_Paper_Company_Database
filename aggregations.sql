/* Queries using SUM */

/* Total amount of poster_qty paper ordered */
SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;

/* Total amount of standard_qty paper ordered */
SELECT SUM(standard_qty) AS total_standard_sales
FROM orders;

/* Total dollar amount of sales using the total_amt_usd */
SELECT SUM(total_amt_usd) AS total_dollar_sales
FROM orders;

/* Total amount for each individual order that was spent on standard and
gloss paper in the orders table. ( dollar amount for each order in the table) */
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

/* Though the price/standard_qty paper varies from one order to the next.
I would like this ratio across all of the sales made in the orders table.*/
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

/* Queries using MIN, MAX, AVG */

When was the earliest order ever placed?
SELECT MIN(occurred_at)
FROM orders;

/* without using an aggregation function: */
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

/* When did the most recent (latest) web_event occur? */
SELECT MAX(occurred_at)
FROM web_events;

/* without using an aggregation function: */
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

/* Mean (AVERAGE) amount spent per order on each paper type, as well as the
mean amount of each paper type purchased per order. */
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss,
       AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd,
       AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

/* What is the MEDIAN total_usd spent on all orders? */
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
/* Since there are 6912 orders - we want the average of the 3457 and 3456 order
amounts when ordered. This is the average of 2483.16 and 2482.55. This gives
the median of 2482.855. This obviously isn't an ideal way to compute. If we
obtain new orders, we would have to change the limit. */

/* Queries using GROUP BY */

/* Which account (by name) placed the earliest order? */
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

/* Total sales in usd for each account. */
SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

/* Via what channel did the most recent (latest) web_event occur,
which account was associated with this web_event? */
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

/* Total number of times each type of channel from the web_events was used. */
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel

/* Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc */
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

/* What was the smallest order placed by each account in terms of total usd.
SELECT a.name, MIN(total_amt_usd) smallest_order */
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;
/* Sort of strange we have a bunch of orders with no dollars.
We might want to look into those. */

/* Number of sales reps in each region.*/
SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

/* Determine the average amount of each type of paper they purchased
across orders for each account. */
SELECT a.name, AVG(o.standard_qty) avg_stand, AVG(o.gloss_qty) avg_gloss,
               AVG(o.poster_qty) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/* Determine the average amount spent per order on
each paper type for each account. */
SELECT a.name, AVG(o.standard_amt_usd) avg_stand, AVG(o.gloss_amt_usd) avg_gloss,
               AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/* Determine the number of times a particular channel was used in the web_events
table for each sales rep. Ordering by the highest number of occurrences first. */
SELECT s.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;

/* Determine the number of times a particular channel was used in the web_events
table for each region. Ordering by the highest number of occurrences first. */
SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;

/* Queries using DISTINCT */

/* Are any accounts associated with more than one region? */

/*The below two queries have the same number of resulting rows (351), so we know
that every account is associated with only one region. If each account was
associated with more than one region, the first query should have returned */
more rows than the second query.

SELECT a.id as "account id", r.id as "region id",
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

/* and */
SELECT DISTINCT id, name
FROM accounts;

/* Have any sales reps worked on more than one account? */

/*Actually all of the sales reps have worked on more than one account. The
fewest number of accounts any sales rep works on is 3. There are 50 sales reps,
and they all have more than one account. Using DISTINCT in the second query
assures that all of the sales reps are accounted for in the first query. */

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

/* and */
SELECT DISTINCT id, name
FROM sales_reps;

/* Queries using HAVING */

/* How many of the sales reps have more than 5 accounts that they manage? */

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

/* and the same using a SUBQUERY */

SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;

/* How many accounts have more than 20 orders? */
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

/* Which account has the most orders? */
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

/* How many accounts spent more than 30,000 usd total across all orders? */
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

/* How many accounts spent less than 1,000 usd total across all orders? */
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

/* Which account has spent the most with us? */
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

/* Which account has spent the least with us? */
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

/* Which accounts used facebook as a channel to contact customers more than 6 times? */
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

/* Which account used facebook most as a channel? */
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

/* Which channel was most frequently used by most accounts? */
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;
/* All of the top 10 are direct. */

/* queries using DATE function */
/* Sales in terms of total dollars for all orders in each year,
ordered from greatest to least. */
 SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;
/* When looking at the yearly totals, I noticed that 2013 and 2017 have much
smaller totals than all other years. Looking further at the monthly data,
for 2013 and 2017 there is only one month of sales for each of these years
(12 for 2013 and 1 for 2017). Therefore, neither of these are evenly represented.
Sales have been increasing year over year, with 2016 being the largest sales
to date. At this rate, we might expect 2017 to have the largest sales.*/


/* Which month did Parch & Posey have the greatest sales
in terms of total dollars?
In order for this to be 'fair', removing the sales from 2013 and 2017. */
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;
/* The greatest sales amounts occur in December (12). */

/* Which year did Parch & Posey have the greatest sales in terms of total
number of orders? Are all years evenly represented by the dataset? */
SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
/* Again, 2016 by far has the most amount of orders, but again 2013 and 2017
are not evenly represented to the other years in the dataset.

/* Which month did Parch & Posey have the greatest sales in terms of total
number of orders? Are all months evenly represented by the dataset? */
SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;
/* December still has the most sales, but interestingly, November has the
second most sales (but not the most dollar sales. To make a fair comparison
from one month to another 2017 and 2013 data were removed. */

/* In which month of which year did Walmart spend the most on gloss paper
in terms of dollars? */
SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
/* May 2016 was when Walmart spent the most on gloss paper. */

/* Queries using CASE Statement */
/* Query to display for each order, the account ID, total amount of the order,
and the level of the order - ‘Large’ or ’Small’ - depending on if the order
is $3000 or more, or less than $3000. */
SELECT account_id, total_amt_usd,
CASE WHEN total_amt_usd > 3000 THEN 'Large'
ELSE 'Small' END AS order_level
FROM orders;

/* Query to display the number of orders in each of three categories, based on
the total number of items in each order. The three categories are:
'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'. */
SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
   WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
   ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

/* Query to understand 3 different branches of customers based on the
amount associated with their purchases. The top branch includes anyone with a
Lifetime Value (total sales of all orders) greater than 200,000 usd.
The second branch is between 200,000 and 100,000 usd.
The lowest branch is anyone under 100,000 usd. */
SELECT a.name, SUM(total_amt_usd) total_spent,
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY 2 DESC;

/* Query to perform a similar calculation to the first, but we want to obtain
the total amount spent by customers only in 2016 and 2017. Keep the same levels
as in the previous question. Order with the top spending customers listed first.*/
SELECT a.name, SUM(total_amt_usd) total_spent,
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;

/* Query to identify top performing sales reps, which are sales reps associated
with more than 200 orders. Create a table with the sales rep name, the total
number of orders, and a column with top or not depending on if they have more
than 200 orders. Placing the top sales people first in your final table. */
SELECT s.name, COUNT(*) num_ords,
     CASE WHEN COUNT(*) > 200 THEN 'top'
     ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;

/* The previous didn't query account for the middle, nor the dollar amount
associated with the sales. Management decides they want to see these
characteristics represented as well. We would like to identify top performing
sales reps, which are sales reps associated with more than 200 orders or more
than 750000 in total sales. The middle group has any rep with more than 150
orders or 500000 in sales. Placing the top sales people based on dollar amount
of sales first in final table. */
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent,
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
     ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;
