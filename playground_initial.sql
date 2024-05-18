SELECT TOP (1000) [SaleID]
      ,[SaleDate]
      ,[ProductID]
      ,[EmployeeID]
      ,[QuantitySold]
      ,[SaleAmount]
      ,[City]
  FROM [staging].[dbo].[Staging_Sales]


SELECT * FROM [core].[dbo].[Products]

SELECT * FROM report.dbo.Report_SalesByCity

SELECT * FROM report.dbo.Report_MonthlySalesByCategoryCity

SELECT * FROM report.dbo.Report_EmployeeSalesByCity

DELETE FROM staging.dbo.Staging_Sales

DELETE FROM report.dbo.Report_SalesByCity

DELETE FROM report.dbo.Report_EmployeeSalesByCity

DELETE FROM report.dbo.Report_MonthlySalesByCategoryCity