CREATE TABLE Groups (
	GroupId INT Identity,
	Name nvarchar(100) NOT NULL,
	CONSTRAINT PK_Groups PRIMARY KEY(GroupId),
	CONSTRAINT UK_Groups UNIQUE(Name))

GO