USE Bank
GO

CREATE PROC usp_SelectPersonsRicherThan(@amount money)
AS
SELECT p.FirstName + ' ' + p.Lastname AS [Full Name], SUM(a.Balance) AS [Sum] FROM Persons p
JOIN Accounts a
ON p.Id = a.PersonId
GROUP BY a.PersonId, p.FirstName, p.Lastname
HAVING SUM(a.Balance) >= @amount
GO

EXEC usp_SelectPersonsRicherThan 5000