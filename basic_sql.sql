/* 10 earliest orders in the orders table */
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

/* Top 5 orders in terms of largest total_amt_usd */
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

/* Lowest 20 orders in terms of smallest total_amt_usd */
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

/* Query that displays the order ID, account ID, and total dollar amount
for all the orders, sorted first by the account ID (in ascending order),
and then by the total dollar amount (in descending order) */
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

/* Pull the first 5 rows and all columns from the orders table
that have a dollar amount of gloss_amt_usd greater than or equal to 1000.*/
SELECT *
FROM orders
WHERE gloss_amt_usd>=1000
LIMIT 5;

/* Pull the first 10 rows and all columns from the orders
table that have a total_amt_usd less than 500.*/
SELECT *
FROM orders
WHERE total_amt_usd<=500
LIMIT 10;

/* Filter the accounts table to include the company name, website,
and the primary point of contact (primary_poc) just for the Exxon Mobil
company in the accounts table. */
SELECT name, website, primary_poc
FROM accounts
WHERE name='Exxon Mobil';

/* Unit price for standard paper for each order.
Limit the results to the first 10 orders */
SELECT standard_amt_usd/standard_qty AS Unit_Price, id, account_id
FROM orders
LIMIT 10;

/* percentage of revenue that comes from poster paper for each order
Limit the results to the first 10 orders */
SELECT id, account_id,
(standard_amt_usd + gloss_amt_usd + poster_amt_usd)* 100 AS revenue_percentage
FROM orders
LIMIT 10;

/* All the companies whose names start with 'C'.*/
SELECT *
FROM accounts
WHERE name LIKE 'C%';

/* All companies whose names contain the string 'one' somewhere in the name.*/
SELECT *
FROM accounts
WHERE name LIKE '%one%';

/* All companies whose names end with 's'. */
SELECT *
FROM accounts
WHERE name LIKE '%s';

/* Find the account name, primary_poc, and sales_rep_id for
Walmart, Target, and Nordstrom. */
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target','Nordstrom');

/* Find all information regarding individuals who were contacted
via the channel of organic or adwords. */
SELECT *
FROM web_events
WHERE channel IN ('organic','adwords');

/* Find the account name, primary_poc, and sales_rep_id for all stores except
Walmart, Target, and Nordstrom. */
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart','Target','Nordstrom');

/* Find all information regarding individuals who were contacted via any method
except using organic or adwords methods. */
SELECT *
FROM web_events
WHERE channel NOT IN ('organic','adwords');

/* All the companies whose names do not start with 'C'.*/
SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

/* All companies whose names do not contain
the string 'one' somewhere in the name.*/
SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

/* All companies whose names do not end with 's'. */
SELECT *
FROM accounts
WHERE name NOT LIKE '%s';

/* Returns all the orders where the standard_qty is over 1000,
the poster_qty is 0, and the gloss_qty is 0. */
SELECT *
FROM orders
WHERE standard_qty > 100 AND poster_qty = 0 AND gloss_qty = 0;

/* Find all the companies whose names do not start with 'C' and end with 's'. */
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

/* Find all information regarding individuals who were contacted via
the organic or adwords channels, and started their account at any point
in 2016, sorted from newest to oldest. */
SELECT *
FROM web_events
WHERE channel IN ('organic','adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

/* Find list of orders ids where either gloss_qty or
poster_qty is greater than 4000.*/
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

/* Returns a list of orders where the standard_qty is zero
and either the gloss_qty or poster_qty is over 1000. */
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

/* Find all the company names that start with a 'C' or 'W', and the
primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'. */
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
           AND primary_poc NOT LIKE '%eana%');
