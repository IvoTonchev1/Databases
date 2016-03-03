--- task 1
select PeakName from Peaks
order by PeakName asc

--- task 2
select top 30 CountryName, Population from Countries
where ContinentCode = 'EU'
order by Population desc, CountryName asc

--- task 3
select CountryName, CountryCode, isnull(case when CurrencyCode = 'EUR' then 'Euro' else 'Not Euro' end, 'Not Euro') as [Currency] from Countries
order by CountryName asc, CountryCode asc

--- task 4
select CountryName as [Country Name], IsoCode as [ISO Code] from Countries
where CountryName like '%a%a%a%'
order by IsoCode asc

--- task 5
select p.PeakName, m.MountainRange as [Mountain], p.Elevation from Peaks p
join Mountains m on p.MountainId = m.Id
order by p.Elevation desc, p.PeakName asc

--- task 6
select p.PeakName, m.MountainRange as [Mountain], c.CountryName, con.ContinentName from Peaks p
join Mountains m on p.MountainId = m.Id
join MountainsCountries mt on mt.MountainId = m.Id
join Countries c on mt.CountryCode = c.CountryCode
join Continents con on c.ContinentCode = con.ContinentCode
order by p.PeakName asc, c.CountryName asc

--- task 7
select r.RiverName as [River], COUNT(c.CountryCode) as [Countries Count] from Rivers r
join CountriesRivers cr on r.Id = cr.RiverId
join Countries c on cr.CountryCode = c.CountryCode
group by r.RiverName
having COUNT(c.CountryCode) > 2
order by r.RiverName asc

--- task 8
select MAX(Elevation) as [MaxElevation], MIN(Elevation) as [MinElevation], AVG(Elevation) as [AverageElevation] from Peaks

--- task 9
select c.CountryName, con.ContinentName, COUNT(r.Id) as [RiversCount], isnull(SUM(r.Length), 0) as [TotalLength] from Countries c
left join Continents con on c.ContinentCode = con.ContinentCode
left join CountriesRivers cr on cr.CountryCode = c.CountryCode
left join Rivers r on r.Id = cr.RiverId
group by c.CountryName, con.ContinentName
order by RiversCount desc, TotalLength desc, c.CountryName asc

--- task 10
select cur.CurrencyCode, cur.Description as [Currency], COUNT(c.CurrencyCode) as [NumberOfCountries] from Currencies cur
left join Countries c on c.CurrencyCode = cur.CurrencyCode
group by cur.CurrencyCode, cur.Description
order by NumberOfCountries desc, cur.Description asc

--- task 11
select con.ContinentName, sum(c.AreaInSqKm) as [CountriesArea], sum(cast(c.Population as bigint)) as [CountriesPopulation] from Continents con
join Countries c on c.ContinentCode = con.ContinentCode
group by con.ContinentName
order by CountriesPopulation desc

--- task 12
select c.CountryName, MAX(p.Elevation) as [HighestPeakElevation], MAX(r.Length) as [LongestRiverLength] from Countries c
left join MountainsCountries mt on c.CountryCode = mt.CountryCode
left join Mountains m on m.Id = mt.MountainId
left join Peaks p on p.MountainId = m.Id
left join CountriesRivers cr on cr.CountryCode = c.CountryCode
left join Rivers r on r.Id = cr.RiverId
group by c.CountryName
order by HighestPeakElevation desc, LongestRiverLength desc, c.CountryName asc

--- task 13
select p.PeakName, r.RiverName, lower(substring(p.PeakName, 1, len(p.PeakName) - 1) + r.RiverName) as [Mix] from Peaks p, rivers r
where right(p.PeakName, 1) = left(r.RiverName, 1)
order by Mix asc

--- task 14
SELECT
  c.CountryName AS [Country],
  p.PeakName AS [Highest Peak Name],
  p.Elevation AS [Highest Peak Elevation],
  m.MountainRange AS [Mountain]
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
WHERE p.Elevation =
  (SELECT MAX(p.Elevation)
   FROM MountainsCountries mc
     LEFT JOIN Mountains m ON m.Id = mc.MountainId
     LEFT JOIN Peaks p ON p.MountainId = m.Id
   WHERE c.CountryCode = mc.CountryCode)
