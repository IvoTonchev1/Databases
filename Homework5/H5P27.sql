SELECT TOP 1 t.Name AS [Name], COUNT(t.TownId) AS [Number of employees] FROM Employees e
JOIN Addresses a
ON e.AddressID = a.AddressID
JOIN Towns t
ON a.TownID = t.TownID
GROUP BY t.Name, t.TownID
ORDER BY [Number of employees] DESC