--- task 1
select TeamName from Teams
order by TeamName asc

--- task 2
select top 50 CountryName, Population from Countries
order by Population desc

--- task 3
select CountryName, CountryCode, case when CurrencyCode = 'EUR' then 'Inside' else 'Outside' end as [Eurozone] from Countries
order by CountryName asc

--- task 4
select TeamName as [Team Name], CountryCode as [Country Code] from Teams
where TeamName like '%[0-9]%'
order by CountryCode asc

--- task 5
select k.CountryName as [Home Team], c.CountryName as [Away Team], im.MatchDate as [Match Date] from Countries c
join InternationalMatches im on c.CountryCode = im.AwayCountryCode
join Countries k on k.CountryCode = im.HomeCountryCode
order by MatchDate desc

--- task 6
select t.TeamName as [Team Name], l.LeagueName as [League], (case when l.CountryCode is null then 'International' else c.CountryName end) as [League Country] from Teams t
join Leagues_Teams lt on t.Id = lt.TeamId
join Leagues l on lt.LeagueId = l.Id
left join Countries c on l.CountryCode = c.CountryCode
order by t.TeamName asc, l.LeagueName

--- task 7
select t.TeamName as [Team], count(t.Id) as [Matches Count] from Teams t
join TeamMatches tm on t.Id = tm.AwayTeamId or t.Id = tm.HomeTeamId
group by t.TeamName
having count(t.id) > 1
order by t.TeamName asc

--- task 8
select l.LeagueName as [League Name], count(distinct lt.TeamId) as [Teams], count(distinct tm.Id) as [Matches], isnull(AVG(tm.AwayGoals + tm.HomeGoals), 0) as [Average Goals]
from Leagues l
left join Leagues_Teams lt on l.Id = lt.LeagueId
left join TeamMatches tm on l.Id = tm.LeagueId
group by l.LeagueName
order by [Teams] desc, [Matches] desc

--- task 9
select t.TeamName, isnull(sum(tm1.HomeGoals), 0) + isnull(sum(tm2.AwayGoals), 0) as [Total Goals] from Teams t
left join TeamMatches tm1 on tm1.HomeTeamId = t.Id
left join TeamMatches tm2 on tm2.AwayTeamId = t.Id
group by t.TeamName
order by [Total Goals] desc, t.TeamName

--- task 10
select tm1.MatchDate as [First Date], tm2.MatchDate as [Second Date] from TeamMatches tm1, TeamMatches tm2
where (tm2.MatchDate > tm1.MatchDate) and (datediff(day, tm1.MatchDate, tm2.MatchDate) < 1)
order by [First Date] desc, [Second Date] desc

--- task 11
select lower(substring(t.TeamName, 1, len(t.TeamName) - 1) + reverse(m.TeamName)) as [Mix] from Teams t, Teams m
where right(t.TeamName, 1) = right(m.TeamName, 1)
order by Mix asc

--- task 12
select c.CountryName as [Country Name], count(distinct im.Id) as [International Matches], count(distinct tm.Id) as [Team Matches]
from Countries c
left join InternationalMatches im on c.CountryCode = im.AwayCountryCode or c.CountryCode = im.HomeCountryCode
left join Leagues l on l.CountryCode = c.CountryCode
left join TeamMatches tm on tm.LeagueId = l.Id 
group by c.CountryName
HAVING (COUNT(DISTINCT im.Id)) > 0 OR (COUNT(DISTINCT tm.Id) > 0)
order by [International Matches] desc, [Team Matches] desc, c.CountryName asc 


--- task 13
create table FriedlyMatches(
	Id int Primary Key Identity Not null,
	HomeTeamId int not null,
	AwayTeamId int not null,
	MatchDate datetime null)
GO

alter table FriedlyMatches with check Add constraint
FK_FriedlyMatches_Teams_HomeTeam Foreign Key (HomeTeamId) references Teams (Id)
GO

alter table FriedlyMatches with check add constraint
FK_FrienlyMatches_Teams_AwayTeam Foreign key (AwayTeamId) references Teams (Id)
GO

INSERT INTO Teams(TeamName) VALUES
 ('US All Stars'),
 ('Formula 1 Drivers'),
 ('Actors'),
 ('FIFA Legends'),
 ('UEFA Legends'),
 ('Svetlio & The Legends')
GO

INSERT INTO FriedlyMatches(
  HomeTeamId, AwayTeamId, MatchDate) VALUES
  
((SELECT Id FROM Teams WHERE TeamName='US All Stars'), 
 (SELECT Id FROM Teams WHERE TeamName='Liverpool'),
 '30-Jun-2015 17:00'),
 
((SELECT Id FROM Teams WHERE TeamName='Formula 1 Drivers'), 
 (SELECT Id FROM Teams WHERE TeamName='Porto'),
 '12-May-2015 10:00'),
 
((SELECT Id FROM Teams WHERE TeamName='Actors'), 
 (SELECT Id FROM Teams WHERE TeamName='Manchester United'),
 '30-Jan-2015 17:00'),

