SELECT e.FirstName, e.LastName, m.[Employees count] FROM Employees e 
JOIN  
	(SELECT ManagerID, COUNT(ManagerID) AS [Employees count] FROM Employees 
	 GROUP BY ManagerID) m 
ON m.ManagerID = e.EmployeeID 
WHERE m.[Employees count] = 5
