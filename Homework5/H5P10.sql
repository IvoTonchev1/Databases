SELECT t.Name AS [Town], d.Name AS [Department], COUNT(*) AS [Employees Count] FROM Employees e
JOIN Departments d
ON e.DepartmentID = d.DepartmentID
JOIN Addresses a
ON e.AddressID = a.AddressID
JOIN Towns t
ON a.TownID = t.TownID
GROUP BY d.DepartmentID, d.Name, t.Name
ORDER By d.Name