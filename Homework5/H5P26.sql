SELECT d.Name AS [Department], e.JobTitle AS [Job Title], MIN(e.FirstName) AS [First Name], MIN(Salary) AS [Min Salary]
FROM Employees e
JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle
ORDER BY d.Name
