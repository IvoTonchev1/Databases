USE Bank
GO

CREATE PROC dbo.usp_SelectFullName
AS
SELECT FirstName + ' ' + Lastname AS [Full Name] FROM Persons
GO

EXEC usp_SelectFullName