--Afternoon assesment
--1
SELECT *
FROM Products
WHERE Category = 'Electronics'
  AND Price > 500;

--2
SELECT SUM(Quantity) AS TotalQuantitySold
FROM Orders;

--3
SELECT 
    p.ProductName,
    SUM(o.Quantity * p.Price) AS TotalRevenue
FROM 
    Orders o
JOIN 
    Products p ON o.ProductID = p.ProductID
GROUP BY 
    p.ProductName;

--4
SELECT 
    p.ProductName,
    SUM(o.Quantity * p.Price) AS TotalRevenue
FROM 
    Orders o
JOIN 
    Products p ON o.ProductID = p.ProductID
GROUP BY 
    p.ProductName
HAVING 
    SUM(o.Quantity * p.Price) > 30000
ORDER BY 
    TotalRevenue DESC;
--Order of Execution:where->groupby->having->orderby

--5
SELECT 
    Category,
    COUNT(ProductName) AS NoOfProducts
FROM 
    Products
GROUP BY 
    Category;

--6
SELECT 
    c.CustomerID,
    c.FirstName
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
GROUP BY 
    c.CustomerID,
    c.FirstName
HAVING 
    COUNT(o.OrderID) > 5;

--Stored procedure exercise
--1
CREATE PROCEDURE GetAllCustomers
AS
BEGIN
    SELECT * FROM Customers;
END;

EXEC GetAllCustomers;

--2
CREATE PROCEDURE GetOrderDetailsByOrderId
	@OrderId INT
AS
BEGIN
	SELECT * FROM Orders WHERE OrderId=@OrderId;
END;

EXEC GetOrderDetailsByOrderId @OrderId=3;

--3
CREATE PROCEDURE GetProductsByCategoryAndPrice
    @Category VARCHAR(50),
    @MinPrice DECIMAL(10, 2)
AS
BEGIN
    SELECT *
    FROM Products
    WHERE Category = @Category
      AND Price >= @MinPrice;
END;

EXEC GetProductsByCategoryAndPrice @Category='Electronics',@MinPrice=7000.00;

--4
CREATE PROCEDURE InsertNewProduct
    @ProductName VARCHAR(100),
    @Category VARCHAR(50),
    @Price DECIMAL(10, 2),
    @StockQuantity INT
AS
BEGIN
    INSERT INTO Products (ProductName, Category, Price, StockQuantity)
    VALUES (@ProductName, @Category, @Price, @StockQuantity);
END

EXEC InsertNewProduct 
    @ProductName = 'New Product', 
    @Category = 'Electronics', 
    @Price = 499.99, 
    @StockQuantity = 100;

--5
CREATE PROCEDURE UpdateCustomerEmail
    @CustomerID INT,
    @NewEmail VARCHAR(100)
AS
BEGIN
    UPDATE Customers
    SET Email = @NewEmail
    WHERE CustomerID = @CustomerID;
END;

EXEC UpdateCustomerEmail 
    @CustomerID = 3, 
    @NewEmail = 'new.email@example.com';

--6
CREATE PROCEDURE DeleteOrderByID
    @OrderID INT
AS
BEGIN
    DELETE FROM Orders
    WHERE OrderID = @OrderID;
END;

EXEC DeleteOrderByID @OrderID = 3;

--7
CREATE PROCEDURE GetTotalProductsInCategory
    @Category VARCHAR(50),
    @TotalProducts INT OUTPUT
AS
BEGIN
    SET @TotalProducts = 0;
    SELECT @TotalProducts = COUNT(*)
    FROM Products
    WHERE Category = @Category;
END;

DECLARE @ProductCount INT;

EXEC GetTotalProductsInCategory 
    @Category = 'Electronics', 
    @TotalProducts = @ProductCount OUTPUT;

SELECT @ProductCount AS TotalProducts;
