USE Bank
GO

CREATE PROC usp_SelectAccountInterest(@accountId int, @interestRate money)
AS
DECLARE @oldSum money
SELECT @oldSum = Balance FROM Accounts
WHERE Id = @accountId

DECLARE @updatedSum money
SET @updatedSum = dbo.ufn_CalculateUpdatedBalance(@oldSum, @interestRate, 1)

SELECT @updatedSum - @oldSum AS [Monthly Interest]
GO

EXEC usp_SelectAccountInterest 8,5