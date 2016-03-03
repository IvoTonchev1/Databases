SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary BETWEEN (SELECT MIN(Salary) FROM Employees) AND (SELECT MIN(Salary) + (0.1 * MIN(Salary)) FROM Employees)