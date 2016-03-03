SELECT e.FirstName + ' ' + e.LastName AS [Full Mame], a.AddressText AS [Address], t.Name AS [Town]
FROM Employees e, Addresses a, Towns t
WHERE e.AddressID = a.AddressID AND a.TownID = t.TownID