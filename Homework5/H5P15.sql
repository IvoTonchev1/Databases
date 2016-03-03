CREATE TABLE Users (
	UserId INT Identity,
	UserName nvarchar(50) NOT NULL,
	[Password] nvarchar(50) NOT NULL,
	FullName nvarchar(50) NOT NULL,
	LastLoginDate smalldatetime,
	CONSTRAINT PK_Users PRIMARY KEY(UserId),
	CONSTRAINT UK_Users UNIQUE(UserName),
	CONSTRAINT chk_Password CHECK (LEN(Password) > 5))
GO
