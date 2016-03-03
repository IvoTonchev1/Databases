USE Bank
GO

CREATE TABLE Logs(
	LogId INT PRIMARY KEY IDENTITY NOT NULL,
	AccountId INT NOT NULL,
	OldSum money NULL,
	NewSum money NULL)
GO 

 
CREATE TRIGGER tr_BankAccountsChange ON Accounts 
FOR UPDATE 
AS 
INSERT INTO dbo.Logs (AccountId, NewSum, OldSum) 
	SELECT 
		d.Id, 
		i.Balance, 
		d.Balance 
	FROM INSERTED i 
		JOIN DELETED d 
			ON d.Id = i.Id 
GO 
