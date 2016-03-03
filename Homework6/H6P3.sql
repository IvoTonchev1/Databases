CREATE FUNCTION ufn_CalculateUpdatedBalance(@sum money, @yearlyInterestRate money, @months int) RETURNS money
AS
BEGIN
	DECLARE @monthlyInterestRate money 
	SET @monthlyInterestRate = @yearlyInterestRate / 12 
	RETURN @sum * (1 + @months * @monthlyInterestRate / 100) 
END
GO

SELECT FirstName + ' ' + LastName AS [Full Name], 
dbo.ufn_CalculateUpdatedBalance(a.Balance, 5, 24) AS FutureSum 
FROM Persons p 
JOIN Accounts a 
ON a.PersonId = p.Id 

