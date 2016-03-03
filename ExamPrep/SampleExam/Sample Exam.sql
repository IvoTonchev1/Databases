--- task 1
select Title from Ads
order by title asc

--- task 2
select Title, Date from Ads
where Date between '2014-12-26 00:00:00.000' and '2015-01-01 23:59:59.000'
order by Date asc

--- task 3
select Title, Date, case when ImageDataURL is null then 'no' else 'yes' end as [Has Image] from Ads

--- task 4
select * from Ads
where (ImageDataURL is null) or (CategoryId is null) or (TownId is null)

--- task 5
select a.Title, t.Name as [Town] from Ads a
left outer join Towns t on a.TownId = t.Id

--- task 6
select a.Title, c.Name as [CategoryName], t.Name as [TownName], ad.Status from Ads a
left outer join Categories c on a.CategoryId = c.Id
left outer join Towns t on a.TownId = t.Id
left outer join AdStatuses ad on a.StatusId = ad.Id

--- task 7
select a.Title, c.Name as [CategoryName], t.Name as [TownName], ad.Status from Ads a
join Categories c on a.CategoryId = c.Id
join Towns t on a.TownId = t.Id
join AdStatuses ad on a.StatusId = ad.Id
where (t.Name in ('sofia', 'blagoevgrad', 'stara zagora')) and ad.Status = 'Published'
order by title asc

--- task 8
select MIN(Date) as [MinDate], MAX(Date) as [MaxDate] from Ads

--- task 9
select top 10 a.Title, a.Date, s.Status from Ads a
join AdStatuses s on a.StatusId = s.Id
order by a.Date desc

--- task 10
Declare @minyear int
set @minyear = year((select min(date) from Ads))
declare @minmonth int = month((select min(date) from Ads where year(date) = @minyear))
select a.Id, a.Title, a.Date, s.Status from Ads a
join AdStatuses s on a.StatusId = s.Id
where (s.Status not in ('Published')) and (year(a.Date) = @minyear) and (month(a.Date) = @minmonth)

--- task 11
select s.Status, COUNT(*) as [Count] from AdStatuses s
join Ads a on s.Id = a.StatusId
GROUP BY s.Status
Order by s.Status

--- task 12
select t.Name as [Town Name], s.Status, COUNT(*) as [Count] from Towns t
join Ads a on t.Id = a.TownId
join AdStatuses s on a.StatusId = s.Id
group by t.Name, s.Status
order by t.Name, s.Status

--- task 13
SELECT 
  MIN(u.UserName) as UserName, 
  COUNT(a.Id) as AdsCount,
  (CASE WHEN admins.UserName IS NULL THEN 'no' ELSE 'yes' END) AS IsAdministrator
FROM 
  AspNetUsers u
  LEFT JOIN Ads a ON u.Id = a.OwnerId
  LEFT JOIN (
    SELECT DISTINCT u.UserName
	FROM AspNetUsers u
	  LEFT JOIN AspNetUserRoles ur ON ur.UserId = u.Id
	  LEFT JOIN AspNetRoles r ON ur.RoleId = r.Id
	WHERE r.Name = 'Administrator'
  ) AS admins ON u.UserName = admins.UserName
GROUP BY OwnerId, u.UserName, admins.UserName
ORDER BY u.UserName

--- task 14
select COUNT(a.Id) as [AdsCount], isNull(t.Name, '(no town)') as [Town] from Ads a
left join Towns t on a.TownId = t.Id
group by t.Name
having count(a.Id) in (2, 3)
order by t.Name asc

--- task 15
select a.Date as [FirstDate], b.Date as [SecondDate] from Ads a, ads b
where b.Date > a.Date and Datediff(hour, a.Date, b.Date) < 12
order by a.Date, b.Date


--- task 16
create table Countries(
	Id int not null Primary Key Identity,
	Name nvarchar(100) Not Null)
GO

Alter table Towns add CountryId int
GO

Alter table Towns add Constraint FK_Towns_Countries
Foreign Key(CountryId) references Countries(Id)
GO 

INSERT INTO Countries(Name) VALUES ('Bulgaria'), ('Germany'), ('France')
UPDATE Towns SET CountryId = (SELECT Id FROM Countries WHERE Name='Bulgaria')
INSERT INTO Towns VALUES
('Munich', (SELECT Id FROM Countries WHERE Name='Germany')),
('Frankfurt', (SELECT Id FROM Countries WHERE Name='Germany')),
('Berlin', (SELECT Id FROM Countries WHERE Name='Germany')),
('Hamburg', (SELECT Id FROM Countries WHERE Name='Germany')),
('Paris', (SELECT Id FROM Countries WHERE Name='France')),
('Lyon', (SELECT Id FROM Countries WHERE Name='France')),
('Nantes', (SELECT Id FROM Countries WHERE Name='France'))

update Ads
set TownId = (select Id from Towns where Name = 'Paris')
where DATENAME(WEEKDAY, Date) = 'Friday'

update Ads
set TownId = (Select Id from Towns where Name = 'Hamburg')
where DATENAME(WEEKDAY, Date) = 'Thursday'

delete from Ads
from Ads a
join AspNetUsers u on a.OwnerId = u.Id
join AspNetUserRoles ur on u.Id = ur.UserId
join AspNetRoles r on ur.RoleId = r.Id
where r.Name = 'Partner'

Insert into Ads (Title, Text, Date, OwnerId, StatusId)
Values ('Free Book', 'Free C# Book', GETDATE(), (Select Id From AspNetUsers where UserName = 'Nakov'), (Select Id from AdStatuses where Status = 'Waiting Approval'))

select t.Name as [Town], c.Name as [Country], COUNT(a.Id) as [AdsCount] from Towns t
Full outer join Countries c on t.CountryId = c.Id
Full outer join Ads a on t.Id = a.TownId
GROUP BY t.Name, c.Name
Order by t.Name, c.Name


--- task 17
Create view AllAds
AS
select a.Id, a.Title, u.UserName as [Author], a.Date, t.Name as [Town], c.Name as [Category], s.Status from Ads a
left join Towns t on t.Id = a.TownId
left join Categories c on c.Id = a.CategoryId
left join AdStatuses s on s.Id = a.StatusId
left join AspNetUsers u on u.Id = a.OwnerId

select * from AllAds

create function fn_ListsUsersAds() 
	returns @tbl_UsersAds Table(
			UserName nvarchar(MAX),
			AdDates nvarchar(MAX))
AS
BEGIN
	DECLARE UsersCursor CURSOR FOR
		SELECT UserName FROM AspNetUsers
		ORDER BY UserName DESC;
	OPEN UsersCursor;
	DECLARE @username NVARCHAR(MAX);
	FETCH NEXT FROM UsersCursor INTO @username;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ads NVARCHAR(MAX) = NULL;
		SELECT
			@ads = CASE
				WHEN @ads IS NULL THEN CONVERT(NVARCHAR(MAX), Date, 112)
				ELSE @ads + '; ' + CONVERT(NVARCHAR(MAX), Date, 112)
			END
		FROM AllAds
		WHERE Author = @username
		ORDER BY Date;

		INSERT INTO @tbl_UsersAds
		VALUES(@username, @ads)
		
		FETCH NEXT FROM UsersCursor INTO @username;
	END;
	CLOSE UsersCursor;
	DEALLOCATE UsersCursor;
	RETURN;
END
GO

select * from fn_ListsUsersAds()