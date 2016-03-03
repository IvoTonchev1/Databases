UPDATE Users
SET Password = NULL
WHERE LastLoginDate <= CAST('2013-10-03' AS smalldatetime)