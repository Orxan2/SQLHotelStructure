CREATE DATABASE Hotel

USE Hotel
CREATE TABLE RoomTypes
(
Id int primary key identity,
RoomType nvarchar(50),
RoomPrice decimal(10,2)
)

CREATE TABLE Rooms
(
Id int primary key identity,
Room nvarchar(50),
RoomTypeId int FOREIGN KEY REFERENCES RoomTypes(Id),
RentPrice decimal(10,2),
IsTaken bit DEFAULT('False'),
)

CREATE TABLE Spendings
(
Id int primary key identity,
Foods decimal(10,2),
Sauna decimal(10,2),
OtherServices decimal(10,2),
TotalPrice decimal(10,2)
)

CREATE TABLE PaymentTypes
(
Id int primary key identity,
PaymentType nvarchar(50)
)
CREATE TABLE Payments
(
Id int primary key identity,
PaymentTypeId int FOREIGN KEY REFERENCES PaymentTypes(Id)
)
CREATE TABLE VisaTypes
(
Id int primary key identity,
VisaType nvarchar(50)
)

CREATE TABLE Customers
(
Id int primary key identity,
[Name] nvarchar(50),
[Surname] nvarchar(50),
[Age] int,
[Job] nvarchar(50),
[CreatedDate] datetime DEFAULT DATEADD(HOUR,4,GETUTCDATE()),
[HowLong] datetime,
[IsForeign] bit DEFAULT('False'),
)

CREATE TABLE WaitingCustomers
(
Id int primary key identity,
[Name] nvarchar(50),
[Surname] nvarchar(50),
[Age] int,
[Job] nvarchar(50),
[CreatedDate] datetime DEFAULT DATEADD(HOUR,4,GETUTCDATE()),
[WaitingTo] datetime,
[IsForeign] bit DEFAULT('False'),
VisaTypeId int FOREIGN KEY REFERENCES VisaTypes(Id),
)
CREATE TABLE Reservations
(
Id int primary key identity,
CustomerId int FOREIGN KEY REFERENCES Customers(Id),
RoomId int FOREIGN KEY REFERENCES Rooms(Id),
SpendingId int FOREIGN KEY REFERENCES Spendings(Id),
PaymentId int FOREIGN KEY REFERENCES Payments(Id),
)

INSERT INTO RoomTypes
VALUES('Single',300),('Double',350),('Triple',420),('Quad',500),('Queen',720.50),('King',1000)

INSERT INTO Rooms(Room,RoomTypeId,RentPrice)
VALUES('S1',1,300),('Q2',5,800),('D1',2,300),('Q1',4,600),('T1',3,420),('K1',6,1000)

INSERT INTO PaymentTypes
VALUES('Cash'),('Card')

INSERT INTO Payments
VALUES(1),(2),(2)

INSERT INTO VisaTypes
VALUES('Tourism'),('Sport'),('Personal'),('Education'),('Work')

INSERT INTO Customers(Name,Surname,Age,Job,HowLong)
VALUES('Orxan',N'İbrahimli',22,'Magistr',DATEADD(DAY,7,GETUTCDATE()))

INSERT INTO Customers(Name,Surname,Age,Job,HowLong)
VALUES('Clint','Edwards',36,'Polis',DATEADD(DAY,4,GETUTCDATE()))

INSERT INTO Customers(Name,Surname,Age,Job,HowLong)
VALUES('Elxan',N'Kərimli',56,N'Həkim',DATEADD(WEEK,3,GETUTCDATE())),
(N'Tərlan','Abbasov',25,N'Müəllim',DATEADD(WEEK,3,GETUTCDATE()))

INSERT INTO Customers(Name,Surname,Age,Job,HowLong)
VALUES('John','Baker',23,'İdmançı',DATEADD(DAY,5,GETUTCDATE())),
('Selena','Fierce',19,'Model',DATEADD(WEEK,2,GETUTCDATE()))

INSERT INTO WaitingCustomers(Name,Surname,Age,Job,WaitingTo)
VALUES(N'Aytən',N'Alıyeva',26,N'Həkim',DATEADD(WEEK,2,GETUTCDATE())),
(N'Teymur','Eminov',18,N'Tələbə',DATEADD(DAY,7,GETUTCDATE()))

INSERT INTO WaitingCustomers(Name,Surname,Age,Job,WaitingTo,IsForeign,VisaTypeId)
VALUES('Min Jae','Kim',24,'İdmançı',DATEADD(DAY,5,GETUTCDATE()),'True',2),
('Gabriela','Lima',27,'Aktrisa',DATEADD(WEEK,5,GETUTCDATE()),'True',3),
('Bart','Deaken',54,'Alim',DATEADD(DAY,4,GETUTCDATE()),'True',3)

INSERT INTO Spendings
VALUES(45.99,60,25,130.99),
(50,85,30,165),
(30,70,20,120),
(50,60,30,140),
(20,90,20,130),
(30,40,50,120)

