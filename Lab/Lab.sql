--- task 1
select Title from Questions
order by Title asc

--- task 2
select Content, CreatedOn from Answers
where CreatedOn >= '2012-06-15 00:00.000' and CreatedOn < '2013-03-22 00:00.000'
order by CreatedOn

--- task 3
select Username, LastName, case when PhoneNumber is null then 0 else 1 end as [Has Phone] from Users
order by LastName

--- task 4
select Title as [Question Title], u.Username as [Author] from Questions q
join Users u
on q.UserId = u.Id
order by [Question Title]

--- task 5
select top 50 a.Content as [Answer Content], a.CreatedOn, u.Username as [Answer Author], q.Title as [Question Title], c.Name as [Category Name] from Answers a
join Questions q
on q.Id = a.QuestionId
join Categories c
on q.CategoryId = c.Id
join Users u
on a.UserId = u.Id
order by [Category Name], [Answer Author], CreatedOn

--- task 6
select c.Name as [Category], q.Title as [Question], q.CreatedOn from Questions q
right join Categories c
on q.CategoryId = c.Id
order by Category, Question

--- task 7
select u.Id, u.Username, u.FirstName, u.PhoneNumber, u.RegistrationDate, u.Email from users u
left join Questions q
on u.Id = q.UserId
where (u.PhoneNumber is null) and (q.Id is null)
order by RegistrationDate

--- task 8
select MIN(CreatedOn) as [MinDate], MAX(CreatedOn) as [MaxDate] from Answers
where CreatedOn > '2012-01-01 00:00.000' and CreatedOn < '2015-01-01 00:00.000'

--- task 9
select top 10 a.Content as [Answer], a.CreatedOn, u.Username from Answers a
join Users u
on u.Id = a.UserId
order by a.CreatedOn desc

--- task 10
select a.Content as [Answer Content], q.Title as [Question], c.Name as [Category] from Answers a
join Questions q
on a.QuestionId = q.Id
join Categories c
on q.CategoryId = c.Id
where YEAR(a.CreatedOn) = (select MAX(YEAR(a.CreatedOn)) from Answers)
order by Category

--- task 11
select c.Name as [Category], COUNT(a.Id) as [Answers Count] from Categories c
left outer join Questions q
on q.CategoryId = c.Id
left outer join Answers a
on a.QuestionId = q.Id
group by c.Name
order by [Answers Count] desc

--- task 12
select c.Name as [Category], u.Username, u.PhoneNumber, COUNT(a.Id) as [Answers Count] from Categories c
left outer join Questions q
on q.CategoryId = c.Id
left outer join Answers a
on q.Id = a.QuestionId
left outer join Users u
on q.UserId = u.Id
group by c.Name, u.Username, u.PhoneNumber
having (u.PhoneNumber is not null)
order by [Answers Count], u.Username

--- task 14
Use Forum
GO

CREATE view AllQuestionsNew
as
select u.id as [UId], u.Username, u.FirstName, u.LastName, u.Email, u.PhoneNumber, u.RegistrationDate, q.Id as [QId], q.Title, q.Content, q.CategoryId, q.UserId, q.CreatedOn
from Users u
right outer join Questions q on u.Id = q.UserId

select * from AllQuestionsNew


CREATE function fn_ListUsersQuestions() returns table
(UserName nvarchar(100) Not null,
Questions ntext not null)
AS
Begin
	insert 
	select Username, Title as [Questions] from AllQuestionsNew
	group by Username
	order by Username asc, Title desc
end
