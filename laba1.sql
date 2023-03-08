-- VARIANT 7
-- 1 TASK

CREATE DATABASE NewDatabase;
USE NewDatabase; 
GO
CREATE SCHEMA sales;
GO
CREATE SCHEMA person;
GO
CREATE TABLE sales.Orders (OrderNum INT NULL);
GO 

BACKUP DATABASE NewDatabase 
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\NewDatabase.bak'
GO

USE master; 
GO
DROP DATABASE NewDatabase;
GO

RESTORE DATABASE NewDatabase
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\NewDatabase.bak'
WITH REPLACE; 
GO

-- 2 TASK 
-- 2.1 task
USE AdventureWorks2012;
GO
SELECT count (GroupName) FROM HumanResources.Department
WHERE GroupName = 'Executive General and Administration'

GO

-- 2.2 task
SELECT TOP 5 BusinessEntityID, JobTitle, Gender, BirthDate FROM HumanResources.Employee
ORDER BY BirthDate desc;
GO

-- 2.3 task
SELECT BusinessEntityID, JobTitle, Gender, HireDate, REPLACE(LoginID, 'adventure-works', 'adventure-works2012') FROM HumanResources.Employee
WHERE Gender = 'F' AND DATEPART(DW, HireDate) % 7 = 2 ;
GO

-- 3 TASK
-- 3.1 task
SELECT Employee.BusinessEntityID, Employee.JobTitle, MAX(EmployeePayHistory.RateChangeDate) AS LastRateDate 
	FROM HumanResources.Employee 
	INNER JOIN HumanResources.EmployeePayHistory 
		ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
	GROUP BY Employee.BusinessEntityID, Employee.JobTitle;
GO

-- 3.2 task
SELECT Employee.BusinessEntityID, Employee.JobTitle, Department.Name AS DepName, EmployeeDepartmentHistory.StartDate, EmployeeDepartmentHistory.EndDate,
	DATEDIFF(YY, EmployeeDepartmentHistory.StartDate, ISNULL(EmployeeDepartmentHistory.EndDate, GETDATE())) AS Years
	FROM HumanResources.Employee 
	INNER JOIN HumanResources.EmployeeDepartmentHistory 
		ON Employee.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
	INNER JOIN HumanResources.Department
		ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID;
GO

-- 3.3 task
SELECT Employee.BusinessEntityID, Employee.JobTitle, Department.Name AS DepName, Department.DepartmentID, Department.GroupName,
	CASE 
		WHEN CHARINDEX(' ', Department.GroupName) > 0 
		THEN LEFT(Department.GroupName, CHARINDEX(' ', Department.GroupName))
		ELSE Department.GroupName
		END AS DepGroup
FROM HumanResources.Employee
INNER JOIN HumanResources.EmployeeDepartmentHistory
	ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
INNER JOIN HumanResources.Department
	ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID 
AND EmployeeDepartmentHistory.EndDate IS NULL;
GO

-- 4 TASK 
-- a

CREATE TABLE dbo.PersonPhone (
	BusinessEntityID INT NOT NULL,
	PhoneNumber NVARCHAR(25) NOT NULL,
	PhoneNumberTypeID INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
);
GO

-- b
ALTER TABLE dbo.PersonPhone
	ADD CONSTRAINT PK_PersonPhones 
	PRIMARY KEY (BusinessEntityID, PhoneNumber);
GO

-- c
ALTER TABLE dbo.PersonPhone
	ADD PostalCode NVARCHAR(15),
	CONSTRAINT CHK_PostalCode CHECK (
		PostalCode NOT LIKE '%[a-zA-Z]%'
	);
GO

-- d
ALTER TABLE dbo.PersonPhone
	ADD CONSTRAINT DF_PersonPhone_PostalCode
		DEFAULT '0' FOR PostalCode;
GO

-- e
INSERT INTO dbo.PersonPhone(
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate
)
SELECT PersonPhone.BusinessEntityID, 
	PersonPhone.PhoneNumber,
	PersonPhone.PhoneNumberTypeID,
	PersonPhone.ModifiedDate
FROM Person.PersonPhone as PersonPhone
INNER JOIN Person.PhoneNumberType as PhoneNumberType
	ON PhoneNumberType.PhoneNumberTypeID = PersonPhone.PhoneNumberTypeID
		WHERE PhoneNumberType.Name = 'Cell';
GO

-- f
ALTER TABLE dbo.PersonPhone
	ALTER COLUMN PhoneNumberTypeID BIGINT NULL;
GO





