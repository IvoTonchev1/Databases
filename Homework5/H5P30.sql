INSERT INTO [dbo].[WorkHours](
            [Date],
            [Task],
            [Hours],
            [Comments],
			[EmployeeID])
     VALUES
           (GETDATE(),
            'task 1',
            3,
            'task 1 comment',
			2);

INSERT INTO [dbo].[WorkHours](
            [Date],
            [Task],
            [Hours],
            [Comments],
			[EmployeeID])
     VALUES
           (GETDATE(),
           'task 2',
           3,
           'task 2 comment',
		   4);

INSERT INTO [dbo].[WorkHours](
            [Date],
            [Task],
            [Hours],
            [Comments],
			[EmployeeID])
     VALUES
           (GETDATE(),
           'task 1',
           3,
           NULL,
		   2);

UPDATE WorkHours
SET Comments = 'No comment'
WHERE Comments IS NULL;


DELETE FROM WorkHours
WHERE EmployeeID = 4;
