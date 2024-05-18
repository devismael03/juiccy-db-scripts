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



