USE core; -- Replace with your database name
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'PumPum123'; 
GO

CREATE CERTIFICATE EmployeeSalaryCert
WITH SUBJECT = 'Certificate to encrypt Salary column';
GO

CREATE SYMMETRIC KEY EmployeeSalaryKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE EmployeeSalaryCert;
GO

ALTER TABLE Employees
ADD EncryptedSalary VARBINARY(MAX);
GO

OPEN SYMMETRIC KEY EmployeeSalaryKey
DECRYPTION BY CERTIFICATE EmployeeSalaryCert;

UPDATE Employees
SET EncryptedSalary = ENCRYPTBYKEY(KEY_GUID('EmployeeSalaryKey'), CAST(Salary AS VARBINARY(MAX)));

CLOSE SYMMETRIC KEY EmployeeSalaryKey;
GO

ALTER TABLE Employees
DROP COLUMN Salary;





OPEN SYMMETRIC KEY EmployeeSalaryKey
DECRYPTION BY CERTIFICATE EmployeeSalaryCert;

SELECT EmployeeID, FirstName, LastName, Position, 
       CAST(DECRYPTBYKEY(EncryptedSalary) AS DECIMAL(10, 2)) AS Salary, 
       HireDate
FROM Employees;

CLOSE SYMMETRIC KEY EmployeeSalaryKey;
GO