UNION
SELECT
  c.CountryName AS [Country],
  '(no highest peak)' AS [Highest Peak Name],
  0 AS [Highest Peak Elevation],
  '(no mountain)' AS [Mountain]
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
WHERE 
  (SELECT MAX(p.Elevation)
   FROM MountainsCountries mc
     LEFT JOIN Mountains m ON m.Id = mc.MountainId
     LEFT JOIN Peaks p ON p.MountainId = m.Id
   WHERE c.CountryCode = mc.CountryCode) IS NULL
ORDER BY c.CountryName, [Highest Peak Name]


--- task 15
create table Monasteries(
	Id int primary key identity not null,
	Name nvarchar(200) not null,
	CountryCode Char(2) not null)
GO

alter table Monasteries with check add constraint
	FK_Monasteries_Countries foreign key(CountryCode) references Countries(CountryCode)
GO

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

alter table Countries
add IsDeleted bit not null
default 0

update Countries
set IsDeleted = 1
where CountryCode in (select c.CountryCode from Countries c
						join CountriesRivers cr on cr.CountryCode = c.CountryCode
						join Rivers r on r.Id = cr.RiverId
						group by c.CountryCode
						having count(r.id) > 3)

select m.Name as [Monastery], c.CountryName as [Country] from Monasteries m
join Countries c on c.CountryCode = m.CountryCode
where c.IsDeleted = 0
order by m.Name


--- task 16
Update Countries
set CountryName = 'Burma'
where CountryName = 'Myanmar'

Insert into Monasteries(Name, CountryCode)
Values ('Hanga Abbey', (select CountryCode from Countries where CountryName = 'Tanzania'))
INSERT INTO Monasteries(Name, CountryCode) VALUES
('Myin-Tin-Daik', (SELECT CountryCode FROM Countries WHERE CountryName = 'Myanmar'))

select con.ContinentName, c.CountryName, COUNT(m.Id) as [MonasteriesCount] from Continents con
left join Countries c on c.ContinentCode = con.ContinentCode
left join Monasteries m on m.CountryCode = c.CountryCode
group by con.ContinentName, c.CountryName, c.IsDeleted
having c.IsDeleted = 0
order by MonasteriesCount desc, c.CountryName asc


--- task 17
CREATE FUNCTION fn_MountainsPeaksJSON()
	RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @json NVARCHAR(MAX) = '{"mountains":['

	DECLARE montainsCursor CURSOR FOR
	SELECT Id, MountainRange FROM Mountains

	OPEN montainsCursor
	DECLARE @mountainName NVARCHAR(MAX)
	DECLARE @mountainId INT
	FETCH NEXT FROM montainsCursor INTO @mountainId, @mountainName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @json = @json + '{"name":"' + @mountainName + '","peaks":['

		DECLARE peaksCursor CURSOR FOR
		SELECT PeakName, Elevation FROM Peaks
		WHERE MountainId = @mountainId

		OPEN peaksCursor
		DECLARE @peakName NVARCHAR(MAX)
		DECLARE @elevation INT
		FETCH NEXT FROM peaksCursor INTO @peakName, @elevation
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @json = @json + '{"name":"' + @peakName + '",' +
				'"elevation":' + CONVERT(NVARCHAR(MAX), @elevation) + '}'
			FETCH NEXT FROM peaksCursor INTO @peakName, @elevation
			IF @@FETCH_STATUS = 0
				SET @json = @json + ','
		END
		CLOSE peaksCursor
		DEALLOCATE peaksCursor
		SET @json = @json + ']}'

		FETCH NEXT FROM montainsCursor INTO @mountainId, @mountainName
		IF @@FETCH_STATUS = 0
			SET @json = @json + ','
	END
	CLOSE montainsCursor
	DEALLOCATE montainsCursor

	SET @json = @json + ']}'
	RETURN @json
END
GO

SELECT dbo.fn_MountainsPeaksJSON()


