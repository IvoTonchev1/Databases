USE Bank
GO

CREATE PROC usp_SelectWithdrawMoney(@accountId int, @sum money)
AS
DECLARE @oldSum money 
SELECT 	@oldSum = Balance 
FROM Accounts 
WHERE Id = @accountId

IF (@sum < 0)
	BEGIN
		RAISERROR('You cannot withdraw negative amount', 16, 1)
	END
IF (@sum > @oldSum)
	BEGIN
		RAISERROR('Your balance is not sufficient', 16, 1)
	END

UPDATE Accounts
SET Balance = Balance - @sum
WHERE Accounts.Id = @accountId

GO

EXEC usp_SelectWithdrawMoney 8, 100
SELECT * FROM Accounts


GO

CREATE PROC usp_SelectDepositMoney(@accountId int, @sum money)
AS
DECLARE @oldSum money 
SELECT 	@oldSum = Balance 
FROM Accounts 
WHERE Id = @accountId

IF (@sum < 0)
	BEGIN
		RAISERROR('You cannot deposit negative amount', 16, 1)
	END

UPDATE Accounts
SET Balance = Balance + @sum
WHERE Accounts.Id = @accountId

GO

EXEC usp_SelectDepositMoney 8, 200
SELECT * FROM Accounts