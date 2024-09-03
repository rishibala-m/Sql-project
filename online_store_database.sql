CREATE DATABASE Online_Store_Database;
USE Online_Store_Database;

CREATE TABLE Customers(
CustomerId INT PRIMARY KEY,
Name VARCHAR(20),
Email VARCHAR(20),
Phone VARCHAR(12),
Address VARCHAR(50),
City VARCHAR(20),
State VARCHAR(20),
ZipCode VARCHAR(10));
INSERT INTO Customers(CustomerId,CustomerName,Email,Phone,Address,City,State,ZipCode)
VALUES(1,"Arun",'arun@gmail.com','9488406990','2/28, North Street',"Nellai",'TamilNadu','627 113'),
(2,'abdul','abdul@gmail.com','8937266400','1/16 South Street','Nellai','TamilNadu','617 117'),
(3,'karthi','karthi@gmail.com','9732289001','8/19 West Street','Chennai','TamilNadu','600 129'),
(4,'mike','mike@gmail.com','9364382900','6/2 East Street','Kumari','TamilNadu','637 009'),
(5,'mugil','mugil@gmail.com','8120428909','1/5 South Street','Madurai','TamilNadu','657 001');

ALTER TABLE Customers  
CHANGE Name CustomerName VARCHAR(20);
SELECT *FROM Customers;

CREATE TABLE Products(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(50),
Description TEXT,
Price DECIMAL(10,2),
StockQuantity INT,
Category VARCHAR(50));

INSERT INTO Products(ProductID,ProductName,Description,Price,StockQuantity,Category)
VALUES(1,"Laptop","i5 13th gen",50000.00,10,"Electronics"),
(2,"SmartPhone","Amoled Display,5G",20000.00,30,"Electronics"),
(3,"FaceWash","Aloevera",550.00,50,'Cosmetics'),
(4,"Iodex","Muscle pain Relief",100.00,20,'Medicine'),
(5,"Shoes","size-10,black color",600.00,30,'Fashion');

SELECT*FROM Products;

CREATE TABLE Orders(
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
ShippingAddress VARCHAR(50),
OrderStatus VARCHAR(50),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID));

INSERT INTO Orders(OrderID,CustomerID,OrderDate,ShippingAddress,OrderStatus)
VALUES(1,1,'2024-01-25','2/28, North Street,Nellai,TamilNadu,627 113','Shipped'),
(2,1,'2024-11-02','2/28, North Street,Nellai,TamilNadu,627 113','Ordered'),
(3,4,'2024-10-30','6/2 East Street,Kumari,TamilNadu,637 009','Delivered');

CREATE TABLE OrderDetails(
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
UnitPrice DECIMAL(10,2),
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY(ProductID) REFERENCES Products(ProductID));

INSERT INTO OrderDetails(OrderDetailID,OrderID,ProductID,Quantity,UnitPrice)
VALUES(1,1,1,2,'50000.00'),
(2,2,5,2,'600.00'),
(3,3,2,4,'2000.00');


CREATE TABLE Payment(
PaymentID INT PRIMARY KEY,
OrderID INT,
PaymentDate DATE,
PaymentMethod VARCHAR(50),
Amount DECIMAL(10,2),
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID)); 

INSERT INTO Payment(PaymentID,OrderID,PaymentDate,PaymentMethod,Amount)
VALUES(1,1,'2024-01-26','CreditCard',10000.00),
(2,2,'2024-11-04','PayPal','1200.00'),
(3,3,'2024-10-31','GPay','80000.00');



 -- queries
 SELECT*FROM Customers;
 SELECT*FROM Products;
  SELECT*FROM Orders;
 SELECT*FROM OrderDetails;
 SELECT*FROM Payment;
 
 -- Retrieve All Orders for a Specific Customer
 SELECT o.OrderID,
 o.OrderDate,
 o.ShippingAddress,
 o.OrderStatus
 FROM Orders o 
WHERE CustomerId=1;

 Retrieve Order Details for a Specific Order
 
 SELECT od.OrderDetailID,
 od.OrderID,
 p.ProductName,
 od.Quantity,
 od.UnitPrice
 FROM OrderDetails od 
 INNER JOIN Products p
 ON od.ProductID=p.ProductID;
 
 -- Retrieve Payment Information for a Specific Order
 
 SELECT pay.PaymentID,
 pay.OrderID,
 pay.PaymentDate,
 pay.PaymentMethod,
 pay.Amount
 From Payment pay
 WHERE OrderID=2;
 
 Retrieve Inventory Status for All Products

SELECT p.ProductID,
p.ProductName,
p.StockQuantity
FROM Products p;

-- Retrieve Total Sales Amount for Each Product

SELECT p.ProductName,
sum(od.Quantity * od.UnitPrice) AS TotalSales
From OrderDetails od
JOIN  Products p
ON p.ProductID =od.ProductID
GROUP BY p.ProductName;

-- Retrieve Orders and Their Payment Status

SELECT o.OrderId,
o.OrderDate,
o.ShippingAddress,
pay.PaymentMethod,
pay.Amount
FROM Orders  o
LEFT JOIN Payment pay
ON pay.OrderId=o.OrderID;

DELIMITER $$
CREATE TRIGGER change_all
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN 
    INSERT INTO Orders(OrderID,CustomerID,OrderDate,ShippingAddress,OrderStatus)
    VALUES(null,new.CustomerID,null,null,null);
END;
DELIMITER $$ 





