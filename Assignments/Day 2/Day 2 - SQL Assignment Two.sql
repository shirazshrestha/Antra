

1.	What is a result set?
-	Result set is the output of a query.

2.	What is the difference between Union and Union All?
(1)	Union will automatically clean up duplications, while Union All will not.
(2)	Union will sort the result by the order of first column by default, while Union will remain the original sequence by default. 
(3) Union All is efficient than Union.

3.	What are the other Set Operators SQL Server has?
(1)	INTERSECT 
(2)	EXCEPT
(3)	MINUS 
(4) UNION
(5) UNION ALL

4.	What is the difference between Union and Join?
Union is used to combine the result-set of two or more SELECT statements. It combines multiple queries into a single query with all the records of queries and the same column forms. (Vertically)
Join is used to combine data from multiple queries with the column names of all queries. The number of rows depends on the kinds of joins and the queries. (Horizontally)

5.	What is the difference between INNER JOIN and FULL JOIN?
INNER JOIN will return the rows that has matched elements in both left and right query.
	FULL JOIN will return all the rows of both queries, even if there is no match.

6.	What is the difference between LEFT JOIN and OUTER JOIN?
Left join is a kind of outer join. Left outer join will return all rows from left query, even if there are unmatched data. There are another two kinds of outer joins, which are right join and full join.  

7.	What is a CROSS JOIN?
Cross join returns the product of query multiplication, which represents all the combination of queries elements.

8.	What is the difference between WHERE clause and HAVING clause?
WHERE could only work on columns that already exist in original queries, after FROM and before key words like “GROUP BY”. Having could be used on columns that don’t exist in original queries, but created during the former processes. Having shall be written after GROUP BY (all in specific sequence).

9. Can there be multiple group by columns?
Yes, there could be. If there are multiple columns following GROUP BY, SQL will put the rows with the same values in all those columns in the same group.

Self Join: Self Join is used to join a table to itself after temporally renaming. There’s not key word like “SELF JOIN”, self join is achieved by key word like “WHERE”.


Write queries for following scenarios

1. How many products can you find in the Production.Product table?
SELECT COUNT(ProductID) AS "Number of Products" FROM Production.Product;

2.	Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID) AS "Number of Products in A Category" 
FROM Production.Product AS P
WHERE P.ProductSubcategoryID IS NOT NULL;

3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(ProductID) AS " CountedProducts" 
FROM Production.Product AS P
WHERE P.ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;

4. How many products that do not have a product subcategory. 
SELECT COUNT(ProductID) AS "Number of Products Not in A Category" 
FROM Production.Product AS P
WHERE P.ProductSubcategoryID IS NULL;

5. Write a query to list the summary of products in the Production.ProductInventory table.
SELECT SUM(Quantity) AS 'Summary of Products' 
FROM Production.ProductInventory
GROUP BY ProductID;


6. Write a query to list the summary of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
              ProductID    TheSum
-----------        ----------

SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID =40
GROUP BY ProductID
HAVING SUM(Quantity) < 100;

7. Write a query to list the summary of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
Shelf      ProductID    TheSum

SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID =40
GROUP BY ProductID, Shelf
HAVING SUM(Quantity) < 100;

8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

SELECT ProductID, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID;

9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
ProductID   Shelf      TheAvg
----------- ---------- -----------

SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID,Shelf;

10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
ProductID   Shelf      TheAvg

SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
	FROM Production.ProductInventory
	WHERE Shelf <> 'N/A'
	GROUP BY ProductID, Shelf;

11.	List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
Color           	Class 	TheCount   	 AvgPrice
--------------	- ----- 	----------- 	---------------------

SELECT Color, Class, Count(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class;

Joins:
12.	  
(1)	Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 

Country                        Province
---------                          ----------------------

SELECT c.Name AS Country, s.Name AS Province 
	FROM Person.CountryRegion c 
	FULL JOIN
	Person.StateProvince s
	ON c.CountryRegionCode = s.CountryRegionCode;
(2)	Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.


SELECT c.Name AS Country, s.Name AS Province 
	FROM Person.CountryRegion c 
	RIGHT JOIN
	Person.StateProvince s
	ON c.CountryRegionCode = s.CountryRegionCode;

Could chose different types of JOINs based on requirement.

13.
(1)	
SELECT c.Name AS Country, s.Name AS Province 
	FROM Person.CountryRegion c 
	FULL JOIN
	Person.StateProvince s
	ON c.CountryRegionCode = s.CountryRegionCode
	WHERE c.Name NOT IN ('Germany', 'Canada');	
(2)	
SELECT c.Name AS Country, s.Name AS Province 
	FROM Person.CountryRegion c 
	JOIN
	Person.StateProvince s
	ON c.CountryRegionCode = s.CountryRegionCode
	WHERE c.Name NOT IN ('Germany', 'Canada');	

Using Northwnd Database: (Use aliases for all the Joins)
14.	
SELECT DISTINCT p.*
	FROM Orders o
	FULL JOIN
	[Order Details] od
	ON o.OrderID =  od.OrderID
	LEFT JOIN 
	Products p
	ON od.ProductID = p.ProductID
	WHERE DATEDIFF(year, o.OrderDate, GETDATE())< 21;

15.	
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) as qty FROM 
	Orders o
	FULL JOIN
	[Order Details] od
	ON o.OrderID =  od.OrderID
	WHERE o.ShipPostalCode IS NOT NULL
	GROUP BY ShipPostalCode
	ORDER BY qty DESC;

