SELECT d.Name AS [Department], e.JobTitle, AVG(Salary) AS [Average Salary] FROM Employees e
JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle