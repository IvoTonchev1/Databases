UPDATE Groups 
SET Name = 'Tosho' 
WHERE Name = 'Gosho' 
 
UPDATE Users 
SET UserName = 'Tosho', GroupId = 2 
WHERE UserName = 'Gosho'

UPDATE Users
SET FullName = 'Tosho Toshev'
WHERE FullName = 'Gosho Goshev'
