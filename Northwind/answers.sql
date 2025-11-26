-- Show the most expensive, cheapest, and average price of all products in the products table in a single row.
SELECT
	MAX(unit_price) AS "max price",
	MIN(unit_price) AS "min price",
	AVG(unit_price) AS "average price"
FROM
	products;

-- How many products do we have in each category (category_id)? List the Category ID with the product count next to it.
SELECT
	category_id,
	count(*) AS "product count"
FROM
	products
GROUP BY
	category_id;

-- To which country (ship_country) have we sent how many orders in total? List country name and order count.
SELECT
	ship_country,
	COUNT(*) AS "sum of orders"
FROM
	orders
GROUP BY
	ship_country;

-- What is the average price of products that each supplier (supplier_id) provides to us?
SELECT
	supplier_id,
	ROUND(AVG(unit_price))
FROM
	products
GROUP BY
	supplier_id;

-- We want to find the average age of employees in the company. However, the database only has birth_date. (Hint: In PostgreSQL, the AGE(now(), birth_date) function may be useful, or you can simply look at min/max from birth_date, think simple).
SELECT
	AVG(EXTRACT(YEAR FROM AGE(NOW(), birth_date))) AS "Age average"
FROM
	employees;

-- List only the categories (category_id) that have more than 10 product varieties. (First count, then take those greater than 10).
SELECT
	category_id,
	COUNT(*) AS "product count"
FROM
	products
GROUP BY
	category_id
HAVING
	COUNT(*) > 10;

-- Which employees (employee_id) have taken more than 100 orders in total?
SELECT
	employee_id,
	COUNT(*) AS "order count"
FROM
	orders
GROUP BY
	employee_id
HAVING
	COUNT(*) >= 100;

-- List the name of each product (product_name) and the name of its category (category_name)
SELECT
	c.category_name,
	p.product_name
FROM
	products p
JOIN
	categories c ON c.category_id = p.category_id;

-- List which employee (first_name, last_name) took each order (order_id).
SELECT
	o.order_id,
	e.first_name || ' ' || e.last_name AS employee_name
from
	orders o
JOIN
	employees e ON e.employee_id = o.employee_id;

-- How many products do we have in total in each category (category_name)?
SELECT
	c.category_name,
	COUNT(p.product_id) AS product_count
FROM
	products p
JOIN
	categories c ON c.category_id = p.category_id
GROUP BY
	c.category_name;

-- With which shipping company (company_name) have we shipped how many orders in total?
SELECT
	s.company_name,
	COUNT(o.order_id) AS order_count
FROM
	orders o
JOIN
	shippers s ON s.shipper_id = o.ship_via
GROUP BY
	s.company_name;

-- Which of our suppliers (company_name) provide us with more than 3 different products?
SELECT
	s.company_name,
	COUNT(p.product_id) AS product_count
FROM
	products p
JOIN
	suppliers s ON s.supplier_id = p.supplier_id
GROUP BY
	s.company_name
HAVING
	COUNT(p.product_id) >= 3;

-- List customers who have never placed an order
SELECT
	c.company_name,
	COUNT(o.order_id) OVER(PARTITION BY c.customer_id) AS order_count
FROM
	customers c
LEFT JOIN
	orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- Get the total product stock quantity in our warehouse (sum all product quantities) and the most expensive shipping cost (from orders table).
SELECT
	SUM(units_in_stock) AS "sum of units in stock",
	MAX(freight) AS "Max freight"
FROM
	products,
	orders;

-- Print product name and stock quantity. Also print the total stock of all products repeated in each row. (So we can see what percentage of the total stock each product represents).
SELECT
	product_name,
	units_in_stock,
	SUM(units_in_stock) OVER() AS "all stock"
FROM
	products;

-- Print the name, price of products in the products table and the average price of the category they belong to side by side. (Note: You will not compress rows, every product will be listed!)
SELECT
	product_name,
	unit_price,
	AVG(unit_price) OVER(PARTITION BY category_id) AS "category average"
FROM
	products;

-- List orders (order_id, freight). Next to it, print the average shipping cost of the country (ship_country) where that order went. (Don't lose order details).
SELECT
	order_id,
	ship_country,
	freight,
	AVG(freight) OVER(PARTITION BY ship_country) AS country_mean
FROM
	orders;

-- Sort products by price from most expensive to cheapest. However, do this sorting not for the entire table, but so that each category starts from 1 within itself. (E.g.: Category 1's most expensive should be number 1, Category 2's most expensive should also be number 1).
SELECT
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY unit_price DESC) AS rank,
	product_name,
	category_id,
	unit_price
FROM
	products;

-- Sort each employee's orders by shipping cost (freight) from most expensive to cheapest. Each employee's most expensive order should be number 1. (Use Rank or Row_Number).
SELECT
	RANK() OVER(ORDER BY freight DESC) AS rank,
	order_id,
	employee_id,
	freight
FROM
	orders;

-- In the orders table, sort the orders taken by each employee (employee_id) by date. Next to it, write the cumulative (total) order count that the employee has taken up to that date (Running Count).
SELECT
	order_date,
	employee_id,
	COUNT(order_id) OVER(PARTITION BY employee_id ORDER BY order_date) AS cumulative_count
FROM
	orders;

-- Sort customers' orders by date. In each row, show the date of that order and the previous order date of the same customer side by side. (So we can find out how often the customer orders). Hint: LAG() function.
SELECT
	order_date,
	LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
	order_id,
	customer_id,
	freight
FROM
	orders;

-- Print product name, price, and category name. Next to it, also print the price of the most expensive product in that category
SELECT
	p.product_name,
	p.unit_price,
	c.category_name,
	MAX(p.unit_price) OVER(PARTITION BY p.category_id) AS max_category_price
FROM
	products p
JOIN
	categories c ON c.category_id = p.category_id;

-- List the orders taken by employees (order_id, first_name). Next to each order, write how many orders that employee has taken in total (without grouping rows)
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	o.order_id,
	COUNT(o.order_id) OVER(PARTITION BY e.employee_id) AS order_count
FROM
	employees e
JOIN
	orders o ON o.employee_id = o.employee_id;

-- List the names of employees whose total revenue (sales amount) is over $10,000.
SELECT
	e.first_name || ' ' || e.last_name AS employee_name,
	SUM(od.unit_price * od.quantity) AS sell_sum
FROM
	employees e
JOIN
	orders o ON o.employee_id = e.employee_id
JOIN
	order_details od ON od.order_id = o.order_id
GROUP BY
	e.first_name,
	e.last_name
HAVING
	SUM(od.unit_price * od.quantity) >= 10000;