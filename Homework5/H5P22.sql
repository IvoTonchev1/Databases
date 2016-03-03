INSERT INTO Users
SELECT LOWER(LEFT(FirstName,1) + LastName + RIGHT(FirstName,1)) AS UserName,
LOWER(LEFT(FirstName,1) + LastName + '1111') AS Password,
FirstName + ' ' + LastName AS FullName,
NULL AS LastLoginDate,
1 AS GroupId
FROM Employees