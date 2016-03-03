SELECT e.FirstName + e.LastName AS [Full Name], e.HireDate, d.Name AS [Department] FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE (d.Name IN ('Sales', 'Finance')) AND (e.HireDate BETWEEN '1995' AND '2005')