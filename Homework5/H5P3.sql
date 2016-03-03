SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary, d.Name AS [Department Name] FROM Employees e
JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE Salary =  
	(SELECT MIN(Salary) FROM Employees
	 WHERE e.DepartmentID = DepartmentID)
ORDER BY d.DepartmentID