SELECT d.DepartmentId, d.Name, e.FirstName + ' ' + e.LastName AS [Manager Name]
FROM Departments d
JOIN Employees e
ON D.ManagerID = E.EmployeeID