16.	
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) as qty FROM 
	Orders o
	FULL JOIN
	[Order Details] od
	ON o.OrderID =  od.OrderID
	WHERE o.ShipPostalCode IS NOT NULL 
		AND DATEDIFF(year, o.OrderDate, GETDATE())< 21
	GROUP BY ShipPostalCode
	ORDER BY qty DESC;

17.
select count(customerID),City
from customers
group by City

18.
select count(customerID),City
from customers
group by City
having  count(customerID)>10



19.
SELECT DISTINCT c.CustomerID, c.CompanyName, c.ContactName FROM 
	Orders o
	INNER JOIN 
	Customers c
	ON o.CustomerID = c.CustomerID
	WHERE OrderDate > '1998-1-1';

20.
SELECT c.CustomerID, c.CompanyName, c.ContactName FROM
	Orders o
	INNER JOIN
	Customers c
	ON o.CustomerID = c.CustomerID
	WHERE o.OrderDate IN 
	(SELECT TOP 1 OrderDate FROM Orders
	WHERE OrderDate IS NOT NULL
	GROUP BY OrderDate
	ORDER BY OrderDate DESC);

21.
(a)
SELECT c.CustomerID, c.CompanyName, c.ContactName, 
SUM(od.Quantity) AS QTY FROM 
Customers c 
LEFT JOIN 
Orders o 
ON c.CustomerID = o.CustomerID
LEFT JOIN 
[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName, c.ContactName
ORDER BY QTY;

22
SELECT c.CustomerID,
SUM(od.Quantity) AS QTY FROM 
Customers c 
LEFT JOIN 
Orders o 
ON c.CustomerID = o.CustomerID
LEFT JOIN 
[Order Details] od
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100
ORDER BY QTY;

23.
SELECT DISTINCT sup.CompanyName, ship.CompanyName FROM 
Orders o
LEFT JOIN
[Order Details] od
ON o.OrderID = od.OrderID
INNER JOIN 
Products p
ON od.ProductID = p.ProductID
RIGHT JOIN
Suppliers sup
ON p.SupplierID = sup.SupplierID
INNER JOIN
Shippers ship
ON o.ShipVia = ship.ShipperID;

24.	
SELECT o.OrderDate, p.ProductName FROM 
Orders o
LEFT JOIN
[Order Details] od
ON o.OrderID = od.OrderID
INNER JOIN
Products p
ON od.ProductID = p.ProductID
GROUP BY o.OrderDate, p.ProductName
ORDER BY o.OrderDate;

25.
(1)	
SELECT Title, LastName + ' ' + FirstName AS Name 
FROM Employees
ORDER BY Title;

(2)
SELECT e1.Title, e1.LastName + ' ' + e1.FirstName AS Name1, e2.LastName + ' ' + e2.FirstName AS Name2 
FROM Employees e1
JOIN 
Employees e2
ON e1.Title = e2.Title 
WHERE e1.FirstName <> e2.FirstName OR e1.LastName <>        e2.LastName
ORDER BY Title;

26.
SELECT * FROM (SELECT * FROM Employees) AS T1
INNER JOIN
(SELECT ReportsTo, COUNT(ReportsTo) AS Subordinate  FROM Employees
WHERE ReportsTo IS NOT NULL
GROUP BY ReportsTo
HAVING COUNT(ReportsTo) > 2) T2
ON T2.ReportsTo= T1.EmployeeID;
Question: How to keep most columns but drop only a few of them?


27.
SELECT c.City, c.CompanyName, c.ContactName, 'Customer' as Type
FROM Customers c
UNION
SELECT s.City, s.CompanyName, s.ContactName, 'Supplier' as Type
FROM Suppliers s;

28. 
SELECT * FROM F1 INNER JOIN F2;
ON F1.T1 = F2.T2
----------
2		2
3		3

29.
SELECT * FROM F1 LEFT JOIN F2;
ON F1.T1 = F2.T2
1		NULL

2		2
3		3



