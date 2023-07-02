--Create DATABASE DWH_Project
CREATE DATABASE DWH_Project;

USE DWH_Project;

--Create DimCustomer, DimProduct, DimStatusOrder and FactSalesOrder Table
CREATE TABLE DimCustomer (
	CustomerID int NOT NULL,
	CustomerName varchar(50) NOT NULL,
	Age int NOT NULL,
	Gender varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	NoHP varchar(50) NOT NULL,
	CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerID)
)

CREATE TABLE DimProduct (
	ProductID int NOT NULL,
	ProductName varchar(255) NOT NULL,
	ProductCategory varchar(255) NOT NULL,
	ProductUnitPrice int NOT NULL,
	CONSTRAINT PK_DimProduct PRIMARY KEY (ProductID)
)

CREATE TABLE DimStatusOrder (
	StatusID int NOT NULL,
	StatusOrder varchar(50) NOT NULL,
	StatusOrderDesc varchar(50) NOT NULL
	CONSTRAINT PK_DimStatusOrder PRIMARY KEY (StatusID)
)

CREATE TABLE FactSalesOrder (
	OrderID int NOT NULL,
	CustomerID int NOT NULL,
	ProductID int NOT NULL,
	Quantity int NOT NULL,
	Amount int NOT NULL,
	StatusID int NOT NULL,
	OrderDate date NOT NULL,
	CONSTRAINT PK_FactSalesOrder PRIMARY KEY (OrderID),
	CONSTRAINT FK_DimCustomer FOREIGN KEY (CustomerID) REFERENCES DimCustomer (CustomerID),
	CONSTRAINT FK_DimProduct FOREIGN KEY (ProductID) REFERENCES DimPRoduct (ProductID),
	CONSTRAINT FK_DimStatusOrder FOREIGN KEY (StatusID) REFERENCES DimStatusOrder (StatusID)
);

--Create Store Procedure (SP)
CREATE PROCEDURE summary_order_status 
(@StatusID int) AS
BEGIN
	SELECT 
		slo.OrderID,
		c.CustomerName,
		p.ProductName,
		slo.Quantity,
		sto.StatusOrder
	FROM FactSalesOrder slo 
	INNER JOIN DimCustomer c on slo.CustomerID = c.CustomerID
	INNER JOIN DimProduct p on slo.ProductID = p.ProductID
	INNER JOIN DimStatusOrder sto on slo.StatusID = sto.StatusID
	WHERE sto.StatusID = @StatusID
END;

EXEC summary_order_status @StatusID = 2

-- Recommendation
CREATE PROCEDURE summary_monthly_sales
( @month int ) AS
BEGIN
	SELECT 
		p.ProductCategory,
		SUM(slo.Amount) TotalAmount,
		slo.OrderDate,
		sto.StatusOrder
	FROM FactSalesOrder slo 
	INNER JOIN DimProduct p on slo.ProductID = p.ProductID
	INNER JOIN DimStatusOrder sto on slo.StatusID = sto.StatusID
	WHERE month(slo.OrderDate) = @month
	GROUP BY p.ProductCategory,slo.OrderDate,sto.StatusOrder
END;

EXEC summary_monthly_sales @month = 1