((SELECT Id FROM Teams WHERE TeamName='FIFA Legends'), 
 (SELECT Id FROM Teams WHERE TeamName='UEFA Legends'),
 '23-Dec-2015 18:00'),

((SELECT Id FROM Teams WHERE TeamName='Svetlio & The Legends'), 
 (SELECT Id FROM Teams WHERE TeamName='Ludogorets'),
 '22-Jun-2015 21:00')

GO

select t1.TeamName as [Home Team], t2.TeamName as [Away Team], fm.MatchDate as [Match Date] from FriedlyMatches fm
join Teams t1 on t1.Id = fm.HomeTeamId
join Teams t2 on t2.Id = fm.AwayTeamId
Union
select t1.TeamName as [Home Team], t2.TeamName as [Away Team], tm.MatchDate as [Match Date] from TeamMatches tm
join Teams t1 on t1.Id = tm.HomeTeamId
join Teams t2 on t2.Id = tm.AwayTeamId
order by [Match Date] desc


--- task 14
alter table Leagues add IsSeasonal bit not null default 0

insert into TeamMatches(HomeTeamId, AwayTeamId, HomeGoals, AwayGoals, MatchDate, LeagueId)
values 
((select Id from Teams where TeamName = 'Empoli'), (select Id from Teams where TeamName = 'Parma'),
 2, 2, '19-Apr-2015 16:00', (select Id from Leagues where LeagueName = 'Italian Serie A')),

((select Id from Teams where TeamName = 'Internazionale'), (select Id from Teams where TeamName = 'AC Milan'),
 0, 0, '19-Apr-2015 21:45', (select Id from Leagues where LeagueName = 'Italian Serie A'))

GO

update Leagues
set IsSeasonal = 1
where id in (select l.Id from Leagues l
			 join TeamMatches tm on l.Id = tm.LeagueId
			 group by l.Id
			 having  count(tm.Id) > 0)

SELECT 
	t1.TeamName AS [Home Team],
	tm.HomeGoals AS [Home Goals],
	t2.TeamName AS [Away Team],
	tm.AwayGoals AS [Away Goals],
	l.LeagueName AS [League Name]
FROM TeamMatches tm
JOIN Leagues l ON l.Id = tm.LeagueId
JOIN Teams t1 ON tm.HomeTeamId = t1.Id
JOIN Teams t2 ON tm.AwayTeamId = t2.Id
WHERE tm.MatchDate > '10-Apr-2015'
ORDER BY [League Name], [Home Goals] DESC, [Away Goals] DESC


--- task 15
CREATE FUNCTION fn_TeamsJSON()
	RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @json NVARCHAR(MAX) = '{"teams":['

	DECLARE teamsCursor CURSOR FOR
	SELECT Id, TeamName FROM Teams
	WHERE CountryCode = 'BG'
	ORDER BY TeamName

	OPEN teamsCursor
	DECLARE @TeamName NVARCHAR(MAX)
	DECLARE @TeamId INT
	FETCH NEXT FROM teamsCursor INTO @TeamId, @TeamName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @json = @json + '{"name":"' + @TeamName + '","matches":['

		DECLARE matchesCursor CURSOR FOR
		SELECT t1.TeamName, t2.TeamName, HomeGoals, AwayGoals, MatchDate FROM TeamMatches
		LEFT JOIN Teams t1 ON t1.Id = HomeTeamId
		LEFT JOIN Teams t2 ON t2.Id = AwayTeamId
		WHERE HomeTeamId = @TeamId OR AwayTeamId = @TeamId
		ORDER BY TeamMatches.MatchDate DESC

		OPEN matchesCursor
		DECLARE @HomeTeamName NVARCHAR(MAX)
		DECLARE @AwayTeamName NVARCHAR(MAX)
		DECLARE @HomeGoals INT
		DECLARE @AwayGoals INT
		DECLARE @MatchDate DATE
		FETCH NEXT FROM matchesCursor INTO @HomeTeamName, @AwayTeamName, @HomeGoals, @AwayGoals, @MatchDate
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @json = @json + '{"' + @HomeTeamName + '":' + CONVERT(NVARCHAR(MAX), @HomeGoals) + ',"' + 
						@AwayTeamName + '":' + CONVERT(NVARCHAR(MAX), @AwayGoals) + 
						',"date":' + CONVERT(NVARCHAR(MAX), @MatchDate, 103) + '}'
			FETCH NEXT FROM matchesCursor INTO @HomeTeamName, @AwayTeamName, @HomeGoals, @AwayGoals, @MatchDate
			IF @@FETCH_STATUS = 0
				SET @json = @json + ','
		END
		CLOSE matchesCursor
		DEALLOCATE matchesCursor	
		SET @json = @json + ']}'

		FETCH NEXT FROM teamsCursor INTO @TeamId, @TeamName
		IF @@FETCH_STATUS = 0
			SET @json = @json + ','
	END
	CLOSE teamsCursor
	DEALLOCATE teamsCursor

	SET @json = @json + ']}'
	RETURN @json
END
GO

SELECT dbo.fn_TeamsJSON()