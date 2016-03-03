--- task 1
select Name from Characters
order by Name asc

--- task 2
select top 50 Name as [Game], convert(date, Start, 120) as [Start] from Games
where Start between '2011-01-01 00:00:00.000' and '2013-01-01 00:00:00.000'
order by Start asc, Name asc

--- task 3
select Username, right(Email, len(Email) - charindex('@', Email)) as [Email Provider] from Users
order by [Email Provider] asc, Username asc

--- task 4
select Username, IpAddress as [IP Address] from Users
where IpAddress like '___.1%.%.___'
order by Username asc

--- task 5
select Name as [Game], case when DATEPART(HOUR, Start) between 0 and 11 then 'Morning' when  DATEPART(HOUR, Start) between 12 and 17 then 'Afternoon'
							 when DATEPART(HOUR, Start) between 18 and 24 then 'Evening' end 
							as [Part of the Day]
							,case when Duration <= 3 then 'Extra Short'
							 when (Duration between 4 and 6) then 'Short' 
							 when Duration > 6 then 'Long' else 'Extra Long' end as [Duration] from Games
order by Name asc, Duration asc, [Part of the Day] asc

--- task 6
select right(Email, len(Email) - charindex('@', Email)) as [Email Provider], count(*) as [Number Of Users] from Users
group by right(Email, len(Email) - charindex('@', Email))
order by [Number Of Users] desc, [Email Provider] asc

--- task 7
select g.Name as [Game], gt.Name as [Game Type], u.Username, ug.Level, ug.Cash, c.Name as [Character] from Games g
inner join GameTypes gt on g.GameTypeId = gt.Id
inner join UsersGames ug on ug.GameId = g.Id
inner join Users u on ug.UserId = u.Id
inner join Characters c on c.Id = ug.CharacterId
order by ug.Level desc, u.Username asc, g.Name asc

--- task 8
select u.Username, g.Name as [Game], count(ugt.ItemId) as [Items Count], sum(i.Price) as [Items Price] from Users u
left join UsersGames ug on ug.UserId = u.Id
left join Games g on g.Id = ug.GameId
left join UserGameItems ugt on ug.Id = ugt.UserGameId
left join Items i on i.Id = ugt.ItemId
group by u.Username, g.Name
having COUNT(ugt.ItemId) >= 10
order by [Items Count] desc, [Items Price] desc, u.Username asc

--- task 9
select u.Username, g.Name as [Game], c.Name as [Character], s.Strength + gt.BonusStatsId as [Strength], s.Defence + gt.BonusStatsId as [Defence],
		 s.Speed + gt.BonusStatsId as [Speed], s.Mind + gt.BonusStatsId as [Mind], s.Luck + gt.BonusStatsId as [Luck] from Users u
join UsersGames ug on ug.UserId = u.Id
join Games g on g.Id = ug.GameId
join Characters c on c.Id = ug.CharacterId
join UserGameItems ugi on ugi.UserGameId = ug.Id
join Items i on i.Id = ugi.ItemId
join [Statistics] s on s.Id = i.StatisticId
join GameTypes gt on gt.Id = g.GameTypeId
order by s.Strength desc, s.Defence desc, s.Speed desc, s.Mind desc, s.Luck desc


--- task 10
select i.Name, i.Price, i.MinLevel, s.Strength, s.Defence, s.Speed, s.Luck, s.Mind from Items i
join [Statistics] s on i.StatisticId = s.Id
where (s.Speed > (select avg(Speed) from [Statistics])) and (s.Mind > (select avg(Mind) from [Statistics])) and (s.Luck > (select avg(Luck) from [Statistics]))
order by i.Name asc

--- task 11
select i.Name as [Item], i.Price, i.MinLevel, gt.Name as [Forbidden Game Type] from Items i
left join GameTypeForbiddenItems gf on gf.ItemId = i.Id
left join GameTypes gt on gt.Id = gf.GameTypeId
order by [Forbidden Game Type] desc, i.Name asc

--- task 12
begin tran
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Blackguard')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Alex')) and (GameId = (select Id from Games where Name = 'Edinburgh'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Bottomless Potion of Amplification')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Alex')) and (GameId = (select Id from Games where Name = 'Edinburgh'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Eye of Etlich (Diablo III)')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Alex')) and (GameId = (select Id from Games where Name = 'Edinburgh'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Gem of Efficacious Toxin')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Alex')) and (GameId = (select Id from Games where Name = 'Edinburgh'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Golden Gorget of Leoric')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Alex')) and (GameId = (select Id from Games where Name = 'Edinburgh'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Hellfire Amulet')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Alex')) and (GameId = (select Id from Games where Name = 'Edinburgh'))))


update UsersGames
set Cash = '4702'
where (UserId = (select Id from Users where Username = 'Alex')) and (GameId = (select Id from Games where Name = 'Edinburgh'))
GO

select u.Username, g.Name, ug.Cash, i.Name as [Item Name] from Users u
join UsersGames ug on ug.UserId = u.Id
join Games g on g.Id = ug.GameId
join UserGameItems ugi on ugi.UserGameId = ug.Id
join Items i on i.Id = ugi.ItemId
where g.Name = 'Edinburgh'
order by [Item Name] asc

rollback tran

--- task 13


insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Ahavarion, Spear of Lycander')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Angelic Shard')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Axes')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Band of Hollow Whispers')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Belt of Transcendence')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Blessed of Haull')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Cluckeye')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Crashing Rain')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Crusader Shields')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Devil Tongue')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Earthshatter')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Eye of Etlich (Diablo III)')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Fire Walkers')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Frozen Blood')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Gem of Efficacious Toxin')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Gladiator Gauntlets')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Glowing Ore')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Gogok of Swiftness')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Halcyons Ascent')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Hellcat Waistguard')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Illusory Boots')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Last Breath')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Leonine Bow of Hashir')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Nutcracker')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Reapers Fear')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('The Crudest Boots')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('The Eye of the Storm')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('The Ninth Cirri Satchel')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('The Three Hundredth Spear')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('TragOul Coils')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Unbound Bolt')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Wall of Man')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))
insert into UserGameItems (ItemId, UserGameId)
values ((select Id from Items where Name in  ('Wildwood')),
		(select Id from UsersGames where (UserId = (select Id from Users where Username = 'Stamat')) and (GameId = (select Id from Games where Name = 'Safflower'))))

select i.Name as [Item Name] from Items i
join UserGameItems ugi on ugi.ItemId = i.Id
join UsersGames ug on ug.Id = ugi.UserGameId
join Games g on g.Id = ug.GameId
where g.Name = 'Safflower'
order by [Item Name] asc

select Name, MinLevel from Items
where MinLevel in (11, 12, 19, 20, 21)