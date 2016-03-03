SELECT em.Town, COUNT(*) AS [Number of managers] 
FROM (SELECT DISTINCT e.EmployeeID, t.Name AS [Town]
		FROM Employees e
		JOIN Employees m
		ON m.ManagerID = e.EmployeeID
		JOIN Addresses a
		ON e.AddressID = a.AddressID
		JOIN Towns t
		ON a.TownID = t.TownID) em
GROUP BY em.Town