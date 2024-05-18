CREATE PROCEDURE PopulateReport_SalesByCity
AS
BEGIN
    -- Populate Staging_Sales from Core Sales and calculate SaleAmount
    DELETE FROM staging.dbo.Staging_Sales;
    INSERT INTO staging.dbo.Staging_Sales (SaleID, SaleDate, ProductID, EmployeeID, QuantitySold, SaleAmount, City)
    SELECT 
        S.SaleID, S.SaleDate, S.ProductID, S.EmployeeID, S.QuantitySold, 
        S.QuantitySold * P.Price AS SaleAmount, S.City
    FROM core.dbo.Sales S
    JOIN core.dbo.Products P ON S.ProductID = P.ProductID;

    -- Populate Report_SalesByCity from Staging_Sales
    DELETE FROM Report_SalesByCity;
    INSERT INTO Report_SalesByCity (City, TotalSales, TotalUnitsSold)
    SELECT 
        City,
        SUM(SaleAmount),
        SUM(QuantitySold)
    FROM staging.dbo.Staging_Sales
    GROUP BY City;
END;

GO;
CREATE PROCEDURE PopulateReport_MonthlySalesByCategoryCity
AS
BEGIN
    -- Populate Staging_Sales from Core Sales and calculate SaleAmount
    DELETE FROM staging.dbo.Staging_Sales;
    INSERT INTO staging.dbo.Staging_Sales (SaleID, SaleDate, ProductID, EmployeeID, QuantitySold, SaleAmount, City)
    SELECT 
        S.SaleID, S.SaleDate, S.ProductID, S.EmployeeID, S.QuantitySold, 
        S.QuantitySold * P.Price AS SaleAmount, S.City
    FROM core.dbo.Sales S
    JOIN core.dbo.Products P ON S.ProductID = P.ProductID;

    -- Populate Report_MonthlySalesByCategoryCity from Staging_Sales
    DELETE FROM Report_MonthlySalesByCategoryCity;
    INSERT INTO Report_MonthlySalesByCategoryCity (MonthYear, Category, City, TotalSales, TotalUnitsSold)
    SELECT 
        FORMAT(SaleDate, 'yyyy-MM') AS MonthYear,
        P.Category,
        City,
        SUM(SaleAmount),
        SUM(QuantitySold)
    FROM staging.dbo.Staging_Sales S
    JOIN core.dbo.Products P ON S.ProductID = P.ProductID
    GROUP BY FORMAT(SaleDate, 'yyyy-MM'), P.Category, City;
END;




GO;
CREATE PROCEDURE PopulateReport_EmployeeSalesByCity
AS
BEGIN
    -- Populate Staging_Sales from Core Sales and calculate SaleAmount
    DELETE FROM staging.dbo.Staging_Sales;
    INSERT INTO staging.dbo.Staging_Sales (SaleID, SaleDate, ProductID, EmployeeID, QuantitySold, SaleAmount, City)
    SELECT 
        S.SaleID, S.SaleDate, S.ProductID, S.EmployeeID, S.QuantitySold, 
        S.QuantitySold * P.Price AS SaleAmount, S.City
    FROM core.dbo.Sales S
    JOIN core.dbo.Products P ON S.ProductID = P.ProductID;

    -- Populate Report_EmployeeSalesByCity from Staging_Sales
    DELETE FROM Report_EmployeeSalesByCity;
    INSERT INTO Report_EmployeeSalesByCity (EmployeeID, EmployeeName, City, TotalSales)
    SELECT 
        E.EmployeeID,
        E.FirstName + ' ' + E.LastName AS EmployeeName,
        S.City,
        SUM(S.SaleAmount)
    FROM staging.dbo.Staging_Sales S
    JOIN core.dbo.Employees E ON S.EmployeeID = E.EmployeeID
    GROUP BY E.EmployeeID, E.FirstName + ' ' + E.LastName, S.City;
END;