INSERT INTO Reservations(CustomerId,RoomId,SpendingId,PaymentId)
VALUES(1,4,2,1),
(4,1,4,1),
(3,6,6,1)

INSERT INTO Reservations(CustomerId,RoomId,SpendingId,PaymentId)
VALUES(2,3,1,2),
(6,2,3,1),
(5,5,5,2)

CREATE VIEW CallCustomers
AS
Select c.Name,c.Surname,c.Age,c.Job,rm.Room,rt.RoomType,rt.RoomPrice [Room Price], rm.RentPrice [Room Rented Price], s.TotalPrice [Spendings],pt.PaymentType FROM Reservations re
JOIN Rooms rm
ON rm.Id = re.RoomId
JOIN RoomTypes rt
ON rm.RoomTypeId = rt.Id
JOIN Payments p
ON re.PaymentId = p.Id
JOIN PaymentTypes pt
ON p.PaymentTypeId = pt.Id
JOIN Spendings s
ON re.SpendingId = s.Id
JOIN Customers c
ON re.CustomerId = c.Id

SELECT * FROM CallCustomers

CREATE VIEW CallForeignCustomers
AS
SELECT wc.[Name],wc.Surname,wc.Age,wc.Job,wc.IsForeign,vt.VisaType,wc.WaitingTo,wc.CreatedDate FROM WaitingCustomers wc
JOIN VisaTypes vt
ON wc.VisaTypeId = vt.Id

SELECT * FROM CallForeignCustomers 

CREATE PROCEDURE CallCustomersPayCash @cash nvarchar(50)
AS
Select c.Name,c.Surname,c.Age,c.Job,rm.Room,rt.RoomType,rt.RoomPrice [Room Price],rm.RentPrice [Room Rented Price],s.TotalPrice [Spendings],pt.PaymentType FROM Reservations re
JOIN Rooms rm
ON rm.Id = re.RoomId
JOIN RoomTypes rt
ON rm.RoomTypeId = rt.Id
JOIN Payments p
ON re.PaymentId = p.Id
JOIN PaymentTypes pt
ON p.PaymentTypeId = pt.Id
JOIN Spendings s
ON re.SpendingId = s.Id
JOIN Customers c
ON re.CustomerId = c.Id
WHERE pt.PaymentType = @cash

EXEC CallCustomersPayCash 'Cash'

EXEC CallCustomersPayCash 'Card'

CREATE PROCEDURE CallCustomersForJob @cash nvarchar(50),@job nvarchar(50)
AS
Select c.Name,c.Surname,c.Age,c.Job,rm.Room,rt.RoomType,rt.RoomPrice [Room Price],rm.RentPrice [Room Rented Price],TotalPrice [Spendings],pt.PaymentType FROM Reservations re
JOIN Rooms rm
ON rm.Id = re.RoomId
JOIN RoomTypes rt
ON rm.RoomTypeId = rt.Id
JOIN Payments p
ON re.PaymentId = p.Id
JOIN PaymentTypes pt
ON p.PaymentTypeId = pt.Id
JOIN Spendings s
ON re.SpendingId = s.Id
JOIN Customers c
ON re.CustomerId = c.Id
WHERE pt.PaymentType = @cash AND c.Job Like @job

EXEC CallCustomersForJob'Cash','M%'

EXEC CallCustomersForJob'Cash','M____'


--Functions

CREATE FUNCTION FilterCustomersCountForAge(@StartAge int,@LastAge int)
RETURNS int
AS
BEGIN
DECLARE @count int
SELECT @count = COUNT(Id) FROM Customers
WHERE Age > @StartAge AND Age<@LastAge
RETURN @count
END

SELECT dbo.FilterCustomersCountForAge(10,50)


CREATE FUNCTION FIndCustomerJob(@name nvarchar(50),@surname nvarchar(50))
RETURNS nvarchar(50)
AS
BEGIN
DECLARE @job nvarchar(50)
SELECT @job = Job FROM Customers
WHERE Name = @name AND Surname = @surname
RETURN @job
END

SELECT dbo.FIndCustomerJob('John','Baker') [Job]

SELECT dbo.FIndCustomerJob('Orxan',N'İbrahimli') [Job]

--CREATE FUNCTION FindCustomerPays(@isForeign bit)
--RETURNS decimal
--AS
--BEGIN
--DECLARE @money decimal
--Select @money = SUM(s.TotalPrice) FROM Reservations re
--JOIN Rooms rm
--ON rm.Id = re.RoomId
--JOIN RoomTypes rt
--ON rm.RoomTypeId = rt.Id
--JOIN Payments p
--ON re.PaymentId = p.Id
--JOIN PaymentTypes pt
--ON p.PaymentTypeId = pt.Id
--JOIN Spendings s
--ON re.SpendingId = s.Id
--JOIN Customers c
--ON re.CustomerId = c.Id
--WHERE c.IsForeign = @isForeign
--RETURN @money 
--END

--SELECT dbo.FindCustomerPays('false') [Total Price]
