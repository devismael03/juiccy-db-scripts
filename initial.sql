USE core;

-- Creating the Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName VARCHAR(255),
    Price DECIMAL(10, 2) NOT NULL,
    ProductionCost DECIMAL(10, 2) NOT NULL,
    Category VARCHAR(100)
);

-- Creating the Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Position VARCHAR(100),
    Salary DECIMAL(10, 2),
    HireDate DATE
);

-- Creating the Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY,
    ProductID INT,
    EmployeeID INT,
    QuantitySold INT,
    SaleDate DATE,
    City VARCHAR(100),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


USE staging;

-- Create staging table for sales data including city
CREATE TABLE Staging_Sales (
    SaleID INT PRIMARY KEY,
    SaleDate DATE,
    ProductID INT,
    EmployeeID INT,
    QuantitySold INT,
    SaleAmount DECIMAL(10,2),
    City VARCHAR(100)
);


USE report;

-- Create report table for sales by city
CREATE TABLE Report_SalesByCity (
    ReportID INT PRIMARY KEY IDENTITY,
    City VARCHAR(100),
    TotalSales DECIMAL(10,2),
    TotalUnitsSold INT
);

-- Create report table for monthly sales by category and city
CREATE TABLE Report_MonthlySalesByCategoryCity (
    ReportID INT PRIMARY KEY IDENTITY,
    MonthYear CHAR(7),
    Category VARCHAR(100),
    City VARCHAR(100),
    TotalSales DECIMAL(10,2),
    TotalUnitsSold INT
);

-- Create report table for employee sales by city
CREATE TABLE Report_EmployeeSalesByCity (
    ReportID INT PRIMARY KEY IDENTITY,
    EmployeeID INT,
	EmployeeName VARCHAR(300),
    City VARCHAR(100),
    TotalSales DECIMAL(10,2),
);




USE core;

-- Insert Products
INSERT INTO Products (ProductName, Price, ProductionCost, Category)
VALUES 
('Apple Juice', 2.50, 1.00, 'Juice'), 
('Orange Juice', 3.00, 1.20, 'Juice'), 
('Mango Smoothie', 3.50, 1.50, 'Smoothie'), 
('Berry Mix', 3.00, 1.25, 'Juice'),
('Pineapple Juice', 3.25, 1.40, 'Juice'),
('Grape Juice', 2.75, 1.10, 'Juice'),
('Lemonade', 2.00, 0.90, 'Juice'),
('Strawberry Smoothie', 3.75, 1.60, 'Smoothie'),
('Green Juice', 3.00, 1.30, 'Juice'),
('Carrot Juice', 2.50, 1.10, 'Juice');


-- Insert Employees
INSERT INTO Employees (FirstName, LastName, Position, Salary, HireDate)
VALUES 
('John', 'Doe', 'Production Manager', 5000.00, '2021-01-10'),
('Jane', 'Smith', 'Sales Manager', 4500.00, '2021-02-15'),
('Alice', 'Johnson', 'Sales Representative', 3000.00, '2021-03-01'),
('Bob', 'Brown', 'Sales Representative', 3000.00, '2021-04-01'),
('Emily', 'Davis', 'Production Worker', 2500.00, '2021-05-01'),
('Michael', 'Wilson', 'Production Worker', 2500.00, '2021-06-01');


-- Insert Sales
INSERT INTO Sales (ProductID, EmployeeID, QuantitySold, SaleDate, City)
VALUES 
(1, 3, 100, '2023-01-12', 'New York'), 
(2, 3, 200, '2023-01-13', 'Los Angeles'),
(1, 4, 150, '2023-01-14', 'Chicago'), 
(3, 4, 100, '2023-01-15', 'Miami'),
(7, 3, 100, '2023-01-12', 'Baku'), 
(3, 3, 200, '2023-01-13', 'Los Angeles'),
(6, 4, 150, '2023-01-14', 'Chicago'), 
(5, 6, 100, '2023-01-15', 'Miami'),
(2, 6, 100, '2023-01-12', 'New York'), 
(8, 5, 200, '2023-01-13', 'Los Angeles'),
(4, 1, 150, '2023-01-14', 'Baku'), 
(5, 1, 100, '2023-01-15', 'Istanbul'),
(5, 2, 100, '2023-01-15', 'Miami'),
(7, 3, 100, '2023-01-12', 'New York'), 
(3, 2, 200, '2023-01-13', 'Los Angeles'),
(4, 4, 150, '2023-01-14', 'Baku'), 
(9, 5, 100, '2023-01-15', 'Istanbul'),
(10, 5, 200, '2023-01-13', 'Los Angeles'),
(8, 1, 150, '2023-01-14', 'Baku'), 
(6, 1, 100, '2023-01-15', 'Istanbul');







USE core;

SELECT * FROM products;

DELETE FROM products WHERE ProductID IN (11,12);
-- Insert Products
INSERT INTO Products (ProductName, Price, ProductionCost, Category)
VALUES 
('Apple Juice 2', 2.50, 1.00, 'Juice');
