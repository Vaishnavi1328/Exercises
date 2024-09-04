--Aug 24
--1
SELECT c.customer_id AS CUSTOMER_ID, c.FirstName AS FIRST_NAME, c.LastName AS LAST_NAME, 
SUM(o.OrderAmount) AS TOTAL_SPENT
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.FirstName, c.LastName
HAVING SUM(o.OrderAmount) < 1000;

--2
SELECT c.customer_id AS CUSTOMER_ID, c.FirstName AS FIRST_NAME, c.LastName AS LAST_NAME, o.OrderDate AS ORDER_DATE, o.OrderAmount AS ORDER_AMOUNT,
SUM(o.OrderAmount) OVER (PARTITION BY c.customer_id ORDER BY o.OrderDate) AS RUNNING_TOTAL
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.OrderDate;

--3
SELECT c.customer_id AS CUSTOMER_ID, c.FirstName AS FIRST_NAME, c.LastName AS LAST_NAME, c.City AS CITY,
SUM(o.OrderAmount) AS TOTAL_SPENT,
RANK() OVER (PARTITION BY c.City ORDER BY SUM(o.OrderAmount) DESC) AS CITY_RANK
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.FirstName, c.LastName, c.City;

--4
WITH CustomerTotals AS (
    SELECT c.customer_id AS CUSTOMER_ID, c.FirstName AS FIRST_NAME, c.LastName AS LAST_NAME, 
    SUM(o.OrderAmount) AS TOTAL_SPENT
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.FirstName, c.LastName
)
SELECT CUSTOMER_ID, FIRST_NAME, LAST_NAME, TOTAL_SPENT,
SUM(TOTAL_SPENT) OVER () AS OVERALL_TOTAL,
(TOTAL_SPENT * 100.0 / SUM(TOTAL_SPENT) OVER ()) AS PERCENTAGE_OF_TOTAL
FROM CustomerTotals;

-- 5
SELECT c.customer_id AS CUSTOMER_ID, c.FirstName AS FIRST_NAME, c.LastName AS LAST_NAME, 
SUM(o.OrderAmount) AS TOTAL_SPENT,
RANK() OVER (ORDER BY SUM(o.OrderAmount) DESC) AS OVERALL_RANK
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.FirstName, c.LastName;

-- 6
SELECT c.City AS CITY, 
AVG(o.OrderAmount) AS AVG_ORDER_AMOUNT
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.City
ORDER BY AVG_ORDER_AMOUNT DESC;

-- 7
SELECT TOP 3 c.customer_id AS CUSTOMER_ID, c.FirstName AS FIRST_NAME, c.LastName AS LAST_NAME, 
SUM(o.OrderAmount) AS TOTAL_SPENT
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.FirstName, c.LastName
ORDER BY TOTAL_SPENT DESC;

-- 8
SELECT YEAR(o.OrderDate) AS ORDER_YEAR, 
SUM(o.OrderAmount) AS YEARLY_TOTAL
FROM Orders o
GROUP BY YEAR(o.OrderDate)
ORDER BY ORDER_YEAR;

-- 9
SELECT c.customer_id AS CUSTOMER_ID, c.FirstName AS FIRST_NAME, c.LastName AS LAST_NAME, 
SUM(o.OrderAmount) AS TOTAL_SPENT,
RANK() OVER (ORDER BY SUM(o.OrderAmount) DESC) AS MUMBAI_RANK
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.City = 'Mumbai'
GROUP BY c.customer_id, c.FirstName, c.LastName;

-- 10
WITH CustomerTotals AS (
    SELECT c.customer_id AS CUSTOMER_ID, c.FirstName AS FIRST_NAME, c.LastName AS LAST_NAME, 
    SUM(o.OrderAmount) AS TOTAL_SPENT
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.FirstName, c.LastName
)
SELECT CUSTOMER_ID, FIRST_NAME, LAST_NAME, TOTAL_SPENT,
AVG(TOTAL_SPENT) OVER () AS AVG_TOTAL_SPENT,
TOTAL_SPENT - AVG(TOTAL_SPENT) OVER () AS DIFFERENCE_FROM_AVERAGE
FROM CustomerTotals;