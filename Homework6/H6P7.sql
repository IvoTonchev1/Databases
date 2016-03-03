USE SoftUni
GO

CREATE FUNCTION ufn_LetterCheck(@text nvarchar(200), @word nvarchar(200)) RETURNS INT
BEGIN
	DECLARE @char nvarchar(1)
	DECLARE @wcount int, @index int, @len int 
	SET @wcount= 0 
	SET @index = 1 
	SET @len= LEN(@word) 
 
	WHILE @index <= @len 
		BEGIN 
			set @char = SUBSTRING(@word, @index, 1) 
 
			if CHARINDEX(@char, @text) = 0 
				BEGIN 
					RETURN 0 
				END 
 
			SET @index = @index+ 1 
		END 
 
		RETURN 1 
	END 
GO 


DECLARE empCursor CURSOR READ_ONLY FOR 
	(SELECT e.FirstName, e.LastName, t.Name 
 	FROM Employees e 
	JOIN Addresses a 
	ON a.AddressID = e.AddressID 
	JOIN Towns t 
	ON t.TownID = a.TownID) 
 
OPEN empCursor 
DECLARE @firstName char(50), @lastName char(50), @town char(50), @string char(50) 
FETCH NEXT FROM empCursor INTO @firstName, @lastName, @town 

SET @string = 'oistmiahf' 
 
WHILE @@FETCH_STATUS = 0 
    BEGIN 
    FETCH NEXT FROM empCursor INTO @firstName, @lastName, @town 
	IF dbo.ufn_LetterCheck(@string, @firstName) = 1 
		BEGIN 
			print @firstName 
		END	 
	IF dbo.ufn_LetterCheck(@string, @lastName) = 1 
		BEGIN 
			print @lastName 
		END	 
	IF dbo.ufn_LetterCheck(@string, @town) = 1 
		BEGIN 
			print @town 
		END	 
    END  
 
CLOSE empCursor 
DEALLOCATE empCursor 
