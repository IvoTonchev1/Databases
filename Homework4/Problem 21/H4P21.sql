SELECT e.FirstName + ' ' + e.LastName AS [Employee Name], a.AddressText AS [Address], t.Name AS [Town], m.FirstName + ' ' + m.LastName AS [Manager Name]
FROM Employees e
INNER JOIN Employees m
ON e.ManagerID = m.EmployeeID
JOIN Addresses a
ON e.AddressID = a.AddressID
JOIN Towns t
ON a.TownID = t.TownID