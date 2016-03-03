CREATE TABLE WorkHours(
	Id INT PRIMARY KEY Identity NOT NULL,
	Date datetime NULL,
	Task nvarchar(100) NOT NULL,
	Hours INT NOT NULL,
	Comments ntext NULL,
	EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID) NOT NULL)
GO