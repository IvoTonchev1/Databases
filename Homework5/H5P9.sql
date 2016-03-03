SELECT d.Name AS [Department], AVG(Salary) AS [Average Salary] FROM Employees e
JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.Name
ORDER BY d.Name